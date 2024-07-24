enum ActionError : Error {
  case missingInstallation
}

enum InternalError : Error {
  case missingEnvironmentVariable(String)
}
