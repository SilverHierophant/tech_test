class Gif {
  String id;

  Images images;

  Gif(this.id, this.images);

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(json["id"], Images.fromJson(json["images"]));
  }
}

class Images {
  PreviewGif previewGif;

  Images(this.previewGif);

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(PreviewGif.fromJson(json["preview_gif"]));
  }
}

class PreviewGif {
  String url;

  PreviewGif(this.url);

  factory PreviewGif.fromJson(Map<String, dynamic> json) {
    return PreviewGif(json["url"]);
  }
}
