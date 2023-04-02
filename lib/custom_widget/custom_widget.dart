import 'package:flutter/material.dart';

class SlideUpView extends StatelessWidget {
  // const SlideUpView({super.key});
  final String name;
  final String desc;
  final String user_access;
  final String created_by;
  final String created_on;
  final String updated_on;
  const SlideUpView(
      {Key? key,
      this.name = "",
      this.desc = "",
      this.user_access = "",
      this.created_by = "",
      this.created_on = "",
      this.updated_on = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.amber),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
        child: Column(
          children: [
            Container(
              height: 10,
              width: 60,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'Nama : ',
                    ),
                  ),
                  Text(name)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Deskripsi : '),
                  ),
                  Text(desc)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Akses : '),
                  ),
                  Flexible(child: Text(user_access))
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Dibuat Oleh : '),
                  ),
                  Text(created_by)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Tanggal Dibuat : '),
                  ),
                  Text(created_on)
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Tanggal Diperbaharui : '),
                  ),
                  Text(updated_on)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
