import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // final void Function(File pickedImage) imagePickFn;
  // const UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImage;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedImageFile != null) {
        pickedImage = File(pickedImageFile!.path);
      }
    });
   //widget.imagePickFn(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        pickedImage != null ? CircleAvatar(
          radius: 40,
          backgroundImage: FileImage(pickedImage!),
          backgroundColor: Theme.of(context).primaryColor,
        )
            : Icon(
    Icons.account_circle,
    size: 80,
    color: Colors.grey[700],
    ),
        TextButton.icon(
            onPressed: (){
              _pickImage();
            },
            icon: Icon(Icons.image,color: Theme.of(context).primaryColor,),
            label: Text(
              "Edit Profile Pic",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )
        ),
      ],
    );
  }
}
