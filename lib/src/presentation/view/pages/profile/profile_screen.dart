import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_task/main.dart';
import 'package:my_task/model/response/chatuser_model.dart';
import 'package:my_task/services/apis.dart';
import 'package:my_task/src/presentation/view/component/m_toast.dart';
import 'package:my_task/src/utils/constants/m_colors.dart';
import 'package:my_task/src/utils/constants/m_custom_string_helper.dart';



//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: MyColor.getBackgroundColor(),
          appBar: AppBar(title: const Text('Profile Screen')),

          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    //user profile picture
                    Stack(
                      children: [
                        if(_image != null)...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: Image.file(
                                File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                            ),
                          )
                        ]else...[
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(mq.height * .1),
                            child: CachedNetworkImage(
                              width: mq.height * .2,
                              height: mq.height * .2,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image,
                              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
                            ),
                          ),
                        ],


                        Positioned(
                          bottom: -8,
                          right: -8,
                          child: MaterialButton(
                            elevation: 2,
                            onPressed:  _showBottomSheet,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: MyColor.getBackgroundColor(),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey[300]!, spreadRadius: 0.1, blurRadius: 0.5, offset: const Offset(2,2))
                                ]
                              ),
                              child: Icon(Icons.edit, size: 16, color: MyColor.getSecondaryColor(),),
                            ),
                          ),
                        ) ,
                        //edit image button
                      ],
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .03),

                    // user email label
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // for adding some space
                    SizedBox(height: mq.height * .05),

                    // name input field
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: MyColor.getSecondaryColor()),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Happy Singh',
                          label: const Text('Name'),
                      ),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.info_outline, color: MyColor.getSecondaryColor()),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Feeling Happy',
                          label: const Text('About')),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .05),

                    // update profile button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: MyColor.getSecondaryColor(),shape: const StadiumBorder(), minimumSize: Size(mq.width * .2, mq.height * .06)),
                      onPressed: () {
                        DialogHelper.showLoading();
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            DialogHelper.hideLoading();
                            myToast('Profile Updated Successfully!');
                          });
                        }
                      },
                      icon: const Icon(Icons.edit, size: 28, color: Colors.white,),
                      label:
                      const Text('Update', style: TextStyle(fontSize: 16, color: MyColor.colorWhite)),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(Icons.image)),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(Icons.camera)),
                ],
              )
            ],
          );
        });
  }
}
