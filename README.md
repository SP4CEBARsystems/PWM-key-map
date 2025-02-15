# AutoHotkey Throttle and Steering Script

## Description
This AutoHotkey script provides a method to control movement using a PWM-like keypress system. The throttle value determines the duty cycle of the keypresses, and steering is handled based on mouse position. This script allows for dynamic movement control with adjustable speed and steering intensity.

## Controls
- **Scroll Up**: Increase throttle (max 1.0)
- **Scroll Down**: Decrease throttle (min 0.0)
- **W Key**: Move forward with PWM controlled by throttle
- **S Key**: Move backward with PWM controlled by throttle
- **Middle Mouse Button (MButton)**: Activate steering based on mouse position
  - If the mouse is on the left side of the screen, "A" is pressed with an intensity based on distance from center.
  - If the mouse is on the right side of the screen, "D" is pressed with an intensity based on distance from center.

## How It Works
1. The `throttle` variable is adjusted by scrolling the mouse wheel.
2. Pressing `w` or `s` triggers the `alternate` function, which sends repeated key up/down events based on the throttle value.
3. Pressing the middle mouse button triggers the `steering` function, which determines the required steering based on the mouse's X position relative to the screen center.

This script ensures smooth movement control with dynamic adjustments to speed and steering.