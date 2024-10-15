//
//  Untitled.swift
//  MoveoOneLibrary
//
//  Created by Vladimir Jeftovic on 15.10.24..
//

struct Constants {
    enum Environment: String {
        case development
        case production
    }
    
    enum MoveoOneEventType: String {
        case start_session
        case track
    }

    enum MoveoOneType: String {
        case button
        case text
        case textEdit
        case image
        case image_scroll_horizontal
        case image_scroll_vertical
        case picker
        case slider
        case switchControl
        case progressBar
        case checkbox
        case radioButton
        case table
        case collection
        case segmentedControl
        case stepper
        case datePicker
        case timePicker
        case searchBar
        case webView
        case scrollView
        case activityIndicator
        case video
        case videoPlayer
        case audioPlayer
        case map
        case tabBar
        case toolbar
        case alert
        case modal
        case toast
        case badge
        case dropdown
        case card
        case chip
        case grid
        case custom
    }
    
    enum MoveoOneAction: String {
        case click
        case view
        case appear
        case disappear
        case swipe
        case scroll
        case drag
        case drop
        case tap
        case doubleTap
        case longPress
        case pinch
        case zoom
        case rotate
        case submit
        case select
        case deselect
        case hover
        case focus
        case blur
        case input
        case valueChange
        case dragStart
        case dragEnd
        case load
        case unload
        case refresh
        case play
        case pause
        case stop
        case seek
        case error
        case success
        case cancel
        case retry
        case share
        case open
        case close
        case expand
        case collapse
        case custom
    }
}
