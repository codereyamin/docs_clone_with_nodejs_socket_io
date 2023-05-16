import 'package:docs_clone_with_nodejs_socket_io/repository/auth_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/document_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/socket_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/document_model.dart';
import '../../models/error_model.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleTextEditingController = TextEditingController(text: "unTitle");
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();
  @override
  void initState() {
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    super.initState();
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    super.dispose();
  }

  fetchDocumentData() async {
    errorModel = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(ref.read(userProvider)!.token, widget.id);

    if (errorModel!.data != null) {
      titleTextEditingController.text = (errorModel!.data as DocumentModel).title;
      setState(() {});
    }
  }

  void updateTitle(WidgetRef ref, String title) {
    ref
        .read(documentRepositoryProvider)
        .updateTitle(token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhiteColor,
      appBar: AppBar(
        backgroundColor: cWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.lock,
                size: 16,
              ),
              label: const Text("Share"),
              style: ElevatedButton.styleFrom(backgroundColor: cBlueColor),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: Row(children: [
            Image.asset(
              "asset/images/docs-logo.png",
              height: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: titleTextEditingController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: cBlueColor),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ))
          ]),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: cGrayColor, width: 0.1)),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            quill.QuillToolbar.basic(controller: _controller),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SizedBox(
                width: 700,
                child: Card(
                  color: cWhiteColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: quill.QuillEditor.basic(
                      controller: _controller,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
