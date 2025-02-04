import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hookup4u/Screens/screen_social/search_view/search_screen.dart';
import 'package:hookup4u/models/search_response_model.dart';
import 'package:hookup4u/restapi/social_restapi.dart';
import 'package:hookup4u/util/utils.dart';

class SearchViewModel {

  SearchResponseModel searchResponseModel;
  SearchResponseModel searchRecentResponseModel;


  bool recentDataShowMessage = true;
  bool searchDataShowMessage = true;

  bool isChangesThisScreen = false;

  SearchScreenState state;

  SearchViewModel(SearchScreenState state) {
    this.state = state;
    userRecentHistory();
  }

  searchListApi(String searchTile) {
    EasyLoading.show();
    SocialRestApi.searchFriendListApi(searchTile).then((value) {
      searchDataShowMessage = false;
      if(value != null && value.statusCode == 200) {
        // imagesList.add(value.sourceUrl.toString());
        searchResponseModel = SearchResponseModel.fromJson(jsonDecode(value.body));
        state.setState(() {});
      } else {
        Utils().showToast("Data is empty");
      }
      //flase load;
    });
  }

  userFollowApi(String userId, bool isRecentView) {

    print("Hello $userId");
    EasyLoading.show();
    // String imageJoint = imagesList.join(",");

    SocialRestApi.postUserFollowApi(userId).then((value) {
      print(value);
      Map<String, dynamic> message = jsonDecode(value.body);
      if(message['code'] == 200 && message['status'] == "success") {

        isChangesThisScreen = true;

        // Utils().showToast(message['message']);
        // showMyPostApi();
        // state.isShowFollowUnFollow = !state.isShowFollowUnFollow;

        if(!isRecentView) {
          userRecentHistory();
        } else {
          searchListApi(state.searchFiled.text);
        }
        state.setState(() {});
      } else if(message['status'] == "error"){
        Utils().showToast(message['message']);
      } else {
        Utils().showToast("something wrong");
      }
    });
  }


  userRecentHistory() {
    EasyLoading.show();
    SocialRestApi.getRecentUserList().then((value) {
      print(value);
      Map<String, dynamic> message = jsonDecode(value.body);
      if(value != null && message['code'] == 200 && message['status'] == "success") {
        recentDataShowMessage = false;
        // searchListApi(state.searchFiled.text);
        // searchRecentResponseModel = SearchResponseModel();
        searchRecentResponseModel = SearchResponseModel.fromJson(message);
        state.setState(() {});
      } else if(message['status'] == "error") {
        Utils().showToast(message['message']);
      } else {
        Utils().showToast("something wrong");
      }
    });
  }


  userRecentHistoryDelete() {
    EasyLoading.show();
    SocialRestApi.deleteRecentHistory().then((value) {
      print(value);
      Map<String, dynamic> message = jsonDecode(value.body);
      if(value != null && message['code'] == 200 && message['status'] == "success") {
        searchRecentResponseModel = SearchResponseModel();
        Utils().showToast(message['message']);
        state.setState(() {});
      } else if(message['status'] == "error"){
        Utils().showToast(message['message']);
      } else {
        Utils().showToast("something wrong");
      }
    });
  }


}