#!/usr/bin/env bash

brew install \
	bat \
	graphviz \
	openssl@3

brew install --cask \
	alfred \
	cursorsense \
	contexts \
	docker \
	hammerspoon \
	kitty \
	hex-fiend \
	middleclick \
	signal \
	sublime-text \
	wireshark

brew tap homebrew/cask-fonts
brew install --cask font-fira-code

cargo install \
	cargo-audit \
	cargo-update \
	git-delta \
	just
