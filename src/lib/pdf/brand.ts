/**
 * BlocIQ Brand Style Guide
 * Official brand colours, typography, and assets
 */

export const BlocIQBrand = {
  colours: {
    primary: "#1A2E6C",     // BlocIQ Navy
    secondary: "#00B6F0",   // BlocIQ Blue
    background: "#F5F6F7",  // Light Grey
    text: "#222222",
    tableAlt: "#E8EAED",
    success: "#10B981",     // Green
    warning: "#F59E0B",     // Amber
    danger: "#EF4444",      // Red
    white: "#FFFFFF"
  },
  font: {
    family: "Inter",
    headerWeight: "700",
    bodyWeight: "400",
    mediumWeight: "500"
  },
  logo: "/assets/brand/blociq_logo.png",
  spacing: {
    pageMargin: 50,
    sectionGap: 20,
    tableRowHeight: 25,
    headerHeight: 40
  },
  fontSize: {
    title: 28,
    heading1: 22,
    heading2: 18,
    heading3: 14,
    body: 10,
    small: 8
  }
};

export const StatusColors = {
  compliant: BlocIQBrand.colours.success,
  due_soon: BlocIQBrand.colours.warning,
  overdue: BlocIQBrand.colours.danger,
  unknown: BlocIQBrand.colours.text,
  active: BlocIQBrand.colours.success
};

export const StatusIcons = {
  compliant: "✓",
  due_soon: "⚠",
  overdue: "✗",
  unknown: "?",
  active: "✓"
};
