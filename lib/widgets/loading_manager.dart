import 'package:flutter/material.dart';

class LoadingManager extends StatefulWidget {
  final Widget child;
  final bool showLoadingAnimation;

  static final ValueNotifier<bool> isLoading = ValueNotifier(false);

  static void set(bool enabled) {
    isLoading.value = enabled;
  }

  static void run(Function() callback) async {
    isLoading.value = true;
    await callback();
    isLoading.value = false;
  }

  const LoadingManager({super.key, required this.child, this.showLoadingAnimation = false});

  @override
  State<LoadingManager> createState() => _LoadingManagerState();
}

class _LoadingManagerState extends State<LoadingManager> {
  @override
  Widget build(BuildContext context) {
    if (!widget.showLoadingAnimation) {
      return ValueListenableBuilder(
        valueListenable: LoadingManager.isLoading,
        builder: (context, isLoading, _) {
          return PopScope(
            canPop: !isLoading,
            child: IgnorePointer(ignoring: isLoading, child: widget.child),
          );
        },
      );
    }

    return ValueListenableBuilder(
      valueListenable: LoadingManager.isLoading,
      builder: (context, isLoading, _) {
        return PopScope(
          canPop: !isLoading,
          child: isLoading
              ? Stack(
                  children: [
                    widget.child,
                    Container(
                      color: const Color.fromARGB(118, 0, 0, 0),
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  ],
                )
              : widget.child,
        );
      },
    );
  }
}
