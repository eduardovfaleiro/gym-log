import 'dart:developer';

import 'package:flutter/material.dart';

mixin LoadingManager {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  bool get isLoading => isLoadingNotifier.value;

  void setLoading(bool enabled) {
    isLoadingNotifier.value = enabled;
    log('LoadingManager.setLoading($enabled)');
  }
}

class LoadingPresenter extends StatelessWidget {
  final Widget child;
  final bool showLoadingAnimation;
  final ValueNotifier<bool> isLoadingNotifier;

  const LoadingPresenter({
    super.key,
    required this.child,
    required this.isLoadingNotifier,
    this.showLoadingAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showLoadingAnimation) {
      return ValueListenableBuilder(
        valueListenable: isLoadingNotifier,
        builder: (context, isLoading, _) {
          return PopScope(
            canPop: !isLoading,
            child: IgnorePointer(ignoring: isLoading, child: child),
          );
        },
      );
    }

    return ValueListenableBuilder(
      valueListenable: isLoadingNotifier,
      builder: (context, isLoading, _) {
        return PopScope(
          canPop: !isLoading,
          child: isLoading
              ? Stack(
                  children: [
                    child,
                    Container(
                      color: const Color.fromARGB(118, 0, 0, 0),
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  ],
                )
              : child,
        );
      },
    );
  }
}
