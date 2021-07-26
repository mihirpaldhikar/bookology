import 'package:get_storage/get_storage.dart';

class CacheService {
  final cacheStorage = GetStorage();

  void setCurrentUser({required String userName, bool? isVerified}) {
    cacheStorage.write('userName', userName);
    cacheStorage.write('isVerified', isVerified);
  }

  String getCurrentUserNameCache() {
    return cacheStorage.read('userName');
  }

  bool getCurrentIsVerifiedCache() {
    return cacheStorage.read('isVerified');
  }
}
