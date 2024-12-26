import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4282801553),
      surfaceTint: Color(4282801553),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4292469503),
      onPrimaryContainer: Color(4278196548),
      secondary: Color(4283915889),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4292600569),
      onSecondaryContainer: Color(4279507756),
      tertiary: Color(4285683058),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4294825978),
      onTertiaryContainer: Color(4280947500),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294637823),
      onSurface: Color(4279900960),
      onSurfaceVariant: Color(4282664527),
      outline: Color(4285888384),
      outlineVariant: Color(4291151568),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282614),
      inversePrimary: Color(4289709823),
      primaryFixed: Color(4292469503),
      onPrimaryFixed: Color(4278196548),
      primaryFixedDim: Color(4289709823),
      onPrimaryFixedVariant: Color(4281222520),
      secondaryFixed: Color(4292600569),
      onSecondaryFixed: Color(4279507756),
      secondaryFixedDim: Color(4290758364),
      onSecondaryFixedVariant: Color(4282402393),
      tertiaryFixed: Color(4294825978),
      onTertiaryFixed: Color(4280947500),
      tertiaryFixedDim: Color(4292852702),
      onTertiaryFixedVariant: Color(4284038490),
      surfaceDim: Color(4292532704),
      surfaceBright: Color(4294637823),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243322),
      surfaceContainer: Color(4293848564),
      surfaceContainerHigh: Color(4293453807),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280893812),
      surfaceTint: Color(4282801553),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284314793),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282139477),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285363336),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4283775574),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4287196041),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294637823),
      onSurface: Color(4279900960),
      onSurfaceVariant: Color(4282401611),
      outline: Color(4284309351),
      outlineVariant: Color(4286085763),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282614),
      inversePrimary: Color(4289709823),
      primaryFixed: Color(4284314793),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4282669967),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285363336),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283784303),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4287196041),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4285485680),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532704),
      surfaceBright: Color(4294637823),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243322),
      surfaceContainer: Color(4293848564),
      surfaceContainerHigh: Color(4293453807),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278198353),
      surfaceTint: Color(4282801553),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280893812),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279968307),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282139477),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281407795),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283775574),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294637823),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280362027),
      outline: Color(4282401611),
      outlineVariant: Color(4282401611),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282614),
      inversePrimary: Color(4293389311),
      primaryFixed: Color(4280893812),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4279184220),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282139477),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280691774),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283775574),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282197054),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532704),
      surfaceBright: Color(4294637823),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243322),
      surfaceContainer: Color(4293848564),
      surfaceContainerHigh: Color(4293453807),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4289709823),
      surfaceTint: Color(4289709823),
      onPrimary: Color(4279512928),
      primaryContainer: Color(4281222520),
      onPrimaryContainer: Color(4292469503),
      secondary: Color(4290758364),
      onSecondary: Color(4280889410),
      secondaryContainer: Color(4282402393),
      onSecondaryContainer: Color(4292600569),
      tertiary: Color(4292852702),
      onTertiary: Color(4282459970),
      tertiaryContainer: Color(4284038490),
      onTertiaryContainer: Color(4294825978),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279374616),
      onSurface: Color(4293059305),
      onSurfaceVariant: Color(4291151568),
      outline: Color(4287598745),
      outlineVariant: Color(4282664527),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4282801553),
      primaryFixed: Color(4292469503),
      onPrimaryFixed: Color(4278196548),
      primaryFixedDim: Color(4289709823),
      onPrimaryFixedVariant: Color(4281222520),
      secondaryFixed: Color(4292600569),
      onSecondaryFixed: Color(4279507756),
      secondaryFixedDim: Color(4290758364),
      onSecondaryFixedVariant: Color(4282402393),
      tertiaryFixed: Color(4294825978),
      onTertiaryFixed: Color(4280947500),
      tertiaryFixedDim: Color(4292852702),
      onTertiaryFixedVariant: Color(4284038490),
      surfaceDim: Color(4279374616),
      surfaceBright: Color(4281874751),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279900960),
      surfaceContainer: Color(4280164133),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4290169599),
      surfaceTint: Color(4289709823),
      onPrimary: Color(4278195258),
      primaryContainer: Color(4286156999),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4291087073),
      onSecondary: Color(4279178790),
      secondaryContainer: Color(4287271077),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293181410),
      onTertiary: Color(4280552743),
      tertiaryContainer: Color(4289169062),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279374616),
      onSurface: Color(4294769407),
      onSurfaceVariant: Color(4291414740),
      outline: Color(4288783020),
      outlineVariant: Color(4286677900),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4281288569),
      primaryFixed: Color(4292469503),
      onPrimaryFixed: Color(4278193967),
      primaryFixedDim: Color(4289709823),
      onPrimaryFixedVariant: Color(4279972966),
      secondaryFixed: Color(4292600569),
      onSecondaryFixed: Color(4278849825),
      secondaryFixedDim: Color(4290758364),
      onSecondaryFixedVariant: Color(4281284168),
      tertiaryFixed: Color(4294825978),
      onTertiaryFixed: Color(4280158241),
      tertiaryFixedDim: Color(4292852702),
      onTertiaryFixedVariant: Color(4282854728),
      surfaceDim: Color(4279374616),
      surfaceBright: Color(4281874751),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279900960),
      surfaceContainer: Color(4280164133),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294769407),
      surfaceTint: Color(4289709823),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4290169599),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294769407),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291087073),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965754),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4293181410),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279374616),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294769407),
      outline: Color(4291414740),
      outlineVariant: Color(4291414740),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4278921305),
      primaryFixed: Color(4292863743),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4290169599),
      onPrimaryFixedVariant: Color(4278195258),
      secondaryFixed: Color(4292929277),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291087073),
      onSecondaryFixedVariant: Color(4279178790),
      tertiaryFixed: Color(4294958332),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4293181410),
      onTertiaryFixedVariant: Color(4280552743),
      surfaceDim: Color(4279374616),
      surfaceBright: Color(4281874751),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279900960),
      surfaceContainer: Color(4280164133),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
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
        scaffoldBackgroundColor: colorScheme.background,
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
