/// this class contains some constants used in this project
class Constants {
  // Login State Constants
  static const invalidURL = 0;
  static const success = 1;
  static const podNotFound = 2;

  // Auth Data Keys
  static const String accessToken = "accessToken";
  static const String webId = "webId";
  static const String podURI = "podURI";
  static const String containerURI = "containerURI";
  static const String kleeFileURI = "kleeFileURI";
  static const String rsaInfo = "rsaInfo";
  static const String rsa = "rsa";
  static const String pubKeyJwk = "pubKeyJwk";

  // Container Info
  static const String relativeContainerURI = "klee/";
  static const String containerName = "klee";

  // Klee File Info
  static const String relativeKleeFileURI = "klee.ttl";
  static const String kleeFileName = "klee";

  // Klee File Keys
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String dateTime = "dateTime";

  // HTTP Status Constants
  static const int ok = 200;
  static const int created = 201;

  // WebId Url Reg Check
  static final RegExp urlRegExp =
      RegExp(r"(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");

  // Pod None Value
  static const String none = "none";

  // Sparql Action
  static const String insert = "insert";
  static const String delete = "delete";
  static const String update = "update";

  // Predicate Prefix
  static const String predicate = "http://xmlns.com/foaf/0.1/";

  // Login Scopes
  static const List<String> scopes = <String>[
    'openid',
    'profile',
    'offline_access',
    'webid',
    'email',
    'api'
  ];

  // Geo Info Saving Interval (seconds)
  static const int interval = 60;

  // for testing
  static const String cookie =
      "nssidp.sid=s%3A8WafLNvTJ49wdlLjP0qu_z7yuIACDpXp.Mqz1bYcM61tm2JwVbeqG6EjBcvx%2FD791GVmcgIxCWgU";
}
