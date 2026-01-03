# 🎃 Halloween Quiz (Casa Rural)

A spooky, interactive quiz application built with **Flutter** and **Firebase**, designed for group events and "Casa Rural" getaways.

![Halloween Quiz Preview](https://github.com/user-attachments/assets/placeholder-image-if-available)  
*(Note: Visuals feature a custom "Spooky" design system with glassmorphism and animated gradients)*

## 👻 Overview

This app serves as the digital companion for a real-world scavenger hunt or quiz night. Players split into teams (Team A vs. Team B), solve riddles, and race to unlock the "Final Chest".

### Key Features
- **Team System**: Select your team and set a custom group name.
- **Immersive UI**:
    - **Custom Theme**: "Blood Red" & "Pumpkin Orange" palette.
    - **Glassmorphism**: Translucent cards and dialogs using `BackdropFilter`.
    - **Fonts**: integrated `GoogleFonts.creepster` for that horror vibe.
- **Real-Time Gameplay**:
    - **Live Leaderboard**: Scores sync instantly across devices using Firebase Realtime Database.
    - **Progress Tracking**: Cloud-based tracking of current phase and score.
- **Interactive Mechanics**:
    - **Riddles & Logic**: Questions loaded dynamically from local assets.
    - **Help System**: Penalized hints to help stuck teams.
    - **Validation**: Smart text input with feedback (e.g., "The darkness laughs at you...").

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Backend**: [Firebase](https://firebase.google.com/)
    - **Realtime Database**: For live score syncing and device state.
    - **Cloud Firestore**: Additional logging (optional).
- **State Management**: `setState` + Firebase Streams.
- **Key Packages**:
    - `auto_size_text`: For responsive typography.
    - `google_fonts`: For the "Creepster" and "Montserrat" typefaces.
    - `hugeicons`: For modern, rounded iconography.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Firebase Project configured (with `google-services.json` / `GoogleService-Info.plist` / `firebase_options.dart`).

### Installation
1.  **Clone the repository**:
    ```bash
    git clone https://github.com/rruizosm/HalloweenQuiz.git
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## 📂 Project Structure

- **`lib/app/theme.dart`**: Centralized design system (Colors, Gradients, TextStyles).
- **`lib/sections/spooky_widgets.dart`**: Reusable UI components (`SpookyCard`, `SpookyButton`, `SpookyDialog`).
- **`lib/sections/home.dart`**: Main game loop, question display, and logic.
- **`lib/sections/classification.dart`**: Real-time leaderboard overlay.
- **`assets/questions.json`**: Configuration file containing the riddles and answers.

---
*Built with 🧡 and 🩸 for a terrifyingly fun night.*
