class ChannelModel {
  final int id;
  final String name;
  final String image;
  final String link;
  final int categoryId;
  final String category;

  ChannelModel({
    required this.id,
    required this.name,
    required this.image,
    required this.link,
    required this.categoryId,
    required this.category,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json["id"],
      name: json["name"],
      image: json["image"] ?? "",
      link: json["link"],
      categoryId: json["category_id"],
      category: json["category"],
    );
  }
}