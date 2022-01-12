import 'package:flutter/cupertino.dart';
import 'flutter_paytabs_bridge.dart';

class IOSThemeConfigurations {
  String? logoImage;
  String? primaryColor;
  String? primaryFontColor;
  String? secondaryColor;
  String? secondaryFontColor;
  String? strokeColor;
  String? buttonColor;
  String? buttonFontColor;
  String? titleFontColor;
  String? backgroundColor;
  String? placeholderColor;
  String? primaryFont;
  String? secondaryFont;
  int? strokeThinckness;
  int? inputsCornerRadius;
  String? buttonFont;
  String? titleFont;

  IOSThemeConfigurations({
    this.logoImage,
    this.primaryColor,
    this.primaryFontColor,
    this.secondaryColor,
    this.secondaryFontColor,
    this.strokeColor,
    this.buttonColor,
    this.buttonFontColor,
    this.titleFontColor,
    this.backgroundColor,
    this.placeholderColor,
    this.primaryFont,
    this.secondaryFont,
    this.strokeThinckness,
    this.inputsCornerRadius,
    this.buttonFont,
    this.titleFont,
  });
}

extension IOSThemeConfigurationsExtension on IOSThemeConfigurations {
  Map<String, dynamic> get map {
    return {
      pt_ios_logo: this.logoImage,
      pt_ios_primary_color: this.primaryColor,
      pt_ios_primary_font_color: this.primaryFontColor,
      pt_ios_secondary_color: this.secondaryColor,
      pt_ios_secondary_font_color: this.secondaryFontColor,
      pt_ios_stroke_color: this.strokeColor,
      pt_ios_button_color: this.buttonColor,
      pt_ios_button_font_color: this.buttonFontColor,
      pt_ios_title_font_color: this.titleFontColor,
      pt_ios_background_color: this.backgroundColor,
      pt_ios_placeholder_color: this.placeholderColor,
      pt_ios_primary_font: this.primaryFont,
      pt_ios_secondary_font: this.secondaryFont,
      pt_ios_stroke_thinckness: this.strokeThinckness,
      pt_ios_inputs_corner_radius: this.inputsCornerRadius,
      pt_ios_button_font: this.buttonFont,
      pt_ios_title_font: this.titleFont,
    };
  }
}