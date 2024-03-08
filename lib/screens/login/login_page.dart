import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Container());
  }
}
