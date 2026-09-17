import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileImageWidget extends StatelessWidget {
  final double size;
  const ProfileImageWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {

    bool isOwner = Get.find<AuthController>().getUserType() == 'owner';

    return GetBuilder<ProfileController>(builder: (profileController) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImageWidget(
            image: isOwner ? profileController.profileModel?.imageFullUrl ?? '' : profileController.profileModel?.employeeInfo?.imageFullUrl ?? '',
            width: size, height: size, fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}