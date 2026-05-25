import 'package:flutter/material.dart';

abstract final class AppDimensions {
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;

  static const double productImageSize = 64;
  static const double cartImageSize = 56;
  static const double emptyStateIconSize = 64;
  static const double emptySearchIconSize = 56;
  static const double badgeMinSize = 18;
  static const double quantityButtonSize = 40;
  static const double quantityLabelWidth = 32;
  static const double badgeBorderRadius = 9;

  static const EdgeInsets listPadding = EdgeInsets.fromLTRB(
    spacing16,
    spacing8,
    spacing16,
    spacing16,
  );

  static const EdgeInsets searchFieldPadding = EdgeInsets.fromLTRB(
    spacing16,
    spacing8,
    spacing16,
    spacing12,
  );

  static const EdgeInsets chipsPadding = EdgeInsets.symmetric(
    horizontal: spacing16,
  );

  static const EdgeInsets cardContentPadding = EdgeInsets.all(spacing16);

  static const EdgeInsets summaryPadding = EdgeInsets.all(spacing16);

  static const EdgeInsets emptyStatePadding = EdgeInsets.all(spacing24);

  static const EdgeInsets badgeHorizontalPadding = EdgeInsets.symmetric(
    horizontal: spacing4,
  );

  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(8),
  );
}
