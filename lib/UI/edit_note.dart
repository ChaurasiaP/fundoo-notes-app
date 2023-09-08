import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/services/my_note_model.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class EditNote extends StatefulWidget {
  final Note note;

  const EditNote({super.key, required this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController headingController = TextEditingController(text: widget.note.title);
  late TextEditingController notesContentController = TextEditingController(text: widget.note.content);

  bool isLoading = false;
  List<Note> notesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: routesBG,
      resizeToAvoidBottomInset: false,
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
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        const Text("Edit Your Note",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                                FirestoreDB.updateNote(
                                    headingController.text,
                                    notesContentController.text,
                                    widget.note.id);
                              });

                              if (!mounted) return;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainRoute()));
                            },
                            child: const Icon(Icons.save, color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(children: [
                        // enter heading for the note
                        TextFormField(
                          controller: headingController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.note.title,
                              hintStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25)),
                          style: headingStyle,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width,
                          // enter the content for the note
                          child: TextFormField(
                            // to be able to change line once the line is filled,
                            // maxLines is null so that it will automatically adjust the size as per the text input,

                            keyboardType: TextInputType.multiline,
                            // this enables enter key in textfield keyboard
                            maxLines: null,
                            // this will change the line automatically once the specified space is filled
                            controller: notesContentController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: widget.note.content,
                                hintStyle: hintTextStyle),
                            style: contentStyle,
                          ),
                        ),

                        // create note button, will route to the main screen and add the new note to the list
                      ]),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
