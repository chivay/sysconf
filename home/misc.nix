{ pkgs, ... }:
let
in
{
  programs.home-manager.enable = true;

  programs.bash.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
    ];
  };
  programs.firefox.enable = true;

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "Hubert Jasudowicz";
    userEmail = "hubert.jasudowicz@gmail.com";
    extraConfig = {
      submodule = {
        recurse = true;
      };
    };
  };

  home.packages = with pkgs; [
    htop
    rbw
    libnotify
    unzip
    zip
    p7zip
    file
    imagemagick
    wireshark
    dconf
    xdg-utils
    gnupg1
    jq

    # neomutt
    ripgrep
    zathura

    whois
    wget
    dig

    (python3.withPackages (packages: with packages; [
      ipython
    ]))

    signal-desktop
    element-desktop
    discord
    ghidra

    man-pages
    man-pages-posix

    usbutils
    pciutils

    imhex

    binutils
    teamspeak_client
    ansible
    yt-dlp
    chatblade
    kicad
  ];

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  programs.nix-index.enable = true;
  programs.nix-index.enableBashIntegration = true;
}
