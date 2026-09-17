import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ExportButton extends StatelessWidget {
  final Function()? onTap;
  final bool isLoading;
  const ExportButton({super.key, this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(children: [
          isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.blue)) : const Icon(Icons.download, color: Colors.blue),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text('export'.tr, style: robotoBold.copyWith(color: Colors.blue)),
        ]),
      ),
    );
  }
}