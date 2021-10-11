import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class ShowImageScreen extends StatelessWidget {

  final String imageUrl;

   ShowImageScreen(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,

        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: PhotoView(
        imageProvider:CachedNetworkImageProvider(imageUrl,) ,
        loadingBuilder: (context, event) => Center(child: CircularProgressIndicator()),
    ),
    );
  }
}
