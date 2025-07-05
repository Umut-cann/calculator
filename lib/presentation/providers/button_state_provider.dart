import 'package:flutter_riverpod/flutter_riverpod.dart';

// Button press state class to identify each button uniquely
class ButtonPressState {
  final Map<String, bool> _pressedButtons = {};
  
  bool isPressed(String buttonId) => _pressedButtons[buttonId] ?? false;
  
  ButtonPressState setPressed(String buttonId, bool isPressed) {
    final newState = ButtonPressState();
    // Copy existing state
    newState._pressedButtons.addAll(_pressedButtons);
    // Update the specific button state
    newState._pressedButtons[buttonId] = isPressed;
    return newState;
  }
}

// Notifier to manage button press states
class ButtonStateNotifier extends Notifier<ButtonPressState> {
  @override
  ButtonPressState build() {
    return ButtonPressState();
  }
  
  void setPressed(String buttonId, bool isPressed) {
    state = state.setPressed(buttonId, isPressed);
  }
}

// Global provider for button press states
final buttonStateProvider = NotifierProvider<ButtonStateNotifier, ButtonPressState>(
  () => ButtonStateNotifier(),
);
