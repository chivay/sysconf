{ pkgs, config, ... }:
let
  localAddr = "198.18.1.1";
  localIP = "${localAddr}/32";
  localAS = 65001;
  publicSubnet = "198.18.1.0/24";
  # Split 198.18.2.0/24 into
  # Internal
  # 198.18.2.0/25  255.255.255.128  198.18.2.0 - 198.18.2.127  198.18.2.1 - 198.18.2.126
  # Gateway
  # 198.18.2.128/25  255.255.255.128  198.18.2.128 - 198.18.2.255  198.18.2.129 - 198.18.2.254
  intraSubnet = "198.18.2.0/25";
  gatewaySubnet = "198.18.2.128/25";

  intraWgPort = 51821;
  gatewayWgPort = 51823;
  localNets = [ publicSubnet intraSubnet ];
  subnet = "198.18.0.0/16";

  netPeers = {
    bonus = {
      ASN = 65069;
      publicKey = "iilU7ne3GmkCDV01ztPzlwD5DzoulOqAVOScCeimYhw=";
      endpoint = "zibi.bonusplay.pl:51820";
      peerIP = "198.18.69.1";
      listenPort = 51820;
    };
    ptrcnull = {
      ASN = 65042;
      publicKey = "U1zMThsIMBcr/mh/lF/YShlsMOScmXZoezpPvSwnT0M=";
      endpoint = "ptrc.pl:51821";
      peerIP = "198.18.42.1";
      listenPort = 51822;
    };
  };

  mkProtocolEntry = name: peer: "protocol bgp ${name} from p4peers { neighbor ${peer.peerIP} as ${toString peer.ASN}; };";
  mkNetPeer = name: peer: pkgs.lib.nameValuePair "p4net-${name}" {
    ips = [ localIP ];
    listenPort = peer.listenPort;
    privateKeyFile = config.age.secrets.gbur-wg-p4net.path;
    allowedIPsAsRoutes = false;
    postSetup = "ip route add ${peer.peerIP}/32 dev p4net-${name}";
    postShutdown = "ip route del ${peer.peerIP}/32";
    peers = [
      {
        publicKey = peer.publicKey;
        allowedIPs = [ subnet ];
        endpoint = peer.endpoint;
      }
    ];
  };
in
{
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  age.secrets.gbur-wg-p4net = {
    file = ../../secrets/gbur-wg-p4net.age;
  };

  networking.wireguard.interfaces = {
    wg-gateway = {
      ips = [ gatewaySubnet ];
      privateKeyFile = config.age.secrets.gbur-wg-p4net.path;
      listenPort = gatewayWgPort;
    };

    wg-intra = {
      ips = [ localIP ];
      listenPort = intraWgPort;
      privateKeyFile = config.age.secrets.gbur-wg-p4net.path;
      postSetup = "ip route add ${intraSubnet} dev wg-intra";
      postShutdown = "ip route del ${intraSubnet}";
      peers = [
        # xakep
        {
          publicKey = "+qZQ1WtBYOUbGCIjGgsA/8S0FGXmYSOZAKMMEyWLCyU=";
          allowedIPs = [ "198.18.2.2/32" ];
        }
        # raspi
        {
          publicKey = "jqtz1WStWWxMcXMrCdukp2c/6J737AnhBauJNj1fC3o=";
          allowedIPs = [ "198.18.2.3/32" ];
        }
        # pc
        {
          publicKey = "st4IweE89WwcvnNAtV5Q+kn7YjG4KwWztY+S+RUYxHE=";
          allowedIPs = [ "198.18.2.4/32" ];
        }
        # prv
        {
          publicKey = "h2P8A7MU1QN7J6E/vSuerjE9skzWG7U7fjt5fpzRKUk=";
          allowedIPs = [ "198.18.2.5/32" ];
        }
      ];
    };
  } // (pkgs.lib.mapAttrs' mkNetPeer netPeers);

  # Open wireguard ports
  networking.firewall.allowedUDPPorts = pkgs.lib.mapAttrsToList (_: peer: peer.listenPort) netPeers ++ [ intraWgPort gatewayWgPort ];
  # Open BGP port
  networking.firewall.allowedTCPPorts = [ 179 ];
  services.bird2.enable = true;
  services.bird2.config =
    let
      appendPlus = x: x + "+";
      commaConcat = builtins.concatStringsSep ", ";
      localSubnetPatterns = commaConcat (map appendPlus localNets);
      peerIPs = commaConcat (pkgs.lib.mapAttrsToList (_: peer: peer.peerIP + "/32") netPeers);
    in
    ''
      define OWNIP = ${localAddr};
      define OWNAS = ${toString localAS};
      router id OWNIP;

      function is_self_net() {
        return net ~ [ ${localSubnetPatterns} ];
      }

      function is_valid_network() {
        return net ~ [
            ${subnet}+
          ];
      }

      template bgp p4peers {
        local as OWNAS;
        # metric is the number of hops between us and the peer
        path metric 1;
        multihop;
        # this lines allows debugging filter rules
        # filtered routes can be looked up in birdc using the "show route filtered" command
        ipv4 {
          import filter {
            if is_valid_network() && !is_self_net() then {
              accept;
            } else reject;
          };
  
          export filter {
            if is_valid_network() && source ~ [RTS_STATIC, RTS_BGP] then accept; else reject; };
            import limit 1000 action block;
        };
      };

      protocol kernel {
        scan time 20;
        learn;
        persist;

        ipv4 {
          import filter {
            if net ~ [ ${peerIPs} ] then accept;
            reject;
          };

          export filter {
            if source = RTS_STATIC then reject;
            krt_prefsrc = OWNIP;
            accept;
          };
        };
      }

      protocol device {
        scan time 10; # recheck every 10 seconds
      }

      protocol static {
        # Static routes to announce your own range(s)
        route ${publicSubnet} via "lo";
        route 198.18.2.0/24 via "lo";
        ipv4 {
          import all;
          export none;
        };
      };
      log syslog all;
      log stderr all;
    '' + builtins.concatStringsSep "\n" (pkgs.lib.mapAttrsToList mkProtocolEntry netPeers);
}
