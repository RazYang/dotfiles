{
  pkgs,
  self',
  hello-custom,
  ...
}:
pkgs.dockerTools.buildImage {
  name = "hello-oci";
  tag = "latest";
  copyToRoot = [ self'.packages.hello-custom ];
  config = {
    Cmd = [ "${hello-custom}/bin/hello" ]; # same as self'.packages.hello-custom
  };
}
