import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SiteLogo extends StatelessWidget {
  final String url;
  final double size;

  SiteLogo({this.url, this.size = 35.0});

  @override
  Widget build(BuildContext context) {
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: CachedNetworkImage(
    //     fit: BoxFit.fill,
    //     height: size,
    //     width: size,
    //     imageUrl: url,
    //     placeholder: (context, url) => CircularProgressIndicator(),
    //     errorWidget: (context, url, error) => Icon(Feather.getIconData("help-circle")),
    //   ),
    // );

    return ClipOval(
      //borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        height: size,
        width: size,
        imageUrl: url,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(MdiIcons.helpCircleOutline),
      ),
    );
  }
}
