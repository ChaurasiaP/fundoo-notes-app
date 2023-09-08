import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/edit_note.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/services/my_note_model.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class DisplayNote extends StatelessWidget {
  final Note note;

  const DisplayNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    late bool isLoading = false;
    return Scaffold(
      backgroundColor: routesBG,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: activeTab),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _goBack(context),
                        Row(
                          children: [
                            _pinNote(),
                            _space(context),
                            InkWell(
                              onTap: () async {
                                isLoading = true;
                                await FirestoreDB.deleteNote(note.id);
                                //await Future.delayed(Duration(seconds: 2));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainRoute()));
                              },
                              child: Icon(Icons.delete, color: tabItemColor),
                            ),
                            _space(context),
                            _editNote(context),
                            _space(context),
                            _archiveNote(context)
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      Text(note.title, style: headingStyle),
                      const SizedBox(height: 20),
                      Text(note.content, style: contentStyle),
                    ],
                  ))
                ],
              ),
            ),
    );
  }

  Widget _goBack(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainRoute()));
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ));

  // SIZED BOX
  Widget _space(BuildContext context) =>
      SizedBox(width: MediaQuery.of(context).size.width * 0.04);

  // PINNED NOTE WIDGET
  Widget _pinNote() => Icon(Icons.push_pin, color: tabItemColor);

  // DELETE NOTE WIDGET
  // Widget _deleteNote(BuildContext context) =>
  //     InkWell(
  //       onTap: ()async {
  //         await FirestoreDB.deleteNote(note.id);
  //         Navigator.pop(context);
  //       },
  //       child: Icon(Icons.delete, color: tabItemColor),
  //     );

  // EDIT NOTE WIDGET
  Widget _editNote(BuildContext context) => InkWell(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EditNote(note: note)));
      },
      child: Icon(Icons.edit, color: tabItemColor));

  Widget _archiveNote(BuildContext context) => InkWell(
      onTap: () async {
        await FirestoreDB.archiveNote(note.title, note.content, note.id);
        Future.delayed(Duration(seconds: 4));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainRoute()));
      },
      child: Icon(Icons.archive_rounded, color: tabItemColor));
}
