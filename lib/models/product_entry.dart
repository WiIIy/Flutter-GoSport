// To parse this JSON data, do
//
//     final newsEntry = newsEntryFromJson(jsonString);

import 'dart:convert';

List<NewsEntry> newsEntryFromJson(String str) => List<NewsEntry>.from(json.decode(str).map((x) => NewsEntry.fromJson(x)));

String newsEntryToJson(List<NewsEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsEntry {
    String id;
    String name;
    int price;
    String category;
    String thumbnail;
    String description;
    bool isFeatured;
    String seller;

    NewsEntry({
        required this.id,
        required this.name,
        required this.price,
        required this.category,
        required this.thumbnail,
        required this.description,
        required this.isFeatured,
        required this.seller,
    });

    factory NewsEntry.fromJson(Map<String, dynamic> json) => NewsEntry(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        description: json["description"],
        isFeatured: json["is_featured"],
        seller: json["seller"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "category": category,
        "thumbnail": thumbnail,
        "description": description,
        "is_featured": isFeatured,
        "seller": seller,
    };
}
