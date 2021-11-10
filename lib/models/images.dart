import 'dart:convert';

class UploadImage {
  late String publicId;
  late String url;

  UploadImage.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    url = json["url"];
  }

  Map<String, dynamic> toJson() => {
        "public_id": publicId,
        "url": url,
      };
}
