{}:
{
  # Enable Wayland backend
  nixpkgs.config.chromium.commandLineArgs = "--ozone-platform-hint=auto";
}
