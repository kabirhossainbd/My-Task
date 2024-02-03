
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_task/controller/base_controller.dart';
import 'package:my_task/services/firebase_auth_service.dart';
import 'package:my_task/src/presentation/view/component/m_toast.dart';
import 'package:my_task/src/presentation/view/pages/auth/login_screen.dart';
import 'package:my_task/src/presentation/view/pages/dashboard/dashboard.dart';
import 'package:my_task/src/utils/constants/m_custom_string_helper.dart';

class AuthController extends GetxController implements GetxService, BaseController {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _reference = FirebaseDatabase.instance.ref().child('Users');

  Future registration(String userName,String email, String password, String phone) async{
    showLoading();
    update();
    try{
      _auth.createUserWithEmailAndPassword(email: email, password: password).then((value){
        SessionService().userId = value.user!.uid.toString();
        _reference.child(value.user!.uid.toString()).set({
          'uid' : value.user!.uid.toString(),
          'email' : value.user!.email.toString(),
          "onlineStatus" : 'active',
          'phone' : phone,
          'username' : userName,
          'profile' : value.user!.photoURL.toString()
        }).then((value){
          hideLoading();
          Get.off(const DashboardScreen());
        }).onError((error, stackTrace){
          hideLoading();
          myToast(error.toString());
        });
      });
    }catch(e){
      debugPrint(e.toString());
    }
}


  Future login(String email, String password) async{
    showLoading();
    update();
    try{
      _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      ).then((value){
        SessionService().userId = value.user!.uid.toString();
        hideLoading();
        Get.off(const DashboardScreen());
      }).onError((error, stackTrace){
        hideLoading();
        myToast(error.toString());
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }


  void isLogin(){
   final user = _auth.currentUser;
   if(user != null){
     SessionService().userId = user.uid.toString();
     Get.off(const DashboardScreen());
   }else{
     Get.off(const LoginScreen());
   }
  }

  logOut(){
    DialogHelper.showLoading();
    _auth.signOut().then((value){
      SessionService().userId = '';
      Get.off(const LoginScreen());
    });
    DialogHelper.hideLoading();
  }

  @override
  hideLoading() {
    DialogHelper.hideLoading();
  }


  @override
  showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }
}
