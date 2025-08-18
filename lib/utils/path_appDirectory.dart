//Get Document Path
import 'package:path_provider/path_provider.dart';

Future<String> getAppDocumentsPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
