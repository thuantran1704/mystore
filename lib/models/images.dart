import 'dart:convert';

UploadImage uploadImageFromJson(String str) => UploadImage.fromJson(json.decode(str));

String uploadImageToJson(UploadImage data) => json.encode(data.toJson());

class UploadImage {
  UploadImage({
    required this.publicId,
    required this.url,
  });

  String publicId;
  String url;

  factory UploadImage.fromJson(Map<String, dynamic> json) => UploadImage(
    publicId: json["public_id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "public_id": publicId,
    "url": url,
  };
}
