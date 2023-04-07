import 'package:docs_clone_with_nodejs_socket_io/models/document_model.dart';
import 'package:docs_clone_with_nodejs_socket_io/models/error_model.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/auth_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../common/widgets/loader.dart';
import '../../utils/colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push("/document/${errorModel.data.id}");
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push("/document/$documentId");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: cWhiteColor, actions: [
        IconButton(
            onPressed: () => createDocument(context, ref),
            icon: const Icon(
              Icons.add,
              color: cBlackColor,
            )),
        IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: cRedColor,
            )),
      ]),
      body: FutureBuilder<ErrorModel?>(
        future: ref.watch(documentRepositoryProvider).getDocument(ref.watch(userProvider)!.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 5),
              width: 600,
              child: ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  DocumentModel documentModel = snapshot.data!.data[index];

                  return InkWell(
                    onTap: () => navigateToDocument(context, documentModel.id),
                    child: SizedBox(
                      height: 50,
                      child: Card(
                        child: Center(child: Text(documentModel.title)),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
