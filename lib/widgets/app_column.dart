import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_delivery_app/widgets/small_text.dart';

import '../utils/app_colors.dart';
import '../utils/dimensions.dart';
import 'big_text.dart';
import 'icons_text_widget.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: text, size: Dimensions.font26),
        SizedBox(
          height: Dimensions.height10,
        ),
        Row(
          children: [
            Wrap(
                children: List.generate(
                    5,
                    (index) =>
                        Icon(Icons.star, color: AppColor.mainColor, size: 15))),
            SizedBox(
              width: 5,
            ),
            SmallText(text: "4.5"),
            SizedBox(
              width: 5,
            ),
            SmallText(text: "1234"),
            SizedBox(
              width: 5,
            ),
            SmallText(text: "comments"),
          ],
        ),
        SizedBox(height: Dimensions.height20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(
                icon: Icons.circle_sharp,
                text: "Normal",
                sizedBox: 5,
                iconColor: AppColor.iconColor1),
            IconAndTextWidget(
                icon: Icons.location_on,
                text: "1.8km",
                sizedBox: 5,
                iconColor: AppColor.mainColor),
            IconAndTextWidget(
                icon: Icons.access_time_rounded,
                text: "32min",
                sizedBox: 5,
                iconColor: AppColor.iconColor2)
          ],
        )
      ],
    );
  }
}
