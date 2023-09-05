import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fundoo_notes/UI/display_archive_note.dart';
import 'package:fundoo_notes/UI/side_menu.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/services/my_note_model.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class ViewArchivedNotes extends StatefulWidget {
  const ViewArchivedNotes({super.key});

  @override
  State<ViewArchivedNotes> createState() => _ViewArchivedNotesState();
}

class _ViewArchivedNotesState extends State<ViewArchivedNotes> {
  List<Note> archivedNotesList = [];
  bool isListView = false;
  var viewMode = const Icon(Icons.list_outlined);
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArchivedNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: const SideMenu(),
      backgroundColor: allRoutesBG,
      body: SafeArea(
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
                  _searchButton()
                ],
              ),
            ),
            const SizedBox(height: 25),
            _displayArchivedNotes(),
          ]),
        ),
      ),
    );
  }

  Widget _drawerBarIcon() => IconButton(
      onPressed: () {
        _drawerKey.currentState!.openDrawer();
      },
      icon: Icon(Icons.menu, color: buttonsColor));

  // search bar
  Widget _searchBar() => Container(
        alignment: Alignment.centerLeft,
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: const BoxDecoration(),
        child: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Archived Notes",
          ),
        ),
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

// search icon
  Widget _searchButton() => IconButton(
      onPressed: () {}, icon: Icon(Icons.search_rounded, color: buttonsColor));

  Widget _displayArchivedNotes() => Expanded(
        child: MasonryGridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: archivedNotesList.length,
            crossAxisCount: isListView ? 1 : 2,
            itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayArchiveNotes(
                                note: archivedNotesList[index])));
                    archivedNotesList = await FirestoreDB.fetchArchiveNotes();
                    setState(() {});
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: _colorGenerator(),
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(7.5)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            archivedNotesList[index].title,
                            style: displayHeadingStyle,
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            archivedNotesList[index].content,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: contentStyle,
                          ),
                          const SizedBox(height: 10),
                          // Text(
                          //     "last modified:\n ${notesList[index].createdTime}",
                          //     style: subtitleTextStyle),
                        ],
                      )),
                )),
      );

  Color? _colorGenerator() {
    var value = Random().nextInt(notesColors.length);
    return notesColors[value];
  }

  void getArchivedNotes() async {
    archivedNotesList = await FirestoreDB.fetchArchiveNotes();
    setState(() {});
  }
}
