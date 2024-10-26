{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixbtw";
  home.homeDirectory = "/home/nixbtw";
  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "24.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
    vlc blender krita gimp spotify vscode vencord vesktop gqrx chromium arduino virtualbox whitesur-gtk-theme papirus-icon-theme emacs discord wireshark metasploit johnny sqlmap maltego social-engineer-toolkit gparted libreoffice alacritty polybar rofi picom netcat-openbsd wofi waybar i3 i3status i3lock i3blocks dmenu kitty whitesur-cursors lxappearance qt6ct feh dunst notify-desktop unzip php nodejs_22 libnotify proot nmap pipes cbonsai tty-clock docker-ls docker sl inetutils cmatrix mpd sbclPackages.xkeyboard udisks lemonbar xmobar waybar w3m eww swww btop swaylock fastfetch gnome.eog scrot grim gnome.gnome-screenshot bc light hyfetch mpc-cli hashcat qpaeq ladspaPlugins tmux jre8
cmus nodejs_22 php unzip firebase-tools audacious 
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

  };


  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
