class ChatUserModel {
  ChatUserModel({
    required this.image,
    required this.name,
    required this.about,
    required this.isOnline,
    required this.lastActive,
    required this. id,
    required this.createAt,
    required this.pushToken,
    required this.email,
  });
  late final String image;
  late final String name;
  late final String about;
  late final bool isOnline;
  late final String lastActive;
  late final String  id;
  late final String createAt;
  late final String pushToken;
  late final String email;

  ChatUserModel.fromJson(Map<String, dynamic> json){
    image = json['image']??'';
    name = json['name']??'';
    about = json['about']??'';
    isOnline = json['isOnline']??'';
    lastActive = json['last_active']??'';
    id = json[' id']??'';
    createAt = json['create_at']??'';
    pushToken = json['push_token']??'';
    email = json['email']??'';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['isOnline'] = isOnline;
    data['last_active'] = lastActive;
    data[' id'] =  id;
    data['create_at'] = createAt;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}