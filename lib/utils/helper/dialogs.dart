import 'package:chat_app/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.primaryColor.withOpacity(.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  static void showProgressBar(BuildContext context){

    showDialog(context: context, builder: (_)=>const Center(child: CircularProgressIndicator(),));

  }
}
