// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

List<Category> categoryListFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));
List<Category> categoryListFromMap(List<Map<String, dynamic>> list) =>
    List<Category>.from(list.map((x) => Category.fromJson(x)));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  final List<Category>? children;
  final bool enable;
  final int id;
  final String name;

  Category({
    required this.children,
    required this.enable,
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        children: json["children"] == null
            ? []
            : List<Category>.from(
                json["children"]!.map((x) => Category.fromJson(x))),
        enable: json["enable"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "children": children == null
            ? []
            : List<dynamic>.from(children!.map((x) => x.toJson())),
        "enable": enable,
        "id": id,
        "name": name,
      };
}
