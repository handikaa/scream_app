import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final List<Widget>? decorations;
  final List<Widget> children;
  final Color backgroundColorFilter;
  final bool lightLogo;
  final Widget? bottomNavigationBar;
  const Layout({
    super.key,
    this.decorations,
    required this.children,
    this.backgroundColorFilter = Colors.white,
    this.lightLogo = false,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/background-sharp.png'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // Column(
          //   children: [
          //     const Padding(
          //       padding: EdgeInsets.all(10),
          //       child: Row(
          //         children: [
          //           Image(
          //             image: AssetImage('assets/images/logo-left.png'),
          //             width: 150,
          //           ),
          //           Spacer(),
          //           Image(
          //             image: AssetImage('assets/images/logo-right.png'),
          //             width: 150,
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(
          //       height: MediaQuery.of(context).size.height * 0.1,
          //     ),
          //     const Image(
          //       image: AssetImage('assets/images/program-name.png'),
          //       width: 300,
          //     ),
          //   ],
          // ),
          if (decorations != null) ...decorations!,
          ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
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
