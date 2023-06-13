import 'package:get_storage/get_storage.dart';
import '../../contants/Constants.dart';

getHeader() {
  GetStorage box = GetStorage();
  var token = box.read(loginToken);
  print("print token $token");
  var header = {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  return header;
}
