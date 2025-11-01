import 'dart:async';

import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  final List<Widget>? decorations;
  final List<Widget> children;
  final Color backgroundColorFilter;
  final bool lightLogo;
  final String bg;
  final Widget? bottomNavigationBar;
  const Layout({
    super.key,
    this.decorations,
    required this.children,
    this.backgroundColorFilter = Colors.white,
    this.lightLogo = false,
    this.bottomNavigationBar,
    this.bg = 'assets/images/background-sharp.png',
  });

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _tapCount = 0;
  Timer? _resetTimer;

  void _onLogoTap() {
    _tapCount++;

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 1), () {
      _tapCount = 0;
    });

    if (_tapCount == 3) {
      _resetTimer?.cancel();
      _tapCount = 0;

      Navigator.pushNamed(context, '/set-value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.bg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/logo-left.png'),
                      width: 150,
                    ),
                    Spacer(),
                    Image(
                      image: AssetImage('assets/images/logo-right.png'),
                      width: 150,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              GestureDetector(
                onTap: _onLogoTap,
                child: const Image(
                  image: AssetImage('assets/images/program-name.png'),
                  width: 300,
                ),
              ),
            ],
          ),
          if (widget.decorations != null) ...widget.decorations!,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: widget.children,
            // Image.asset(
            //   lightLogo
            //       ? 'assets/images/lg_logo_light.png'
            //       : 'assets/images/lg_logo.png',
            //   width: 105,
            // ),

            // ListView(
            //   children: children,
            // ),
          ),
          // Positioned(
          //   top: 170,
          //   left: 20,
          //   right: 20,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       // Image.asset(
          //       //   lightLogo
          //       //       ? 'assets/images/lg_logo_light.png'
          //       //       : 'assets/images/lg_logo.png',
          //       //   width: 105,
          //       // ),
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.15,
          //       ),
          //       Column(
          //         children: children,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
