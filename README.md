# Scientific Calculator App

A modern scientific calculator application built with Flutter that follows the MVP (Model-View-Presenter) architecture and uses Riverpod for state management.

## Features

- **Operator Precedence**: Follows BODMAS/PEMDAS rules for calculations
- **Scientific Functions**: Includes sin, cos, tan, ln, log, square root, π, e, and factorial
- **Parentheses Support**: For complex calculations
- **History Tracking**: Saves calculation history using Hive
- **Modern UI**: Clean design with a green and white color scheme
- **Animations**: Smooth transitions and effects
- **Responsive Design**: Works in both portrait and landscape orientations
- **Haptic Feedback**: For better user experience

## Architecture

This app follows the MVP (Model-View-Presenter) architecture:
- **Model**: Handles data and business logic
- **View**: UI components (screens, widgets)
- **Presenter**: Mediates between Model and View

## Technical Details

- **State Management**: Riverpod
- **Local Storage**: Hive for history tracking
- **Optimizations**: System fonts for better performance, const modifiers throughout

## Getting Started

To run this project locally:

```bash
flutter pub get
flutter run
```
