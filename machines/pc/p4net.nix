{ lib, config, options, modulesPath, specialArgs }:
{
  security.pki.certificates = [ (builtins.readFile ../../files/p4net-ca.crt) ];
  systemd.network = {
    enable = true;
    netdevs = {
      "90-p4net" = {
        netdevConfig = { Kind = "wireguard"; Name = "wg-p4net"; };
        wireguardConfig = {
          PrivateKeyFile = "/persist/p4net/privkey";
        };
        wireguardPeers = [
          {
            wireguardPeerConfig = {
              Endpoint = "gbur.potega.xyz:51821";
              PublicKey = "n95378M/NgKYPLl2vpxYA32tLt8JJ3u3BsNP0ykSiS8=";
              AllowedIPs = [ "198.18.0.0/16" ];
            };
          }
        ];
      };
    };
    networks = {
      "40-wlan0" = {
        matchConfig.Name = "wlan0";
        DHCP = "yes";
        dhcpV4Config.UseDNS = false;
      };
      "90-p4net" = {
        matchConfig.Name = "wg-p4net";
        dns = [ "198.18.1.1" ];
        address = [ "198.18.2.4/32" ];
        domains = [ "p4" ];
        networkConfig = {
          DNSSEC = false;
        };
        routes = [
          {
            routeConfig = {
              Gateway = "198.18.1.1";
              Destination = "198.18.0.0/16";
              GatewayOnLink = true;
            };
          }
        ];
        linkConfig = {
          RequiredForOnline = false;
        };
      };
    };
  };
}
