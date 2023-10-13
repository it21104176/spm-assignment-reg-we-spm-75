// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MapLocationSearchWidget extends StatelessWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;
  final VoidCallback findMyPath;
  const MapLocationSearchWidget({
    Key? key,
    required this.originController,
    required this.destinationController,
    required this.findMyPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Origin Location             : ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: TextFormField(
                  controller: originController,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                  const InputDecoration(hintText: "Origin Location"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Destination Location   : ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: TextFormField(
                  controller: destinationController,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                  const InputDecoration(hintText: "Destination Location"),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: () => findMyPath(),
              child: const Text("Find My Path"),
            ),
          ),
        ],
      ),
    );
  }
}
