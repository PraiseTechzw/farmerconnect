class CropDetails {
  final String cropName;
  final String imageUrl;
  final String description;
  final String season;
  final String tips;

  CropDetails({
    required this.cropName,
    required this.imageUrl,
    required this.description,
    required this.season,
    required this.tips, required String location,
  });

  // Factory constructor to parse from JSON
  factory CropDetails.fromJson(Map<String, dynamic> json) {
    return CropDetails(
      cropName: json['cropName'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      season: json['season'],
      tips: json['tips'], location: 'Chinhoyi',
    );
  }
}
