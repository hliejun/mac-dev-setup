#!/bin/bash

function command_exists {
  command -v "$1" >/dev/null
}

#
# Copy git ssh config file
#
echo " ------- Git SSH config ------"
mkdir ~/.ssh && cp $(
  cd $(dirname ${BASH_SOURCE:-$0})
  pwd
)/settings/git/config ~/.ssh/config
read -p 'Do you want to configure Git ssh ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  ssh-keygen -t rsa
  chmod 600 ~/.ssh/id_rsa
  eval $(ssh-agent)
  ssh-add ~/.ssh/id_rsa
  ssh-add -l
  echo 'Let’s register your public key on GitHub\ncheck command: `ssh -T git@github.com`'
  ;;
esac
echo " ------------ END ------------"

#
# Memorize user pass
#
read -sp "Your Password: " pass

#
# Install zsh
#
if [ ! -e "$(brew --prefix)/bin/zsh" ]; then
  echo " ------------ zsh ------------"
  brew install zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting colordiff
  which -a zsh
  echo $pass | sudo -S -- sh -c 'echo "$(brew --prefix)/bin/zsh" >> /etc/shells'
  # This is a workaround for problems that Xcode and others may refer to
  echo $pass | sudo sh -c "mkdir -p /usr/local/bin & ln -s $(brew --prefix)/bin/zsh /usr/local/bin/zsh"
  chsh -s "$(brew --prefix)/bin/zsh"
  echo " ------------ END ------------"
fi

#
# Install dotfiles system
#
echo " ---------- dotfiles ---------"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh)"
cp $(
  cd $(dirname ${BASH_SOURCE:-$0})
  pwd
)/settings/zsh/private.zsh ~/.yadr/zsh/private.zsh
echo "typeset -U path PATH
path=(
  $(brew --prefix)/bin(N-/)
  $(brew --prefix)/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /Library/Apple/usr/bin
)
" >>~/.yadr/zsh/private.zsh
if [ -d /opt/homebrew/bin ]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.yadr/zsh/private.zsh
fi
source ~/.zshrc
echo " ------------ END ------------"

#
# Powerline
#
echo " --------- Powerline ---------"
# Font: MesloLGS NF Regular 13pt
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.yadr/zsh/private.zsh
cp $(
  cd $(dirname ${BASH_SOURCE:-$0})
  pwd
)/settings/zsh/p10k.zsh ~/.yadr/zsh/p10k.zsh
echo " ------------ END ------------"

#
# Install ruby
#
if [ ! -e "$(echo ~$USERNAME)/.asdf/shims/ruby" ]; then
  echo " ----------- Ruby ------------"
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  ruby_latest=$(asdf list all ruby | grep -v '[a-z]' | tail -1 | sed 's/ //g')
  asdf install ruby $ruby_latest
  asdf global ruby $ruby_latest
  asdf reshim ruby
  ruby -v
  where ruby
  asdf which ruby
  echo " ------------ END ------------"
fi

read -p 'Do you want to enter your Git user name ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  read -p 'Git user name:' name
  git config --global user.name $name
  git config user.name
  echo " ------------ END ------------"
  ;;
esac

read -p 'Do you want to enter your Git user e-mail ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  read -p 'Git user e-mail:' mail
  git config --global user.email $mail
  git config user.email
  echo " ------------ END ------------"
  ;;
esac

read -p 'Do you want to enter your GitHub Access Token ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  read -p 'GitHub Access Token:' token
  echo "export GITHUB_ACCESS_TOKEN=${token}" >>~/.yadr/zsh/private.zsh
  echo "export HOMEBREW_GITHUB_API_TOKEN=${token}" >>~/.yadr/zsh/private.zsh
  echo "Writing to ~/.yadr/zsh/private.zsh is complete."
  echo " ------------ END ------------"
  ;;
esac

read -p 'Do you want to install Google Cloud CLI ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  brew install --cask google-cloud-sdk
  echo "source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" >>~/.yadr/zsh/private.zsh
  echo "source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" >>~/.yadr/zsh/private.zsh
  source ~/.zshrc
  gcloud auth login
  ;;
esac

read -p 'Do you want to install App Store Apps ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  $(
    cd $(dirname ${BASH_SOURCE:-$0})
    pwd
  )/appstore.sh
  ;;
esac

read -p 'Do you want to install Third Party Apps ? [y/n]' input
case $input in
'' | [Nn]*)
  echo "Skip"
  ;;
[Yy]*)
  $(
    cd $(dirname ${BASH_SOURCE:-$0})
    pwd
  )/app.sh
  ;;
esac
