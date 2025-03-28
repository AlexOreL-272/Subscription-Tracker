import 'package:flutter/material.dart';

class SlideableWidget extends StatefulWidget {
  final Widget child;

  final VoidCallback? onLeftActionPressed;
  final Icon? leftIcon;

  final VoidCallback? onRightActionPressed;
  final Icon? rightIcon;

  const SlideableWidget({
    required this.child,
    this.onLeftActionPressed,
    this.leftIcon,
    this.onRightActionPressed,
    this.rightIcon,
    super.key,
  });

  @override
  State<SlideableWidget> createState() => _SlideableWidgetState();
}

class _SlideableWidgetState extends State<SlideableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  static const double _buttonVisibleThreshold = 0.12;
  static const double _minimalSwipeThreshold = 0.07;
  static const double _actionTriggerThreshold = 0.7;
  static const double _buttonJumpThreshold = 0.7;

  static const double _iconSize = 28.0;

  bool _buttonNeedJump = false;
  bool _wasSwipedPastThreshold = false;

  int _swipeDirection = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final width = context.size!.width;
    final delta = details.primaryDelta! / width;

    if (_animationController.value == 0 && delta != 0) {
      _swipeDirection =
          delta > 0 ? -1 : 1; // -1 for left-to-right, 1 for right-to-left
    }

    if (widget.rightIcon != null &&
        _swipeDirection > 0 &&
        delta < 0 &&
        _animationController.value <= _buttonJumpThreshold) {
      setState(() {
        _animationController.value = (_animationController.value - delta).clamp(
          0.0,
          1.0,
        );

        if (_animationController.value >= _buttonJumpThreshold &&
            !_buttonNeedJump) {
          _buttonNeedJump = true;
        } else if (_animationController.value < _buttonJumpThreshold &&
            _buttonNeedJump) {
          _buttonNeedJump = false;
        }

        if (_animationController.value >= _actionTriggerThreshold) {
          _wasSwipedPastThreshold = true;
        }
      });
    } else if (widget.leftIcon != null &&
        _swipeDirection < 0 &&
        delta > 0 &&
        _animationController.value <= _buttonJumpThreshold) {
      setState(() {
        _animationController.value = (_animationController.value + delta).clamp(
          0.0,
          1.0,
        );

        if (_animationController.value >= _buttonJumpThreshold &&
            !_buttonNeedJump) {
          _buttonNeedJump = true;
        } else if (_animationController.value < _buttonJumpThreshold &&
            _buttonNeedJump) {
          _buttonNeedJump = false;
        }

        if (_animationController.value >= _actionTriggerThreshold) {
          _wasSwipedPastThreshold = true;
        }
      });
    } else if (_animationController.value > 0) {
      if ((_swipeDirection > 0 && delta > 0) ||
          (_swipeDirection < 0 && delta < 0)) {
        setState(() {
          if (_swipeDirection > 0) {
            _animationController.value = (_animationController.value - delta)
                .clamp(0.0, 1.0);
          } else {
            _animationController.value = (_animationController.value + delta)
                .clamp(0.0, 1.0);
          }

          // Update button position as we swipe back
          if (_animationController.value < _buttonJumpThreshold &&
              _buttonNeedJump) {
            _buttonNeedJump = false;
          }
        });
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_wasSwipedPastThreshold &&
        _animationController.value >= _actionTriggerThreshold) {
      if (_swipeDirection > 0) {
        widget.onRightActionPressed?.call();
      } else {
        widget.onLeftActionPressed?.call();
      }

      _animationController.animateTo(0.0);
      setState(() {
        _buttonNeedJump = false;
        _wasSwipedPastThreshold = false;
        _swipeDirection = 0;
      });
    } else if (_animationController.value >= _buttonVisibleThreshold) {
      // If we swiped partially, animate to the button visible position
      _animationController.animateTo(_buttonVisibleThreshold);
      setState(() {
        _buttonNeedJump = false;
      });
    } else if (_animationController.value >= _minimalSwipeThreshold) {
      // If we swiped just a little bit past the minimal threshold,
      // still animate to the button visible position
      _animationController.animateTo(_buttonVisibleThreshold);
      setState(() {
        _buttonNeedJump = false;
      });
    } else {
      // Otherwise animate back to the start
      _animationController.animateTo(0.0);
      setState(() {
        _buttonNeedJump = false;
        _swipeDirection = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: Stack(
            children: [
              // Right action button (appears when swiping right-to-left)
              if (widget.rightIcon != null && _swipeDirection >= 0) ...{
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(
                        right:
                            _buttonNeedJump
                                ? _buttonJumpThreshold * constraints.maxWidth -
                                    _iconSize
                                : 0,
                      ),

                      child: IconButton(
                        onPressed: () {
                          widget.onRightActionPressed?.call();
                          _animationController.animateTo(0.0);
                          _buttonNeedJump = false;
                          _wasSwipedPastThreshold = false;
                          _swipeDirection = 0;
                        },

                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        iconSize: _iconSize,
                        icon: widget.rightIcon!,
                      ),
                    ),
                  ),
                ),
              },

              // Left action button (appears when swiping left-to-right)
              if (widget.leftIcon != null && _swipeDirection <= 0) ...{
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(
                        left:
                            _buttonNeedJump
                                ? _buttonJumpThreshold * constraints.maxWidth -
                                    _iconSize
                                : 0,
                      ),

                      child: IconButton(
                        onPressed: () {
                          widget.onLeftActionPressed?.call();
                          _animationController.animateTo(0.0);
                          _buttonNeedJump = false;
                          _wasSwipedPastThreshold = false;
                          _swipeDirection = 0;
                        },

                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        iconSize: _iconSize,

                        icon: widget.leftIcon!,
                      ),
                    ),
                  ),
                ),
              },

              // The main container content that slides
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _swipeDirection *
                          -1 *
                          _animationController.value *
                          MediaQuery.of(context).size.width,
                      0,
                    ),
                    child: child,
                  );
                },
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}
