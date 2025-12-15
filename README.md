AgriRich

AgriRich is a crossplatform mobile application designed to help farmers manage agricultural waste efficiently while fostering collaboration and knowledge sharing within farming communities.

The platform combines waste tracking, pickup scheduling, waste commerce, geolocation, and community engagement into a single, easy-to-use mobile solution.


Features

- **User Authentication**
  - Firebase login and registration
-  **Waste Tracking**
  - Log agricultural waste types and quantities
-  **Pickup Scheduling**
  - Schedule waste pickups with date and time selection
- **E-commerce**
  - Buying and selling of valuable farm waste
-  **Map Integration**
  - Visualize pickup locations using map-based views
-  **Community Chat**
  - In-app chat for farmers to share tips, insights, and best practices
-  **Responsive UI**
  - Clean and intuitive Flutter interface across devices

---

Problem Statement

Agricultural waste is often poorly tracked and inefficiently managed, leading to environmental harm and missed recycling opportunities.

AgriWealth addresses this by providing farmers with:
- A centralized system to record waste
- A place to buy or sell valuable farm waste
- Tools to coordinate pickups
- A community space for collaboration and education

---

Tech Stack

- **Flutter / Dart**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Cloud Storage**
- **Google Maps API**

---

Firebase Configuration

This project uses Firebase as its backend.
To run the app locally:

Create a Firebase project

Enable:
- Authentication
- Cloud Firestore
- Cloud Storage

Add your Firebase configuration files:
- google-services.json (Android)
- GoogleService-Info.plist (iOS)

Replace placeholder values in firebase_options.dart
