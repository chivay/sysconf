{
  users.users.chivay = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "wireshark" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.chivay = {
      imports = [
        ./alacritty.nix
        ./fonts.nix
        ./misc.nix
        ./multimedia.nix
        ./nvim.nix
        ./sway.nix
        ./tmux.nix
      ];
      home.username = "chivay";
      home.homeDirectory = "/home/chivay";
      home.stateVersion = "21.05";
    };
  };
}
