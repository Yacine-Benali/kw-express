import 'package:flutter/material.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:provider/provider.dart';

import 'app/sign_in/phone_number/phone_number_sign_in_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return StreamBuilder<AuthUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            AuthUser user = snapshot.data;
            if (user == null) {
              return PhoneNumberSignInPage.create(context);
            }
            return Container(
              color: Colors.red,
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
