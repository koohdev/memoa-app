# Memoa User Manual

## 1. Overview & Purpose

Welcome to Memoa, your personal companion for a more organized and mindful life. In today's fast-paced world, it's easy to lose track of important thoughts, tasks, and connections. Memoa is designed to be a beautiful and intuitive sanctuary for your mind, bringing together the essential tools you need to stay on top of your day and in touch with your well-being.

Memoa is more than just a utility—it's a space for you. Whether you're capturing a fleeting memory in your private diary, setting a crucial reminder, checking the weather before you head out, or connecting with a friend through real-time chat, Memoa provides a seamless and elegant experience. Our goal is to help you navigate your life with greater ease and intention, all within a single, beautifully crafted application.

## 2. Visual Design Philosophy

Memoa is designed with a clean, modern aesthetic that is both visually appealing and easy to navigate. We believe that a well-designed app should feel like a natural extension of your own mind—uncluttered, intuitive, and a pleasure to use.

*   **Elegant Simplicity:** The user interface is designed to be as clean and uncluttered as possible, with a focus on clear typography and a balanced layout. This minimalist approach helps you focus on what matters most: your thoughts, your tasks, and your connections.
*   **Intuitive Navigation:** We've made it easy to move between the different features of the app with a clear and consistent navigation bar. The icons are designed to be instantly recognizable, so you can get to where you need to go without any guesswork.
*   **Light & Dark Modes:** We understand that everyone has their own preferences, which is why we offer both light and dark themes. Whether you prefer a bright, airy interface or a more subdued, calming one, you can choose the theme that best suits your mood and environment.

## 3. Feature List

* **Authentication:** Secure user sign-up, sign-in, and password recovery.
* **Home Screen:** A central dashboard providing an overview of the app's features.
* **Diary:** Create, view, and manage personal diary entries.
* **Reminders:** Set, edit, and delete reminders to keep track of important tasks.
* **Real-time Chat:** Communicate with other users in real-time.
* **Weather:** Get the current weather forecast for your location.
* **Light & Dark Mode:** Switch between light and dark themes for a comfortable viewing experience.

## 4. How to Use the App (Step-by-Step)

### 4.1. Getting Started

1.  **Sign Up:** New users can create an account using their email and a password. A "Forgot Password?" option is available if you forget your credentials.
2.  **Sign In:** Existing users can sign in with their registered email and password.

### 4.2. Navigating the App

Once logged in, you'll land on the **Home Screen**. From here, you can access all of the app's features through the navigation bar at the bottom of the screen:

*   **Home:**  Returns you to the main dashboard.
*   **Diary:** Opens the diary screen.
*   **Remind:** Takes you to the reminders list.
*   **Weather:** Shows the current weather forecast.
*   **Chat:** Opens the user list for starting a new chat.

### 4.3. Using the Features

*   **Creating a Diary Entry:**
    1.  Navigate to the **Diary** screen.
    2.  Tap the "Write" button to open the **Write Screen**.
    3.  Enter a title and your thoughts in the provided fields.
    4.  Tap "Save" to store your entry.

*   **Setting a Reminder:**
    1.  Navigate to the **Remind** screen.
    2.  Tap the "+" button to open the **Add Reminder Screen**.
    3.  Enter a title and description for your reminder.
    4.  Tap "Add" to save the reminder.

*   **Starting a Chat:**
    1.  Navigate to the **Chat** screen.
    2.  Select a user from the list to open the **Chat Screen**.
    3.  Type your message and tap the send button.

## 5. Screens & Modules Explanation

*   **Authentication Screens (`/signin`, `/signup`, `/forgot-password`):** These screens handle all aspects of user authentication, including creating an account, logging in, and resetting a password.
*   **Home Screen (`/home`):** The central navigation hub of the application.
*   **Diary Screens (`/diary`, `/diary/:noteId`, `/write`):**  The diary feature is split into three screens: one to display all diary entries, one to view the details of a specific entry, and one to create a new entry.
*   **Reminder Screens (`/remind`, `/add_reminder`, `/reminder/:id`):** Similar to the diary, the reminder feature has a main screen to list all reminders, a screen to add new ones, and a screen to edit existing ones.
*   **Weather Screen (`/weather`):**  Displays the current weather conditions.
*   **Chat Screens (`/users`, `/chat`):** The chat feature consists of a screen to list all users and a screen for real-time messaging with a selected user.

## 6. Settings/Configuration

*   **Theme:** You can switch between light and dark mode by tapping the theme toggle button in the app's settings.
*   **Logout:**  You can log out of your account by navigating to the **Logout Screen** from the app's main menu.

## 7. Error Handling & Edge Cases

*   **No Internet Connection:** If you are not connected to the internet, you will not be able to sign in, sign up, or access online features like chat and weather. The app will display a message indicating the lack of a network connection.
*   **Incorrect Credentials:** If you enter the wrong email or password during sign-in, an error message will be displayed.
*   **Email Already in Use:** If you try to sign up with an email that is already registered, you will be prompted to use a different email address.

## 8. FAQ

**Q: Is my diary private?**

A: Yes, your diary entries are private and can only be viewed by you.

**Q: How do I change my password?**

A: You can reset your password from the "Forgot Password?" link on the sign-in and sign-up screens.

**Q: Is the chat feature secure?**

A: The chat feature uses Firebase Realtime Database for secure and private communication between users.

## 9. Anything the End-User Should Know

*   Memoa is a cloud-based application, so your data is securely stored and accessible from any device where you are logged in.
*   We are constantly working to improve Memoa and add new features. Keep an eye out for updates!
