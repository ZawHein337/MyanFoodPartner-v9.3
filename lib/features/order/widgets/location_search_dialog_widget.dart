import 'package:custom_info_window/custom_info_window.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_list_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/map_custom_info_window_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryManSearchDialogWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  final CustomInfoWindowController customInfoWindowController;
  final PageController pageController;
  final List<DeliveryManListModel> deliveryManList;
  const DeliveryManSearchDialogWidget({super.key, required this.mapController, required this.deliveryManList,
    required this.customInfoWindowController, required this.pageController});

  @override
  Widget build(BuildContext context) {

   // final TextEditingController controller = TextEditingController();

    return Scrollable(viewportBuilder: (context, position) => Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      alignment: Alignment.topCenter,
      child: GetBuilder<DeliveryManController>(builder: (deliveryManController) {

/*        if(deliveryManController.selectedDeliveryMan != null) {
          controller.text = deliveryManController.selectedDeliveryMan!.name!;
        } else {
          controller.text = '';
        }*/

        return Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
          child: SizedBox(width: Dimensions.webMaxWidth, child: Stack(children: [

            TypeAheadField(
              /*textFieldConfiguration: TextFieldConfiguration(
                controller: controller,
                textInputAction: TextInputAction.search,
                autofocus: false,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: 'search_here'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    borderSide: BorderSide(style: BorderStyle.none, width: 0.3, color: Theme.of(context).hintColor),
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

                if(deliveryManController.selectedDeliveryMan != null) {
                  controller.text = deliveryManController.selectedDeliveryMan!.name!;
                } else {
                  controller.text = '';
                }

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

              suggestionsCallback: (pattern) {
                return deliveryManController.searchDeliveryMan(pattern);
              },

              itemBuilder: (context, DeliveryManListModel suggestion) {
                return Container(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Row(children: [

                      const Icon(Icons.location_on),

                      Expanded(
                        child: Text(suggestion.name!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                        )),
                      ),

                    ]),
                  ),
                );
              },

              onSelected: (DeliveryManListModel suggestion) async {
                deliveryManController.selectDeliveryManInMap(suggestion);
                LatLng latLng = LatLng(double.parse(suggestion.lat!), double.parse(suggestion.lng!));
                if(mapController != null) {
                  mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
                  customInfoWindowController.addInfoWindow!(MapCustomInfoWindowWidget(image: '${suggestion.imageFullUrl}'), latLng);
                }
                int selectedIndex = 0;
                for (var deliveryMan in deliveryManList) {
                  if(deliveryMan.id == suggestion.id) {
                    selectedIndex = deliveryManList.indexOf(deliveryMan);
                    pageController.animateToPage(selectedIndex, duration: const Duration(milliseconds: 1000), curve: Curves.bounceInOut);
                  }
                }
              },
            ),

            deliveryManController.selectedDeliveryMan != null ? Positioned(
              right: 10, top: 0, bottom: 0,
              child: IconButton(
                onPressed: () {
                  //controller.clear();
                  deliveryManController.selectDeliveryManInMap(null);
                },
                icon: const Icon(Icons.clear),
              ),
            ) : const SizedBox(),

          ])),
        );
      }),
    ));
  }
}