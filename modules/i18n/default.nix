{
  config,
  inputs,
  lib,
  ...
}:
let
  glibcLocales =
    pkgs:
    pkgs.glibcLocales.override {
      allLocales = false;
      locales = [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];
    };

in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.glibcLocales = glibcLocales pkgs;
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "zh_CN.UTF-8";
        LC_IDENTIFICATION = "zh_CN.UTF-8";
        LC_MEASUREMENT = "zh_CN.UTF-8";
        LC_MONETARY = "zh_CN.UTF-8";
        LC_NAME = "zh_CN.UTF-8";
        LC_NUMERIC = "zh_CN.UTF-8";
        LC_PAPER = "zh_CN.UTF-8";
        LC_TELEPHONE = "zh_CN.UTF-8";
        LC_TIME = "zh_CN.UTF-8";
      };
    };
  flake.modules.home.base =
    { pkgs, ... }:
    {
      i18n.glibcLocales = glibcLocales pkgs;
    };

}
