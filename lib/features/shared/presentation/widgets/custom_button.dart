import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  /// Builds the button widget based on the [isOutlined] property.
  ///
  /// If [isOutlined] is true, an [OutlinedButton] is returned. Otherwise, an
  /// [ElevatedButton] is returned.
  ///
  /// The button's child is determined by the [_buildButtonContent] method,
  /// which is called with the current [Theme].
  ///
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: _buildButtonContent(theme),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.primaryColor,
        foregroundColor: textColor ?? Colors.white,
      ),
      child: _buildButtonContent(theme),
    );
  }

  /// Builds the button content based on the [isLoading] and [icon] properties.
  ///
  /// If [isLoading] is true, a [CircularProgressIndicator] is returned. If [icon]
  /// is not null, a [Row] is returned with the icon and the button text. Otherwise,
  /// the button text is returned directly.
  ///
  /// The [theme] parameter is used to determine the color of the
  /// [CircularProgressIndicator].
  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? theme.primaryColor : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
