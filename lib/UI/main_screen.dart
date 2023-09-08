import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fundoo_notes/UI/add_new_note.dart';
import 'package:fundoo_notes/UI/display_note.dart';
import 'package:fundoo_notes/UI/search_page.dart';
import 'package:fundoo_notes/UI/side_menu.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/services/my_note_model.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  // declaring a global key to enable drawer expansion, where required
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  // will store the data fetched from the firestore using class FirestoreDB methods
  List<Note> notesList = [];

  //boolean to toggle between list view and grid view
  bool isListView = false;
  var viewMode = const Icon(Icons.list_outlined);

  // boolean to set the data to be in sync or not with the online database
  bool isSync = true;
  Icon syncIcon = Icon(Icons.sync, color: buttonsColor);

  // boolean to show loading animation while the data is being fetched from the servers
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //  called fetchNotes in init to get the notesList populated with the data from the firebase firestore
    fetchNotes();

    // everytime the main route will be opened first the skeleton view will be shown then the notes
    callSkeleton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,

        // drawer menu-bar
        drawer: const SideMenu(),
        // enables opening drawer with swiping
        // drawer menu-bar ends

        backgroundColor: routesBG,
        //bg color imported from colors.dart

        // add note feature at bottom right of the screen
        floatingActionButton: FloatingActionButton.small(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddNewNote())); // routing to another screen ( AddNewNote() ) to add new note
            notesList = await FirestoreDB.getNotesData();
            setState(() {});
          },
          child: const Icon(Icons.add, size: 35),
        ),

        //app body
        body: SafeArea(
          /* wrapped into SafeArea widget display content below the status bar/notch area,
        to ensure app opens in accessible area of screen
         */
          child: Column(children: [
            Container(
              // title bar
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                  color: searchBarBG, borderRadius: BorderRadius.circular(8.5)),

              //title bar items wrapped under row, since, they are to be displayed in a row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _drawerBarIcon(),
                  _searchBar(),
                  _changeViewMode(),
                  _syncToCloud()
                  //_searchButton()
                ],
              ),
            ),
            // title bar ends

            const SizedBox(height: 25), //spacing

            /*
          while the data is being fetched, a skeleton body will be displayed for a few seconds
           */
            // ALL NOTES DISPLAY SECTION
            isLoading ? _skeletonNotes(context) : _displayNotes()
          ]),
        ));
  }

  // USER DEFINED FUNCTIONS AND WIDGETS

  void fetchNotes() async {
    notesList = await FirestoreDB.getNotesData();
  }

  void callSkeleton() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  // title bar widgets
  Widget _drawerBarIcon() => IconButton(
      onPressed: () {
        _drawerKey.currentState!.openDrawer();
      },
      icon: Icon(Icons.menu, color: buttonsColor));

  // search bar, will route to another screen where search results will be displayed
  Widget _searchBar() => GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchNote()));
        },
        child: Container(
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: const BoxDecoration(),
            child: Text("Search Your Notes", style: hintTextStyle)),
      );

  // switch to list/tab view
  Widget _changeViewMode() => IconButton(
        onPressed: () {
          setState(() {
            isListView == false
                ? (
                    isListView = true,
                    viewMode = const Icon(Icons.grid_view_outlined)
                  )
                : (
                    isListView = false,
                    viewMode = const Icon(Icons.list_outlined)
                  );
          });
        },
        icon: viewMode,
      );

  // offline online data sync
  Widget _syncToCloud() => InkWell(
      onLongPress: () {
        setState(() {
          isSync == true
              ? (
                  isSync = false,
                  syncIcon = Icon(Icons.sync_disabled, color: buttonsColor)
                )
              : (
                  isSync = true,
                  syncIcon = Icon(Icons.sync, color: buttonsColor)
                );
        });
      },
      onTap: () {
        setState(() {
          isSync == true
              ? (
                  isSync = false,
                  syncIcon = Icon(Icons.sync, color: buttonsColor)
                )
              : (
                  isSync = true,
                  syncIcon = Icon(Icons.sync_disabled, color: buttonsColor)
                );
        });
      },
      child: isSync ? Icon(Icons.sync, color: buttonsColor) : syncIcon);

  Widget _displayNotes() => Expanded(
        child: MasonryGridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: notesList.length,
            // fetched from fetchNotes() method called in init method
            crossAxisCount: isListView ? 1 : 2,
            // 1 will be for list view, 2 for gridView
            itemBuilder: (context, index) => InkWell(
                  // INKWELL enables to tap and route to another screen to view the selected note on full screen
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DisplayNote(note: notesList[index])));
                    notesList = await FirestoreDB.getNotesData();
                    setState(() {});
                  },
                  child: _notesSection(
                      index), // view all notes in the grid/list view
                )),
      );

  Widget _notesSection(int index) => Container(
      decoration: BoxDecoration(
          color: colorGenerator(),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(7.5)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            notesList[index].title,
            style: displayHeadingStyle,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 20),
          Text(
            notesList[index].content,
            overflow: TextOverflow.ellipsis,
            maxLines: 6,
            style: contentStyle,
          ),
        ],
      ));

  // default boxes with grey lines, will be displayed while the data loads from the server
  Widget skeletonBody() => Container(
        height: MediaQuery.of(context).size.height * 0.02,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.5), color: Colors.grey[200]),
      );

  // similar to _displayNotes()
  Widget _skeletonNotes(BuildContext context) => Expanded(
        child: MasonryGridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: 10,
            crossAxisCount: isListView ? 1 : 2,
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    setState(() {});
                  },
                  child: _skeleton(index),
                )),
      );

  // similar to notesSection
  Widget _skeleton(int index) => Container(
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(7.5)),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: Colors.grey[200]),
              ),
              const SizedBox(height: 20),
              skeletonBody(),
              const SizedBox(height: 10),
              skeletonBody(),
              const SizedBox(height: 10),
              skeletonBody(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
}
