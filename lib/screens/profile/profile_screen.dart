// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user_model.dart';
import 'package:chat_app/network/firebase_dabase.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/utils/app_colors/app_colors.dart';
import 'package:chat_app/utils/asset_image/k_assets_image.dart';
import 'package:chat_app/utils/helper/dialogs.dart';
import 'package:chat_app/utils/helper/helper_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUserModel userModel;
  const ProfileScreen({
    super.key,
    required this.userModel,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _image;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile Screen"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .06),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: size.height * .2,
                            width: size.height * .2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.black54),
                            ),
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(size.width * .3),
                                    child: Image.file(
                                      File(_image!),
                                      height: size.height * .2,
                                      width: size.height * .2,
                                    ))
                                : ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(size.width * .3),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.userModel.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: size.height * .2,
                                        width: size.height * .2,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.transparent,
                                              BlendMode.colorBurn,
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        child: Icon(CupertinoIcons.person),
                                      ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -4,
                            child: MaterialButton(
                              child: const CircleAvatar(
                                child: Icon(Icons.edit),
                              ),
                              onPressed: () {
                                _showModelSheet();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  Text(
                    widget.userModel.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  TextFormField(
                    initialValue: widget.userModel.name,
                    onSaved: (val) => widget.userModel.name = val ?? '',
                    //onSaved: (val)=>FirebaseDatabase.me.name==val??'',
                    validator: (val) => val != null && val.isNotEmpty
                        ? null
                        : "Required Name Field",
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      hintText: "eg.Happy Singh",
                      label: const Text("Name"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  TextFormField(
                    initialValue: widget.userModel.about,
                    onSaved: (val) => widget.userModel.about = val ?? '',
                    //onSaved: (val)=>FirebaseDatabase.me.about==val??'',
                    validator: (val) => val != null && val.isNotEmpty
                        ? null
                        : "Required About Field",
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                      ),
                      hintText: "eg.Felling Happy",
                      label: const Text("About"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        elevation: 1, backgroundColor: AppColors.primaryColor),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FirebaseDatabase.updateUserInfo();
                        kPrint("Inside Validator !!");
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Update",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);
              Navigator.pop(context);
              Navigator.pop(context);
              await FirebaseDatabase.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                });
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ),
      ),
    );
  }

  _showModelSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: mqSize.height * .03, bottom: mqSize.height * .05),
            children: [
              const Text(
                "Pick Profile Picture!!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: mqSize.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(mqSize.width * .3, mqSize.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        kPrint("Image Path : ${image.path}");
                        setState(() {
                          _image = image.path;
                        });
                        FirebaseDatabase.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                      KAssetsImage.image_add,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(mqSize.width * .3, mqSize.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        kPrint("Image Path : ${image.path}");
                        setState(() {
                          _image = image.path;
                        });
                        FirebaseDatabase.updateProfilePicture(File(_image!));

                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                      KAssetsImage.camera,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
