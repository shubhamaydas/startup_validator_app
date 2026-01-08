# Workshop Setup Instructions

## For You (Shubhamay)

### Before the Workshop

#### 1. Set Up GitHub Repository

```bash
# Extract the project
tar -xzf startup_validator_app.tar.gz
cd startup_validator_app

# Initialize git
git init
git add .
git commit -m "Initial commit: Startup Validator App for BCBT Workshop"

# Create repo on GitHub (https://github.com/new)
# Name: startup-validator-app
# Description: Flutter app for validating startup ideas - BCBT Workshop Demo

# Push to GitHub
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/startup-validator-app.git
git push -u origin main
```

#### 2. Set Up Demo Firebase Project

1. Create Firebase project: "startup-validator-demo"
2. Enable Email/Password authentication
3. Create Firestore database
4. Set up security rules (see FIREBASE_SETUP.md)
5. Add some sample ideas for demonstration

#### 3. Prepare Your Development Environment

```bash
# Test the app works
flutter pub get
flutterfire configure  # Point to your demo Firebase project
flutter run
```

#### 4. Update Presentation Slide 10

Add to slide 10:
- GitHub Repository Link: https://github.com/YOUR_USERNAME/startup-validator-app
- QR Code to the repository (generate at qr-code-generator.com)

#### 5. Test Run

- Do a complete run-through of the demo
- Time each section
- Prepare 2-3 backup plans for common issues
- Have your phone/emulator ready with the app running

### During the Workshop

#### Introduction (30 min)
1. Show the presentation slides 1-9
2. Show the live app on your phone/emulator
3. Explain the 5-stage framework
4. Demo key features:
   - Creating an idea
   - Liking ideas
   - Giving feedback
   - Validation checklist

#### Live Coding (15-20 min)
Show students:
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/startup-validator-app.git
cd startup-validator-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

Walk through:
1. Project structure (models, screens, services)
2. Authentication flow (auth_screen.dart)
3. CRUD operations (firestore_service.dart)
4. Real-time updates (StreamBuilder in home_screen.dart)
5. State management (Provider)

#### Hands-On Session (60+ min)

**Guided Exercise: Add a New Feature**

Let students add a "Favorite" feature (bookmark ideas):

1. **Update Model** (startup_idea.dart):
   ```dart
   final List<String> favoritedBy;
   ```

2. **Update Service** (firestore_service.dart):
   ```dart
   Future<void> toggleFavorite(String ideaId, String userId) {
     // Similar to toggleLike
   }
   ```

3. **Update UI** (idea_card.dart):
   ```dart
   // Add favorite icon button
   ```

This teaches them:
- Data modeling
- Service layer pattern
- UI updates
- Firestore operations

### Student Setup Instructions

Share these steps in the workshop:

1. **Prerequisites Check**
   ```bash
   flutter doctor
   ```

2. **Clone Repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/startup-validator-app.git
   cd startup-validator-app
   flutter pub get
   ```

3. **Firebase Setup**
   - Each student creates their own Firebase project
   - Follow FIREBASE_SETUP.md
   - Run `flutterfire configure`

4. **Run the App**
   ```bash
   flutter run
   ```

### Common Issues to Address

1. **"Flutter not found"**
   - Check PATH
   - Run `flutter doctor`

2. **"No devices found"**
   - Start Android emulator
   - Or use `flutter run -d chrome` for web

3. **"Firebase not initialized"**
   - Check google-services.json location
   - Run `flutter clean && flutter pub get`

4. **"Permission denied in Firestore"**
   - Verify security rules
   - Check user is authenticated

### Backup Plans

**Plan A**: Students follow along on their laptops
**Plan B**: If setup issues, show live coding and share recording later
**Plan C**: Use DartPad for basic Flutter concepts if all else fails

### Post-Workshop

1. **Share Resources**:
   - GitHub repository link
   - Presentation slides
   - Recording (if available)
   - Discord/Slack invite

2. **Create Issues for Challenges**:
   - Label issues as "good-first-issue"
   - Provide hints in issue descriptions
   - Encourage students to submit PRs

3. **Follow-Up**:
   - Share any additional resources
   - Announce office hours
   - Highlight student projects

## Marketing the Workshop

### Social Media Posts

**LinkedIn/Twitter:**
```
🚀 Excited to lead "Building Your First Product" workshop at BCBT Startup Hub!

We'll build a real Flutter app from scratch:
✅ User authentication
✅ Real-time database
✅ Community features
✅ Production deployment

Students will learn the complete product lifecycle - from idea validation to production.

📅 January 8, 2025
📍 BCBT, Berlin

#Flutter #Firebase #StartupLife #TechWorkshop
```

### Email to Students

Subject: Workshop Prep: Building Your First Product

```
Hi everyone!

Excited to see you at the workshop on January 8th! 

To get the most out of our time together, please:

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Create a Firebase account: https://firebase.google.com/
3. Install VS Code or Android Studio
4. Bring your laptop with charger

We'll be building a real mobile app that helps validate startup ideas!

GitHub Repo (bookmark this): [YOUR-REPO-LINK]

See you there!
- Shubhamay
```

## Presentation Tips

1. **Start with why**: Show a failed startup story, then introduce the framework
2. **Live demo first**: Show the working app before diving into code
3. **Keep it interactive**: Ask students about their startup ideas
4. **Use real examples**: Share ChefCoco stories
5. **Encourage questions**: Pause frequently for Q&A
6. **Celebrate small wins**: Clap when students get their app running
7. **Take photos**: Document the workshop for social media

## Success Metrics

Track:
- Number of attendees
- Apps successfully running
- GitHub stars
- Follow-up questions
- Student projects shared

## Contact During Workshop

- Email: [your-email]
- LinkedIn: linkedin.com/in/shubhamay-das
- GitHub: github.com/YOUR_USERNAME

---

Good luck with the workshop! You've got this! 🚀
