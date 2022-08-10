#!/bin/bash

echo " ----- Install developer tools ------"
brew tap AdoptOpenJDK/openjdk
brew install --cask adoptopenjdk
brew install --cask android-studio
brew install --cask docker
brew install --cask postman
brew install --cask visual-studio-code
brew install --cask figma
brew install --cask sourcetree
brew install --cask flipper
brew install scrcpy
brew install node
brew install watchman
brew install nvm
brew install rbenv
brew install cocoapods

echo " ----- Install network tools ------"
brew install --cask google-chrome
brew install --cask firefox
brew install --cask microsoft-edge
brew install --cask openvpn-connect

echo " ----- Install media file tools ------"
brew install --cask imageoptim
brew install --cask handbrake
brew install --cask keka

echo " ----- Install productivity tools ------"
brew install --cask spotify
brew install --cask notion
brew install --cask todoist
brew install --cask rectangle
brew install --cask hiddenbar

echo " ----- Install communication tools ------"
brew install --cask slack
brew install --cask zoom
brew install --cask telegram
brew install --cask microsoft-teams

esac
