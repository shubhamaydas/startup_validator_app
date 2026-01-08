# Startup Validator App 💡

A Flutter app for validating startup ideas with community feedback - created for BCBT Startup Hub Workshop, January 8, 2025.

## Overview

Startup Validator helps aspiring entrepreneurs validate their startup ideas by:
- 📝 Documenting ideas with structured validation checklists
- 👥 Getting feedback from the community
- ❤️ Receiving likes and engagement
- 📊 Tracking validation progress through the 5-stage framework

## Features

- **User Authentication**: Secure signup/login with Firebase Auth
- **Create & Share Ideas**: Submit startup ideas with problem, solution, and target audience
- **Validation Checklist**: Track progress through essential validation steps:
  - Identified the problem
  - Talked to potential users
  - Researched competitors
  - Validated market need
  - Defined target audience
- **Community Engagement**: Like ideas and provide constructive feedback
- **My Ideas Dashboard**: Manage and edit your own ideas
- **Real-time Updates**: See new ideas and feedback instantly

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Real-time NoSQL database
- **Provider** - State management
- **Google Fonts** - Beautiful typography

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/startup_validator_app.git
   cd startup_validator_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**

   a. Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   
   b. Enable Authentication:
      - Go to Authentication > Sign-in method
      - Enable Email/Password provider
   
   c. Create Firestore Database:
      - Go to Firestore Database
      - Create database in production mode
      - Set up security rules (see below)
   
   d. Add Firebase to your Flutter app:
      - For Android: Download `google-services.json` and place it in `android/app/`
      - For iOS: Download `GoogleService-Info.plist` and place it in `ios/Runner/`
   
   e. Update Firebase configuration files:
      - Follow Firebase console instructions for platform-specific setup
      - Use FlutterFire CLI for easier setup: `flutter pub global activate flutterfire_cli`
      - Run: `flutterfire configure`

4. **Set up Firestore Security Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users collection
       match /users/{userId} {
         allow read: if true;
         allow create: if request.auth != null;
         allow update, delete: if request.auth.uid == userId;
       }
       
       // Ideas collection
       match /ideas/{ideaId} {
         allow read: if true;
         allow create: if request.auth != null;
         allow update: if request.auth.uid == resource.data.userId;
         allow delete: if request.auth.uid == resource.data.userId;
       }
       
       // Feedback collection
       match /feedback/{feedbackId} {
         allow read: if true;
         allow create: if request.auth != null;
         allow update, delete: if request.auth.uid == resource.data.userId;
       }
     }
   }
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── user.dart            # User model
│   ├── startup_idea.dart    # Startup idea model
│   └── feedback.dart        # Feedback model
├── screens/
│   ├── splash_screen.dart   # Initial loading screen
│   ├── auth_screen.dart     # Login/signup screen
│   ├── home_screen.dart     # Main feed of all ideas
│   ├── my_ideas_screen.dart # User's own ideas
│   ├── create_idea_screen.dart  # Create/edit idea form
│   └── idea_detail_screen.dart  # Idea details with feedback
├── services/
│   ├── auth_service.dart    # Authentication logic
│   └── firestore_service.dart   # Database operations
└── widgets/
    └── idea_card.dart       # Reusable idea card component
```

## Workshop Demo

This app demonstrates key concepts from the "Building Your First Product" workshop:

1. **Stage 1: Ideation & Validation** - Structured validation checklist
2. **Stage 2: Planning & Architecture** - Clean architecture with separation of concerns
3. **Stage 3: MVP Development** - Core features only (CRUD + social features)
4. **Stage 4: Testing & Iteration** - Real-time feedback loop
5. **Stage 5: Production & Scaling** - Firebase for production-ready backend

## Key Learning Points

### Clean Architecture
- **Models**: Data structures representing app entities
- **Services**: Business logic separated from UI
- **Screens**: UI components
- **Widgets**: Reusable UI elements

### State Management
- Using Provider for dependency injection
- StreamBuilder for real-time updates
- Proper state lifting and management

### Firebase Integration
- Authentication flow
- Real-time database with Firestore
- Security rules for data protection
- Optimistic UI updates

## Common Issues & Solutions

### Issue: Firebase not initialized
**Solution**: Make sure you've run `firebase configure` and added platform-specific files

### Issue: Build errors on iOS
**Solution**: Run `cd ios && pod install && cd ..`

### Issue: Firestore permission denied
**Solution**: Check your security rules and ensure user is authenticated

## Contributing

This is an educational project created for the BCBT Startup Hub workshop. Feel free to:
- Fork the repository
- Create feature branches
- Submit pull requests
- Report issues

## Next Steps for Students

After the workshop, try adding:
1. **User profiles** with avatars
2. **Search and filtering** for ideas
3. **Categories/tags** for ideas
4. **Upvote/downvote** system
5. **Email notifications** for feedback
6. **Share ideas** on social media
7. **Analytics dashboard** showing idea metrics
8. **AI-powered** validation suggestions

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [FlutterFire](https://firebase.flutter.dev/)

## Workshop Slides

See the full workshop presentation: [Building Your First Product: From Idea to Production](link-to-presentation)

## Contact

Created by **Shubhamay Das** for BCBT Startup Hub Workshop
- LinkedIn: [linkedin.com/in/shubhamay-das](https://linkedin.com/in/shubhamay-das)
- Email: [your-email]

## License

MIT License - feel free to use this code for learning and building your own projects!

---

**Built with ❤️ at BCBT Startup Hub, Berlin**
# startup_validator_app
