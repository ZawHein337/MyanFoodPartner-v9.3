import 'package:stackfood_multivendor_restaurant/features/auth/controllers/location_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationSearchDialogWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialogWidget({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:  0),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: SizedBox(width: context.width, child: TypeAheadField(
          /*noItemsFoundBuilder: (context) => ListTile(
            title: Text('no_result_found'.tr, style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),
          ),*/
          /*textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            textInputAction: TextInputAction.search,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: 'search_location'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(style: BorderStyle.none, width: 0),
              ),
              hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor,
              ),
              filled: true, fillColor: Theme.of(context).cardColor,
            ),
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
            ),
          ),*/

          hideOnEmpty: true,

          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'search_location'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
                ),
                filled: true, fillColor: Theme.of(context).cardColor,
              ),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
              ),
            );
          },

          suggestionsCallback: (pattern) async {
            return await Get.find<LocationController>().searchLocation(context, pattern);
          },

          itemBuilder: (context, PredictionModel suggestion) {
            return Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [

                  const Icon(Icons.location_on),

                  Expanded(
                    child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                    )),
                  ),

                ]),
              ),
            );
          },

          onSelected: (PredictionModel suggestion) async {
            Position position = await Get.find<LocationController>().setSuggestedLocation(suggestion.placeId, suggestion.description, mapController);
            Get.back(result: position);
          },

          errorBuilder : (_,value) {
            return const SizedBox();
          },

        )),
      ),
    );
  }
}