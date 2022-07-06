import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/editpages/inst_edit.dart';
import 'package:schoolmanagement/models/instructor.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../addpages/ins_add.dart';
import '../api.dart';
import 'login.dart';
import 'settingsmain.dart';

Widget _verticalDivider = const VerticalDivider(
  color: Colors.grey,
  thickness: 1,
);

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

class Instructors extends StatefulWidget {
  static const String id = 'instructors';
  const Instructors({Key? key}) : super(key: key);

  @override
  _InstructorsState createState() => _InstructorsState();
}

class MyData extends DataTableSource {
  final List<Instructor> snapshot;
  final Function(Instructor) onEditPressed;
  MyData(this.snapshot, this.onEditPressed);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => snapshot.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    var current = snapshot[index];

    return DataRow(cells: [
      DataCell(IconButton(
        icon: Icon(
          Icons.visibility_outlined,
          color: Colors.grey[700],
        ),
        onPressed: () {
          onEditPressed(current);
        },
      )),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.id.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.nameAr.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.nameEn.toString()),
      ),
      DataCell(_verticalDivider),
    ]);
  }
}

class _InstructorsState extends State<Instructors> {
  late Future<List<Instructor>> futureAlbum;
  List<Instructor> _data = [];
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    TextEditingController search = TextEditingController();

    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: 'تفاصيل التدريسيين - نظام اللجنة الامتحانية',
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
      sideBar: _sideBar.SideBarMenus(context, Instructors.id),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              FutureBuilder<List<Instructor>>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    {
                      if (snapshot.hasData) {
                        _data = snapshot.data ?? [];
                        return StatefulBuilder(builder: (context, setState) {
                          return PaginatedDataTable(
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: search,
                                    decoration: InputDecoration(
                                        labelText: 'البحث عن تدريسي',
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: IconButton(
                                          icon:
                                              const Icon(Icons.search_outlined),
                                          onPressed: () {
                                            setState(() {
                                              if (search.text.isEmpty) {
                                                _data = snapshot.data!;
                                                return;
                                              }
                                              _data = snapshot.data!.where((s) {
                                                return s.nameAr
                                                    .contains(search.text);
                                              }).toList();
                                            });
                                            search.text = '';
                                          },
                                        )),
                                  ).margin9,
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width) / 4,
                                  child: TextButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'اضافة تدريسي جديد',
                                        style: buttons,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          return blue;
                                          // Use the component's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences localStorage =
                                          await SharedPreferences.getInstance();
                                      if (localStorage.getString("token") ==
                                          null) {
                                        context.showSnackBar(
                                            'لا تملك صلاحية الوصول, الرجاء تسجيل الدخول',
                                            isError: true);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AddInsAlert(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            columns: [
                              DataColumn(
                                  label: Text(
                                'عرض المعلومات',
                                style: header,
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text(
                                'رقم التدريسي',
                                style: header,
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('اسم التدريسي ', style: header)),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label:
                                      Text('Instructor Name', style: header)),
                              DataColumn(label: _verticalDivider),
                            ],
                            arrowHeadColor: blue,
                            source: MyData(_data, (_data) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    InstEditAlert(current: _data),
                              );
                            }),
                            columnSpacing: 95,
                            showCheckboxColumn: true,
                          );
                        });
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                  }),
            ],
          ),
        ).margin9,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
}
