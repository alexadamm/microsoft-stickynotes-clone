import 'package:flutter_dotenv/flutter_dotenv.dart';

String rootEndpoint = dotenv.get('API_ROOT_ENDPOINT');

class Config {
  static String appName = "Microsoft's Sticky Notes";
  static String regisAPI = "$rootEndpoint/users";
  static String authAPI = "$rootEndpoint/authentications";
  static String notesAPI = "$rootEndpoint/notes";
}
