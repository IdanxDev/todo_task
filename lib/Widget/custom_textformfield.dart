import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/theme_manager.dart';
import '../utils/app_const.dart';

class CustomTextFormField extends StatefulWidget {
  EdgeInsets? margin;
  String? title;
  String? hintText;
  TextEditingController? controller;
  Widget? suffixIcon;
  int? maxLine;
  bool obscureText = false;
  final Widget? suffix;
  Widget? prefixIcon;
  FormFieldValidator? validator;
  GestureTapCallback? onTap;
  bool readOnly;
  bool isSuffix;
  Color? borderColor;
  List<TextInputFormatter>? inputFormatters;
  Color? fillColor;
  TextInputType? textInputType;

  CustomTextFormField(
      {Key? key,
      this.margin,
      this.controller,
      this.onTap,
      this.hintText,
      this.suffixIcon,
      this.suffix,
      this.prefixIcon,
      required this.readOnly,
      this.fillColor,
      this.validator,
      this.title,
      this.borderColor,
      required this.obscureText,
      this.maxLine,
        this.inputFormatters,
        this.textInputType,

      this.isSuffix = false})
      : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  ThemeManager themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.title != null)

        Text(
          widget.title!,
 style: TextStyle(
            fontSize: width * 0.035,
            color: themeManager.getLightBlackColor,
            fontWeight: FontWeight.bold),
        ),
        SizedBox(height: height*0.01,),

        // if(widget.title != null)

        TextFormField(
          onTap: widget.onTap,
          validator: widget.validator,
          readOnly: widget.readOnly,
          keyboardType: widget.textInputType,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(
              fontSize: height * 0.019, color: themeManager.getBlackColor),
          obscureText: widget.obscureText,
          obscuringCharacter: '*',
          controller: widget.controller,
          maxLines: widget.maxLine,
          decoration: InputDecoration(
              filled: true,
              suffix: widget.suffix,
              suffixIconColor: Colors.grey,
              fillColor: widget.fillColor,
              suffixIcon: widget.isSuffix
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      child: Container(
                        child: widget.obscureText
                            ? widget.suffixIcon
                            : Icon(Icons.visibility,color: themeManager.getThemeColor),
                      ))
                  : Container(
                      height: 0,
                      width: 0,
                    ),
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.borderColor ?? Colors.white),
                  borderRadius: BorderRadius.circular(width * 0.03)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.borderColor ?? Colors.white),
                  borderRadius: BorderRadius.circular(width * 0.02)),
              hintStyle: TextStyle(
                  fontSize: height * 0.018,
                  color: themeManager.getBlackColor),
              border: InputBorder.none),
        ),
      ],
    );
  }
}
