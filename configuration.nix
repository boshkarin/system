                                                                           # Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.uinput.enable = true;
 
  networking.hostName = "lambda"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT = "hr_HR.UTF-8";
    LC_MONETARY = "hr_HR.UTF-8";
    LC_NAME = "hr_HR.UTF-8";
    LC_NUMERIC = "hr_HR.UTF-8";
    LC_PAPER = "hr_HR.UTF-8";
    LC_TELEPHONE = "hr_HR.UTF-8";
    LC_TIME = "hr_HR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

   # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.emacs.enable = true;

  # Kanata key remapping
  services.kanata = {
    enable = true;
    keyboards = {
      "asus-laptop".config = ''
      (defsrc
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    d    r    w    b    j    f    u    p    ;    [    ]    \
  caps a    s    h    t    g    y    n    e    o    i    '    ret
  lsft z    x    m    c    v    k    l    ,    .    /    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)

(deflayer workman
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    d    r    w    b    j    f    u    p    ;    [    ]    \
  esc  a    s    h    t    g    y    n    e    o    i    '    ret
  lsft z    x    m    c    v    k    l    ,    .    /    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)
  '';
    };
  };
  
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dmisk = {
    isNormalUser = true;
    description = "Domagoj Miskovic";
    extraGroups = [ "networkmanager" "wheel" "uinput"];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  
  # Enable dconf
  programs.dconf.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  alsa-scarlett-gui asciiquarium audacity bat btop clang clang-tools coreutils cowsay 
  direnv dunst element-desktop emacs eza fd feh figlet fortune gcc git gnome-tweaks 
  gnumake gpaste htop i3 i3blocks i3status jq kanata kitty kitty-themes lf lolcat lsd 
  marksman moreutils nerd-fonts.iosevka neovim nil nix-output-monitor nix-tree nixd npins 
  obs-studio opam pa_applet procs ranger ripgrep rlwrap rustup scrcpy shellcheck 
  slides tealdeer tmatrix tmux tokei unzip vlc wget yt-dlp zellij zoom-us zoxide
  bashInteractive ghc cabal-install haskell-language-server haskellPackages.hlint
  millet smlnj mlkit vscode gimp
  manim nerdfetch
  nerd-fonts.hasklug
  nerd-fonts.symbols-only
  nerd-fonts.iosevka-term
  ghcid
  haskellPackages.LambdaCalculator
  jdk miranda
  
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  home-manager.users.dmisk = { pkgs, ... }: {
    home.packages = with pkgs; [ ];

  programs.direnv.enable = true;
  
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      marksman
    ];
    defaultEditor = true;
    settings = {
      theme = "autumn_night";
      editor = {
        true-color = true;
        mouse = false;
        bufferline = "always";
        line-number = "relative";
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };     
    };
    
    languages = {
      "nix" = {
        language-servers = {
          command = "${pkgs.nixd}/bin/nixd";
        };
      };
    };
  };
  
  programs.git = {
    enable = true;
    userName = "domagojding";
    userEmail = "domagojding@gmail.com";
  };

  home.stateVersion = "24.05";
  };
    
  programs.zsh = {
    enable = true;
    histSize = 100000;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true; 
    enableBashCompletion = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

fonts = {
  fontDir.enable = true;
  enableGhostscriptFonts = true;
  packages = with pkgs.nerd-fonts; [
    hasklug
    fantasque-sans-mono
    zed-mono
    _3270
    bigblue-terminal
    comic-shanns-mono
    iosevka-term
    iosevka
    symbols-only
  ];
};

  system.stateVersion = "24.05"; # Did you read the comment?

}
