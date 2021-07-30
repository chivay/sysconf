{ config, pkgs, lib, ... }:
{
  services.postfix = {
    enable = true;
    hostname = "mail.jasudowi.cz";
    domain = "jasudowi.cz";
    origin = "jasudowi.cz";
    virtual = ''
      postmaster@jasudowi.cz chivay@jasudowi.cz

      @jasudowi.cz chivay@jasudowi.cz
    '';
    destination = [
      "jasudowi.cz"
    ];
  };

}
