{ pkgs, ... }: {
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.coredns.enable = true;
  services.coredns.config =
    ''
      . {
        forward . 1.0.0.1 8.8.8.8 8.8.4.4 {
          except p4
        }
        log
        cache
      }

      chivay.p4 {
        hosts {
          198.18.1.1 gbur.chivay.p4
          198.18.1.2 mruk.chivay.p4
          198.18.1.1 gitea.chivay.p4
          198.18.1.1 irc.chivay.p4
          198.18.1.1 chivay.p4
        }
      }

      57.18.198.in-addr.arpa {
        forward . 198.18.57.1
      }
      dominikoso.p4 {
        forward . 198.18.57.1
      }

      42.18.198.in-addr.arpa {
        forward . 198.18.42.1
      }
      ptrcnull.p4 {
        forward . 198.18.42.1
      }

      69.18.198.in-addr.arpa {
        forward . 198.18.69.1
      }
      bonus.p4 {
        forward . 198.18.69.1
      }

      70.18.198.in-addr.arpa {
        forward . 198.18.70.1
      }
      msm.p4 {
        forward . 198.18.70.1
      }
    '';
}
