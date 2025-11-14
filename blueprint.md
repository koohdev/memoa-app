# Blueprint

## Overview

This is a Flutter application that serves as a personal diary, reminder, and weather app. It also includes a chat feature for users to communicate with each other.

## Style and Design

*   **Theming**
    *   The app uses a clean and modern design with a consistent color scheme and typography.
    *   The primary color is a deep purple, and the accent color is a lighter shade of purple.
    *   The app uses the Google Fonts package to provide a variety of font styles.
*   **Components**
    *   The app uses a variety of Material Design components, including app bars, buttons, cards, and text fields.
    *   The app also uses custom components, such as a custom bottom navigation bar and a custom weather widget.

## Features

*   **Authentication**
    *   Users can sign up and log in with their email and password.
    *   The app uses Firebase Authentication to manage user authentication.
*   **Diary**
    *   Users can create, read, update, and delete diary entries.
    *   Diary entries are stored in Firebase Firestore.
*   **Reminders**
    *   Users can create, read, update, and delete reminders.
    *   Reminders are stored in Firebase Firestore.
*   **Weather**
    *   The app displays the current weather and a 5-day forecast.
    *   The weather data is fetched from the OpenWeatherMap API.
*   **Chat**
    *   Users can chat with each other in real-time.
    *   The chat feature uses Firebase Firestore to store and retrieve messages.

## Current Plan

*   **Refactor the UI**
    *   Remove the chat icon from the bottom navigation bar.
    *   Add a "Chat with Friends" card to the main dashboard.
    *   Ensure the styling of the new card matches the overall theme of the app.

