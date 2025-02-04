import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hookup4u/app.dart';
import 'package:hookup4u/models/profile_detail.dart';
import 'package:hookup4u/models/user_detail_model.dart' as userM;
import 'package:hookup4u/models/user_details_new_model.dart';
import 'package:hookup4u/prefrences.dart';
import 'package:hookup4u/restapi/restapi.dart';
import 'package:hookup4u/util/utils.dart';
import 'edit_profile_screen.dart';
import 'package:http/http.dart' as http;


class EditProfileViewModel {

  Map imageUpdateData = {};
  List imageList = List();
  EditProfilePageState state;
  EditProfileViewModel(EditProfilePageState state) {
    this.state = state;
  }

  editProfileUser() async {

      EasyLoading.show();

      Map<String, dynamic> userMapData = {
        "id" : appState.currentUserData.data.id.toString(),
        // "name": state.nameTxt.text,
        // "email":"",
        // "phone": state.phoneTxt.text,
        "gender": state.selectGender,
        "date_of_birth" : state.dateOfBirth,
      };

      Map<String, dynamic> mapUserData = {
        "name": state.nameTxt.text,
        "image": appState.medialList[0].sourceUrl
      };

      RestApi.updateUserName(mapUserData).then((value) {
        appState.currentUserData.data.displayName = state.nameTxt.text;
      });

      final check = await RestApi.updateUserDetailsSocial(userMapData);

      EasyLoading.dismiss();

      if(check != null && check.statusCode == 200 || check.statusCode == 201) {
          UserDetailsModel userDetailsModel = UserDetailsModel.fromJson(json.decode(check.body));

          appState.userDetailsModel.meta = userM.Meta();
          appState.userDetailsModel.meta.gender = userDetailsModel.gender;
          appState.userDetailsModel.meta.dateOfBirth = userDetailsModel.dateOfBirth;

          Navigator.pop(state.context, mapUserData);
          // print(appState.userDetailsModel.meta.toJson());

          appState.currentUserData.data.displayName = state.nameTxt.text;
          // appState.userDetailsModel.meta.name = state.nameTxt.text;
          // appState.userDetailsModel.meta.gender = state.selectGender;
          // appState.userDetailsModel.meta.dateOfBirth = state.dateOfBirth;

          await sharedPreferences.setString(Preferences.metaData, check.body);
          appState.currentUserData = profileDetailFromJson(sharedPreferences.getString(Preferences.profile));
          print(appState.currentUserData);
          // await sharedPreferences.setString(Preferences.metaData, jsonEncode(userDetailsModel.toJson()));
      } else {
        print("some thing wrong");
      }
  }


  /*updateUserDetails() async {

    EasyLoading.show();
    // EasyLoading.dismiss();

    // appState.jobTitle = jobTitleCont.text.trim();
    // appState.userDetailsModel.meta.jobTitle = jobTitleCont.text.trim();
    // appState.about = aboutCont.text.trim();
    // appState.userDetailsModel.meta.about = aboutCont.text.trim();
    // appState.livingIn = livingCont.text.trim();
    // appState.userDetailsModel.meta.livingIn = livingCont.text.trim();
    // appState.userDetailsModel.meta.children = appState.children;
    // appState.userDetailsModel.meta.relation = appState.relation;
    // appState.userDetailsModel.meta.deviceToken = "";

    // appState.userDetailsModel.meta = userM.Meta();
    appState.userDetailsModel.meta.name = state.nameTxt.text;
    appState.userDetailsModel.meta.dateOfBirth = state.dateOfBirth;
    appState.userDetailsModel.meta.gender = state.selectGender;
    print(appState.userDetailsModel.meta.toFirstJson());

    // print(appState.userDetailsModel.meta.toJson());
    // await sharedPreferences.setString(Preferences.metaData, jsonEncode(appState.userDetailsModel.meta.toJson()));

    RestApi.updateUserDetails(appState.userDetailsModel.meta.toRemoveToken()).then((value) {
      EasyLoading.dismiss();
      if (value == 'success') {
        Navigator.pop(state.context, {"name" : state.nameTxt.text});
      } else {
        Utils().showToast("Something went wrong! Try to update after sometime");
        // snackbarWithDismiss('Something went wrong! Try to update after sometime');
      }
    });
  }*/


  updateUserProfile(File image) async {

    EasyLoading.show();
    var fileContentBase64 = base64.encode(image.readAsBytesSync());

    // List<int> imageBytes = image.readAsBytesSync();
    // print(imageBytes);
    // String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> imageFromData = {
      "file" : image.readAsBytesSync(),
      // "file" : image.readAsBytesSync().toString(),
      "action" : "bp_avatar_upload",
    };

    RestApi.updateUserProfile(image).then((response) {
    EasyLoading.dismiss();
    imageList = List();

    if(response != null && response.statusCode == 200) {
      print("Image Uploaded");
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        if(value != null) {
          // imageList.add();
          imageList = json.decode(value);
          appState.medialList[0].sourceUrl = imageList[0]['thumb'];
          print(image. length);
          state.setState(() { });
        } else {
          Utils().showToast("image uploading null data show");
        }
      });
    } else {
      print("Upload Failed");
      return "error";
    }

    // if(value != "error") {
    //
    //   List image = List();
    //   image.add(json.decode(value));
    //   print(image.length);
    //
    // } else {
    //   Utils().showToast("image uploading in error show");
    // }
    // if(value != null && value?.statusCode == 200 || value?.statusCode == 201) {
       // var imageData = json.decode(value.body);
       // if(imageData != null) {
       //    imageUpdateData = imageData[0];
       //    appState.medialList[0].sourceUrl = imageUpdateData['thumb'];
       //    state.setState(() { });
       //  }
      // }
    });

  }





}