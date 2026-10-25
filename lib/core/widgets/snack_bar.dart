import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

enum SnachBarState { error, success }

Color? getState(SnachBarState state, BuildContext context) {
  switch (state) {
    case SnachBarState.error:
      return context.tokens.color.dangerSoft;
    case SnachBarState.success:
      return context.tokens.color.successSoft;
  }
}

Color getBorderColor(SnachBarState state, BuildContext context) {
  switch (state) {
    case SnachBarState.error:
      return context.tokens.color.danger;
    case SnachBarState.success:
      return context.tokens.color.success;
  }
}

IconData getIcon(SnachBarState state) {
  switch (state) {
    case SnachBarState.error:
      return Icons.close;
    case SnachBarState.success:
      return Icons.check;
  }
}

void showsnakbar(BuildContext context, String message, SnachBarState state) {
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _TopSnackBarWidget(
      message: message,
      state: state,
      onClose: () => overlayEntry.remove(),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
}

class _TopSnackBarWidget extends StatefulWidget {
  const _TopSnackBarWidget({
    required this.message,
    required this.state,
    required this.onClose,
  });

  final String message;
  final SnachBarState state;
  final VoidCallback onClose;

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(controller);

    controller.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await controller.reverse();
        widget.onClose();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final isSmallScreen = screenWidth < 600;

    final snackBarWidth = isSmallScreen ? screenWidth - 24 : 420.0;

    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: snackBarWidth,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: getState(widget.state, context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getBorderColor(widget.state, context),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: getBorderColor(widget.state, context),
                        child: Icon(
                          getIcon(widget.state),
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: getBorderColor(widget.state, context),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Icon(
                          Icons.close,
                          color: getBorderColor(widget.state, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
