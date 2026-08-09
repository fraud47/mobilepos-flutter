import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../imports/core_imports.dart';


class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.autofocus = false,
    this.underlined = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool autofocus;
  final bool underlined;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final fillColor = context.isDarkMode
        ? cs.surfaceContainerHighest.withValues(alpha: 0.45)
        : const Color(0xFFFAFAFA);
    final iconColor = WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.error)) {
        return cs.error;
      }
      return cs.onSurface.withValues(alpha: 0.82);
    });
    final hintColor = WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.error)) {
        return cs.error;
      }
      return cs.onSurfaceVariant.withValues(alpha: 0.65);
    });
    final labelWidget = label == null || label==''
        ? null
        : Padding(
            padding:  EdgeInsets.only(bottom: 5,right: 5.w),
            child: Text(
              label!,
              style: tt.labelLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelWidget != null) labelWidget,
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          autofocus: autofocus,
          style: tt.labelLarge?.copyWith(
            color: cs.onSurface,
            fontSize: underlined ? 18 : null,
            fontWeight:  FontWeight.w400,
            letterSpacing: 0,
          ),
          cursorColor: cs.primary,
          cursorErrorColor: cs.error,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),

            hintText: underlined ? null : hint,
            hintStyle: tt.labelLarge?.copyWith(
              color: hintColor,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            contentPadding: underlined
                ? const EdgeInsets.only(bottom: 9, top: 2)
                : const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
            prefixIcon: prefixIcon,
            prefixIconColor: iconColor,
            prefixIconConstraints: underlined
                ? const BoxConstraints(
                    minWidth: 0,
                    minHeight: 20,
                  )
                : const BoxConstraints(
                    minWidth: 42,
                    minHeight: 20,
                  ),
            suffixIcon: suffixIcon,
            suffixIconColor: underlined ? cs.primary : iconColor,
            suffixIconConstraints: underlined
                ? const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  )
                : null,


            errorBorder:InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ],
    );
  }

  InputBorder _border(
    BuildContext context, {
    bool focused = false,
    bool disabled = false,
    bool error = false,
  }) {
    final cs = context.theme.colorScheme;
    if (!underlined) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(focused && error ? 40 : 30),
        borderSide: error ? BorderSide(color: cs.error) : BorderSide.none,
      );
    }

    final color = error
        ? cs.error
        : disabled
            ? cs.primary.withValues(alpha: 0.45)
            : cs.primary;

    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: focused ? 2.4 : 2,
      ),
    );
  }
}
