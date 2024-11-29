import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  User? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}
