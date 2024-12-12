#!/usr/bin/python

from AppKit import NSWorkspace
import time
while True:
    time.sleep(3)
    activeAppName = NSWorkspace.sharedWorkspace().activeApplication()['NSApplicationName']
    print(activeAppName)