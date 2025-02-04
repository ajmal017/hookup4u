import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hookup4u/Screens/screen_social/comment_view/comment_screen.dart';
import 'package:hookup4u/Screens/screen_social/friends_request/friends_request_screen.dart';
import 'package:hookup4u/Screens/screen_social/home/tab1/post_data/post_data_screen.dart';
import 'package:hookup4u/Screens/screen_social/like_show/like_show_screen.dart';
import 'package:hookup4u/Screens/screen_social/search_view/search_screen.dart';
import 'package:hookup4u/Screens/screen_social/user_profile_view/user_profile_screen.dart';
import 'package:hookup4u/models/socialPostShowModel.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/utils.dart';
import 'package:intl/intl.dart';
import 'edit/edit_screen.dart';
import 'home_viewmodel.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;


class SocialHomePage extends StatefulWidget {

  final TabController tabController;
  const SocialHomePage({Key key, this.tabController}) : super(key: key);

  @override
  SocialHomePageState createState() => SocialHomePageState();
}

class SocialHomePageState extends State<SocialHomePage> {

  bool isRef = false;
  String postIdStr = "0";
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController commentController = TextEditingController(text: "");

  List<String> emojis = ["👍","❤️","😘","🤣","😡","😥"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final loveEmojis = Emoji.byKeyword('love'); // returns list of lovely emojis :)
    // print(loveEmojis);
    print(commentController.text);
    refreshList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    // setState(() {
    //   // model.showCommentApi();
    // });
    return null;
  }

  SocialHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    model ?? (model = SocialHomeViewModel(this));
    return Material(
      color: ColorRes.primaryColor,
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshList,
        child: SingleChildScrollView (
          physics: ClampingScrollPhysics(),
          child: Column (
            children: [
              headerView(),
              // storyView(),
              showUserData()
            ],
          ),
        ),
      ),
    );
  }

  headerView() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10,  right: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              icon: Icon(Icons.arrow_back_outlined, color: ColorRes.white),
              onPressed: ()  {
                  Navigator.pop(context);
              }),
          ),
        Expanded(
          child: InkResponse(
            onTap: () async {
              bool isUpdate = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
              if(isUpdate) {
                model.showPostApi();
              }
            },
            child: Container(
                width: Utils().getDeviceWidth(context) - 175,
                height: 40,
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration (
                  color: ColorRes.greyBg.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(60),
                ),
               child: Text("Search Friends", style: TextStyle(color: Colors.white)),
               /* child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Friends"
                  ),
                )*/
            ),
          ),
        ),

        InkWell (
          onTap: () async {
            // isRef = await Navigator.push(context, MaterialPageRoute(builder: (context) => PostDataScreen(isEdit: false, postId: "")));
            // if (isRef) {
            //   model.showPostApi();
            // }
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsRequestPage()));
          },
          child: Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: ColorRes.primaryRed,
              shape: BoxShape.circle
            ),
            child: Icon(Icons.person_add_alt_1, color: ColorRes.white, size: 25),
          ),
        ),


        InkWell(
          onTap: () async {
            isRef = await Navigator.push(context, MaterialPageRoute(builder: (context) => PostDataScreen(isEdit: false, postId: "")));
            if (isRef) {
              model.showPostApi();
            }
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: ColorRes.primaryRed,
                shape: BoxShape.circle
            ),
            child: Icon(Icons.add, color: ColorRes.white, size: 35),
          ),
        )
      ]),
    );
  }

  storyView() {
    return Container(
      height: 250,
      width: Utils().getDeviceWidth(context),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(right: 10, top: 20),
                  child: Text("View all", style: TextStyle(color: ColorRes.primaryRed)))),
          Text("Streams"),
          Container(
            height: 150,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
              return Container(
                height: 150,
                width: 125,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: ColorRes.greyBg,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text("hello"),
              );
            }),
          )
        ],
      ),
    );
  }

  showUserData() {
    if(model.isEmptyMessageShow) {
      return Container();
    } else {
      return model.socialPostShowList.length == 0 ?
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .8,
          alignment: Alignment.center,
          child: Text("No any friend post", style: TextStyle(color: ColorRes.white, fontSize: 20), overflow: TextOverflow.ellipsis)) :
      Container(
        width: kIsWeb ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: model.socialPostShowList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return showView(index, model.socialPostShowList[index]);
            }),
      );
    }
  }

  showView(int index, SocialPostShowData socialPostShowList) {
    if(model.socialPostShowList[index].parentPost != null) {
      return sharingViewShow(index, socialPostShowList);
    } else {
      return postView(index, socialPostShowList);
    }
  }


  likeComment(int index, SocialPostShowData socialPostShowList) {
    return Container(
      height: 50,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Row(
           children: [
             SizedBox(width: 10),
             InkWell (
                 onTap: () {
                   if(model.socialPostShowList[index].selfLike) {
                     model.deleteLikeApi(socialPostShowList.id, index);
                   } else {
                     model.addLikeApi(socialPostShowList.id, "#like", index);
                   }
                 },
                 onLongPress: () {
                   postIdStr = socialPostShowList.id;
                   setState(() {});
                 },
                  child:  model.socialPostShowList[index].selfLike
                      ? Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Icon(Icons.favorite,
                              color: Colors.white)
                  ) : Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Icon(Icons.favorite_border_outlined, color: Colors.white))),

              // : Icon(Icons.favorite_border_outlined, color: Colors.white)

             SizedBox(width: 10),
             InkWell(
                 onTap: () {
                   if(socialPostShowList.likeCount != null  && socialPostShowList.likeCount != 0) {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => LikeShowScreen(postId: socialPostShowList.id)));
                   }
                 },
                 child: Container(
                     height: 40,
                     alignment: Alignment.center,
                     child: Text(socialPostShowList.likeCount.toString() ?? "0", style: TextStyle(color: Colors.white)))),


             SizedBox(width: 20),
             InkResponse(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(postId: socialPostShowList.id)));
                 },
                 child: Container(
                     height: 40,
                     alignment: Alignment.center,
                     child: Icon(Icons.message, color: Colors.white))
             ),

             SizedBox(width: 15),
             InkWell(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(postId: socialPostShowList.id)));
                 },
                 child: Container(
                     height: 40,
                     alignment: Alignment.center,
                     child: Text(socialPostShowList.commentCount.toString() ?? "0", style: TextStyle(color: Colors.white)))),
           ],
         ),
         // Padding(
         //     padding: EdgeInsets.only(right: 10),
         //     child: Image(
         //         height: 35,
         //         width: 35,
         //         image: AssetImage('asset/Icon/layer.png'))),
        ],
      ),
    );
  }

  postView(int index, SocialPostShowData socialPostShowList) {

    String currentTime = "";
    DateTime dateTIme = DateTime.parse(model.socialPostShowList[index].postDate);
    final date2 = DateTime.now().toUtc();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(date2);
    DateTime utcTime = DateTime.parse(formatted);
    final days = utcTime.difference(dateTIme).inDays;
    final hours = utcTime.difference(dateTIme).inHours;
    final minutes = utcTime.difference(dateTIme).inMinutes;

    if(minutes <= 60) {
      currentTime = "$minutes minutes ago";
    } else if(hours <= 24) {
      currentTime = "$hours hours ago";
    } else if(days > 0) {
      currentTime = "$days days ago";
    }

    return Stack(
      children: [
        Container(
          // height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(5),
              color: ColorRes.primaryColor,
              boxShadow: [BoxShadow(color: ColorRes.black, blurRadius: 5.0, offset: Offset(0, 0), spreadRadius: 0.1)]
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    userImgNameShow(index, currentTime),

                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: popUpMenuButton(index, model.socialPostShowList[index].id, false),
                    ),
                  /*  Row(
                      children: [
                        InkResponse(
                            onTap: () {
                              model.showPostApi();
                            },
                            child: Icon(Icons.refresh, color: Colors.black, size: 30)),
                        InkResponse (
                            onTap: () async {
                              // model.deletePostApi(model.socialPostShowList[index].id);
                              isRef = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditDataScreen(socialPostShowData: socialPostShowList)));
                              if(isRef) {
                                model.showPostApi();
                              }
                            },
                            child: Icon(Icons.edit, color: Colors.black, size: 30)),
                        InkResponse(
                            onTap: () {
                              model.deletePostApi(socialPostShowList.id);
                            },
                            child: Icon(Icons.delete, color: Colors.black, size: 30))
                      ],
                    )*/
                  ],
                ),
              ), //appState.currentUserData

              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                  child: model.socialPostShowList[index].content != null && model.socialPostShowList[index].content.isNotEmpty ?
                  Text(model.socialPostShowList[index].content, style: TextStyle(color: ColorRes.white), textAlign: TextAlign.left ) : Container()),

              model?.socialPostShowList[index]?.media != null && model?.socialPostShowList[index].media.isNotEmpty ? Container(
                height: MediaQuery.of(context).size.height - 400,
                // height: double.infinity,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: PageView.builder(
                    itemCount: model.socialPostShowList[index].media.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index1) {
                      return CachedNetworkImage(
                          imageUrl: model.socialPostShowList[index].media[index1],
                          placeholder: (context, url) => Image.asset (
                              'asset/Icon/placeholder.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover ),
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover
                      );
                    }),
              )  :  Container(),
              likeComment(index, socialPostShowList),
            ],
          ),
        ),
        likeEmojisView(index, socialPostShowList)
      ],
    );
  }

  sharingViewShow(int index, SocialPostShowData socialPostShowList) {

    String currentTime = "";
    DateTime dateTIme = DateTime.parse(model.socialPostShowList[index].postDate);
    final date2 = DateTime.now().toUtc();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    print(formatter);
    final String formatted = formatter.format(date2);
    DateTime utcTime = DateTime.parse(formatted);
    final days = utcTime.difference(dateTIme).inDays;
    final hours = utcTime.difference(dateTIme).inHours;
    final minutes = utcTime.difference(dateTIme).inMinutes;

    if(minutes <= 60) {
      currentTime = "$minutes minutes ago";
    } else if(hours <= 24) {
      currentTime = "$hours hours ago";
    } else if(days > 0) {
      currentTime = "$days days ago";
    }

    return Stack(
      children: [
        Container(
          // height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(5),
              color: ColorRes.primaryColor,
              boxShadow: [BoxShadow(color: ColorRes.black, blurRadius: 5.0, offset: Offset(0, 0), spreadRadius: 0.1)]
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 0),
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    userImgNameShow(index, currentTime),
                    Padding(padding: EdgeInsets.only(right: 10),
                      child: popUpMenuButton(index, model.socialPostShowList[index].parentPost.id, true),
                    ),
                  ],
                ),
              ), //appState.currentUserData

              Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Text(model.socialPostShowList[index].content, style: TextStyle(color: ColorRes.white))),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    SizedBox(height: 10),

                    Row(
                      children: [

                        SizedBox(width: 10),

                        InkResponse(
                          onTap: () {
                            // widget.tabController.animateTo(3, duration: Duration(milliseconds: 500));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                                height: 25,
                                width: 25,
                                image: NetworkImage(model.socialPostShowList[index].thumb)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${model.socialPostShowList[index].parentPost.userName }",  style: TextStyle(color: ColorRes.white), overflow: TextOverflow.ellipsis, maxLines: 1),
                            // Text(currentTime, style: TextStyle(color: ColorRes.greyBg, fontSize: 12))
                          ],
                        ),
                      ],
                    ),

                    // Padding(padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                    //     child: Text(model.socialPostShowList[index].parentPost.userName, style: TextStyle(color: ColorRes.white))),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 10, bottom: 5, top: 10),
                        child: model.socialPostShowList[index].parentPost.content != null && model.socialPostShowList[index].parentPost.content.isNotEmpty ?
                        Text(model.socialPostShowList[index].parentPost.content, style: TextStyle(color: ColorRes.white), textAlign: TextAlign.left ) : Container()),
                    model.socialPostShowList[index].parentPost.media != null && model.socialPostShowList[index].parentPost.media.isNotEmpty ? Container(
                      height: MediaQuery.of(context).size.height  - 400,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: PageView.builder(
                          itemCount: model.socialPostShowList[index].parentPost.media.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index1) {
                            return
                                 CachedNetworkImage(
                                imageUrl: model.socialPostShowList[index].parentPost.media[index1],
                                placeholder: (context, url) => Image.asset(
                                    'asset/Icon/placeholder.png',
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover);
                            //     : Image.asset(
                            //     'asset/Icon/placeholder.png',
                            //     height: 120,
                            //     width: 120,
                            //     fit: BoxFit.cover
                            // );
                          }),
                    ) : Container(),

                  ],
                ),
              ),


              likeComment(index, socialPostShowList),

              /*Container(height: 50, color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    likeCommentShare("Comment",2, model.socialPostShowList[index].id),
                    likeCommentShare("Share",3, model.socialPostShowList[index].id),
                  ],
                ),
              )*/
            ],
          ),
        ),

        likeEmojisView(index, socialPostShowList)

      ],
    );
  }

  userImgNameShow(int index, String currentTime) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(
            userId: int.parse(model.socialPostShowList[index].userId),
            isFollow: true)));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
                height: 25,
                width: 25,
                image: NetworkImage(model.socialPostShowList[index].thumb)),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${model.socialPostShowList[index].userName }",  style: TextStyle(color: ColorRes.white), overflow: TextOverflow.ellipsis, maxLines: 1),
              Text(currentTime, style: TextStyle(color: ColorRes.greyBg, fontSize: 12))
            ],
          ),
        ],
      ),
    );
  }

  likeEmojisView(int index, SocialPostShowData socialPostShowList) {
    return  Positioned(
        bottom: 40,
        child: postIdStr == model.socialPostShowList[index].id ?
        Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 150,
            margin: EdgeInsets.only(left: 15, right: 10, top: 0, bottom: 25),
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration (
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(50)
            ),
            child: ListView.builder(
                itemCount: emojis.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                      postIdStr = "-1";

                      if(index == 0) {
                        model.addLikeApi(socialPostShowList.id, "#like", index);
                      } else if(index == 1) {
                        model.addLikeApi(socialPostShowList.id, "#love", index);
                      } else if(index == 2) {
                        model.addLikeApi(socialPostShowList.id, "#care", index);
                      } else if(index == 3) {
                        model.addLikeApi(socialPostShowList.id, "#haha", index);
                      } else if(index == 4) {
                        model.addLikeApi(socialPostShowList.id, "#angry", index);
                      } else if(index == 5) {
                        model.addLikeApi(socialPostShowList.id, "#sad", index);
                      }
                    },

                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(emojis[index].toString(), style: TextStyle(fontSize: 30))),
                  );
             /* return Image(
                  height: 40,
                  width: 40,
                  image: AssetImage("asset/Icon/${emojis[index]}.png"))*/;
            })
        ) : Container());
  }


  popUpMenuButton(int index, String postId, bool isShare) {
    return PopupMenuButton<String> (
      color: ColorRes.white,
      child: Image(
          height: 25,
          width: 25,
          image: AssetImage('asset/Icon/menu.png')),
      // icon: Icon(Icons., color: ColorRes.white),
      onSelected: (value) {
        return handleClick(value, index, postId, isShare);
      },
      itemBuilder: (BuildContext context) {
        return {'Share', 'Edit', 'Delete'}.map((String choice) {
          return PopupMenuItem<String> (
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  Future<void> handleClick(String value, int index, String postId, bool isShare) async {
    switch (value) {
      case 'Share':
          isRef = await Navigator.push(context, MaterialPageRoute(builder: (context) => PostDataScreen(isEdit: true, postId: postId)));
          if (isRef) {
            model.showPostApi();
          }
        break;
      case 'Edit':
        if(isShare) {
          isRef = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditDataScreen(socialPostShowData: model.socialPostShowList[index], isShare: true)));
          if (isRef) {
            model.showPostApi();
          }
        } else {
          isRef = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditDataScreen(socialPostShowData: model.socialPostShowList[index], isShare: false)));
          if(isRef) {
            model.showPostApi();
          }
        }
        break;
      case 'Delete':
        model.deletePostApi(model.socialPostShowList[index].id);
        break;
    }
  }


}