#!/usr/bin/env bash

# Rofi menu entries in the desired order
MENU_OPTIONS="Catppuccin\nNordic\nGruvbox\nRed\nBlue\nMagenta\nWaybar\nWallpapers\nAlacritty\nRofi\nCava"

# Define theme directories for each component
THEMES_DIR="$HOME/.config/themes"
ROFI_THEME_DIR="$THEMES_DIR/rofi"
WAYBAR_THEME_DIR="$THEMES_DIR/waybar"
CAVA_THEME_DIR="$THEMES_DIR/cava"
ALACRITTY_THEME_DIR="$THEMES_DIR/alacritty"
WALLPAPER_DIR="$THEMES_DIR/wallpapers"

# List of themes available for Alacritty
ALACRITTY_OPTIONS="gruvbox\nnordic\ncatppuccin\nLight"

# List of themes available for Cava and Rofi (same)
CAVA_OPTIONS="red\nblue\nmagenta\ncatppuccin\ngruvbox\nnordic"

ROFI_OPTIONS="red\nblue\nmagenta\ncatppuccin\ngruvbox\nnordic\nLight"

# Waybar themes
WAYBAR_OPTIONS="Light\nDark"

# Function to apply a specific theme for a given component
apply_component_theme() {
    local component=$1
    local theme=$2

    case "$component" in
        "Alacritty")
            CONFIG_FILE="$ALACRITTY_THEME_DIR/$theme/alacritty.toml"
            DEST_FILE="$HOME/.config/alacritty/alacritty.toml"
            ;;

        "Rofi")
            CONFIG_FILE="$ROFI_THEME_DIR/$theme/config.rasi"
            DEST_FILE="$HOME/.config/rofi/config.rasi"
            ;;

        "Cava")
            CONFIG_FILE="$CAVA_THEME_DIR/$theme/config"
            DEST_FILE="$HOME/.config/cava/config"
            ;;

        "Waybar")
            # Apply Light or Dark theme based on the selection
            if [[ "$theme" == "Light" ]]; then
                CONFIG_FILE="$WAYBAR_THEME_DIR/light/style.css"
            else
                CONFIG_FILE="$WAYBAR_THEME_DIR/dark/style.css"
            fi
            DEST_FILE="$HOME/.config/waybar/style.css"
            ;;
    esac

    echo "Applying $component theme '$theme' using config file: $CONFIG_FILE"

    if [ -f "$CONFIG_FILE" ]; then
        cp "$CONFIG_FILE" "$DEST_FILE"
        echo "$component theme '$theme' applied."
    else
        echo "Config file for $component and theme '$theme' not found: $CONFIG_FILE"
    fi
}

# Function to apply global themes based on the selected option
apply_global_theme() {
    local theme=$1

    if [[ "$theme" == "blue" || "$theme" == "red" || "$theme" == "magenta" ]]; then
        # Always set Alacritty to Catppuccin for these themes
        apply_component_theme "Alacritty" "catppuccin"
    else
        apply_component_theme "Alacritty" "$theme"
    fi

    apply_component_theme "Rofi" "$theme"
    apply_component_theme "Cava" "$theme"
    apply_component_theme "Waybar" "dark"  # Default to dark for global themes
    select_wallpaper_for_theme "$theme"
    swaymsg reload
}

# Wallpaper selection for each theme
select_wallpaper_for_theme() {
    local theme=$1
    local theme_wallpaper_dir="$WALLPAPER_DIR/$theme"

    if [ -d "$theme_wallpaper_dir" ]; then
        SELECTED_WALLPAPER=$(ls "$theme_wallpaper_dir" | rofi -dmenu -p "Select $theme Wallpaper:")
        if [ -n "$SELECTED_WALLPAPER" ]; then
            WALLPAPER_PATH="$theme_wallpaper_dir/$SELECTED_WALLPAPER"
            sed -i "s|\(img\).*\(--transition-type\)|\1 $WALLPAPER_PATH \2|" "$HOME/.config/themes/wall.sh"
            echo "$theme wallpaper '$SELECTED_WALLPAPER' applied."
            swaymsg reload
        else
            echo "No wallpaper selected for $theme."
        fi
    else
        echo "Wallpaper directory for $theme not found."
    fi
}

# Function to handle Alacritty theme selection
select_alacritty_theme() {
    SELECTED_THEME=$(echo -e "$ALACRITTY_OPTIONS" | rofi -dmenu -p "Select Alacritty Theme:")
    if [ "$SELECTED_THEME" == "Light" ]; then
        # List existing light themes for Alacritty
        LIGHT_THEMES="gruvbox\nnordic\ncatppuccin"
        SELECTED_LIGHT_THEME=$(echo -e "$LIGHT_THEMES" | rofi -dmenu -p "Select Light Theme:")
        if [ -n "$SELECTED_LIGHT_THEME" ]; then
            CONFIG_FILE="$HOME/.config/themes/alacritty/light/$SELECTED_LIGHT_THEME/alacritty.toml"
            cp "$CONFIG_FILE" "$HOME/.config/alacritty/alacritty.toml"
            echo "Light Alacritty theme '$SELECTED_LIGHT_THEME' applied."
        else
            echo "No light theme selected for Alacritty."
        fi
    elif [ -n "$SELECTED_THEME" ]; then
        CONFIG_FILE="$HOME/.config/themes/alacritty/$SELECTED_THEME/alacritty.toml"
        cp "$CONFIG_FILE" "$HOME/.config/alacritty/alacritty.toml"
        echo "Alacritty theme '$SELECTED_THEME' applied."
    else
        echo "No theme selected for Alacritty."
    fi
}
# Function to handle Cava theme selection
select_cava_theme() {
    SELECTED_THEME=$(echo -e "$CAVA_OPTIONS" | rofi -dmenu -p "Select Cava Theme:")
    if [ -n "$SELECTED_THEME" ]; then
        apply_component_theme "Cava" "$SELECTED_THEME"
    else
        echo "No theme selected for Cava."
    fi
}

# Function to handle Rofi theme selection
select_rofi_theme() {
    SELECTED_THEME=$(echo -e "$ROFI_OPTIONS" | rofi -dmenu -p "Select Rofi Theme:")
    if [ "$SELECTED_THEME" == "Light" ]; then
        # List existing light themes for Rofi
        LIGHT_THEMES=$(ls "$HOME/.config/themes/rofi/light")
        SELECTED_LIGHT_THEME=$(echo "$LIGHT_THEMES" | rofi -dmenu -p "Select Light Theme:")
        if [ -n "$SELECTED_LIGHT_THEME" ]; then
            apply_component_theme "Rofi" "$SELECTED_LIGHT_THEME"
            CONFIG_FILE="$HOME/.config/themes/rofi/light/$SELECTED_LIGHT_THEME/config.rasi"
            cp "$CONFIG_FILE" "$HOME/.config/rofi/config.rasi"
            echo "Light Rofi theme '$SELECTED_LIGHT_THEME' applied."
        else
            echo "No light theme selected for Rofi."
        fi
    elif [ -n "$SELECTED_THEME" ]; then
        apply_component_theme "Rofi" "$SELECTED_THEME"
    else
        echo "No theme selected for Rofi."
    fi
}


# Function to handle Waybar theme selection
select_waybar_theme() {
    SELECTED_THEME=$(echo -e "$WAYBAR_OPTIONS" | rofi -dmenu -p "Select Waybar Theme:")
    if [ -n "$SELECTED_THEME" ]; then
        apply_component_theme "Waybar" "$SELECTED_THEME"
        swaymsg reload
    else
        echo "No theme selected for Waybar."
    fi
}

# Function to handle wallpaper selection
select_wallpapers() {
    SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f | sed 's|.*/||' | rofi -dmenu -p "Select Wallpaper:")
    if [ -n "$SELECTED_WALLPAPER" ]; then
        WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER"
        sed -i "s|\(img\).*\(--transition-type\)|\1 $WALLPAPER_PATH \2|" "$HOME/.config/themes/wall.sh"
        echo "Wallpaper '$SELECTED_WALLPAPER' applied."
        swaymsg reload
    else
        echo "No wallpaper selected."
    fi
}

# Show the Rofi menu to select the component
SELECTED=$(echo -e "$MENU_OPTIONS" | rofi -dmenu -p "Select an option:")

# Handle the selected entry
case "$SELECTED" in
    "Catppuccin")
        apply_global_theme "catppuccin"
        ;;

    "Nordic")
        apply_global_theme "nordic"
        ;;

    "Gruvbox")
        apply_global_theme "gruvbox"
        ;;

    "Red")
        apply_global_theme "red"
        ;;

    "Blue")
        apply_global_theme "blue"
        ;;

    "Magenta")
        apply_global_theme "magenta"
        ;;

    "Waybar")
        select_waybar_theme
        ;;

    "Wallpapers")
        select_wallpapers
        ;;

    "Alacritty")
        select_alacritty_theme
        ;;

    "Rofi")
        select_rofi_theme
        ;;

    "Cava")
        select_cava_theme
        ;;

    *)
        echo "No valid option selected."
        ;;
esac
