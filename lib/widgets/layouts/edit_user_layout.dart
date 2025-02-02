import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:chatapp/services/firebase_services/firebasestorage_services.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/providers/upload_profile_provider.dart';
import 'package:chatapp/widgets/dialogs/choose_media_dialog.dart';
import 'package:chatapp/widgets/upload_forms/choose_option_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../touchable_opacity.dart';

class EditUserLayout extends StatefulWidget {
  final UserModel user;
  const EditUserLayout({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserLayoutState createState() => _EditUserLayoutState();
}

class _EditUserLayoutState extends State<EditUserLayout> {
  final TextEditingController _nameController = TextEditingController();
  String ProfieUrl = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name!;
    ProfieUrl = widget.user.photourl!;
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final storage_services = Provider.of<FirebaseStorageServices>(context);
    final uploadProfileService = Provider.of<UploadProfile>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
        ),
        // Container(
        //   color: Colors.grey,
        //   height: 3,
        //   width: 35,
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TouchableOpacity(
                onTap: () {
                  Navigator.pop(context);
                  //_nameController.dispose();
                  _nameController
                      .removeListener(() => _nameController.dispose());
                },
                child: Icon(
                  Icons.close,
                  size: 28,
                  color: Color(0xff209EF1),
                ),
              ),
              Text(
                "Edit Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xffD8D8D8)),
              ),
              uploadProfileService.userDataProgress != DataProgress.loading?
              uploadProfileService.userDataProgress == DataProgress.done?
              //disabled btn
              Icon(
                Icons.done,
                size: 28,
                color: ThemeConstants().themeWhiteColor,
              ):
              TouchableOpacity(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  String newName = _nameController.text;
                  newName != user.name ?uploadProfileService.changeName(newName):null;
                   uploadProfileService.loadUserData(context);
                },
                child: Icon(
                  Icons.done,
                  size: 28,
                  color: ThemeConstants().themeBlueColor,
                ),
              ):
              SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: ThemeConstants().themeBlueColor,
                  strokeWidth: 2,
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: ()async {
                  chooseMedia(context,uploadProfileService.chooseImage);
                  //final bool ischosen = await uploadProfileService.chooseImage();
                  // print(ischosen);
                  //print(uploadProfileService.chosenImagePath);
                  //storage_services.selectFile();
                },
                child: Stack(
                  children: [
                    uploadProfileService.isFileChosen?
                    // CircleAvatar(
                    //   radius: 40,
                    //   backgroundImage:FileImage(File(uploadProfileService.chosenImagePath!)),
                    // ):
                    Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(File(uploadProfileService.chosenImagePath!)),
                      ),
                    ),
                  ):
                    CachedNetworkImage(
                  imageUrl: user.photourl.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: imageProvider,
                      ),
                    ),
                  ),
                ),
                    Positioned(
                      child: GestureDetector(
                        onTap: ()async{
                          uploadProfileService.cropImage();
                        },
                        child: CircleAvatar(
                            backgroundColor: Color(0xff141E29),
                            radius: 10,
                            child: uploadProfileService.isFileChosen?
                            GestureDetector(
                              onTap: () {
                                uploadProfileService.removeImage();
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 12,
                              ),
                            ):Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                              size: 12,
                            )
                            ),
                      ),
                      bottom: 0,
                      right: 0.5,
                    )
                  ],
                ),
              ),
              TextFormField(
                controller: _nameController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD8D8D8))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD8D8D8)))),
              ),
              // Text(uploadProfileService.userDataProgress.toString(),style: chatTextName,)
            ],
          ),
        )
        //TextButton(onPressed: ()=>storage_services.change_name(), child: Text("Change my name"))
      ],
    );
  }
}
