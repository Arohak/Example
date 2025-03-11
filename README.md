# Instagram-Style App!

## Overview

This iOS application demonstrates a modern approach to building a feature-rich app with a focus on reusable UI components, clean architecture, and efficient data handling. The app follows an Instagram-like stories interface, fetches data from a fake products API, and transforms this data into an engaging user experience.


## Architecture

- MV (Model-View) Pattern
Used for simpler views where business logic is minimal
Direct connection between the view and model for straightforward data display

- MVVM (Model-View-ViewModel) Pattern
Used for complex views requiring more sophisticated data handling
ViewModels transform raw data into view-ready formats
Enables better testability and separation of concerns

- Dependency Injection
Services and dependencies are injected rather than created directly
Facilitates testing and modular development


## Data Flow

- API Service: Fetches raw product data from a fake API
- Data Transformation: Converts product data into Story models
- SwiftData: Persists models for offline access
- Navigator Pattern: Type-safe navigation within each module


## Features

- [x] Tab Bar Navigation: Easy navigation between main app sections
- [x] Stories Feed: Instagram-style stories interface with seen/unseen status
- [x] Market Products: Browse product listings
- [x] Pull-to-Refresh: Update content with a simple gesture
- [x] Infinite Scrolling: Load more content as you scroll, pagination
- [ ] Stories: like/unlike functionality is missing
- [ ] Offline: Needs improvement



# What next, Development plan.

## Architecture

- [ ] Modular and Microapp Architecture (https://github.com/Arohak/CashFlow)


## Features

- [ ] Analytics, Mixpanel and Firebase events
- [ ] Crash reporting, Logging
- [ ] Tests, CI/CD, Fastlane


## Tools

- [ ] [SwiftPM](https://www.swift.org/documentation/package-manager/) - The Swift Package Manager is a tool for managing the distribution of Swift code
- [ ] [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions
- [ ] [SwiftGen](https://github.com/SwiftGen/SwiftGen) - SwiftGen is a tool to automatically generate Swift code for resources of your projects (like images, localised strings, etc)
- [ ] [Sourcery](https://github.com/krzysztofzablocki/Sourcery) - Sourcery scans your source code, applies your personal templates and generates Swift code for you, allowing you to use meta-programming techniques to save time and decrease potential mistakes.
- [ ] [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) - SwiftFormat is a code library and command-line tool for reformatting Swift code on macOS or Linux.
- [ ] [Fastlane](https://github.com/fastlane/fastlane) - The easiest way to automate building and releasing your iOS and Android apps

