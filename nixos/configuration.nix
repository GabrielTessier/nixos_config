{ config, lib, pkgs, ...}: {
  config = {
    systemSettings = {
      users = [ "gabriel" ];
      adminUsers = [ "gabriel" ];
      gpg.enable = true;
      hyprland.enable = true;
      c.enable = true;
      emacs.enable = true;
    };
    programs.waybar.enable = true;
    users.users.gabriel.description = "gabriel";
    home-manager.users.gabriel.userSettings = {
      name = "Gabriel TESSIER";
      email = "gabriel.tessier45@gmail.com";
    };

    boot.loader.grub.extraEntries = ''
      menuentry 'Arch Linux (rolling) (on /dev/nvme0n1p3)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-simple-80b11156-c08d-44ac-9ce6-114a125d5267' {
        set gfxpayload=keep
	insmod gzio
	insmod part_gpt
	insmod fat
	search --no-floppy --fs-uuid --set=root 1258-8887
	linux /vmlinuz-linux root=UUID=80b11156-c08d-44ac-9ce6-114a125d5267 rw loglevel=3
	initrd /intel-ucode.img /initramfs-linux.img
      }
    '';
  };
}
