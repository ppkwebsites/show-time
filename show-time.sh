#!/bin/sh

# Installation mode: Run with 'install' argument to copy to ~/bin and install dunst
if [ "$1" = "install" ]; then
    # Create ~/bin directory if it doesn't exist
    mkdir -p ~/bin
    cp "$0" ~/bin/show-time.sh
    chmod +x ~/bin/show-time.sh
    echo "Script installed to ~/bin/show-time.sh"

    # Install dunst
    if ! command -v dunstify > /dev/null 2>&1 || ! command -v dunst > /dev/null 2>&1; then
        echo "Installing dunst for desktop notifications..."
        if sudo pacman -S --noconfirm dunst; then
            echo "dunst installed successfully."
        else
            echo "Failed to install dunst. Please install it manually with 'sudo pacman -S dunst'."
            exit 1
        fi
    else
        echo "dunst is already installed."
    fi
    exit 0
fi

# Check if dunst and dunstify are installed
if ! command -v dunstify > /dev/null 2>&1 || ! command -v dunst > /dev/null 2>&1; then
    echo "dunst or dunstify is not installed. Installing dunst for desktop notifications..."
    if sudo pacman -S --noconfirm dunst; then
        echo "dunst installed successfully."
    else
        echo "Failed to install dunst. Please install it manually with 'sudo pacman -S dunst' and try again."
        exit 1
    fi
fi

# Check if dunst service is active
if ! systemctl --user is-active --quiet dunst; then
    echo "dunst service is not active. Attempting to start dunst service..."

    # Check for dunst config
    if [ ! -f ~/.config/dunst/dunstrc ]; then
        echo "dunst configuration file (~/.config/dunst/dunstrc) not found. Copying default configuration..."
        mkdir -p ~/.config/dunst
        if cp /usr/share/dunst/dunstrc ~/.config/dunst/dunstrc; then
            echo "Default dunst configuration copied to ~/.config/dunst/dunstrc."
        else
            echo "Failed to copy default dunst configuration. Please copy it manually with:"
            echo "  cp /usr/share/dunst/dunstrc ~/.config/dunst/dunstrc"
            exit 1
        fi
    fi

    # Check for conflicting dunst instances
    if pgrep -u "$USER" dunst > /dev/null; then
        echo "A dunst process is already running. Killing existing dunst processes..."
        pkill -u "$USER" dunst
        sleep 1
    fi

    # Attempt to start dunst service
    if systemctl --user start dunst; then
        echo "dunst service started successfully."
    else
        echo "Failed to start dunst service. Checking for common issues..."
        echo "Dunst service status:"
        systemctl --user status dunst.service
        echo "Dunst service logs:"
        journalctl --user -xeu dunst.service --no-pager | tail -n 20
        echo ""
        echo "Possible fixes to try:"
        echo "1. Reset dunst service: systemctl --user reset-failed dunst.service"
        echo "2. Check dunst configuration for errors: dunst -conf ~/.config/dunst/dunstrc"
        echo "3. Ensure required dependencies (e.g., libnotify, dbus) are installed:"
        echo "   sudo pacman -S libnotify dbus"
        echo "4. Start dunst manually: systemctl --user start dunst"
        echo "5. If issues persist, check logs with: journalctl --user -xeu dunst.service"
        exit 1
    fi
fi

# Set default appname
appname="Do or do not"

# Ask user if they want to install yad for a calendar (only if not already installed)
if ! command -v yad > /dev/null 2>&1; then
    echo "Would you like to install yad to display a calendar? (Y/n)"
    read -r install_yad
    # Default to Y if input is empty
    install_yad=${install_yad:-Y}
    if [ "$install_yad" = "y" ] || [ "$install_yad" = "Y" ]; then
        echo "Installing yad for calendar functionality..."
        if sudo pacman -S --noconfirm yad; then
            echo "yad installed successfully."
            echo ""
            echo "To create a shortcut key for opening the yad calendar in Hyprland, add the following line to ~/.config/hypr/hyprland.conf:"
            echo "  bind = SUPER, C, exec, yad --calendar --title='Calendar' --width=300 --height=250 --button='OK':0"
            echo "This binds the calendar to Super+C. Replace 'SUPER, C' with your preferred key combination (e.g., ALT, C for Alt+C)."
            echo "After editing, reload Hyprland with 'hyprctl reload' or restart your session."
            # Change appname to Yad Calendar
            appname="Yad Calendar"
        else
            echo "Failed to install yad. Please install it manually with 'sudo pacman -S yad' and try again."
            exit 1
        fi
    fi
else
    # If yad is already installed, set appname to Yad Calendar
    appname="Yad Calendar"
fi

# Get the current date and time (e.g., Thu Sep 18 16:21 SAST)
current_datetime=$(date +"%a %b %d %H:%M %Z")

# Display the date and time via dunstify with custom colors, appname, and left-click action
if [ "$appname" = "Yad Calendar" ]; then
    action=$(dunstify -a "$appname" -h string:bgcolor:#2E2E2E -h string:fgcolor:#FFFFFF -h string:frcolor:#B8860B -A "calendar,Open Calendar" "Date and time" "$current_datetime")
    if [ "$action" = "calendar" ]; then
        yad --calendar --title="Calendar" --width=300 --height=250 --button="OK":0 2>/dev/null &
    fi
else
    dunstify -a "$appname" -h string:bgcolor:#2E2E2E -h string:fgcolor:#FFFFFF -h string:frcolor:#B8860B "Date and time" "$current_datetime"
fi
