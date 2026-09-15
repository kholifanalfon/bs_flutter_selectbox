import 'package:material_ui/material_ui.dart';

/// This file is copied from bs_flutter_utils package of the same author as bs_flutter_selectbox package

/// To create screen category or to identified device size base on screen width
/// And to define required properties in breakpoints
///
/// Bootstrap v5.0 provides custom breakpoints
/// but for now it is still not possible to customize breakpoints in this package
///
/// More information about Bootstrap Breakpoint visit:
/// https://getbootstrap.com/docs/5.0/layout/breakpoints/
class BreakPoint {
  static const double _widthXxl = 1400.0;
  static const double _widthXl = 1200.0;
  static const double _widthLg = 992.0;
  static const double _widthMd = 768.0;
  static const double _widthSm = 576.0;

  static const double _containerXxl = 1320.0;
  static const double _containerXl = 1140.0;
  static const double _containerLg = 960.0;
  static const double _containerMd = 720.0;
  static const double _containerSm = 576.0;

  static const String stateXxl = 'xxl';
  static const String stateXl = 'xl';
  static const String stateLg = 'lg';
  static const String stateMd = 'md';
  static const String stateSm = 'sm';
  static const String stateXs = 'xs';

  BreakPoint({
    this.breakpoint,
    this.screenWidth,
    this.containerWidth,
    this.state,
  });

  /// Use them to control when your layout can be adapted at a particular device size.
  final double? breakpoint;

  /// Current screen width from [MediaQuery]
  final double? screenWidth;

  /// Maximum width of [BsContainer] widget based on [breakpoint]
  final double? containerWidth;

  /// String [state] for easy identification [screenWidth] category based on [breakpoint]
  final String? state;

  /// Use this to identification current [state] and get all the properties present
  /// on the [breakpoint]
  factory BreakPoint.of(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= _widthXxl) {
      return BreakPoint(
        breakpoint: _widthXxl,
        containerWidth: _containerXxl,
        screenWidth: screenWidth,
        state: stateXxl,
      );
    } else if (screenWidth >= _widthXl) {
      return BreakPoint(
        breakpoint: _widthXl,
        containerWidth: _containerXl,
        screenWidth: screenWidth,
        state: stateXl,
      );
    } else if (screenWidth >= _widthLg) {
      return BreakPoint(
        breakpoint: _widthLg,
        containerWidth: _containerLg,
        screenWidth: screenWidth,
        state: stateLg,
      );
    } else if (screenWidth >= _widthMd) {
      return BreakPoint(
        breakpoint: _widthMd,
        containerWidth: _containerMd,
        screenWidth: screenWidth,
        state: stateMd,
      );
    } else if (screenWidth >= _widthSm) {
      return BreakPoint(
        breakpoint: _widthSm,
        containerWidth: _containerSm,
        screenWidth: screenWidth,
        state: stateSm,
      );
    }

    return BreakPoint(
      breakpoint: 0.0,
      containerWidth: screenWidth,
      screenWidth: screenWidth,
      state: stateXs,
    );
  }

  static bool isMobile(BuildContext context) {
    BreakPoint breakPoint = BreakPoint.of(context);
    return [BreakPoint.stateXs, BreakPoint.stateSm].contains(breakPoint.state);
  }

  static bool isTablet(BuildContext context) {
    BreakPoint breakPoint = BreakPoint.of(context);
    return [BreakPoint.stateMd, BreakPoint.stateLg].contains(breakPoint.state);
  }

  static bool isDesktop(BuildContext context) {
    BreakPoint breakPoint = BreakPoint.of(context);
    return [BreakPoint.stateXl, BreakPoint.stateXxl].contains(breakPoint.state);
  }

  static Widget? onMobile(BuildContext context, WidgetBuilder builder) =>
      BreakPoint.isMobile(context) ? builder(context) : Container();

  static Widget onTablet(BuildContext context, WidgetBuilder builder) =>
      BreakPoint.isTablet(context) ? builder(context) : Container();

  static Widget onDesktop(BuildContext context, WidgetBuilder builder) =>
      BreakPoint.isDesktop(context) ? builder(context) : Container();

  static Widget on(
    BuildContext context, {
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (BreakPoint.isMobile(context)) {
      if (mobile != null)
        return mobile;
      else if (tablet != null)
        return tablet;
      else if (desktop != null)
        return desktop;
      else
        return Container();
    } else if (BreakPoint.isTablet(context)) {
      if (tablet != null)
        return tablet;
      else if (desktop != null)
        return desktop;
      else
        return Container();
    } else if (BreakPoint.isDesktop(context)) {
      if (desktop != null)
        return desktop;
      else
        return Container();
    } else
      return Container();
  }
}

/// If you need to hide some widget in some breakpoint use [BsVisibility]
/// This helpful to create responsive layout
class BsVisibility {
  const BsVisibility({required this.breakPoints});

  final List<String> breakPoints;

  /// Will hide in all screen device
  static const BsVisibility none = BsVisibility(breakPoints: []);

  /// Will show in all breakpoint
  static const BsVisibility block = BsVisibility(
    breakPoints: [
      BreakPoint.stateXs,
      BreakPoint.stateSm,
      BreakPoint.stateMd,
      BreakPoint.stateLg,
      BreakPoint.stateXl,
      BreakPoint.stateXxl,
    ],
  );

  /// Will hide in [BreakPoint.stateSm] breakpoint
  static const BsVisibility hiddenSm = BsVisibility(
    breakPoints: [
      BreakPoint.stateMd,
      BreakPoint.stateLg,
      BreakPoint.stateXl,
      BreakPoint.stateXxl,
    ],
  );

  /// Will hide in ([BreakPoint.stateSm], [BreakPoint.hiddenMd]) breakpoint
  static const BsVisibility hiddenMd = BsVisibility(
    breakPoints: [BreakPoint.stateLg, BreakPoint.stateXl, BreakPoint.stateXxl],
  );

  /// Will hide in ([BreakPoint.stateSm], [BreakPoint.hiddenMd], [BreakPoint.hiddenMd]) breakpoint
  static const BsVisibility hiddenLg = BsVisibility(
    breakPoints: [BreakPoint.stateXl, BreakPoint.stateXxl],
  );

  /// Will hide in ([BreakPoint.stateSm], [BreakPoint.hiddenMd], [BreakPoint.hiddenMd], [BreakPoint.stateXl) breakpoint
  static const BsVisibility hiddenXl = BsVisibility(
    breakPoints: [BreakPoint.stateXxl],
  );

  /// Will only show on [BreakPoint.stateXxl] screen device
  static const BsVisibility hiddenXxl = BsVisibility(breakPoints: []);
}

/// Defines color
class BsColor {
  static const Color color = Color(0xff212529);

  static const Color borderColor = Color(0xffdee2e6);

  static const Color primary = Color(0xff0d6efd);
  static const Color secondary = Colors.grey;
  static const Color danger = Color(0xffdc3545);
  static const Color success = Color(0xff198754);
  static const Color warning = Color(0xffffc107);
  static const Color info = Color(0xff0dcaf0);
  static const Color light = Color(0xfff8f9fa);
  static const Color dark = Color(0xff212529);

  static const Color primaryShadow = Color(0xffc2dbfe);
  static const Color dangerShadow = Color(0xfff0a9b0);

  static const Color textError = Color(0xffdc3545);
}

class BsShadow {
  static const BoxShadow small = BoxShadow(
    color: Color(0xffd9d9d9),
    spreadRadius: 2.0,
    blurRadius: 4.0,
  );

  static const BoxShadow regular = BoxShadow(
    color: Color(0xffd9d9d9),
    spreadRadius: 8.0,
    blurRadius: 16.0,
  );

  static const BoxShadow large = BoxShadow(
    color: Color(0xffd9d9d9),
    spreadRadius: 16.0,
    blurRadius: 48.0,
  );
}
