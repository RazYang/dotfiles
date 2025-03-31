{...}: {
config = {config,pkgs, ...}:{
services.postgresql.enable = true;
system.stateVersion = "24.11";
};
}
