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

## 🔥 Firebase Integration Guide (Step-by-Step)
To connect the project with your own Firebase instance, follow these steps:

1. **Create Firebase Project:**
   * Go to [Firebase Console](https://console.firebase.google.com/).
   * Create a new project named "Auris".
2. **Setup Authentication:**
   * Navigate to **Build > Authentication**.
   * Enable the **Email/Password** sign-in method.
3. **Setup Database:**
   * Navigate to **Build > Firestore Database**.
   * Create a database in **Test Mode** (or update rules later).
4. **Register App:**
   * Click the Android icon to add an app.
   * Enter the Package Name: `com.example.auris_app`.
5. **Download Config File:**
   * Download `google-services.json`.
   * Move it to `android/app/google-services.json`.
6. **Initialize Firebase:**
   * The app is pre-configured to initialize Firebase in `main.dart`. Ensure you run `flutter pub get` to fetch dependencies.

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
