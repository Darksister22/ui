// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolmanagement/mains/degrees.dart';
import 'package:schoolmanagement/mains/grads.dart';
import 'package:schoolmanagement/mains/homepage.dart';
import 'package:schoolmanagement/mains/instructors.dart';
import 'package:schoolmanagement/mains/students.dart';
import 'package:schoolmanagement/stylefiles/style.dart';

import '../mains/course.dart';

class SideBarWidget {
  SideBarMenus(context, selectedRoute) {
    return SideBar(
      activeBackgroundColor: CupertinoColors.systemBlue,
      activeIconColor: Colors.white,
      iconColor: blue,
      textStyle: GoogleFonts.ibmPlexSansArabic(
        color: Colors.grey[700],
        fontSize: 13,
      ),
      activeTextStyle: const TextStyle(
        color: Colors.white,
      ),
      // backgroundColor: Colors.black54,
      items: const [
        MenuItem(
          title: 'الصفحة الرئيسية',
          route: HomePage.id,
          icon: Icons.home_outlined,
        ),
        MenuItem(
            title: 'معلومات الطلبة',
            route: Students.id,
            icon: Icons.people_alt_outlined),
        MenuItem(
            title: 'معلومات التدريسيين',
            route: Instructors.id,
            icon: Icons.assignment_ind_outlined),
        MenuItem(
            title: 'الكورس الدراسي الحالي',
            route: Courses.id,
            icon: Icons.library_books_outlined),
        MenuItem(
            title: 'درجات الطلبة',
            route: DegreeHome.id,
            icon: Icons.table_view_outlined),
        MenuItem(
            title: 'عرض الطلبة المتخرجين',
            route: Grads.id,
            icon: Icons.school_outlined),
        // MenuItem(
        //     title: 'ادارة الملفات', route: Files.id, icon: Icons.upload_file),
      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        Navigator.of(context).pushNamed(item.route!);
      },
    );
  }
}
