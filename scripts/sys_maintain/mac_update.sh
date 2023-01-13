#!/usr/bin/env bash

#export DEBIAN_FRONTEND=noninteractive
sudo softwareupdate -i -a
brew update
brew upgrade
brew upgrade --cask
brew outdated --cask --greedy --verbose
brew upgrade --cask --greedy
brew cleanup
rustup self update
rustup update
tldr --update
