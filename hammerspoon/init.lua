-- ╔╗─╔╦════╦══╦╗──╔═══╗
-- ║║─║║╔╗╔╗╠╣╠╣║──║╔═╗║
-- ║║─║╠╝║║╚╝║║║║──║╚══╗
-- ║║─║║─║║──║║║║─╔╬══╗║
-- ║╚═╝║─║║─╔╣╠╣╚═╝║╚═╝║
-- ╚═══╝─╚╝─╚══╩═══╩═══╝
function has_value(tab, value)
   for i, v in ipairs(tab) do
      if value == v then
         return true
      end
   end

   return false
end


-- ╔═══╦╗─╔╦═══╦══╦═══╗
-- ║╔═╗║║─║╠╗╔╗╠╣╠╣╔═╗║
-- ║║─║║║─║║║║║║║║║║─║║
-- ║╚═╝║║─║║║║║║║║║║─║║
-- ║╔═╗║╚═╝╠╝╚╝╠╣╠╣╚═╝║
-- ╚╝─╚╩═══╩═══╩══╩═══╝
local audioOutputPriority = {}
audioOutputPriority["Bluetooth"] = 0
audioOutputPriority["USB"] = 1
audioOutputPriority["Built-in"] = 2
function getOutputPriority(device)
   priority = audioOutputPriority[device:transportType()]
   if nil == priority then
      return 100
   else
      return priority
   end
end

function sortOutputPriority(left, right)
   return getOutputPriority(left) < getOutputPriority(right)
end

function setDefaultOutputByName(name)
   device = hs.audiodevice.findOutputByName(name)
   if nil ~= device then
      device:setDefaultOutputDevice()
      return true
   else
      return false
   end
end

lastValidAudioOutputDevice = hs.audiodevice.defaultOutputDevice()
function audioWatcherCallback(data)
   -- our output device changed
   if data == "dOut" then
      outputDevice = hs.audiodevice.defaultOutputDevice()
      -- check if we changed to a display port audio device
      if nil ~= outputDevice and outputDevice:transportType() == "DisplayPort" then
         hs.alert.show("Blocking DisplayPort Audio Output")

         local allOutputDevices = hs.audiodevice.allOutputDevices()

         -- try to set our output device to the last valid one
         if not hs.fnutils.contains(allOutputDevices, lastValidAudioOutputDevice) or not lastValidAudioOutputDevice:setDefaultOutputDevice() then
            -- our last valid device was disconnected so sort our preferred output types
            table.sort(allOutputDevices, sortOutputPriority)

            -- now that we're sorted grab the first device
            if nil ~= allOutputDevices[1] then
               allOutputDevices[1]:setDefaultOutputDevice()
            else
               hs.console.printStyledtext("We couldn't find a valid audio output device to switch to")

               for i, device in ipairs(allOutputDevices) do
                  hs.console.printStyledtext(tostring(device) .. " - " .. device:transportType())
               end
            end
         end
      else
         lastValidAudioOutputDevice = outputDevice
      end
   end
end
hs.audiodevice.watcher.setCallback(audioWatcherCallback)
hs.audiodevice.watcher.start()


-- ╔═══╦═══╦═══╦╗──╔══╦═══╦═══╦════╦══╦═══╦═╗─╔╗
-- ║╔═╗║╔═╗║╔═╗║║──╚╣╠╣╔═╗║╔═╗║╔╗╔╗╠╣╠╣╔═╗║║╚╗║║
-- ║║─║║╚═╝║╚═╝║║───║║║║─╚╣║─║╠╝║║╚╝║║║║─║║╔╗╚╝║
-- ║╚═╝║╔══╣╔══╣║─╔╗║║║║─╔╣╚═╝║─║║──║║║║─║║║╚╗║║
-- ║╔═╗║║──║║──║╚═╝╠╣╠╣╚═╝║╔═╗║─║║─╔╣╠╣╚═╝║║─║║║
-- ╚╝─╚╩╝──╚╝──╚═══╩══╩═══╩╝─╚╝─╚╝─╚══╩═══╩╝─╚═╝
function applicationWatcher(name, event, application)
   if hs.application.watcher.launched == event then
      if "zoom.us" == name then
         -- set our output to the audio engine speakers (if conncted) for zoom meetings
         if setDefaultOutputByName("Audioengine 2+  ") then
            hs.alert.show("Set Audioengine For Zoom")
         else
            hs.console.printStyledtext("We couldn't find the audio engine")
         end
      end
   elseif hs.application.watcher.terminated == event then
      if "zoom.us" == name then
         -- once we close zoom go back to our DAC
         if setDefaultOutputByName("FIIO USB DAC E17K") then
            hs.alert.show("Set FIIO After Zoom")
         end
      end
   end
end

-- hs.application.watcher.new(applicationWatcher):start()





local log = hs.logger.new('uplift', 'info')

function nowTime()
   local date = os.date("*t")
   local hour = tonumber(date.hour)
   local min = tonumber(date.min)
   return hour, min
end

function nextThirty()
   local hour, min = nowTime()
   if 30 <= min then
      if 23 == hour then
         return "00:00"
      else
         return (hour + 1) .. ":00"
      end
   else
      return hour .. ":30"
   end
end

deskTimer = nil
function toggleDesk()
   -- schedule the next move
   local nextTime = nextThirty()
   log.i("Scheduling next toggle: " .. nextTime)

   -- clear out any existing timers
   if deskTimer ~= nil then
      deskTimer:stop()
   end
   deskTimer = hs.timer.doAt(nextTime, 0, toggleDesk):start()

   -- check that the time is correct AND we're plugged into an external monitor
   local _, min = nowTime()
   local numScreens = #hs.screen.allScreens()
   if (min == 0 or min == 30) and numScreens > 1 then

      local output, deskAvailable, _, _ = hs.execute("uplift --timeout 5 query", true)
      if deskAvailable then

         log.i("Asking to toggle desk")
         hs.notify.new(function (notification)
            -- check that the user actually clicked Yes
            if hs.notify.activationTypes[notification:activationType()] == "actionButtonClicked" then
               hs.alert.show("Toggling Desk")
               hs.execute("uplift force-toggle", true)
               log.i("Toggled desk")
            else
               notification:withdraw()
            end
         end, {
            ["title"] = "Toggle Desk?",
            ["autoWithdraw"] = true,
            ["withdrawAfter"] = 300, -- withdraw after 5 minutes
            ["hasActionButton"] = true,
            ["actionButtonTitle"] = "Yes"
         }):send()
      else
         log.i("Desk not found: " .. output)
      end
   else
      log.i("Not plugged into an external monitor, found: " .. tostring(numScreens) .. " at " .. min)
   end
end

-- kick off our desk toggling
local next = nextThirty()
deskTimer = hs.timer.doAt(next, 0, toggleDesk):start()
log.i("Started desk timer: " .. next)



-- for i, device in ipairs(hs.audiodevice.allOutputDevices()) do
--    hs.console.printStyledtext("'" .. device:name() .. "'")
-- end

subl = hs.appfinder.appFromName("Sublime Text")

-- subl:selectMenuItem({"File", "New File"})


function buildApplication(name, newMenuPath)
   Application = {
      name = name,
      app = hs.appfinder.appFromName(name)
   }

   function Application.newWindow()
      Application.app:selectMenuItem(newMenuPath)
   end

   return Application
end


subl = buildApplication("Sublime Text", {"File", "New File"})

-- subl.newWindow()