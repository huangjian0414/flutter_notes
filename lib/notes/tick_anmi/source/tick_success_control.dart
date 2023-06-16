


import 'package:flutter/material.dart';

class TickSuccessControl {

  AnimationController? animationController;

  bool isSuccess;

  TickSuccessControl({this.isSuccess = false,this.animationController});

  updateStatus(bool status){
    if (status != isSuccess) {
      isSuccess = status;
      animationController?.reset();
      if (isSuccess) {
        animationController?.forward();
      }else{
        animationController?.repeat();
      }
    }
  }
}