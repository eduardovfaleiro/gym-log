import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff465d91),
      surfaceTint: Color(0xff465d91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd9e2ff),
      onPrimaryContainer: Color(0xff001944),
      secondary: Color(0xff575e71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdbe2f9),
      onSecondaryContainer: Color(0xff141b2c),
      tertiary: Color(0xff725572),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffdd7fa),
      onTertiaryContainer: Color(0xff2a132c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b20),
      onSurfaceVariant: Color(0xff44464f),
      outline: Color(0xff757780),
      outlineVariant: Color(0xffc5c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffafc6ff),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff001944),
      primaryFixedDim: Color(0xffafc6ff),
      onPrimaryFixedVariant: Color(0xff2e4578),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff141b2c),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff404659),
      tertiaryFixed: Color(0xfffdd7fa),
      onTertiaryFixed: Color(0xff2a132c),
      tertiaryFixedDim: Color(0xffdfbbde),
      onTertiaryFixedVariant: Color(0xff593d5a),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff294174),
      surfaceTint: Color(0xff465d91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5d74a9),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3c4355),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6d7488),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff553a56),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff896b89),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b20),
      onSurfaceVariant: Color(0xff40434b),
      outline: Color(0xff5d5f67),
      outlineVariant: Color(0xff787a83),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffafc6ff),
      primaryFixed: Color(0xff5d74a9),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff445b8f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6d7488),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff555c6f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff896b89),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6f5270),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002051),
      surfaceTint: Color(0xff465d91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff294174),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1b2233),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3c4355),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff311933),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff553a56),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff21242b),
      outline: Color(0xff40434b),
      outlineVariant: Color(0xff40434b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffe7ebff),
      primaryFixed: Color(0xff294174),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0f2b5c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3c4355),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff262c3e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff553a56),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3d243e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffafc6ff),
      surfaceTint: Color(0xffafc6ff),
      onPrimary: Color(0xff142f60),
      primaryContainer: Color(0xff2e4578),
      onPrimaryContainer: Color(0xffd9e2ff),
      secondary: Color(0xffbfc6dc),
      onSecondary: Color(0xff293042),
      secondaryContainer: Color(0xff404659),
      onSecondaryContainer: Color(0xffdbe2f9),
      tertiary: Color(0xffdfbbde),
      onTertiary: Color(0xff412742),
      tertiaryContainer: Color(0xff593d5a),
      onTertiaryContainer: Color(0xfffdd7fa),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc5c6d0),
      outline: Color(0xff8f9099),
      outlineVariant: Color(0xff44464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff465d91),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff001944),
      primaryFixedDim: Color(0xffafc6ff),
      onPrimaryFixedVariant: Color(0xff2e4578),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff141b2c),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff404659),
      tertiaryFixed: Color(0xfffdd7fa),
      onTertiaryFixed: Color(0xff2a132c),
      tertiaryFixedDim: Color(0xffdfbbde),
      onTertiaryFixedVariant: Color(0xff593d5a),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff1a1b20),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb6caff),
      surfaceTint: Color(0xffafc6ff),
      onPrimary: Color(0xff00143a),
      primaryContainer: Color(0xff7990c7),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc4cae1),
      onSecondary: Color(0xff0f1626),
      secondaryContainer: Color(0xff8a90a5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe4bfe2),
      onTertiary: Color(0xff240d27),
      tertiaryContainer: Color(0xffa786a6),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xfffcfaff),
      onSurfaceVariant: Color(0xffc9cad4),
      outline: Color(0xffa1a2ac),
      outlineVariant: Color(0xff81838c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff2f4779),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff000f2f),
      primaryFixedDim: Color(0xffafc6ff),
      onPrimaryFixedVariant: Color(0xff1b3466),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff0a1121),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff2f3648),
      tertiaryFixed: Color(0xfffdd7fa),
      onTertiaryFixed: Color(0xff1e0821),
      tertiaryFixedDim: Color(0xffdfbbde),
      onTertiaryFixedVariant: Color(0xff472d48),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff1a1b20),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffcfaff),
      surfaceTint: Color(0xffafc6ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffb6caff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcfaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc4cae1),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9fa),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe4bfe2),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffcfaff),
      outline: Color(0xffc9cad4),
      outlineVariant: Color(0xffc9cad4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff0b2859),
      primaryFixed: Color(0xffdfe6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb6caff),
      onPrimaryFixedVariant: Color(0xff00143a),
      secondaryFixed: Color(0xffe0e6fd),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc4cae1),
      onSecondaryFixedVariant: Color(0xff0f1626),
      tertiaryFixed: Color(0xffffdcfc),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe4bfe2),
      onTertiaryFixedVariant: Color(0xff240d27),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff1a1b20),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
