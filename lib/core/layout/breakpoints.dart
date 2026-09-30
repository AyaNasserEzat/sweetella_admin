enum AppBreakpoint { compact, medium, expanded }

abstract final class AppBreakpoints {
  static const double compactMax = 599;
  static const double mediumMax = 839;

  static AppBreakpoint fromWidth(double width) {
    if (width < compactMax) {
      return AppBreakpoint.compact;
    }

    if (width < mediumMax) {
      return AppBreakpoint.medium;
    }

    return AppBreakpoint.expanded;
  }
}
