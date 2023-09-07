import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
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
  List<Note> notesList = [];
  bool isListView = false;
  var viewMode = const Icon(Icons.list_outlined);
  bool isSync = true;
  Icon syncIcon = Icon(Icons.sync, color: buttonsColor);
  bool isLoading = false;

  // declaring a global key to enable drawer expansion, where required
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Future createNewNote() async {
    // await FirestoreDB().createNewNoteFirestore("sdf", "34");
  }

  Future updateNote() async {
    // await FirestoreDB().updateNote("Sixth title", "this is the Sixth demo content of the new heading", FirebaseAuth.instance.currentUser!.email.toString(), "2");
  }

  Future readNote() async {
    // await FirestoreDB().readAllNotes("sd");
  }

  Future deleteNote() async {
    // await FirestoreDB.deleteNote();
  }

  Future readAllNote() async {
    // await FirestoreDB.getAllNotesData("as");
  }

  @override
  void initState() {
    super.initState();
    fetchNotes();
    // debugPrint("inside init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,

      // drawer menu-bar code
      drawer: const SideMenu(),
      // drawer menu-bar ends

      backgroundColor: routesBG,

      body: SafeArea(
        // wrapped into SafeArea widget display content below the notch area
        child: Container(
          alignment: Alignment.topLeft,
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
            const SizedBox(height: 25),
            isLoading ? _displayNotes() : _skeletonNotes(context),
          ]),
        ),
      ),
      // floating action button (+) to create new note
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
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }

  // user defined widget returning functions

  // title bar widgets
  Widget _drawerBarIcon() => IconButton(
      onPressed: () {
        _drawerKey.currentState!.openDrawer();
      },
      icon: Icon(Icons.menu, color: buttonsColor));

  // search bar
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
      child: isSync
          ? Icon(
              Icons.sync,
              color: buttonsColor,
            )
          : syncIcon);

// search icon (currently replaced by sync icon)
//   Widget _searchButton() => IconButton(
//       onPressed: () {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const SearchNote()));
//       },
//       icon: Icon(Icons.search_rounded, color: buttonsColor));

  Widget _displayNotes() => Expanded(
        child: MasonryGridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: notesList.length,
            crossAxisCount: isListView ? 1 : 2,
            itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DisplayNote(note: notesList[index])));
                    notesList = await FirestoreDB.getNotesData();
                    setState(() {});
                  },
                  child: _notesSection(index),
                )),
      );

  Color? _colorGenerator() {
    var value = Random().nextInt(notesColors.length);
    return notesColors[value];
  }

  Widget _notesSection(int index) =>
      Container(
          decoration: BoxDecoration(
              color: _colorGenerator(),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(7.5)),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notesList[index].title,
                style: displayHeadingStyle,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 10),
              Text(
                notesList[index].content,
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                style: contentStyle,
              ),
              const SizedBox(height: 10),
              // Text(
              //     "last modified:\n ${notesList[index].createdTime}",
              //     style: subtitleTextStyle),
            ],
          ));

  Widget _skeleton(int index) =>
      Container(
        height: MediaQuery.of(context).size.height*0.2,
          decoration: BoxDecoration(
            color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(7.5)),
          padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _skeletonBody(),
            const SizedBox(height: 10),
            _skeletonBody(),
            const SizedBox(height: 10),
            _skeletonBody(),
            const SizedBox(height: 10),
            _skeletonBody(),
            const SizedBox(height: 10),
            _skeletonBody(),
          ],
        ),
          );
  void fetchNotes() async {
    setState(() {
      isLoading = false;
    });
    notesList = await FirestoreDB.getNotesData();
    setState(() {
      isLoading = true;
    });
  }

  Widget _skeletonBody() =>
    Container(
      height: MediaQuery.of(context).size.height*0.02,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          color: Colors.grey[350]
      ),
    );

  Widget _skeletonNotes(BuildContext context) =>
    Expanded(
      child: MasonryGridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          itemCount: notesList.length,
          crossAxisCount: isListView ? 1 : 2,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {});
            },
            child: _skeleton(index),
          )),
    );
}
