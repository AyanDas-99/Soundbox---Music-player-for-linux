import 'package:flutter/material.dart';
import 'package:soundbox/view/page_controller_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter error: ${details.exception}');
    if (details.stack != null) {
      print('Stack trace: ${details.stack}');
    }
  };
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.blueGrey.shade900),
      home: const PageControllerScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:soundbox/view/detailed_screen.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       home: Page1(),
//     ),
//   );
// }

// class Page1 extends StatelessWidget {
//   const Page1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Spacer(),
//           SizedBox(
//             height: 200,
//             child: Row(
//               children: [
//                 Hero(tag: 'image',
//                 child: Icon(Icons.image)),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(context).push(_createRoute());
//                   },
//                   icon: Icon(Icons.arrow_upward),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) =>
//         const DetailedScreen(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0, 1);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }

// class Page2 extends StatelessWidget {
//   const Page2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: const Center(
//         child: Text('Page 2'),
//       ),
//     );
//   }
// }
