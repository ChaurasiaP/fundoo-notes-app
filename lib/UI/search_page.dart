import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fundoo_notes/UI/display_note.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/UI/side_menu.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/services/my_note_model.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class SearchNote extends StatefulWidget {
  const SearchNote({super.key});

  @override
  State<SearchNote> createState() => _SearchNoteState();
}

class _SearchNoteState extends State<SearchNote> {
  List<Note> searchResultsNotes = [];
  List<String> searchResultsIDs = [];
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              // title bar
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                  color: searchBarBG, borderRadius: BorderRadius.circular(8.5)),

              //title bar items wrapped under row, since, they are to be displayed in a row
              child: Row(
                children: <Widget>[
                  _goBack(context),
                  const SizedBox(width: 25),
                  _searchBar(),
                  // _searchButton()
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("Search Results:"),
            const SizedBox(height: 25),
            _displaySearchResult()
          ]),
        ),
      ),
    );
  }

  Widget _goBack(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainRoute()));
      },
      child: Icon(Icons.arrow_back, color: buttonsColor));

  // search bar
  Widget _searchBar() => Container(
        alignment: Alignment.centerLeft,
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: const BoxDecoration(),
        child: TextField(
          onSubmitted: (value) => {fetchResults(value)},
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search Your Notes",
          ),
        ),
      );

  Widget _displaySearchResult() => Expanded(
        child: MasonryGridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: searchResultsNotes.length,
            crossAxisCount: 2,
            itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DisplayNote(note: searchResultsNotes[index])));
                    searchResultsNotes = await FirestoreDB.getNotesData();
                    setState(() {});
                  },
                  child: Container(
                    // color: allRoutesBG,
                      decoration: BoxDecoration(
                        color: allRoutesBG,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(7.5)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            searchResultsNotes[index].title,
                            style: displayHeadingStyle,
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            searchResultsNotes[index].content,
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

  void fetchResults(String query) async {
    var result = await FirestoreDB.getNotesData();
    for (var searchResult in result) {
      if (searchResult.title
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase().trim()) ||
          searchResult.content
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase().trim())) {
        searchResultsNotes.add(searchResult);
      }
    }
    setState(() {});
  }
}
