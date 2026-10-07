{
  mkKdeDerivation,
  kmail-account-wizard
}:
mkKdeDerivation {
  pname = "kmail";

  extraBuildInputs = [
    kmail-account-wizard
  ];
  meta.mainProgram = "kontact";
}
