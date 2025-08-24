import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppleTransitions {
  // Apple-style page transition
  static Widget slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: AppTheme.easeInOutQuint)),
      ),
      child: child,
    );
  }

  // Apple-style fade transition
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: AppTheme.easeOut)),
      child: child,
    );
  }

  // Apple-style scale transition for dialogs
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(
        Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: AppTheme.easeInOutQuint)),
      ),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  // Apple-style slide up transition for bottom sheets
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: AppTheme.easeInOutQuint)),
      ),
      child: child,
    );
  }

  // Apple-style scale and fade transition for modals
  static Widget modalTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Transform.scale(
      scale: animation
          .drive(
            Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).chain(CurveTween(curve: AppTheme.easeInOutQuint)),
          )
          .value,
      child: FadeTransition(
        opacity: animation.drive(CurveTween(curve: AppTheme.easeOut)),
        child: child,
      ),
    );
  }
}

// Apple-style animated button with scale and opacity
class AppleAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double scaleDown;

  const AppleAnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 100),
    this.scaleDown = 0.95,
  });

  @override
  State<AppleAnimatedButton> createState() => _AppleAnimatedButtonState();
}

class _AppleAnimatedButtonState extends State<AppleAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

// Apple-style animated container for state changes
class AppleAnimatedContainer extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Duration duration;
  final Curve curve;

  const AppleAnimatedContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AppleAnimatedContainer> createState() => _AppleAnimatedContainerState();
}

class _AppleAnimatedContainerState extends State<AppleAnimatedContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        border: widget.border,
      ),
      child: widget.child,
    );
  }
}
