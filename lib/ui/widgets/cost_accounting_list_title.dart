import 'package:flutter/material.dart';

class CAListTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? iconColor;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final bool showIcon;
  final void Function()? onIconTap;

  const CAListTitle({
    Key? key,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.onTap,
    this.onLongPress,
    this.onIconTap,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: showIcon
            ? IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: iconColor,
                  size: 40,
                ),
                onPressed: onIconTap,
              )
            : null,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
      margin: const EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
    );
  }
}
