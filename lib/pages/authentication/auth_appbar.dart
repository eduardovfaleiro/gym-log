import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_log/widgets/brightness_manager.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final brightnessManager = BrightnessManager.of(context);

    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            brightnessManager.updateBrightness(brightnessManager.brightness);
          },
          icon: const Icon(Icons.light_mode),
          selectedIcon: const Icon(Icons.dark_mode),
          isSelected: brightnessManager.brightness == Brightness.dark,
        ),
      ],
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Bem-vindo ao', style: Theme.of(context).textTheme.bodyMedium),
          SvgPicture.asset(
            'assets/gym_log_horizontal_logo.svg',
            height: 24,
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
