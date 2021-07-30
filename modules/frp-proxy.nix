{ config, pkgs, lib, ... }:
let
  cfg = ''
    [common]
    server_addr = 0xc2.net
    server_port = 7000

    [mail]
    type = tcp
    local_ip = 127.0.0.1
    local_port = 25
    remote_port = 25

    [ssh]
    type = tcp
    local_ip = 127.0.0.1
    local_port = 22
    remote_port = 1337
  '';
  configFile = pkgs.writeText "frps.ini" cfg;
in
{
  systemd.services.frp-proxy = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "FRP fast proxy";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.frp}/bin/frpc -c ${configFile}'';
      ExecReload = ''${pkgs.frp}/bin/frpc reload -c ${configFile}'';
      LimitNOFILE = 1048576;
    };
  };
  environment.systemPackages = [ pkgs.frp ];
}
