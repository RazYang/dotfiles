{ inputs, ... }: {
  systems = builtins.filter (system: system != "x86_64-darwin") (import inputs.systems);
}
