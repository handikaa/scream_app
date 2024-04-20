import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final List<Widget>? decorations;
  final List<Widget> children;
  final Color backgroundColorFilter;
  final bool lightLogo;
  const Layout({
    super.key,
    this.decorations,
    required this.children,
    this.backgroundColorFilter = Colors.white,
    this.lightLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      backgroundColorFilter, BlendMode.softLight),
                  opacity: 0.2),
            ),
          ),
          if (decorations != null) ...decorations!,
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(lightLogo
                    ? 'assets/images/lg_logo_light.png'
                    : 'assets/images/lg_logo.png'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Column(
                  children: children,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
