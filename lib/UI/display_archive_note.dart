import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/edit_note.dart';
import 'package:fundoo_notes/UI/view_archive_notes.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/services/my_note_model.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';


class DisplayArchiveNotes extends StatelessWidget {
  final Note note;
  const DisplayArchiveNotes({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: allRoutesBG,
      body: SafeArea(
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
                  _unArchiveNote(context)
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
  Widget _goBack(BuildContext context) =>
      InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewArchivedNotes()));
          },
          child: const Icon(Icons.arrow_back, color: Colors.white,)
      );

  //SIZED BOX
  Widget _space(BuildContext context) =>
      SizedBox(width: MediaQuery.of(context).size.width*0.04);


  // DELETE NOTE WIDGET
  Widget _deleteNote(BuildContext context) =>
      InkWell(
        onTap: ()async {
          await FirestoreDB.deleteArchivedNote(note.id);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewArchivedNotes()));
        },
        child: Icon(Icons.delete, color: tabItemColor),
      );

  //EDIT NOTE WIDGET
  Widget _editNote(BuildContext context) =>
      InkWell(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditNote(note: note)));
          },
          child: Icon(Icons.edit, color: tabItemColor)
      );

  Widget _unArchiveNote(BuildContext context) =>
      InkWell(
          onTap: ()async {
            await FirestoreDB.unArchiveNote(note.title, note.content, note.id);
            debugPrint(note.id);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewArchivedNotes()));
            },
          child: Icon(Icons.unarchive_rounded, color: tabItemColor));
}
