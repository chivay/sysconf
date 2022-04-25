let
  chivay = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLJN8Kz3Cn4mMQCPar9j99s5rD7JAP2kUWVleiv2LF8";

  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdCuiI0bV/M5KtVu/AqIMwPjcUUQ+pIC6GPs3iqu1Qq";
  gbur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNaFuVZt7HpKIH0O4RUApv7V8ch0CGrDqxkeaZ1VROm";
in
{
  "pc-wg-p4net.age".publicKeys = [ chivay pc ];
}
