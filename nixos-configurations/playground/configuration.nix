{ pkgs, ... }:
{
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    devShmSize = "100%";
    devSize = "100%";
    runSize = "100%";

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq"; # see https://news.ycombinator.com/item?id=14814530
    };

  };
  services = {
    dbus.implementation = "broker";
    nginx = {
      enable = true;
      group = "acme";
      package = pkgs.nginxMainline;
      clientMaxBodySize = "100m";
      defaultHTTPListenPort = 8;
      defaultSSLListenPort = 5;
      virtualHosts = {
        "ldap.razyang.com" = {
          forceSSL = true;
          useACMEHost = "razyang.com";
          locations."/" = {
            proxyPass = "http://localhost:17170";
          };
        };
      };
    };
    factorio = {
      enable = true;
      game-name = "razyang's factorio game";
      admins = [ "razyang" ];
      allowedPlayers = [
        "razyang"
        "SEMOKA"
        "Toto_xx"
      ];
    };
    lldap = {
      enable = true;
      settings = {
        ldap_base_dn = "dc=razyang,dc=com";
        ldap_user_dn = "razyang";
      };
    };
    bitmagnet.enable = false;

    postgresql = {
      enable = true;
      enableJIT = true;
      enableTCPIP = true;
      package = pkgs.postgresql_17_jit;
    };

  };

  security.wrapperDirSize = "100%";
  security.acme = {
    defaults = {
      email = "xzzorz@gmail.com";
    };
    certs = {
      "razyang.com" = {
        dnsProvider = "cloudflare";
        environmentFile = "/var/lib/secrets/razyang.com-cloudflare-api-token";
        extraDomainNames = [ "*.razyang.com" ];
      };
    };
    acceptTerms = true;
  };

  networking = {
    hostName = "playground";
    useDHCP = true;
  };

  users.users.root.initialHashedPassword = "$y$j9T$.BxY4vIjQZapjGvpFvNJy1$u.Z.DuX4/z8hk81K8otcOILeECVx53IqRMlcKj/ek87";

  #environment.memoryAllocator.provider = "mimalloc";
  environment.persistence."/nix/persistent" = {
    hideMounts = true;
    directories = [
      "/root"
      "/var/log"
      "/var/lib/"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  #nixpkgs.hostPlatform = {
  #  system = "x86_64-linux";
  #  gcc.arch = "znver2";
  #  gcc.tune = "znver2";
  #};

  environment.systemPackages = with pkgs; [
    linux-manual
    man-pages
    man-pages-posix
  ];
  nix.settings.system-features = [
    "benchmark"
    "big-parallel"
    "kvm"
    "nixos-test"
    "gccarch-znver2"
  ];
  system.stateVersion = "24.05";
}
