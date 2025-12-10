{
  pkgs,
  self',
  infuse,
  hello-custom,
  ...
}:
infuse hello-custom {
  __output.pname = _: "hello-infuse";
}
