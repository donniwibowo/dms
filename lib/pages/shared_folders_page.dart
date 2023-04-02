import 'package:best_flutter_ui_templates/pages/recent_page.dart';
import 'package:best_flutter_ui_templates/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:best_flutter_ui_templates/design_storage/home_design.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../controller.dart';
import '../custom_widget/custom_widget.dart';
import '../design_storage/design_app_theme.dart';
import '../design_storage/recent_files_list_view.dart';
import '../design_storage/shared_folders_list_view.dart';

class SharedFoldersPage extends StatefulWidget {
  @override
  _SharedFoldersPageState createState() => _SharedFoldersPageState();
}

class _SharedFoldersPageState extends State<SharedFoldersPage> {
  // CategoryType categoryType = CategoryType.ui;
  int _selectedIndex = 1;

  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    _fabHeight = _initFabHeight;
    _panelHeightOpen = MediaQuery.of(context).size.height * .40;

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Container(
      color: DesignAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.up,
          distance: 60,
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          closeButtonStyle: const ExpandableFabCloseButtonStyle(
            backgroundColor: Colors.red,
          ),
          children: [
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.folder_outlined),
              backgroundColor: Colors.red,
              onPressed: () {},
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.file_upload),
              backgroundColor: Colors.red,
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            TopHeader(
              title: 'DMS',
              subtitle: 'Shared Folder',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SearchBar(),
                      SharedFoldersListView(),
                    ],
                  ),
                ),
              ),
            ),
            SlidingUpPanel(
              defaultPanelState: PanelState.CLOSED,
              maxHeight: _panelHeightOpen,
              minHeight: 0,
              controller: panelController,
              panel: StreamBuilder<Widget?>(
                stream: pageController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) return const SizedBox.shrink();
                  return snapshot.data!;
                },
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              }),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared),
              label: 'Shared',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.av_timer),
              label: 'Recent',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DesignHomeScreen(
                  folder_parent_id: "0",
                )));
      } else if (_selectedIndex == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SharedFoldersPage()));
      } else if (_selectedIndex == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RecentPage()));
      }
    });
  }
}
