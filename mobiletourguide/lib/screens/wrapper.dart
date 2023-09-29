import 'package:mobiletourguide/models/user.dart';
import 'package:mobiletourguide/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:mobiletourguide/widgets/navigation.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // the user data thaat the provider provides can be a user data or null
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Auth();
    } else {
      return const Navigation(
        initialIndex: 0,
      );
    }
  }
}
