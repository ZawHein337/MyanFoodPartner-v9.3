import 'dart:math';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';

class MapCustomInfoWindowWidget extends StatelessWidget {
  final String image;
  const MapCustomInfoWindowWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, width: 50,
      child: Stack(children: [

        const SizedBox(),

        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.rotate(
            angle: pi / 4.0,
            child: Container(
              height: 20, width: 20,
              color: Theme.of(context).cardColor,
            ),
          ),
        ),

        Column(children: [

          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: CustomImageWidget(image: image, fit: BoxFit.fill),
              ),
            ),
          ),

          const Expanded(flex: 1, child: SizedBox()),

        ]),

      ]),
    );
  }
}