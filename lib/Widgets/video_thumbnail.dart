import 'package:flutter/material.dart';
import 'package:resq_track/Components/image_viewer.dart';
import 'package:resq_track/Utils/utils.dart';

class YouTubeThumbnail extends StatelessWidget {
  final String videoUrl;

  YouTubeThumbnail({required this.videoUrl});

  String getYouTubeThumbnailUrl(String url) {
    final videoId = getYouTubeVideoId(url);
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  String getYouTubeVideoId(String url) {
    RegExp regExp = RegExp(
      r"(?<=v=|/videos/|embed/|youtu.be/|\/v\/|\/e\/|watch\?v=|watch\?vi=|watch%3Fv%3D|watch%26v%3D|^youtu.be\/|^youtube.com\/v\/|^youtube.com\/watch\?v=|^youtube.com\/watch\?vi=|^youtube.com\/embed\/)([^#&?]*)(?=\?|\&|$)",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.firstMatch(url)?.group(0) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = getYouTubeThumbnailUrl(videoUrl);
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: ImageViewer(
        url:thumbnailUrl,
        height: Utils.screenHeight(context) * 0.2,
        width: Utils.screenHeight(context) * 0.2,
        // fit: BoxFit.cover,
        // loadingBuilder: (context, child, progress) {
        //   return progress == null
        //       ? child
        //       : Center(child: CircularProgressIndicator());
        // },
        // errorBuilder: (context, error, stackTrace) {
        //   return Center(child: Text('Thumbnail not available'));
        // },
      ),
    );
  }
}
