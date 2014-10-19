# START thoughtbot/laptop/master/mac
fancy_echo() {
	printf "\n%b\n" "$1"
}
### end common-components/shared-functions

#!/usr/bin/env bash
### end common-components/bash-shebang

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e
### end common-components/exit-trap


if [ ! -f "$HOME/.zshrc" ]; then
	touch "$HOME/.zshrc"
fi


# START ~/.osx — https://mths.be/osx


###############################################################################
# General UI/UX                                                               #
###############################################################################

fancy_echo "Increase window resize speed for Cocoa applications"
	defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

fancy_echo "Expand save panel by default"
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

fancy_echo "Expand print panel by default"
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

fancy_echo "Save to disk (not to iCloud) by default"
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

fancy_echo "Automatically quit printer app once the print jobs complete"
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

fancy_echo "Disable the “Are you sure you want to open this application?” dialog"
	defaults write com.apple.LaunchServices LSQuarantine -bool false

fancy_echo "Remove duplicates in the “Open With” menu (also see lscleanup alias)"
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

fancy_echo "Disable Resume system-wide"
	defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

fancy_echo "Set Help Viewer windows to non-floating mode"
	defaults write com.apple.helpviewer DevMode -bool true

fancy_echo "Check for software updates daily, not just once per week"
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1


###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

#fancy_echo "Disable local Time Machine snapshots"
#	sudo tmutil disablelocal

fancy_echo "Disable hibernation (speeds up entering sleep mode)"
	sudo pmset -a hibernatemode 0

if [ -f "/Private/var/vm/sleepimage" ]; then
	fancy_echo "Remove the sleep image file to save disk space"
		sudo rm /Private/var/vm/sleepimage
fi
fancy_echo "Create a zero-byte file instead…"
	sudo touch /Private/var/vm/sleepimage
fancy_echo "…and make sure it can’t be rewritten"
	sudo chflags uchg /Private/var/vm/sleepimage

#fancy_echo "Disable the sudden motion sensor as it’s not useful for SSDs"
#	sudo pmset -a sms 0


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

fancy_echo "Disable “natural” (Lion-style) scrolling"
	defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

fancy_echo "Increase sound quality for Bluetooth headphones/headsets"
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

fancy_echo "Enable full keyboard access for all controls"
# (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

fancy_echo "Disable auto-correct"
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

fancy_echo "Stop iTunes from responding to the keyboard media keys"
	launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null


###############################################################################
# Screen                                                                      #
###############################################################################

fancy_echo "Require password immediately after sleep or screen saver begins"
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

fancy_echo "Save screenshots to the desktop"
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"

fancy_echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
	defaults write com.apple.screencapture type -string "png"

fancy_echo "Enable subpixel font rendering on non-Apple LCDs"
	defaults write NSGlobalDomain AppleFontSmoothing -int 2


###############################################################################
# Finder                                                                      #
###############################################################################

fancy_echo "Set Home folder as the default location for new Finder windows"
# For other paths, use `PfLo` and `file:///full/path/here/`
	defaults write com.apple.finder NewWindowTarget -string "PfHm"
	defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

fancy_echo "Show icons for hard drives, servers, and removable media on the desktop"
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

fancy_echo "Finder: show hidden files by default"
	defaults write com.apple.finder AppleShowAllFiles -bool true

fancy_echo "Finder: show all filename extensions"
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

fancy_echo "Finder: show status bar"
	defaults write com.apple.finder ShowStatusBar -bool true

#fancy_echo "Finder: show path bar"
#	defaults write com.apple.finder ShowPathbar -bool true

fancy_echo "Finder: allow text selection in Quick Look"
	defaults write com.apple.finder QLEnableTextSelection -bool true

fancy_echo "Display full POSIX path as Finder window title"
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

fancy_echo "When performing a search, search the current folder by default"
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

fancy_echo "Disable the warning when changing a file extension"
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

fancy_echo "Enable spring loading for directories"
	defaults write NSGlobalDomain com.apple.springing.enabled -bool true

fancy_echo "Remove the spring loading delay for directories"
	defaults write NSGlobalDomain com.apple.springing.delay -float 0

fancy_echo "Avoid creating .DS_Store files on network volumes"
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

#fancy_echo "Disable disk image verification"
#	defaults write com.apple.frameworks.diskimages skip-verify -bool true
#	defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
#	defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

fancy_echo "Automatically open a new Finder window when a volume is mounted"
	defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
	defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
	defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

#fancy_echo "Show item info near icons on the desktop and in other icon views"
#	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

#fancy_echo "Show item info to the right of the icons on the desktop"
#	/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

#fancy_echo "Enable snap-to-grid for icons on the desktop and in other icon views"
#	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

#fancy_echo "Increase grid spacing for icons on the desktop and in other icon views"
#	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

#fancy_echo "Increase the size of icons on the desktop and in other icon views"
#	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

fancy_echo "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

fancy_echo "Disable the warning before emptying the Trash"
	defaults write com.apple.finder WarnOnEmptyTrash -bool false

fancy_echo "Enable the MacBook Air SuperDrive on any Mac"
	sudo nvram boot-args="mbasd=1"

fancy_echo "Show the ~/Library folder"
	chflags nohidden ~/Library

fancy_echo "Expand the following File Info panes:"
fancy_echo "“General”, “Open with”, and “Sharing & Permissions”"
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
		General -bool true \
		OpenWith -bool true \
		Privileges -bool true


###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

#fancy_echo "Set the icon size of Dock items to 36 pixels"
#	defaults write com.apple.dock tilesize -int 36

#fancy_echo "Change minimize/maximize window effect"
#	defaults write com.apple.dock mineffect -string "scale"

#fancy_echo "Minimize windows into their application’s icon"
#	defaults write com.apple.dock minimize-to-application -bool true

fancy_echo "Enable spring loading for all Dock items"
	defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

fancy_echo "Show indicator lights for open applications in the Dock"
	defaults write com.apple.dock show-process-indicators -bool true

fancy_echo "Speed up Mission Control animations"
	defaults write com.apple.dock expose-animation-duration -float 0.1

fancy_echo "Disable Dashboard"
	defaults write com.apple.dashboard mcx-disabled -bool true

fancy_echo "Don’t show Dashboard as a Space"
	defaults write com.apple.dock dashboard-in-overlay -bool true

fancy_echo "Don’t automatically rearrange Spaces based on most recent use"
	defaults write com.apple.dock mru-spaces -bool false

fancy_echo "Enable the 2D Dock"
	defaults write com.apple.dock no-glass -bool true

fancy_echo "Adambware - Dock Position on Right"
	defaults write com.apple.dock orientation -string "right"

fancy_echo "Adambware - Disable dock magnification"
	defaults write com.apple.dock magnification -bool false


###############################################################################
# Safari & WebKit                                                             #
###############################################################################

fancy_echo "Set Safari’s home page to about:blank for faster loading"
	defaults write com.apple.Safari HomePage -string "about:blank"

fancy_echo "Prevent Safari from opening ‘safe’ files automatically after downloading"
	defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

fancy_echo "Enable Safari’s debug menu"
	defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

fancy_echo "Make Safari’s search banners default to Contains instead of Starts With"
	defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

fancy_echo "Enable the Develop menu and the Web Inspector in Safari"
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

fancy_echo "Add a context menu item for showing the Web Inspector in web views"
	defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


###############################################################################
# Mail                                                                        #
###############################################################################

fancy_echo "Copy email addresses as foo@example.com instead of Foo Bar <foo@example.com> in Mail.app"
	defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

fancy_echo "Disable inline attachments (just show the icons)"
	defaults write com.apple.mail DisableInlineAttachmentViewing -bool true


###############################################################################
# Spotlight                                                                   #
###############################################################################

fancy_echo "Hide Spotlight tray-icon (and subsequent helper)"
	sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

fancy_echo "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before."
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
	sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"


###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

fancy_echo "Only use UTF-8 in Terminal.app"
	defaults write com.apple.terminal StringEncodings -array 4

#fancy_echo "Use a modified version of the Solarized Dark theme by default in Terminal.app"
#	TERM_PROFILE='Solarized Dark xterm-256color';
#	CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
#	if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
#		open "${HOME}/init/${TERM_PROFILE}.terminal";
#		sleep 1; # Wait a bit to make sure the theme is loaded
#		defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
#		defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
#	fi;

#fancy_echo "Install the Solarized Dark theme for iTerm"
#	open "${HOME}/init/Solarized Dark.itermcolors"

fancy_echo "Don’t display the annoying prompt when quitting iTerm"
	defaults write com.googlecode.iterm2 PromptOnQuit -bool false

fancy_echo "Adambware - Terminal Defaults"
	defaults write com.apple.Terminal "Default Window Settings" -string "Novel"
	defaults write com.apple.Terminal "Startup Window Settings" -string "Novel"


###############################################################################
# Time Machine                                                                #
###############################################################################

fancy_echo "Prevent Time Machine from prompting to use new hard drives as backup volume"
	defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

fancy_echo "Disable local Time Machine backups"
	hash tmutil &> /dev/null && sudo tmutil disablelocal


###############################################################################
# Activity Monitor                                                            #
###############################################################################

fancy_echo "Show the main window when launching Activity Monitor"
	defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

fancy_echo "Show all processes in Activity Monitor"
	defaults write com.apple.ActivityMonitor ShowCategory -int 0

fancy_echo "Sort Activity Monitor results by CPU usage"
	defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
	defaults write com.apple.ActivityMonitor SortDirection -int 0


###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

#fancy_echo "Enable the debug menu in Address Book"
#	defaults write com.apple.addressbook ABShowDebugMenu -bool true

#fancy_echo "Enable the debug menu in iCal (pre-10.8)"
#	defaults write com.apple.iCal IncludeDebugMenu -bool true

fancy_echo "Use plain text mode for new TextEdit documents"
	defaults write com.apple.TextEdit RichText -int 0

fancy_echo "Open and save files as UTF-8 in TextEdit"
	defaults write com.apple.TextEdit PlainTextEncoding -int 4
	defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

fancy_echo "Enable the debug menu in Disk Utility"
	defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
	defaults write com.apple.DiskUtility advanced-image-options -bool true


###############################################################################
# Mac App Store                                                               #
###############################################################################

fancy_echo "Enable the WebKit Developer Tools in the Mac App Store"
	defaults write com.apple.appstore WebKitDeveloperExtras -bool true

#fancy_echo "Enable Debug Menu in the Mac App Store"
#	defaults write com.apple.appstore ShowDebugMenu -bool true


###############################################################################
# Messages                                                                    #
###############################################################################

fancy_echo "Disable automatic emoji substitution (i.e. use plain text smileys)"
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

fancy_echo "Disable continuous spell checking"
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false


###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################
fancy_echo "Starting Chrome Tweaks"

fancy_echo "Allow installing user scripts via GitHub Gist or Userscripts.org"
	defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

fancy_echo "Disable the all too sensitive backswipe"
	defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false


###############################################################################
# Transmission.app                                                            #
###############################################################################
fancy_echo "Starting Transmission Tweaks"

fancy_echo "Don’t prompt for confirmation before downloading"
	defaults write org.m0k.transmission DownloadAsk -bool false

fancy_echo "Trash original torrent files"
	defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

fancy_echo "Hide the donate message"
	defaults write org.m0k.transmission WarningDonate -bool false
fancy_echo "Hide the legal disclaimer"
	defaults write org.m0k.transmission WarningLegal -bool false


###############################################################################
# Kill affected applications                                                  #
###############################################################################
fancy_echo "Killing affected applications ..."

#for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#	"Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
#	"Terminal" "Transmission" "iCal"; do
#	killall "${app}" > /dev/null 2>&1
#done
fancy_echo "Done. You should reboot now."
