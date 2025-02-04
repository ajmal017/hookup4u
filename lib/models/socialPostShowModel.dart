import 'package:hookup4u/models/user_profile_model.dart';

class SocialPostShowModel {
  int code;
  String message;
  String status;
  List<SocialPostShowData> data;

  SocialPostShowModel({this.code, this.message, this.status, this.data});

  SocialPostShowModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<SocialPostShowData>();
      json['data'].forEach((v) {
        data.add(new SocialPostShowData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SocialPostShowData {
  String id;
  String userId;
  String content;
  List<String> media;
  String visibility;
  ParentPost parentPost;
  String userName;
  String thumb;
  String postDate;
  int likeCount;
  int commentCount;
  bool selfLike;

  SocialPostShowData(
      {this.id,
        this.userId,
        this.content,
        this.media,
        this.visibility,
        this.parentPost,
        this.userName,
        this.thumb,
        this.postDate,
        this.likeCount,
        this.commentCount,
        this.selfLike
      });

  SocialPostShowData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content = json['content'];
    media = json['media'].cast<String>();
    visibility = json['visibility'];
    parentPost = json['parent_post'] != null && json['parent_post'].length != 0
        ? new ParentPost.fromJson(json['parent_post'])
        : null;
    userName = json['user_name'];
    thumb = json['thumb'];
    postDate = json['post_date'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    selfLike = json['self_like'];
  }

/*  SocialPostShowData.fromUserPosts(UserPosts userPosts) {
    id = userPosts.id;
    userId = userPosts.userId;
    content = userPosts.content;
    media = userPosts.media.cast<String>();
    visibility = userPosts.visibility;
    // parentPost = userPosts.parentPostData != null
    //     ? new ParentPost.fromJson(userPosts.parentPostData)
    //     : null;
    userName = userPosts.userName;
    thumb = userPosts.thumb;
    postDate = userPosts.postDate;
    likeCount = userPosts.likeCount;
    commentCount = userPosts.commentCount;
    selfLike = userPosts.selfLike;
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['media'] = this.media;
    data['visibility'] = this.visibility;
    if (this.parentPost != null) {
      data['parent_post'] = this.parentPost.toJson();
    }
    data['user_name'] = this.userName;
    data['thumb'] = this.thumb;
    data['post_date'] = this.postDate;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['self_like'] = this.selfLike;
    return data;
  }
}

class ParentPost {
  String id;
  String userId;
  String content;
  List<String> media;
  String visibility;
  ParentPost parentPost;
  String userName;
  String thumb;
  String postDate;

  ParentPost(
      {this.id,
        this.userId,
        this.content,
        this.media,
        this.visibility,
        this.parentPost,
        this.userName,
        this.thumb,
        this.postDate
      });

  ParentPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content = json['content'];
    media = json['media'].cast<String>();
    visibility = json['visibility'];
    // parentPost = json['parent_post'];
    parentPost = json['parent_post'] != null && json['parent_post'].length != 0 && json['parent_post'] is Map
        ? new ParentPost.fromJson(json['parent_post'])
        : null;
    userName = json['user_name'];
    thumb = json['thumb'];
    postDate = json['post_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['media'] = this.media;
    data['visibility'] = this.visibility;
    // data['parent_post'] = this.parentPost;
    if (this.parentPost != null) {
      data['parent_post'] = this.parentPost.toJson();
    }
    data['user_name'] = this.userName;
    data['thumb'] = this.thumb;
    data['post_date'] = this.postDate;
    return data;
  }
}

/*


class SocialPostShowModel {
  int code;
  String message;
  String status;
  List<SocialPostShowData> data;

  SocialPostShowModel({this.code, this.message, this.status, this.data});

  SocialPostShowModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<SocialPostShowData>();
      json['data'].forEach((v) {
        data.add(new SocialPostShowData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SocialPostShowData {
  String id;
  String userId;
  String userName;
  String content;
  List<String> media;
  String visibility;
  String parentPost;

  SocialPostShowData(
      {this.id,
        this.userId,
        this.userName,
        this.content,
        this.media,
        this.visibility,
        this.parentPost});

  SocialPostShowData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    content = json['content'];
    media = json['media'].cast<String>();
    visibility = json['visibility'];
    parentPost = json['parent_post'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['content'] = this.content;
    data['media'] = this.media;
    data['visibility'] = this.visibility;
    data['parent_post'] = this.parentPost;
    return data;
  }
}
*/
