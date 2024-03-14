import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/Details.dart';
import 'package:food_app/pages/Url.dart';

class ViewProfile extends StatefulWidget {
  // const ViewProfile({super.key});
  Details details;
  ViewProfile(this.details);

  @override
  State<ViewProfile> createState() => _ViewProfileState(details);
}

class _ViewProfileState extends State<ViewProfile> {
  Details details;
  _ViewProfileState(this.details);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: MyUrl.fullurl + MyUrl.imageurl + details.image,
            placeholder: (context, url) => const CircularProgressIndicator(),
            imageBuilder: (context, imageProvider) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(image: imageProvider)),
              );
            },
          ),
        ),
      ),
    );
  }
}
