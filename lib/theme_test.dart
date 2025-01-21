import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280904263),
      surfaceTint: Color(4280904263),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289655493),
      onPrimaryContainer: Color(4278800689),
      secondary: Color(4283327317),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291946710),
      onSecondaryContainer: Color(4281813822),
      tertiary: Color(4282082417),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4290767352),
      onTertiaryContainer: Color(4280437848),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4287823882),
      surface: Color(4294376436),
      onSurface: Color(4279704857),
      onSurfaceVariant: Color(4282403138),
      outline: Color(4285626738),
      outlineVariant: Color(4290824640),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086509),
      inversePrimary: Color(4287878571),
      primaryFixed: Color(4289655493),
      onPrimaryFixed: Color(4278198544),
      primaryFixedDim: Color(4287878571),
      onPrimaryFixedVariant: Color(4278800689),
      secondaryFixed: Color(4291946710),
      onSecondaryFixed: Color(4278984468),
      secondaryFixedDim: Color(4290104506),
      onSecondaryFixedVariant: Color(4281813822),
      tertiaryFixed: Color(4290767352),
      onTertiaryFixed: Color(4278198055),
      tertiaryFixedDim: Color(4288925148),
      onTertiaryFixedVariant: Color(4280437848),
      surfaceDim: Color(4292271061),
      surfaceBright: Color(4294376436),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981678),
      surfaceContainer: Color(4293586920),
      surfaceContainerHigh: Color(4293192419),
      surfaceContainerHighest: Color(4292863197),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278206244),
      surfaceTint: Color(4280904263),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4281956693),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280761134),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284314211),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278991687),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283069312),
      onTertiaryContainer: Color(4294967295),
      error: Color(4285792262),
      onError: Color(4294967295),
      errorContainer: Color(4291767335),
      onErrorContainer: Color(4294967295),
      surface: Color(4294376436),
      onSurface: Color(4279046671),
      onSurfaceVariant: Color(4281350194),
      outline: Color(4283192654),
      outlineVariant: Color(4284968808),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086509),
      inversePrimary: Color(4287878571),
      primaryFixed: Color(4281956693),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280180798),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284314211),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282735179),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283069312),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281424487),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4291020993),
      surfaceBright: Color(4294376436),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981678),
      surfaceContainer: Color(4293192419),
      surfaceContainerHigh: Color(4292468439),
      surfaceContainerHighest: Color(4291744716),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278203421),
      surfaceTint: Color(4280904263),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4279063603),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280102948),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281945664),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278202684),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280569691),
      onTertiaryContainer: Color(4294967295),
      error: Color(4284481540),
      onError: Color(4294967295),
      errorContainer: Color(4288151562),
      onErrorContainer: Color(4294967295),
      surface: Color(4294376436),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4278190080),
      outline: Color(4280692264),
      outlineVariant: Color(4282600261),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086509),
      inversePrimary: Color(4287878571),
      primaryFixed: Color(4279063603),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278205217),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281945664),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280497962),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280569691),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278663235),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4290099892),
      surfaceBright: Color(4294376436),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293784299),
      surfaceContainer: Color(4292863197),
      surfaceContainerHigh: Color(4291942095),
      surfaceContainerHighest: Color(4291020993),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4287878571),
      surfaceTint: Color(4287878571),
      onPrimary: Color(4278204704),
      primaryContainer: Color(4278800689),
      onPrimaryContainer: Color(4289655493),
      secondary: Color(4290104506),
      onSecondary: Color(4280366376),
      secondaryContainer: Color(4281813822),
      onSecondaryContainer: Color(4291946710),
      tertiary: Color(4288925148),
      onTertiary: Color(4278400321),
      tertiaryContainer: Color(4280437848),
      onTertiaryContainer: Color(4290767352),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279178513),
      onSurface: Color(4292863197),
      onSurfaceVariant: Color(4290824640),
      outline: Color(4287271819),
      outlineVariant: Color(4282403138),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292863197),
      inversePrimary: Color(4280904263),
      primaryFixed: Color(4289655493),
      onPrimaryFixed: Color(4278198544),
      primaryFixedDim: Color(4287878571),
      onPrimaryFixedVariant: Color(4278800689),
      secondaryFixed: Color(4291946710),
      onSecondaryFixed: Color(4278984468),
      secondaryFixedDim: Color(4290104506),
      onSecondaryFixedVariant: Color(4281813822),
      tertiaryFixed: Color(4290767352),
      onTertiaryFixed: Color(4278198055),
      tertiaryFixedDim: Color(4288925148),
      onTertiaryFixedVariant: Color(4280437848),
      surfaceDim: Color(4279178513),
      surfaceBright: Color(4281678646),
      surfaceContainerLowest: Color(4278849292),
      surfaceContainerLow: Color(4279704857),
      surfaceContainer: Color(4279968029),
      surfaceContainerHigh: Color(4280691495),
      surfaceContainerHighest: Color(4281415218),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4289260479),
      surfaceTint: Color(4287878571),
      onPrimary: Color(4278201368),
      primaryContainer: Color(4284391031),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4291551952),
      onSecondary: Color(4279642654),
      secondaryContainer: Color(4286617222),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4290372594),
      onTertiary: Color(4278200884),
      tertiaryContainer: Color(4285437860),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294955724),
      onError: Color(4283695107),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279178513),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4292272086),
      outline: Color(4289442988),
      outlineVariant: Color(4287271563),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292863197),
      inversePrimary: Color(4278932274),
      primaryFixed: Color(4289655493),
      onPrimaryFixed: Color(4278195465),
      primaryFixedDim: Color(4287878571),
      onPrimaryFixedVariant: Color(4278206244),
      secondaryFixed: Color(4291946710),
      onSecondaryFixed: Color(4278392074),
      secondaryFixedDim: Color(4290104506),
      onSecondaryFixedVariant: Color(4280761134),
      tertiaryFixed: Color(4290767352),
      onTertiaryFixed: Color(4278195226),
      tertiaryFixedDim: Color(4288925148),
      onTertiaryFixedVariant: Color(4278991687),
      surfaceDim: Color(4279178513),
      surfaceBright: Color(4282402369),
      surfaceContainerLowest: Color(4278454278),
      surfaceContainerLow: Color(4279836443),
      surfaceContainer: Color(4280559909),
      surfaceContainerHigh: Color(4281218095),
      surfaceContainerHighest: Color(4281941818),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4290641875),
      surfaceTint: Color(4287878571),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4287615399),
      onPrimaryContainer: Color(4278193925),
      secondary: Color(4292802275),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4289841334),
      onSecondaryContainer: Color(4278193925),
      tertiary: Color(4292408831),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4288661976),
      onTertiaryContainer: Color(4278193426),
      error: Color(4294962409),
      onError: Color(4278190080),
      errorContainer: Color(4294946468),
      onErrorContainer: Color(4280418305),
      surface: Color(4279178513),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294967295),
      outline: Color(4293587689),
      outlineVariant: Color(4290561468),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292863197),
      inversePrimary: Color(4278932274),
      primaryFixed: Color(4289655493),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4287878571),
      onPrimaryFixedVariant: Color(4278195465),
      secondaryFixed: Color(4291946710),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290104506),
      onSecondaryFixedVariant: Color(4278392074),
      tertiaryFixed: Color(4290767352),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4288925148),
      onTertiaryFixedVariant: Color(4278195226),
      surfaceDim: Color(4279178513),
      surfaceBright: Color(4283191628),
      surfaceContainerLowest: Color(4278190080),
      surfaceContainerLow: Color(4279968029),
      surfaceContainer: Color(4281086509),
      surfaceContainerHigh: Color(4281810232),
      surfaceContainerHighest: Color(4282599491),
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


  List<ExtendedColor> get extendedColors => [
  ];
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
