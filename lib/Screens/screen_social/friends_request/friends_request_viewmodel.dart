import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hookup4u/models/friends_request_view_model.dart';
import 'package:hookup4u/restapi/social_restapi.dart';
import 'package:hookup4u/util/utils.dart';

import 'friends_request_screen.dart';

class FriendRequestViewModel {

  FriendsRequestPageState state;

  FriendRequestViewModel(FriendsRequestPageState state) {

    this.state = state;
    friendRequestShow(true);

  }

  bool isMessageShow = false;
  List<FriendsRequest> allFriendRequestShow = [];

  friendRequestShow(bool isLoaderShow) {

    if(isLoaderShow) {
      EasyLoading.show();
    }
    // String imageJoint = imagesList.join(",");
    SocialRestApi.getFriendRequestListApi().then((value) {
      print(value);
      // if(message['code'] == 200 && message['status'] == "success") {
      if(value != null && value.statusCode == 200) {
        allFriendRequestShow = List();
        // List mapData = jsonDecode(value.body);
        // mapData.forEach((element) {
          FriendsRequestViewModel friendsRequestViewModel = FriendsRequestViewModel.fromJson(jsonDecode(value.body));

          friendsRequestViewModel.data.forEach((element) {
            allFriendRequestShow.add(element);
          });

        // });
        state.setState(() {});
      // } else if(message['status'] == "error"){
      //   Utils().showToast(message['message']);
      } else {
        Utils().showToast("something wrong");
      }
    });
  }

  acceptFriendRequestApi(String friendId) {

    EasyLoading.show();
    // String imageJoint = imagesList.join(",");

    SocialRestApi.putAcceptFriendRequest(friendId).then((value) {
      print(value);

      // if(message['code'] == 200 && message['status'] == "success") {
      if(value != null && value.statusCode == 200) {

        // Utils().showToast();


        /*     List mapData = jsonDecode(value.body);

        mapData.forEach((element) {

          FriendsRequestViewModel friendsRequestViewModel = FriendsRequestViewModel.fromJson(element);
          allFriendRequestShow.add(friendsRequestViewModel);
        });*/

        state.setState(() {});
        // } else if(message['status'] == "error"){
        //   Utils().showToast(message['message']);
      } else {
        Utils().showToast("something wrong");
      }
    });
  }


  deleteFriendsRequest(String friendId) {

    EasyLoading.show();

    SocialRestApi.deleteFriendRequestApi(friendId).then((value) {
      print(value);

      // if(message['code'] == 200 && message['status'] == "success") {
      if(value != null && value.statusCode == 200) {

        Utils().showToast("Delete request.");

        friendRequestShow(true);

        // Utils().showToast();


        /*     List mapData = jsonDecode(value.body);

        mapData.forEach((element) {

          FriendsRequestViewModel friendsRequestViewModel = FriendsRequestViewModel.fromJson(element);
          allFriendRequestShow.add(friendsRequestViewModel);
        });*/

        state.setState(() {});
        // } else if(message['status'] == "error"){
        //   Utils().showToast(message['message']);
      } else {
        Utils().showToast("something wrong");
      }
    });

  }


}