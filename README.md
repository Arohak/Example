# Instagram-Style App!

## Overview

This iOS application demonstrates a modern approach to building a feature-rich app with a focus on reusable UI components, clean architecture, and efficient data handling. The app follows an Instagram-like stories interface, fetches data from a fake products API, and transforms this data into an engaging user experience.

## Features

- Tab Bar Navigation: Easy navigation between main app sections
- Stories Feed: Instagram-style stories interface with seen/unseen status
- Market Products: Browse and search through product listings

- Pull-to-Refresh: Update content with a simple gesture
- Infinite Scrolling: Load more content as you scroll
- Offline Support: View previously loaded content without internet

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

