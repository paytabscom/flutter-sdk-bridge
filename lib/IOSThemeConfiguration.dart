import 'flutter_paytabs_bridge.dart';

class IOSThemeConfigurations {
  String? logoImage;
  String? primaryColor;
  String? primaryColorDark;
  String? primaryFontColor;
  String? primaryFontColorDark;
  String? secondaryColor;
  String? secondaryColorDark;
  String? secondaryFontColor;
  String? secondaryFontColorDark;
  String? strokeColor;
  String? strokeColorDark;
  String? buttonColor;
  String? buttonColorDark;
  String? buttonFontColor;
  String? buttonFontColorDark;
  String? titleFontColor;
  String? titleFontColorDark;
  String? backgroundColor;
  String? backgroundColorDark;
  String? placeholderColor;
  String? placeholderColorDark;
  String? primaryFont;
  String? secondaryFont;
  int? strokeThinckness;
  int? inputsCornerRadius;
  String? buttonFont;
  String? titleFont;

  IOSThemeConfigurations({
    this.logoImage,
    this.primaryColor,
    this.primaryColorDark,
    this.primaryFontColor,
    this.primaryFontColorDark,
    this.secondaryColor,
    this.secondaryColorDark,
    this.secondaryFontColor,
    this.secondaryFontColorDark,
    this.strokeColor,
    this.strokeColorDark,
    this.buttonColor,
    this.buttonColorDark,
    this.buttonFontColor,
    this.buttonFontColorDark,
    this.titleFontColor,
    this.titleFontColorDark,
    this.backgroundColor,
    this.backgroundColorDark,
    this.placeholderColor,
    this.placeholderColorDark,
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
      pt_ios_primary_color_dark: this.primaryColorDark,

      pt_ios_primary_font_color: this.primaryFontColor,
      pt_ios_primary_font_color_dark: this.primaryFontColorDark,

      pt_ios_secondary_color: this.secondaryColor,
      pt_ios_secondary_color_dark: this.secondaryColorDark,

      pt_ios_secondary_font_color: this.secondaryFontColor,
      pt_ios_secondary_font_color_dark: this.secondaryFontColorDark,

      pt_ios_stroke_color: this.strokeColor,
      pt_ios_stroke_color_dark: this.strokeColorDark,

      pt_ios_button_color: this.buttonColor,
      pt_ios_button_color_dark: this.buttonColorDark,

      pt_ios_button_font_color: this.buttonFontColor,
      pt_ios_button_font_color_dark: this.buttonFontColorDark,

      pt_ios_title_font_color: this.titleFontColor,
      pt_ios_title_font_color_dark: this.titleFontColorDark,

      pt_ios_background_color: this.backgroundColor,
      pt_ios_background_color_dark: this.backgroundColorDark,

      pt_ios_placeholder_color: this.placeholderColor,
      pt_ios_placeholder_color_dark: this.placeholderColorDark,

      pt_ios_primary_font: this.primaryFont,
      pt_ios_secondary_font: this.secondaryFont,
      pt_ios_stroke_thinckness: this.strokeThinckness,
      pt_ios_inputs_corner_radius: this.inputsCornerRadius,
      pt_ios_button_font: this.buttonFont,
      pt_ios_title_font: this.titleFont,
    };
  }
}