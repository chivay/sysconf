{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./coredns.nix
    ./p4net.nix
  ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [
    htop
    tmux
    git
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  boot.cleanTmpDir = true;
  services.gitea = {
    enable = true;
    appName = "p4net gitea";
    database = { type = "sqlite3"; };
    domain = "gitea.chivay.p4";
    rootUrl = "https://gitea.chivay.p4";
    httpPort = 3001;

  };

  virtualisation.docker.enable = true;

  ##services.inspircd.enable = true;
  ##services.inspircd.config = ''
  ##<admin name="Hubert Jasudowicz" nick="chivay" email="root@chivay.p4">
  ##<server name="irc.chivay.p4" description="p4net IRC server" network="p4net" id="000">

  ##<module name="spanningtree">
  ##<autoconnect period="10s" server="irc.bonus.p4">
  ##<link allowmask="198.18.69.0/24"
  ##      ipaddr="198.18.69.1"
  ##      name="irc.bonus.p4"
  ##      port="7000"
  ##      recvpass="2137"
  ##      sendpass="2137" >

  ##<bind address="198.18.1.1" port="6667" type="clients" defer="0s" free="no">
  ##<bind address="198.18.1.1" port="7000" type="servers" defer="5s" free="no">
  ##'';

  networking.firewall.allowedTCPPorts = [ 80 443 6667 7000 ];
  services.nginx = {
    enable = true; # Enable Nginx
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."gitea.chivay.p4" = {
      # Gitea hostname
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:3001/"; # Proxy Gitea
      sslCertificate = "/persist/chivay-wildcard.crt";
      sslCertificateKey = "/persist/chivay.key";
    };

    virtualHosts."chivay.p4" = {
      root = "/var/www/chivay.p4";
      forceSSL = true;
      sslCertificate = "/persist/chivay-wildcard.crt";
      sslCertificateKey = "/persist/chivay.key";
    };

    virtualHosts."irc.chivay.p4" = {
      forceSSL = false;
      locations."/".proxyPass = "http://localhost:9000/"; # Proxy Gitea
    };

  };

  networking.hostName = "gbur";
  networking.firewall.enable = true;
  networking.nameservers = [ "127.0.0.1" "1.1.1.1" "1.0.0.1" ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHL/kB8ntXpTs2YrH5NBbo/jvROm/J1kRiZ8sTl7Zbc chivay@xakep"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLJN8Kz3Cn4mMQCPar9j99s5rD7JAP2kUWVleiv2LF8"
  ];

}
