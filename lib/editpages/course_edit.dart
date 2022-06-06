import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/course.dart';
import 'package:schoolmanagement/models/instructor.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../mains/login.dart';
import '../mains/settingsmain.dart';
import '../mains/stu_sem.dart';
import '../models/courseins.dart';
import '../translate.dart';

class EditCourse extends StatefulWidget {
  final InsCourse current;

  const EditCourse({Key? key, required this.current}) : super(key: key);

  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final _courseEN = TextEditingController();
  final _courseAR = TextEditingController();
  final _code = TextEditingController();

  final _unit = TextEditingController();
  final _success = TextEditingController(text: '50');
  final List<String> _level = [
    'بكالوريوس',
    'ماجستير',
    'دكتوراة',
  ];
  final List<String> _year = [
    'السنة الاولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
    'السنة السادسة',
    'السنة الثامنة',
    'السنة التاسعة',
    'السنة العاشرة',
  ];
  var snack = '';
  var error = false;

  Future _editCrs() async {
    var data = {
      "name_ar": _courseAR.text,
      "name_en": _courseEN.text,
      'level': translateLevelAE(sellevel),
      'code': _code.text,
      'unit': _unit.text,
      'year': translateYearAE(selyear),
      'ins_name': selins.toString(),
      'success': _success.text
    };

    try {
      await CallApi().postData(data, "/api/courses/update");

      snack = 'تم تحديث معلومات الطالب بنجاح';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  Future<List<Instructor>> fetchAlbum() async {
    final response = await CallApi().getData('/api/instructors');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List;

      return result.map((e) => Instructor.fromJson(e)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load');
    }
  }

  Future _delStu() async {
    String id = widget.current.id.toString();
    var data = {};

    try {
     
          await CallApi().postData(data, "/api/courses/destroy/$id");

      snack = 'تم حذف المادة بنجاح';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  late int id;

  late String sellevel = 'بكالوريوس';
  late String selyear = 'السنة الاولى';
   String? selins ;
  late Future<List<Instructor>> futureAlbum;
  List<Instructor> _data = [];
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    _courseEN.text = widget.current.nameEn;
    _courseAR.text = widget.current.nameAr;
    _code.text = widget.current.code;
    _success.text = widget.current.success.toString();
    id = widget.current.id;
    selins = widget.current.instructor!.nameAr;
    selyear = translateYearEA(widget.current.year);
    sellevel = translateLevelEA(widget.current.level);
    _unit.text = widget.current.unit.toString();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: 'اضافة كورس جديد',
              color: lightgrey,
              size: 20,
              fontWeight: FontWeight.bold,
            )),
            Expanded(
              child: Container(),
            ),
            IconButton(
                icon: const Icon(Icons.settings),
                color: dark.withOpacity(.7),
                onPressed: () async {
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();

                  if (localStorage.getString("token") == null ||
                      localStorage.getString("role") == "admin") {
                    context.showSnackBar('لا تملك صلاحية الوصول',
                        isError: true);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  }
                }),
            Container(
              width: 1,
              height: 22,
              color: lightgrey,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: dark.withOpacity(.7),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 24,
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: dark,
        ),
        backgroundColor: light,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _courseEN,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال اسم المادة';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'اسم المادة English',
                          prefixIcon: const Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: FutureBuilder<List<Instructor>>(
                              future: futureAlbum,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _data = snapshot.data ?? [];
                                  List<String> list = [];
                                  for (var i = 0; i < _data.length; i++) {
                                    list.add(_data[i].nameAr);
                                  }
                                  return StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                      return DropdownButton<String>(
                                        isExpanded: true,
                                        hint: const Text('اختيار التدريسي'),
                                        value: selins,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selins = newValue.toString();
                                          });
                                        },
                                        items: list.map((ins) {
                                          return DropdownMenuItem(
                                            child: Text(ins),
                                            value: ins,
                                          );
                                        }).toList(),
                                      );
                                    },
                                  );
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    CircularProgressIndicator(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _courseAR,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال اسم المادة';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'اسم المادة',
                          prefixIcon: const Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال كود المادة';
                          }
                          return null;
                        },
                        controller: _code,
                        decoration: InputDecoration(
                          labelText: 'كود المادة',
                          prefixIcon: const Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال وحدة المادة';
                          }
                          return null;
                        },
                        controller: _unit,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'وحدة المادة',
                          prefixIcon: const Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _success,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال درجة النجاح للمادة';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'درجة النجاح',
                          prefixIcon: const Icon(Icons.check),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('اختيار المرحلة الدراسية'),
                              value: sellevel,
                              onChanged: (newValue) {
                                setState(() {
                                  sellevel = newValue.toString();
                                });
                              },
                              items: _level.map((level) {
                                return DropdownMenuItem(
                                  child: Text(level),
                                  value: level,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('اختيار السنة الدراسية'),
                              value: selyear,
                              onChanged: (newValue) {
                                setState(() {
                                  selyear = newValue.toString();
                                });
                              },
                              items: _year.map((year) {
                                return DropdownMenuItem(
                                  child: Text(year),
                                  value: year,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width) / 5,
                        child: TextButton(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'الغاء',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return blue;
                                // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StuSem(
                                  current: widget.current,
                                ),
                              ),
                            );
                          },
                        ).margin9,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width) / 5,
                        child: TextButton(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'حذف المادة',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return blue;
                                // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _delStu();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Courses(),
                                ),
                              );

                              context.showSnackBar(snack, isError: error);
                            }
                          },
                        ).margin9,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width) / 5,
                        child: TextButton(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'اضافة',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return blue;
                                // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _editCrs();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Courses(),
                                ),
                              );

                              context.showSnackBar(snack, isError: error);
                            }
                          },
                        ).margin9,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}