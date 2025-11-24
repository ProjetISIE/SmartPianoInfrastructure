{ pkgs, ... }: # SD card image for Raspberry Pi 4
# See https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi
# https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_4
# https://l33tsource.com/blog/2024/04/02/Build-custom-NixOS-Raspberry-Pi-images
# https://rbf.dev/blog/2020/05/custom-nixos-build-for-raspberry-pis
{
  networking.hostName = "RaspberryPi4";

  hardware = {
    enableRedistributableFirmware = true;
    # raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    # deviceTree = {
    #   enable = true;
    #   filter = "*rpi-4-*.dtb";
    # };
  };

  users = {
    extraUsers.root = {
      # initialHashedPassword = hashedPassword;
      # hashedPassword = null;
      # initialPassword = password;
      password = "root";
      # hashedPasswordFile = null;
    };
    users.nixos = {
      # initialHashedPassword = hashedPassword;
      # hashedPassword = null;
      # initialPassword = password;
      password = "nixos";
      # hashedPasswordFile = null;
    };
  };

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  networking.wireless.enable = true; # Prefer NetworkManager

  services = {
    openssh.enable = true; # Enable the OpenSSH daemon
    nfs.server.enable = true; # Share files across network
    qemuGuest.enable = true; # To use inside VMs
    openssh = {
      settings.PermitRootLogin = "yes"; # Easily login as root via SSH
      settings.PasswordAuthentication = true;
    };
  };

  console.enable = true;

  environment = {
    systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];
  };
}
