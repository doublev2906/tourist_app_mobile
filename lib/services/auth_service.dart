import 'package:get/get.dart';
import 'package:tourist_app_mobille/storage/storage.dart';

class AuthService extends GetxService {    
  
  final name = Rx<String>('');

  final email = Rx<String>('');
  
  final phoneNumber = Rx<String>('');

  final userId = Rx<String>('');
  
  final accessToken = Rx<String>('');
  
  final refreshToken = Rx<String>('');
  
  void setUserData(){
    final String token = appStorage.getToken(accessToken);
  }
  
  
}