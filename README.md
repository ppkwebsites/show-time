# show-time
Shows date and time when pressing shortcut key on hyprland

🫸 Command To Install
chmod +x show-time.sh    //make script executable
./show-time.sh install        // run script only once, and after only use shortcut key


What Does the Script Do?
The show-time.sh script:
Displays the current date and time in a desktop notification using dunst.
Optionally lets you open a calendar with yad by clicking the notification.
Includes an installation mode to set everything up neatly in your ~/bin directory.
Works great with Hyprland (or other desktop environments) and can be bound to a keyboard shortcut.

Let’s get started
Prerequisites
An Arch-based Linux distro (e.g., Arch Linux, Manjaro) since the script uses pacman for package management.
Basic terminal knowledge.
sudo privileges for installing packages.

If you’re on a different distro (like Ubuntu or Fedora), you’ll need to tweak the package installation commands (e.g., use apt or dnf).

​Step 2: Make the Script ExecutableRun this command to make the script executable:

chmod +x show-time.shStep 3: Run the Install ModeThe script has a special install mode that sets things up properly.
Run:
./show-time.sh install
This does the following:
Creates a ~/bin directory if it doesn’t exist.
Copies the script to ~/bin/show-time.sh and makes it executable.
Checks if dunst (a notification daemon) is installed. If not, it installs it using sudo pacman -S dunst.
Why run install first? It ensures the script is in a standard location (~/bin) and that dunst is installed. If you skip this, the script will still try to install dunst when run, but it won’t move itself to ~/bin.
Note: Ensure ~/bin is in your $PATH. Add this line to your ~/.bashrc or equivalent if it’s not already there:
export PATH="$HOME/bin:$PATH"Then reload your shell:
source ~/.bashrcStep 4: Run the ScriptAfter installation, run the script to display the current date and time:
show-time.sh
This will:
Check if dunst is installed and running. If not, it installs dunst and starts the service.
Prompt you to install yad (for calendar functionality) if it’s not installed. Press Y (or Enter) to install, or n to skip.
Show a notification with the current date and time (e.g., Fri Sep 19 13:13 SAST).
If yad is installed, clicking the notification opens a calendar.
Step 5: Optional - Set Up a Keyboard ShortcutIf you installed yad, the script suggests adding a keybinding to your Hyprland configuration (~/.config/hypr/hyprland.conf) to open the calendar directly.
Add this line:
bind = SUPER, C, exec, yad --calendar --title='Calendar' --width=300 --height=250 --button='OK':0This binds the calendar to Super+T. You can change SUPER, C to your preferred key combo (e.g., ALT, C for Alt+C).
Reload Hyprland to apply:
hyprctl reloadTroubleshooting
Non-Arch distros: The script uses pacman. For other distros, install dunst and yad manually (e.g., sudo apt install dunst yad on Ubuntu).
Dunst issues: If notifications don’t appear, check the dunst service:
systemctl --user status dunst
Start it if needed:
systemctl --user start dunst
Yad not installed: The script works without yad, but you won’t get the calendar feature.
Permission errors: Ensure you have sudo privileges for installing packages.

Why It’s Cool
This script is lightweight and customizable. It’s perfect for minimal setups like Hyprland, and the calendar feature is a nice touch for quick date checks. Plus, the notifications look sleek with their custom colors! 😎
