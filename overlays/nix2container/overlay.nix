final: prev: {
  nix2container =
    prev.inputs.nix2container.packages."${prev.stdenv.hostPlatform.system}".nix2container;
}
