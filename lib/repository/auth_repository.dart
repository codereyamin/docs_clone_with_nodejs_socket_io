import 'dart:convert';

import 'package:docs_clone_with_nodejs_socket_io/constants/constant_url.dart';
import 'package:docs_clone_with_nodejs_socket_io/models/user_model.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/local_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../models/error_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: "some error", data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
            email: user.email,
            name: user.displayName ?? "",
            profilePci: user.photoUrl ?? "",
            uid: "",
            token: "token");
        var res =
            await _client.post(Uri.parse("$host/api/signUp"), body: userAcc.toJson(), headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        });

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)["user"]["_id"],
              token: jsonDecode(res.body)["token"],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (err) {
      error = ErrorModel(error: err.toString(), data: null);
    }

    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(error: "some error", data: null);
    try {
      final token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.get(Uri.parse("$host/api/signUp"), headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
          "x-auth-token": token
        });

        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)["user"],
              ),
            ).copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (err) {
      error = ErrorModel(error: err.toString(), data: null);
    }

    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken("");
  }
}
