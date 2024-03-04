class UserModel {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;

  UserModel({this.id, this.name, this.email, this.phoneNumber});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    return data;
  }
}