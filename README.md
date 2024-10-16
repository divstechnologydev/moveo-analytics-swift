# moveo-analytics-swift

<div align="center" style="text-align: center">
  <img src="https://github.com/user-attachments/assets/ae163684-fcff-4fa8-b793-63849834c735" height="150"/>
</div>

####
## Table of Contents
- [Introduction] (#introduction)
- [Quick Start Guide](#quick-start-guide)
  - [Add Moveo One Analytics](#1-add-moveo-one-analytics)
  - [Initialize](#2-initialize)
  - [Setup](#3-setup)
  - [Track Data](#4-track-data)
  - [Obtain API KEY](#5-obtain-api-key)
  - [Use Results](#6-use-results)
## Introduction
Welcome to the official Moveo One Analytics React Native library.

Moveo One analytics is the user cognitive-behavioral analytics tool.
moveo-analytics-swift is SDK for Swift UI iOS client apps to use Moveo One tools.
## Quick Start Guide
Moveo One Swift UI SDK is pure Swift implementation of Moveo One Analytics tracker
### 1. Install Moveo One Analytics
#### Prerequisites
TBD
#### Steps
1. Add Moveo One Analytics
By adding dependency
````
https://github.com/divstechnologydev/moveo-analytics-swift.git
````
through File -> Add Package Dependencies... in XCode
choose latest version

   
### 2. Initialize
Initialization is usually done in AppDelegate.
To obtain a token, please contact us at: info@moveo.one and request API token.
We are working on bringing token creation to our dashboard, but for now, due to the early phase, contact us and we will be more than happy to provide you with an API token.
```
import MoveoOneLibrary
...
MoveoOne.instance.initialize(token: <UNIQUE_TOKEN>)
MoveoOne.instance.identify(userId: <CURRENT_USER_ID>)
```

This means that you are obtaining an instance of a MoveoOne analytics library, initializing with pre-obtained <TOKNE>
<USER_ID> is your tracking unique ID of the user who is using the app in order to create personalized analytics.
It is used on Dashboard and WebHook to deliver you calculated results, so you will need to have the notion of how this user Id correlates with your unique real userID.
Note: Do not provide user-identifiable information to Moveo One - we do not store them, but nonetheless, we don't need that data, so it's better to create custom bindings.

### 3. Setup
You may want to setup other parameters, such as:
```
MoveoOne.instance.setLogging(enabled: true)

```
To log responses from Moveo One library

```
MoveoOne.instance.setFlushInterval(interval: 20000)
```
To set automatic flush interval in milliseconds.
Note: the available range is [5000, 60000], aka 5s to 1min

### 4. Track Data
In order to track data, we will need to explain a couple of concepts
#### a) Context
The context is usually a single interaction session that a user has with the app.
More precisely, the context is usually a set of screens, like onboarding. There are no obstacles in creating single-screen contexts, but for now, we will explain multi-screen context.

Context needs to be started
```
MoveoOne.instance.start(context: "context", metadata: ["key": "value"])

```
The context as we explained might be anything and it is ok that you may have only one context for MoveoOne integration.
metadata is free form String to String dictionary that enables you to tag sessions of Moveo One interaction for future comparison and better analytics.
Usally, this is A/B testing group, locale, app versino etc...
It might be:
```
metadata: ["ab": "test_1", "locale": "en", "app_version": "1.2"]
```

#### b) semantic group
Semantic groups are one more level of abstraction.
Semantic group is usually a screen - something that is semantically atomic from user perspective.

Semantic group is one of the first mandatory field you are tracking in MoveoData which we will be exploring in next section:
```
public struct MoveoOneData {
    public let semanticGroup: String
    public let id: String
    public let type: Constants.MoveoOneType
    public let action: Constants.MoveoOneAction
    public let value: Any
    public let metadata: [String: String]?
}

```

#### c) simple data tracking
Data is tracked from user interaction with SwiftUI Components and thus, some bindings need to be placed in user interaction places.
Also, the data about how much text we have on the screen needs to be tracked through setting some onAppear interactions.

You would like to setup some basic on appear events:
```
.onAppear() {
    MoveoOne.instance.tick(
          moveoOneData: MoveoOneData(
                    semanticGroup: "screen_0",
                    id: "text_view_1",
                    type: .text,
                    action: .view,
                    value: data.text,
                    metadata: [:]
                ))
}
```

#### More on tracking data

#### Some examples

### 5. Obtain API KEY

#### API KEY

### 6. Use Results

#### Data ingestion

#### Dashboard
