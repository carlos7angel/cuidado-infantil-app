class Server {

  final String? host;
  final String? apiVersion;
  final String? environment;
  final String? municipality;
  final String? state;

  Server({this.host, this.apiVersion, this.environment, this.municipality, this.state});

  static Server fromJson(Map<String, dynamic> data) {
    return Server(
      host: data['host'],
      apiVersion: data['api_version'],
      environment: data['environment'],
      municipality: data['municipality'],
      state: data['department'],
    );
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['host'] = host;
    data['api_version'] = apiVersion;
    data['environment'] = environment;
    data['municipality'] = municipality;
    data['department'] = state;
    return data;
  }

}