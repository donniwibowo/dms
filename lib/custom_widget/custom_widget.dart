import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

import '../design_storage/design_app_theme.dart';
import '../design_storage/home_design.dart';
import '../settings.dart';

class TopHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const TopHeader({
    Key? key,
    this.title = "",
    this.subtitle = "",
  }) : super(key: key);
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignAppTheme.darkerText,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignAppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
            child: Container(
              width: 60,
              height: 60,
              child: Image.asset('assets/design_storage/userImage.png'),
            ),
          )
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 25),
                  child: TextFormField(
                    controller: searchController,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      // color: DesignAppTheme.nearlyBlue,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // hintText: search,
                      labelText: 'Cari dokumen di sini',
                      // border: InputBorder.none,
                      helperStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: HexColor('#B9BABC'),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: HexColor('#B9BABC'),
                      ),
                    ),
                    onEditingComplete: () {},
                  ),
                ),
              ),
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DesignHomeScreen(
                                folder_parent_id: "0",
                                keyword: searchController.text)));
                      },
                      child: Icon(Icons.search))),
            ]));
  }
}

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
