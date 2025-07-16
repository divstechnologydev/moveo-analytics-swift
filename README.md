# Moveo Analytics Swift Library

<img src="https://www.moveo.one/assets/og_white.png" alt="Moveo Analytics Logo" width="200" />

**Current version: 1.0.17**

A powerful analytics library for iOS applications that provides comprehensive user interaction tracking and behavioral analysis through the Moveo One platform.

## Table of Contents

1. [Introduction](#introduction)
2. [Quick Start Guide](#quick-start-guide)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
   - [Library Initialization](#library-initialization)
   - [Setup](#setup)
   - [Metadata and Additional Metadata](#metadata-and-additional-metadata)
   - [Track Data](#track-data)
3. [Event Types and Actions](#event-types-and-actions)
4. [Comprehensive Example Usage](#comprehensive-example-usage)
5. [Obtain API Key](#obtain-api-key)
6. [Dashboard Access](#dashboard-access)
7. [Support](#support)

## Introduction

Moveo Analytics Swift Library is designed to capture and analyze user interactions within your iOS application. It provides detailed insights into user behavior, interaction patterns, and application usage through a comprehensive tracking system.

The library supports:
- **Context-based tracking** for organizing user sessions
- **Semantic grouping** for logical element organization
- **Flexible metadata** for enhanced analytics
- **Data processing** with configurable flush intervals
- **Multiple event types and actions** for comprehensive interaction capture

## Quick Start Guide

### Prerequisites

- iOS 15.0 or later
- Swift 5.7 or later
- Xcode 14.0 or later
- Moveo One API key (obtain from [Moveo One App](https://app.moveo.one/))

### Installation

Add the Moveo Analytics Swift Library to your project using Swift Package Manager:

1. In Xcode, go to **File** → **Add Package Dependencies**
2. Enter the package URL: `https://github.com/your-repo/moveo-analytics-swift`
3. Select the latest version and add to your target

### Library Initialization

Initialize the library in your `AppDelegate` or `@main` app struct:

```swift
import MoveoOneLibrary

// Initialize with your API token
MoveoOne.instance.initialize(token: "YOUR_API_KEY")
```

### Setup

Configure additional parameters as needed:

```swift
// Set flush interval (in seconds)
MoveoOne.instance.setFlushInterval(interval: 20000)

// Enable logging for debugging
MoveoOne.instance.setLogging(enabled: true)

// Identify user (optional)
MoveoOne.instance.identify(userId: "user_123")
```

### Metadata and Additional Metadata

The library supports two types of metadata management:

#### updateSessionMetadata()

Updates current session metadata. Session metadata should split sessions by information that influences content or creates visually different variations of the same application.

```swift
MoveoOne.instance.updateSessionMetadata([
    "locale": "eng",
    "app_version": "1.2.0",
    "user_type": "premium"
])
```

#### updateAdditionalMetadata()

Updates additional metadata for the session. This is used as data enrichment and enables specific queries or analysis by the defined split.

```swift
MoveoOne.instance.updateAdditionalMetadata([
    "user_country": "US",
    "company": "example_company",
    "experiment_group": "test_1"
])
```

**Metadata Support in Track and Tick Events:**

```swift
// Track with metadata
MoveoOne.instance.track(
    context: "checkout_screen",
    moveoOneData: MoveoOneData(
        semanticGroup: "user_interactions",
        id: "checkout_button",
        type: .button,
        action: .click,
        value: "proceed_to_payment",
        metadata: [
            "screen": "checkout",
            "button_type": "primary",
            "user_type": "premium",
            "cart_total": "99.99"
        ]
    )
)

// Tick with metadata
MoveoOne.instance.tick(
    moveoOneData: MoveoOneData(
        semanticGroup: "content_interactions",
        id: "product_card",
        type: .card,
        action: .appear,
        value: "product_view",
        metadata: [
            "product_id": "12345",
            "category": "electronics",
            "price_range": "100-200",
            "featured": "true"
        ]
    )
)
```

### Track Data

#### Understanding start() Calls and Context

**Single Session, Single Start**

You **do not need multiple start() calls for multiple contexts**. The `start()` method is called only **once at the beginning of a session** and must be called before any `track()` or `tick()` calls.

```swift
// Start session with context
MoveoOne.instance.start(
    context: "main_app_flow",
    metadata: [
        "ab": "test_1",
        "locale": "en",
        "app_version": "1.2"
    ]
)
```

#### When to Use Each Tracking Method

**Use track() when:**
- You want to explicitly specify the event context
- You need to change context between events
- You want to use different context than one specified in start method

```swift
MoveoOne.instance.track(
    context: "checkout_process",
    moveoOneData: MoveoOneData(
        semanticGroup: "user_interactions",
        id: "payment_button",
        type: .button,
        action: .click,
        value: "pay_now",
        metadata: [:]
    )
)
```

**Use tick() when:**
- You're tracking events within the same context
- You want tracking without explicitly defining context
- You want to track events in same context specified in start method

```swift
MoveoOne.instance.tick(
    moveoOneData: MoveoOneData(
        semanticGroup: "screen_0",
        id: "text_view_1",
        type: .text,
        action: .view,
        value: "welcome_message",
        metadata: [:]
    )
)
```

#### Context Definition

- **Context** represents large, independent parts of the application and serves to divide the app into functional units that can exist independently of each other
- Examples: `onboarding`, `main_app_flow`, `checkout_process`

#### Semantic Groups

- **Semantic groups** are logical units **within a context** that group related elements
- Depending on the application, this could be a group of elements or an entire screen (most common)
- Examples: `navigation`, `user_input`, `content_interaction`

## Event Types and Actions

### Available Event Types

| Type | Description |
|------|-------------|
| `button` | Interactive buttons |
| `text` | Text elements |
| `textEdit` | Text input fields |
| `image` | Single images |
| `images` | Multiple images |
| `image_scroll_horizontal` | Horizontal image scrolling |
| `image_scroll_vertical` | Vertical image scrolling |
| `picker` | Selection pickers |
| `slider` | Slider controls |
| `switchControl` | Toggle switches |
| `progressBar` | Progress indicators |
| `checkbox` | Checkbox controls |
| `radioButton` | Radio button controls |
| `table` | Table views |
| `collection` | Collection views |
| `segmentedControl` | Segmented controls |
| `stepper` | Stepper controls |
| `datePicker` | Date pickers |
| `timePicker` | Time pickers |
| `searchBar` | Search bars |
| `webView` | Web view components |
| `scrollView` | Scroll views |
| `activityIndicator` | Loading indicators |
| `video` | Video elements |
| `videoPlayer` | Video players |
| `audioPlayer` | Audio players |
| `map` | Map components |
| `tabBar` | Tab bar components |
| `tabBarPage` | Tab bar pages |
| `tabBarPageTitle` | Tab bar page titles |
| `tabBarPageSubtitle` | Tab bar page subtitles |
| `toolbar` | Toolbar components |
| `alert` | Alert dialogs |
| `alertTitle` | Alert titles |
| `alertSubtitle` | Alert subtitles |
| `modal` | Modal dialogs |
| `toast` | Toast notifications |
| `badge` | Badge elements |
| `dropdown` | Dropdown menus |
| `card` | Card components |
| `chip` | Chip elements |
| `grid` | Grid layouts |
| `custom` | Custom elements |

### Available Event Actions

| Action | Description |
|--------|-------------|
| `click` | Element clicked (normalized to `tap`) |
| `view` | Element viewed (normalized to `appear`) |
| `appear` | Element appeared |
| `disappear` | Element disappeared |
| `swipe` | Swipe gesture |
| `scroll` | Scroll action |
| `drag` | Drag action |
| `drop` | Drop action |
| `tap` | Tap gesture |
| `doubleTap` | Double tap gesture |
| `longPress` | Long press gesture |
| `pinch` | Pinch gesture |
| `zoom` | Zoom action |
| `rotate` | Rotate action |
| `submit` | Form submission |
| `select` | Selection action |
| `deselect` | Deselection action |
| `hover` | Hover action |
| `focus` | Focus action |
| `blur` | Blur action |
| `input` | Input action |
| `valueChange` | Value change |
| `dragStart` | Drag start |
| `dragEnd` | Drag end |
| `load` | Load action (normalized to `appear`) |
| `unload` | Unload action (normalized to `disappear`) |
| `refresh` | Refresh action |
| `play` | Play action |
| `pause` | Pause action |
| `stop` | Stop action |
| `seek` | Seek action |
| `error` | Error action |
| `success` | Success action |
| `cancel` | Cancel action |
| `retry` | Retry action |
| `share` | Share action |
| `open` | Open action (normalized to `appear`) |
| `close` | Close action (normalized to `disappear`) |
| `expand` | Expand action |
| `collapse` | Collapse action |
| `edit` | Edit action |
| `custom` | Custom action |

## Comprehensive Example Usage

Here's a complete example showing how to integrate Moveo Analytics in a SwiftUI app:

```swift
import MoveoOneLibrary
import SwiftUI

struct MainContentView: View {
    @State private var inputText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text("Moveo One")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.36))
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        .onAppear {
                            // Track screen appearance
                            MoveoOne.instance.tick(
                                moveoOneData: MoveoOneData(
                                    semanticGroup: "content_interactions",
                                    id: "main_title",
                                    type: .text,
                                    action: .appear,
                                    value: "app_title",
                                    metadata: [
                                        "screen": "main_screen",
                                        "element_type": "title"
                                    ]
                                )
                            )
                        }
                    
                    // Content Container
                    VStack {
                        Text("This is an example SwiftUI app made for demo purposes.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                            .onAppear {
                                trackParagraphImpression()
                            }
                        
                        // Buttons
                        VStack(spacing: 16) {
                            Button("Button One") {
                                handleButtonPress("Button One")
                            }
                            .onAppear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: "content_interactions",
                                        id: "main_button",
                                        type: .button,
                                        action: .appear,
                                        value: "Button One",
                                        metadata: [:]
                                    )
                                )
                            }
                            .onDisappear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: "content_interactions",
                                        id: "main_button",
                                        type: .button,
                                        action: .disappear,
                                        value: "Button One",
                                        metadata: [:]
                                    )
                                )
                            }
                            .buttonStyle(MoveoButtonStyle(primary: true))
                            
                            Button("Button Two") {
                                handleButtonPress("Button Two")
                            }
                            .buttonStyle(MoveoButtonStyle(primary: false))
                        }
                        .padding(.bottom, 20)
                        
                        // Text Field
                        TextField("Type something...", text: $inputText)
                            .textFieldStyle(MoveoTextFieldStyle())
                            .onSubmit(handleInputSubmit)
                    }
                    .padding(25)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color(red: 0.17, green: 0.42, blue: 0.69).opacity(0.1), radius: 10, y: 4)
                    .frame(width: geometry.size.width * 0.85)
                }
            }
            .background(Color(red: 0.94, green: 0.97, blue: 0.98))
        }
    }
    
    private func trackParagraphImpression() {
        MoveoOne.instance.tick(
            moveoOneData: MoveoOneData(
                semanticGroup: "content_interactions",
                id: "intro_paragraph",
                type: .text,
                action: .view,
                value: "demo_description",
                metadata: [
                    "screen": "main_screen",
                    "interaction_type": "impression",
                    "app_version": "1.0",
                    "platform": "iOS"
                ]
            )
        )
    }
    
    private func handleButtonPress(_ buttonName: String) {
        MoveoOne.instance.track(
            context: "main_screen",
            moveoOneData: MoveoOneData(
                semanticGroup: "user_interactions",
                id: "main_button",
                type: .button,
                action: .click,
                value: "primary_action",
                metadata: [
                    "source": "home_screen",
                    "button": buttonName
                ]
            )
        )
    }
    
    private func handleInputSubmit() {
        MoveoOne.instance.track(
            context: "main_screen",
            moveoOneData: MoveoOneData(
                semanticGroup: "user_interactions",
                id: "main_input",
                type: .textEdit,
                action: .input,
                value: "text_entered",
                metadata: [
                    "source": "home_screen",
                    "input_length": String(inputText.count)
                ]
            )
        )
    }
}

@main
struct SimpleExampleAppApp: App {
    init() {
        // Initialize Moveo Analytics
        MoveoOne.instance.initialize(token: "YOUR_API_KEY")
        MoveoOne.instance.identify(userId: "demo_user_123")
        MoveoOne.instance.setLogging(enabled: true)
        MoveoOne.instance.setFlushInterval(interval: 5)
        
        // Start session with context
        MoveoOne.instance.start(
            context: "main_screen",
            metadata: [
                "app_version": "1.0",
                "platform": "iOS",
                "locale": "en_US"
            ]
        )
        
        // Update additional metadata
        MoveoOne.instance.updateAdditionalMetadata([
            "user_country": "US",
            "experiment_group": "test_1"
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}
```

## Obtain API Key

You can find your organization's API token in the [Moveo One App](https://app.moveo.one/). Navigate to your organization settings to retrieve your unique API key.

## Dashboard Access

Once your data is being tracked, you can access your analytics through [Moveo One Dashboard](https://app.moveo.one/). The dashboard provides comprehensive insights into user behavior, interaction patterns, and application performance.

## Support

For any issues or support, feel free to:

- Open an **issue** on our [GitHub repository](https://github.com/divstechnologydev/moveoone-flutter/issues)
- Email us at [**info@moveo.one**](mailto:info@moveo.one)

---

**Note:** This library is designed for iOS applications and requires iOS 15.0 or later. Make sure to handle user privacy and data collection in compliance with relevant regulations.
