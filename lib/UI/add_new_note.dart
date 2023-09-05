import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class AddNewNote extends StatefulWidget {
  const AddNewNote({super.key});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  // List<Note> notesList = Note.getSampleNotes();

  TextEditingController headingController = TextEditingController();
  TextEditingController notesContentController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: allRoutesBG,
      resizeToAvoidBottomInset: false,
      // to avoid overflow while opening keyboard
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainRoute()));
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        const Text(
                          "Add New Note",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await FirestoreDB.createNewNoteFirestore(
                                  headingController.text,
                                  notesContentController.text);

                              if (!mounted) return;
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.save, color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(children: [
                      // enter heading for the note
                      TextField(
                        controller: headingController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Heading",
                            hintStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 25)),
                        style: headingStyle,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        // enter the content for the note
                        child: TextField(
                          // to be able to change line once the line is filled,
                          // maxLines is null so that it will automatically adjust the size as per the text input,

                          keyboardType: TextInputType.multiline,
                          // this enables enter key in textfield keyboard
                          maxLines: null,
                          // this will change the line automatically once the specified space is filled
                          controller: notesContentController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter your note...",
                              hintStyle: hintTextStyle),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
      ),
    );
  }
}
