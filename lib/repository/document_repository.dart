import 'dart:convert';

import 'package:docs_clone_with_nodejs_socket_io/models/document_model.dart';
import 'package:docs_clone_with_nodejs_socket_io/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../constants/constant_url.dart';

final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    client: Client(),
  ),
);

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(error: "some unexpected error occurred", data: null);
    try {
      var res = await _client.post(
        Uri.parse("$host/doc/create"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
          "x-auth-token": token
        },
        body: jsonEncode({"createdAt": DateTime.now().millisecondsSinceEpoch}),
      );

      switch (res.statusCode) {
        case 200:
          error = ErrorModel(error: null, data: DocumentModel.fromJson(res.body));

          break;

        default:
          error = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (err) {
      error = ErrorModel(error: err.toString(), data: null);
    }

    return error;
  }

  Future<ErrorModel> getDocument(String token) async {
    ErrorModel error = ErrorModel(error: "some unexpected error occurred", data: null);
    try {
      var res = await _client.get(
        Uri.parse("$host/docs/me"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
          "x-auth-token": token
        },
      );

      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body[i]),
                ),
              ),
            );
          }
          error = ErrorModel(error: null, data: documents);

          break;

        default:
          error = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (err) {
      error = ErrorModel(error: err.toString(), data: null);
    }

    return error;
  }
}
