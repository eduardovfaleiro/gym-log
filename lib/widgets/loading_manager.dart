// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';

// mixin LoadingManager {
//   final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
//   bool get isLoading => isLoadingNotifier.value;

//   void setLoading(bool enabled) {
//     isLoadingNotifier.value = enabled;
//     log('LoadingManager.setLoading($enabled)');
//   }
// }

// class LoadingPresenter extends StatefulWidget {
//   final Widget child;
//   final bool showLoadingAnimation;
//   final ValueNotifier<bool> isLoadingNotifier;

//   const LoadingPresenter({
//     super.key,
//     required this.child,
//     required this.isLoadingNotifier,
//     this.showLoadingAnimation = true,
//   });

//   @override
//   State<LoadingPresenter> createState() => _LoadingPresenterState();
// }

// class _LoadingPresenterState extends State<LoadingPresenter> {
//   @override
//   Widget build(BuildContext context) {
//     if (!widget.showLoadingAnimation) {
//       return ValueListenableBuilder(
//         valueListenable: widget.isLoadingNotifier,
//         builder: (context, isLoading, _) {
//           return PopScope(
//             canPop: !isLoading,
//             child: IgnorePointer(ignoring: isLoading, child: widget.child),
//           );
//         },
//       );
//     }

//     return ValueListenableBuilder(
//       valueListenable: widget.isLoadingNotifier,
//       builder: (context, isLoading, _) {
//         return PopScope(
//           canPop: !isLoading,
//           child: isLoading
//               ? Stack(
//                   children: [
//                     widget.child,
//                     Container(
//                       color: const Color.fromARGB(118, 0, 0, 0),
//                       height: double.infinity,
//                       width: double.infinity,
//                       alignment: Alignment.center,
//                       child: const CircularProgressIndicator(),
//                     ),
//                   ],
//                 )
//               : widget.child,
//         );
//       },
//     );
//   }
// }

import 'dart:async';
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

class LoadingPresenter extends StatefulWidget {
  final Widget child;
  // final bool showLoadingAnimation;
  final ValueNotifier<bool> isLoadingNotifier;

  const LoadingPresenter({
    super.key,
    required this.child,
    required this.isLoadingNotifier,
    // this.showLoadingAnimation = true,
  });

  @override
  State<LoadingPresenter> createState() => _LoadingPresenterState();
}

class _LoadingPresenterState extends State<LoadingPresenter> {
  @override
  Widget build(BuildContext context) {
    // if (!widget.showLoadingAnimation) {
    //   return ValueListenableBuilder(
    //     valueListenable: widget.isLoadingNotifier,
    //     builder: (context, isLoading, _) {
    //       return PopScope(
    //         canPop: !isLoading,
    //         child: IgnorePointer(ignoring: isLoading, child: widget.child),
    //       );
    //     },
    //   );
    // }

    return ValueListenableBuilder(
      valueListenable: widget.isLoadingNotifier,
      builder: (context, isLoading, _) {
        return PopScope(
          canPop: !isLoading,
          child: Stack(
            children: [
              IgnorePointer(ignoring: isLoading, child: widget.child),
              if (isLoading)
                FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 2)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      color: const Color.fromARGB(118, 0, 0, 0),
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
