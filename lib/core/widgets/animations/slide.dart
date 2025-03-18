import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum SlideDirection { up, down, left, right, start, end }

class SlideWrapper extends StatefulWidget {
  final Widget child;
  final double? initialOffset;
  final SlideDirection slideDirection;
  final Duration? duration;
  final Duration? startAnimationDelay;
  final Curve? curve;

  const SlideWrapper({
    super.key,
    required this.child,
    this.initialOffset = 20.0,
    this.curve,
    this.slideDirection = SlideDirection.end,
    this.duration = const Duration(milliseconds: 500),
    this.startAnimationDelay = Duration.zero,
  });

  @override
  _SlideWrapperState createState() => _SlideWrapperState();
}

class _SlideWrapperState extends State<SlideWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
    _initializeAnimation();
    _startAnimationWithDelay();
  }

  void _initializeAnimationController() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  void _initializeAnimation() {
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeInOut,
    ));
  }

  void _startAnimationWithDelay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(widget.startAnimationDelay ?? Duration.zero, () {
        if (mounted) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offset = widget.initialOffset ?? 20.0;
    double dx = 0.0, dy = 0.0;

    switch (widget.slideDirection) {
      case SlideDirection.up:
        dy = offset;
        break;
      case SlideDirection.down:
        dy = -offset;
        break;
      case SlideDirection.left:
        dx = offset;
        break;
      case SlideDirection.right:
        dx = -offset;
        break;
      case SlideDirection.start:
        dx = (EasyLocalization.of(context)?.currentLocale?.countryCode ??
                    "en") ==
                'ar'
            ? offset
            : -offset;
        break;
      case SlideDirection.end:
        dx = (EasyLocalization.of(context)?.currentLocale?.countryCode ??
                    "en") ==
                'ar'
            ? -offset
            : offset;
        break;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(dx * _animation.value, dy * _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
