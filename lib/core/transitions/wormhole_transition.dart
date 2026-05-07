import 'package:flutter/material.dart';
import '../theme/galactic_colors.dart';

class WormholeTransition extends PageRouteBuilder<dynamic> {
  WormholeTransition({required this.enterPage, required this.exitPage})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => enterPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                // Fade out exit page
                FadeTransition(
                  opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 0.5),
                    ),
                  ),
                  child: exitPage,
                ),

                // Wormhole effect
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      final wormholeSize = Tween<double>(
                        begin: 0.0,
                        end: MediaQuery.of(context).size.width *
                            3, // Logic tweak for larger scaling
                      )
                          .animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.3, 0.8),
                            ),
                          )
                          .value;

                      if (wormholeSize == 0) return const SizedBox.shrink();

                      return Center(
                        child: Container(
                          width: wormholeSize,
                          height: wormholeSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                GalacticColors.etherealCyan.withValues(
                                  alpha: 1.0 - animation.value,
                                ),
                                GalacticColors.wormholeBlue.withValues(
                                  alpha: 0.5 - animation.value * 0.5,
                                ),
                                Colors.transparent,
                              ],
                              stops: const [0.2, 0.6, 1.0],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Fade in enter page
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.5, 1.0),
                    ),
                  ),
                  child: child,
                ),
              ],
            );
          },
          transitionDuration: const Duration(
            milliseconds: 1500,
          ), // Longer for dramatic effect
        );
  final Widget enterPage;
  final Widget exitPage;
}
