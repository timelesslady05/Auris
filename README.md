# AURIS

Auris is a supportive Augmentative and Alternative Communication (AAC) Flutter application designed to assist children and adolescents in communicating effectively. The app provides a safe, tailored, and customizable environment where users can build sentences and express their needs, feelings, and thoughts using text-to-speech technology.

## Team: AURIS
* **Sarah Joseph** - [GitHub Profile](https://github.com/timelesslady05)
* **Ashe Mariya Binu** - [GitHub Profile](https://github.com/ashemariya27-star)

## 📸 Demo & Screenshots
> Placeholder for demo link and screenshots. Adding dummy data for now.
* [Demo Video Link](#)
* ![Screenshot 1](https://via.placeholder.com/200x400?text=Splash+Screen) ![Screenshot 2](https://via.placeholder.com/200x400?text=Child+Board)

## 🛠 Technical Stack
* **Framework:** [Flutter](https://flutter.dev/) (v3.11.0+)
* **Language:** [Dart](https://dart.dev/)
* **Backend & Database:** [Firebase](https://firebase.google.com/) (Auth & Cloud Firestore)
* **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences) (for temporary caching)
* **Text-to-Speech:** [flutter_tts](https://pub.dev/packages/flutter_tts)
* **Typography:** [Google Fonts (Poppins)](https://fonts.google.com/specimen/Poppins)

## 🔥 Firebase Integration (Step-by-Step)
You can connect the project to Firebase in two ways:

### Option A: Standard (Recommended for Android/iOS)
1. **Create Firebase Project:** [Firebase Console](https://console.firebase.google.com/).
2. **Download Config File:** Download `google-services.json`.
3. **Place File:** Move it to `android/app/google-services.json`.
4. **Enable Plugin:** Uncomment the `google-services` plugin on line 7 of `android/app/build.gradle.kts`.

### Option B: .env (Great for quick setup/Web/Desktop)
1. Open the `.env` file at the root.
2. Fill in your Firebase Project details (API Key, Project ID, App ID, etc.).
3. The app will automatically try to initialize using these values if they are provided.

> [!NOTE]
> For security, the `.env` and `google-services.json` files are automatically excluded from your Git commits in your `.gitignore`.

## 🚀 How to Run the Project
1. **Clone the project:**
   ```bash
   git clone https://github.com/timelesslady05/Auris.git
   cd Auris
   ```
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Firebase Setup:** Follow the Integration Guide above.
4. **Run the App:**
   ```bash
   flutter run
   ```

## Features
* **Age-Appropriate Vocabulary Layouts:** Adaptable board for ages 0-16.
* **Typing & Predictive Suggestions:** Real-time word prediction as you type.
* **Customizable Board:** Parents can add/edit words and categories.
* **Multi-Language Support:** Localized in English, Spanish, French, German, and Italian.
* **Modern UI:** Premium design with glassmorphism and smooth animations.

## 📁 Project Structure
* `lib/services/` - Firebase Auth and Firestore logic.
* `lib/main.dart` - Entry point & Theme.
* `lib/child_page.dart` - Core communication board.
* `lib/design_page.dart` - Vocabulary customization.
