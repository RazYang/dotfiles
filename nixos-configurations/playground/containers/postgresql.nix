_:
{
  config =
    _:
    {
      services.postgresql.enable = true;
      system.stateVersion = "24.11";
    };
}
