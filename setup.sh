#!/bin/sh

# Install xcode tools.
echo "Running xcode-select --install"
xcode-select --install

# Install brew
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Updating brew"
brew update

echo "Installing some core tools (git curl wget)"
brew install git curl wget

echo "Git config"
git config --global user.name "James Wallen-Jones"
git config --global user.email "j.wallen.jones@googlemail.com"
git config --global push.default current

echo "Installing dev tools"
brew install php@7.2 dnsmasq

echo "Installing iterm"
curl -O https://iterm2.com/downloads/stable/iTerm2-3_2_0.zip
unzip iTerm2-3_2_0.zip
mv iTerm.app/ /Applications/
rm -f iTerm2-3_2_0.zip
# Add's an exception to gatekeeper
spctl --add /Applications/iTerm.app/

###########
# dnsmasq #
###########

# Create config directory
mkdir -pv $(brew --prefix)/etc/

# Set up *.test
echo 'address=/.test/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf

# Create resolvers directory
sudo mkdir -v /etc/resolver

# Add nameserver to resolvers
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'

# Start the dnsmasq service
sudo brew services start dnsmasq

# Install composer
echo "Installing composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Show all files in finder
defaults write com.apple.finder AppleShowAllFiles YES

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the delay on Key Repeat
defaults write -g InitialKeyRepeat -int 10
defaults write NSGlobalDomain KeyRepeat -int 1

# Kill Finder to apply some settings
killall Finder
