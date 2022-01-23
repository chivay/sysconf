{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  programs.bash.enable = true;

  programs.ssh.enable = true;

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
  };

  home.packages = with pkgs; [
    rbw
    libnotify
    unzip
    p7zip
    file
    imagemagick
    wireshark
    dconf
    xdg-utils
    gnupg1
    jq

    neomutt
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
    ghidra-bin
  ];

  services.gpg-agent = {
    enable = true;
    extraConfig = "pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry";
  };
}
