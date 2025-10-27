import 'package:flutter/material.dart';

class ShowLoadingOverlay extends StatelessWidget {
  const ShowLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.black.withOpacity(0.4), // efek overlay gelap transparan
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
        ),
      ),
    );
  }
}
