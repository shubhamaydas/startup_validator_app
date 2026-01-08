# Firebase Setup Guide

This guide will walk you through setting up Firebase for the Startup Validator app.

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `startup-validator` (or your choice)
4. Enable Google Analytics (optional but recommended)
5. Click "Create project"

## Step 2: Enable Authentication

1. In Firebase Console, go to **Build** → **Authentication**
2. Click "Get started"
3. Go to **Sign-in method** tab
4. Enable **Email/Password** provider:
   - Click on "Email/Password"
   - Toggle "Enable" ON
   - Click "Save"

## Step 3: Create Firestore Database

1. In Firebase Console, go to **Build** → **Firestore Database**
2. Click "Create database"
3. Select "Start in production mode"
4. Choose a Cloud Firestore location (select closest to your users)
5. Click "Enable"

## Step 4: Set Up Firestore Security Rules

1. In Firestore Database, go to **Rules** tab
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check authentication
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Helper function to check ownership
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      // Anyone can read user profiles
      allow read: if true;
      // Only authenticated users can create their profile
      allow create: if isSignedIn() && isOwner(userId);
      // Only owners can update/delete their profile
      allow update, delete: if isOwner(userId);
    }
    
    // Ideas collection
    match /ideas/{ideaId} {
      // Anyone can read ideas (public feed)
      allow read: if true;
      // Authenticated users can create ideas
      allow create: if isSignedIn();
      // Only idea owners can update their ideas
      allow update: if isSignedIn() && isOwner(resource.data.userId);
      // Only idea owners can delete their ideas
      allow delete: if isSignedIn() && isOwner(resource.data.userId);
    }
    
    // Feedback collection
    match /feedback/{feedbackId} {
      // Anyone can read feedback
      allow read: if true;
      // Authenticated users can create feedback
      allow create: if isSignedIn();
      // Only feedback authors can update/delete
      allow update, delete: if isSignedIn() && isOwner(resource.data.userId);
    }
  }
}
```

3. Click "Publish"

## Step 5: Add Firebase to Flutter App

### Option A: Using FlutterFire CLI (Recommended)

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Run configure command in your project:
```bash
flutterfire configure
```

3. Select your Firebase project from the list
4. Select platforms (Android, iOS, or both)
5. The CLI will automatically generate configuration files

### Option B: Manual Setup

#### For Android:

1. In Firebase Console, click the Android icon to add Android app
2. Register app with package name: `com.bcbt.startupvalidator.startup_validator_app`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`
5. Update `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```
6. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   
   dependencies {
       implementation platform('com.google.firebase:firebase-bom:32.7.0')
   }
   ```

#### For iOS:

1. In Firebase Console, click the iOS icon to add iOS app
2. Register app with Bundle ID: `com.bcbt.startupvalidator.startupValidatorApp`
3. Download `GoogleService-Info.plist`
4. Open Xcode: `open ios/Runner.xcworkspace`
5. Drag `GoogleService-Info.plist` into Runner folder
6. Ensure "Copy items if needed" is checked

## Step 6: Verify Setup

1. Run the app:
```bash
flutter run
```

2. Try to sign up with a test email
3. Check Firebase Console:
   - **Authentication** → Users should show your test user
   - **Firestore Database** → Data should show user document

## Step 7: Create Test Data (Optional)

To test with sample data:

1. Go to Firestore Database
2. Create a sample idea:
   - Collection: `ideas`
   - Document ID: (auto-generate)
   - Fields:
     ```
     id: [same as document ID]
     userId: [copy from Authentication users]
     userName: "Test User"
     title: "AI-Powered Study Assistant"
     problem: "Students struggle to create effective study schedules"
     solution: "AI analyzes course load and creates personalized study plans"
     targetAudience: "College students"
     validationSteps: ["Identified the problem", "Talked to potential users"]
     likes: 0
     likedBy: []
     createdAt: [current timestamp]
     updatedAt: [current timestamp]
     ```

## Step 8: Set Up Firestore Indexes

For complex queries, you may need composite indexes.

1. Go to **Firestore Database** → **Indexes** tab
2. If you see errors in the console about missing indexes, Firebase will provide a link
3. Click the link to automatically create the required index

Common indexes you might need:
- Collection: `ideas`, Fields: `userId` (Ascending), `createdAt` (Descending)
- Collection: `feedback`, Fields: `ideaId` (Ascending), `createdAt` (Ascending)

## Troubleshooting

### Issue: "Default FirebaseApp is not initialized"
**Solution**: 
- Ensure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is properly added
- Run `flutter clean` and rebuild

### Issue: "Permission denied" when reading/writing
**Solution**:
- Check Firestore security rules
- Ensure user is authenticated before making requests
- Verify userId matches in security rules

### Issue: "No Firebase App '[DEFAULT]' has been created"
**Solution**:
- Verify `await Firebase.initializeApp()` is called in `main()`
- Check that config files are in correct locations

### Issue: Build errors on iOS
**Solution**:
```bash
cd ios
pod install
pod update
cd ..
flutter clean
flutter run
```

### Issue: "google-services.json not found"
**Solution**:
- Verify file is in `android/app/` directory (not `android/`)
- Check that file name is exactly `google-services.json`

## Security Best Practices

1. **Never commit Firebase config files to public repositories** (they're in `.gitignore`)
2. **Use environment-specific projects** (dev, staging, production)
3. **Review security rules regularly**
4. **Enable App Check** for production apps
5. **Set up Firebase Security Monitoring**

## Firebase Quotas (Free Tier)

- **Authentication**: 10K verifications/month
- **Firestore**: 
  - 50K reads/day
  - 20K writes/day
  - 20K deletes/day
  - 1 GB storage
- **Storage**: 5 GB
- **Hosting**: 10 GB/month

For a workshop/demo app, these limits are more than sufficient!

## Next Steps

1. Set up Firebase Crashlytics for error tracking
2. Add Firebase Analytics for user behavior
3. Set up Cloud Functions for backend logic
4. Configure Firebase Hosting for web version
5. Enable Firebase Performance Monitoring

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase YouTube Channel](https://www.youtube.com/@Firebase)
- [Firebase Pricing](https://firebase.google.com/pricing)

---

Need help? Check the [main README](README.md) or ask during the workshop!
