import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer(
      {required this.children, required this.sectionName, super.key});
  final List<Widget> children;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        color: const Color.fromRGBO(42, 42, 42, 1),
        child: InputDecorator(
            decoration: InputDecoration(
              labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              labelText: sectionName,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            )),
      ),
    );
  }
}
