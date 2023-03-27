class Search {
  Search({
    required this.title,
    required this.googleUrl,
    required this.youtubeUrl,
    this.dateCreated,
  });
  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      title: json['title'],
      googleUrl: json['googleUrl'],
      youtubeUrl: json['youtubeUrl'],
      dateCreated: json['dateCreated'],
    );
  }

  String title;
  String googleUrl;
  String youtubeUrl;
  String? dateCreated;
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'googleUrl': googleUrl,
      'youtubeUrl': youtubeUrl,
      'dateCreated': dateCreated,
    };
  }
}
