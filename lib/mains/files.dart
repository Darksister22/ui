// import 'package:flutter/material.dart';
// import 'package:flutter_admin_scaffold/admin_scaffold.dart';
// import 'package:schoolmanagement/components/sidemenus.dart';
// import 'package:schoolmanagement/dashboards/filedash.dart';
// import 'package:schoolmanagement/mains/login.dart';
// import 'package:schoolmanagement/stylefiles/customtext.dart';
// import 'package:schoolmanagement/stylefiles/style.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Files extends StatefulWidget {
//   static const String id = 'files';
//   const Files({Key? key}) : super(key: key);

//   @override
//   _FilesState createState() => _FilesState();
// }

// class _FilesState extends State<Files> {
//   final SideBarWidget _sideBarWidget = SideBarWidget();

//   @override
//   Widget build(BuildContext context) {
//     return AdminScaffold(
//         appBar: AppBar(
//           title: Row(
//             children: [
//               Visibility(
//                   child: CustomText(
//                 text: 'ادارة الملفات - نظام اللجنة الامتحانية',
//                 color: lightgrey,
//                 size: 20,
//                 fontWeight: FontWeight.bold,
//               )),
//               Expanded(
//                 child: Container(),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 color: dark.withOpacity(.7),
//                 onPressed: () {},
//               ),
//               Container(
//                 width: 1,
//                 height: 22,
//                 color: lightgrey,
//               ),
//               IconButton(
//                 icon: const Icon(Icons.logout_rounded),
//                 color: dark.withOpacity(.7),
//                 onPressed: () async {
//                   SharedPreferences preferences =
//                       await SharedPreferences.getInstance();
//                   await preferences.clear();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const Login(),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               const SizedBox(
//                 width: 16,
//               ),
//             ],
//           ),
//           iconTheme: IconThemeData(
//             color: dark,
//           ),
//           backgroundColor: light,
//         ),
//         backgroundColor: light,
//         sideBar: _sideBarWidget.SideBarMenus(context, Files.id),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: const <Widget>[
//                 Visibility(child: FileDash()),
//               ],
//             ),
//           ),
//         ));
//   }
// }
