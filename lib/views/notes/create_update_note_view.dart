import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;
  late final List<File> _pickedImages = [];
  final _picker = ImagePicker();
  bool isMenuOpen = false;
  late File file;
  bool isBoldActive = false;
  TextSelection? selectedText;
  bool isItalicsActive = false;
  bool isUnderlineActive = false;
  bool isStrikethroughActive = false;

  // Function to toggle the menu state
  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  Future<void> _openImagePicker() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(pickedImages.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _openCamera() async {
    final XFile? pickedImages =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImages != null) {
      setState(() {
        _pickedImages.add(File(pickedImages.path));
      });
    }
  }

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    print('created!');
    return await _notesService.createNote(owner: owner);
  }

  //if text is empty, delete note
  void _deleteNote() {
    final note = _note;
    if (note != null &&
        _titleController.text.isEmpty &&
        _textController.text.isEmpty) {
      print('Hello, world!');
      _notesService.deleteNote(id: note.id);
    }
  }

  //if text not empty, save note
  void _saveNote() async {
    final note = _note;
    final text = _textController.text;
    final title = _titleController.text;

    if (note != null) {
      if (title.isNotEmpty || text.isNotEmpty) {
        print('updated!');
        await _notesService.updateNote(
          note: note,
          title: title,
          text: text,
        );
      } else {
        print('Hello, world!');
        // Delete note if both title and text are empty
        _deleteNote();
      }
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;

    await _notesService.updateNote(
      note: note,
      text: text,
      title: title,
    );
  }

  void _titleControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;

    await _notesService.updateNote(
      note: note,
      text: text,
      title: title,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  void _setupTitleControllerListener() {
    _titleController.removeListener(_titleControllerListener);
    _titleController.addListener(_titleControllerListener);
  }

  Future<void> _createNoteAndSetupControllers() async {
    if (_note == null) {
      final note = await createNewNote();
      setState(() {
        _note = note;
      });

      _setupTextControllerListener();
      _setupTitleControllerListener();
    }
  }

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    _titleController = TextEditingController();

    _createNoteAndSetupControllers();

    super.initState();
  }

  @override
  void dispose() {
    _deleteNote();
    _saveNote();
    _textController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF4EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4EFEA),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF7EABFF), // Change the color of the back button
          size: 30,
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            child: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.add,
                color: Color(0xFF7EABFF),
                size: 25,
              ),
            ),
            onSelected: (value) {
              if (value == 'Add Photo') {
                _openImagePicker(); // Handle 'Add Photo' action
              } else if (value == 'Add Document') {
                // Handle 'Add Document' action
              } else if (value == 'Open Camera') {
                _openCamera(); // Handle 'Open Camera' action
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: "Add Photo",
                child: Icon(Icons.photo_rounded),
              ),
              const PopupMenuItem(
                value: "Add Document",
                child: Icon(Icons.attach_file_rounded),
              ),
              const PopupMenuItem(
                value: "Open Camera",
                child: Icon(Icons.camera_alt_rounded),
              )
            ],
            tooltip: 'Open menu',
            elevation: 3, // Shadow depth
            padding: EdgeInsets.zero, // Remove default padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Round the corners
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
            child: TextField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              maxLines: null,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(hintText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              // style: TextStyle(
              //   fontWeight: isBoldActive ? FontWeight.bold : FontWeight.normal,
              // ),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing your note here'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0XFFC2BDB8),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isBoldActive = !isBoldActive;
                  // _applyBoldToSelectedText();
                });
              },
              icon: Icon(
                Icons.format_bold_rounded,
                color: isBoldActive
                    ? Colors.blue
                    : Colors
                        .black, // Change the icon color based on the bold state
              ),
              splashColor: Colors.brown.shade100,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isItalicsActive = !isItalicsActive;
                });
              },
              icon: Icon(
                Icons.format_italic_rounded,
                color: isItalicsActive ? Colors.blue : Colors.black,
              ),
              splashColor: Colors.brown.shade100,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isUnderlineActive = !isUnderlineActive;
                });
              },
              icon: Icon(
                Icons.format_underline_rounded,
                color: isUnderlineActive ? Colors.blue : Colors.black,
              ),
              splashColor: Colors.brown.shade100,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isStrikethroughActive = !isStrikethroughActive;
                });
              },
              icon: Icon(
                Icons.format_strikethrough_rounded,
                color: isStrikethroughActive ? Colors.blue : Colors.black,
              ),
              splashColor: Colors.brown.shade100,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.format_list_bulleted_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.format_list_numbered_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.check_box_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
