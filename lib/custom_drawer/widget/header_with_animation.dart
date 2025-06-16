import 'package:flutter/material.dart';

class HeaderWithAnimation extends StatelessWidget {
  const HeaderWithAnimation({
    super.key,
    required this.headerColor,
    TextStyle? titleStyle,
    TextStyle? userNameStyle,
    this.profileImage,
    this.isShowUserProfile = true,
    this.isShowUserName = true,
    required this.title,
    this.userFirstName,
    this.userLastName,
  }) : titleStyle = titleStyle ?? const TextStyle(color: Colors.white),
       userNameStyle = userNameStyle ?? const TextStyle(color: Colors.white);

  final Color headerColor;
  final TextStyle? titleStyle;
  final TextStyle? userNameStyle;
  final String title;
  final String? userFirstName;
  final String? userLastName;
  final String? profileImage;
  final bool isShowUserProfile;
  final bool isShowUserName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: headerColor,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: headerColor,
        title: Text(title, style: titleStyle),
        centerTitle: false,
        actions: [
          if (isShowUserName)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userFirstName ?? "", style: userNameStyle, textAlign: TextAlign.start),
                Text(userLastName ?? "", style: userNameStyle, textAlign: TextAlign.start),
              ],
            ),
          if (isShowUserProfile)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: profileImage != null
                    ? (profileImage!.contains("http") ? NetworkImage(profileImage!) : AssetImage(profileImage!)) as ImageProvider
                    : null,
                radius: 30,
              ),
            ),
        ],
      ),
    );
  }
}
