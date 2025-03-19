# moveo-analytics-swift

<div align="center" style="text-align: center">
  <img src="https://github.com/user-attachments/assets/ae163684-fcff-4fa8-b793-63849834c735" height="150"/>
</div>

## Table of Contents
- [Introduction](#introduction)
- [Quick Start Guide](#quick-start-guide)
  - [Initialize](#1-initialize)
  - [Setup](#2-setup)
  - [Track Events](#3-track-events)
  - [Advanced Usage](#4-advanced-usage)

## Introduction
Welcome to the official Moveo One SwiftUI library. Moveo One analytics is a user cognitive-behavioral analytics tool that seamlessly integrates with your SwiftUI views.

## Quick Start Guide

### 1. Initialize
Initialize MoveoOne in your AppDelegate or early in your app's lifecycle:

```swift
import MoveoOneLibrary

// In your AppDelegate or app initialization
MoveoOne.instance.initialize(token: "YOUR_TOKEN")
MoveoOne.instance.identify(userId: "USER_ID")
```

### 2. Setup
Configure optional settings:

```swift
// Enable logging for development
MoveoOne.instance.setLogging(enabled: true)

// Set custom flush interval (5-60 seconds)
MoveoOne.instance.setFlushInterval(interval: 20)
```

### 3. Track Events
The easiest way to track events is using the `.moveoEvent` view modifier. This modifier automatically tracks user interactions and view appearances.

#### Basic Usage
```swift
Text("Welcome")
    .moveoEvent(
        id: "welcome_title",
        parentId: "welcome_screen",
        type: .text,
        value: .constant("Welcome")
    )
```

#### With Dynamic Values
```swift
TextField("Enter name", text: $username)
    .moveoEvent(
        id: "name_input",
        parentId: "registration_screen",
        type: .textInput,
        value: $username  // Tracks changes to username
    )
```

#### With Metadata
```swift
Button("Submit") {
    handleSubmit()
}
.moveoEvent(
    id: "submit_button",
    parentId: "form_screen",
    type: .button,
    metadata: ["form_type": "registration"],
    value: .constant("Submit")
)
```

#### Common Use Cases

1. **Text Elements**:
```swift
Text("Welcome Message")
    .moveoEvent(
        id: "welcome_message",
        parentId: "home_screen",
        type: .text,
        value: .constant("Welcome Message")
    )
```

2. **Buttons**:
```swift
Button("Continue") {
    // action
}
.moveoEvent(
    id: "continue_button",
    parentId: "onboarding_screen",
    type: .button
)
```

3. **Input Fields**:
```swift
TextField("Email", text: $email)
    .moveoEvent(
        id: "email_input",
        parentId: "signup_form",
        type: .textInput,
        value: $email
    )
```

4. **Custom Components**:
```swift
CustomView()
    .moveoEvent(
        id: "custom_component",
        parentId: "screen_name",
        type: .custom,
        metadata: ["component_type": "special"],
        value: .constant("custom_value")
    )
```

### 4. Advanced Usage

#### Starting a Context
Before tracking events, start a context for your session:

```swift
// At the beginning of your flow/screen
MoveoOne.instance.start(
    context: "onboarding_flow",
    metadata: [
        "version": "2.0",
        "ab_test": "variant_a"
    ]
)
```

#### Updating Session Metadata
```swift
MoveoOne.instance.updateSessionMetadata([
    "step": "completed",
    "duration": "120s"
])
```

#### Best Practices
- Use consistent naming conventions for `id` and `parentId`
- Group related elements under the same `parentId`
- Include relevant metadata for better analytics
- Use semantic types that match the UI element's purpose
- Keep value bindings relevant to the element being tracked

The `.moveoEvent` modifier automatically handles:
- Event timing
- Value changes
- View appearances
- User interactions
- Data buffering and sending

Remember to start a context before tracking events and ensure your token and user ID are properly initialized.
