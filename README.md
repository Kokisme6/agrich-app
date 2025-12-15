
#  AgriRich Mobile Application

AgriRich is a cross-platform mobile application designed to help farmers manage agricultural waste efficiently while fostering collaboration and knowledge sharing within farming communities. The platform combines waste tracking, pickup scheduling, waste commerce, geolocation, and community engagement into a single, easy-to-use mobile solution.

##  Problem Solved

Agricultural waste is often poorly tracked and inefficiently managed, leading to environmental harm and missed recycling opportunities. AgriRich addresses this critical issue by providing farmers with:

  * A centralized system to record waste.
  * A dedicated marketplace to buy or sell valuable farm waste.
  * Tools to coordinate waste pickups.
  * A community space for collaboration and education.

##  Key Features

| Feature Category | Description |
| :--- | :--- |
| **User Authentication** | Secure Firebase login and registration for farmers. |
| **Waste Tracking** | Allows farmers to easily log agricultural waste types and quantity. |
| **Pickup Scheduling** | Facilitates scheduling waste pickups with specific date and time options. |
| **E-commerce** | A platform for the buying and selling of valuable farm waste resources. |
| **Map Integration** | Users can select precise pickup locations and track the real-time location of waste collectors on a map. |
| **Community Chat** | Provides in-app chat functionality for farmers to share tips, insights, and best practices. |
| **Responsive UI** | A clean, intuitive, and adaptive user interface for a smooth user experience. |

##  Tech Stack

| Technology | Purpose |
| :--- | :--- |
| **Frontend** | Flutter / Dart (Cross-platform mobile framework) |
| **Authentication** | Firebase Authentication |
| **Database** | Cloud Firestore (NoSQL database for application data) |
| **Storage** | Firebase Cloud Storage (For storing images and files) |
| **Geolocation** | Google Maps API |

##  Getting Started

Follow these steps to set up and run the AgriRich application locally on your machine.

### Prerequisites

  * Flutter SDK installed and configured.
  * A supported IDE (VS Code or Android Studio).
  * Active Firebase Account.
  * Google Maps API key for map functionality.

### Firebase Configuration

This project relies heavily on Google Firebase for its backend services. You must link your own Firebase project to run the app.

1.  **Create a Firebase Project**
      * Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2.  **Enable Firebase Services**
      * In your new Firebase project, ensure the following services are **enabled**:
          * **Authentication**
          * **Cloud Firestore**
          * **Cloud Storage**
3.  **Add Configuration Files**
      * Register an Android and/or iOS app within your Firebase project.
      * Download the configuration files and place them in the correct locations:
          * **Android:** Place `google-services.json` in the `android/app/` directory.
          * **iOS:** Place `GoogleService-Info.plist` in the `ios/Runner/` directory.
4.  **Update `firebase_options.dart`**
      * Replace the placeholder values in the auto-generated `lib/firebase_options.dart` file with the actual values from your Firebase project configuration.

### Local Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Kokisme6/AgriRich.git
    cd AgriRich
    ```
2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```
    *(Ensure you have a connected device or emulator running.)*

##  Contribution

We welcome contributions\! If you have suggestions for features, find a bug, or want to improve the codebase, please open an issue or submit a pull request.
