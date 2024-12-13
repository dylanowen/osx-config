#!/usr/bin/env bash

# Rust https://www.rust-lang.org/learn/get-started
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Atuin https://docs.atuin.sh/guide/installation/
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

brew install \
	bat \
	graphviz \
	openssl@3

brew install --cask \
	alfred \
	cursorsense \
	contexts \
	dbeaver-community \
	discord \
	docker \
	font-fira-code \
	godot \
	hammerspoon \
	handbrake \
	hex-fiend \
	jordanbaird-ice \
	middleclick \
	signal \
	sublime-text \
	thunderbird \
	vlc \
	wezterm \
	wireshark

cargo install \
	cargo-audit \
	cargo-update \
	git-delta \
	just
