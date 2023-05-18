import 'dart:async';

import 'package:docs_clone_with_nodejs_socket_io/common/widgets/loader.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/auth_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/document_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/socket_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

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
  quill.QuillController? _controller;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();
  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();

    socketRepository.changeListener((data) {
      _controller?.compose(
          quill.Delta.fromJson(data['delta']),
          _controller?.selection ?? const TextSelection.collapsed(offset: 0),
          quill.ChangeSource.REMOTE);
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository
          .autoSave(<String, dynamic>{'delta': _controller!.document.toDelta(), 'room': widget.id});
    });
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
      _controller = quill.QuillController(
          document: errorModel!.data.content.isEmpty
              ? quill.Document()
              : quill.Document.fromDelta(quill.Delta.fromJson(errorModel!.data.content)),
          selection: const TextSelection.collapsed(offset: 0));
      setState(() {});
    }

    _controller!.document.changes.listen((event) {
      if (event.source == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {'delta': event.change, 'room': widget.id};
        socketRepository.typing(map);
      }
    });
  }

  void updateTitle(WidgetRef ref, String title) {
    ref
        .read(documentRepositoryProvider)
        .updateTitle(token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
      backgroundColor: cWhiteColor,
      appBar: AppBar(
        backgroundColor: cWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(
                        ClipboardData(text: 'https:localhost:3000/#/document/${widget.id}'))
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Link Copy!"),
                    ),
                  );
                });
              },
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
            GestureDetector(
              onTap: () {
                Routemaster.of(context).replace('/');
              },
              child: Image.asset(
                "asset/images/docs-logo.png",
                height: 40,
              ),
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
            quill.QuillToolbar.basic(controller: _controller!),
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
                      controller: _controller!,
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
