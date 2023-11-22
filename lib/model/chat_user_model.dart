class ChatUserModel {
  ChatUserModel({
    required this.image,
    required this.name,
    required this.about,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.createAt,
    required this.pushToken,
    required this.email,
  });
  late String image;
  late String name;
  late String about;
  late bool isOnline;
  late String lastActive;
  late String id;
  late String createAt;
  late String pushToken;
  late String email;

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    isOnline = json['isOnline'] ?? '';
    lastActive = json['last_active'] ?? '';
    id = json[' id'] ?? '';
    createAt = json['create_at'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['isOnline'] = isOnline;
    data['last_active'] = lastActive;
    data[' id'] = id;
    data['create_at'] = createAt;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
