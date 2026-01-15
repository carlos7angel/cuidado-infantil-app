import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CachedImage extends StatelessWidget {

  final String image;
  final bool isRound;
  final double radius;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;

  final String noImage = "assets/images/no_image.png";
  bool isUrl = false;

  CachedImage({
    super.key,
    required this.image,
    this.isRound = false,
    this.radius = 0,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {

    if(image.contains('https://') || image.contains('http://')) {
      isUrl = true;
    }

    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: BoxDecoration(
                color: color ?? Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: isUrl ?
              CachedNetworkImage(
                  imageUrl: image,
                  fit: fit,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(noImage, fit: BoxFit.cover,)
              ) : FadeInImage(
                image: AssetImage(image),
                placeholder: AssetImage(image),
                fit: fit,
              ),
            )
        ),
      );
    } catch (e) {
      return Image.asset(noImage, fit: BoxFit.cover,);
    }
  }
}