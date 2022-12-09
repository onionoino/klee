import 'package:klee/net/file_action.dart';
import 'package:latlong2/latlong.dart';

class HomePageService {
  final FileAction fileAction = FileAction();

  saveLocation(LatLng curLatLng) {
    fileAction.readContent().then((value) {
      fileAction.writeContent(
          '$value\n $curLatLng，time：${DateTime.now().toString().substring(0, 19)}');
    });
  }

  showAllRecords() {
    fileAction.readContent().then((value) => print(value.toString()));
  }
}