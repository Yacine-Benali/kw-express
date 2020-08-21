import 'package:flutter/material.dart';
import 'package:kwexpress/constants/app_colors.dart';

class ErrorIconWidget extends StatelessWidget {
  bool _isError;

  ErrorIconWidget(this._isError);

  bool get isError => _isError;

  @override
  Widget build(BuildContext context) {
    Widget out;

    isError
        ? out = new Icon(
            Icons.error,
            color: Color(AppColors.colorPrimary.value),
          )
        : out = new Icon(null);

    return out;
  }
}
