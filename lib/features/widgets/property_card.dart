import 'package:flutter/material.dart';

import 'address_label.dart';

class PropertyCard extends StatelessWidget {
  final String imageAsset;
  final String address;
  final double height;
  final bool isAddressCenter;
  final bool startAddressAnimation;


  const PropertyCard({
    super.key,
    required this.imageAsset,
    required this.address,
    required this.height,
    required this.startAddressAnimation,
    this.isAddressCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: AddressLabel(address: address, isCenter: isAddressCenter, startAddressAnimation: startAddressAnimation,),
          ),
        ],
      ),
    );
  }
}
