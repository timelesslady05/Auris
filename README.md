# 🌟 Auris - Augmentative and Alternative Communication (AAC) App

Auris is a comprehensive, customizable, and multi-lingual Flutter application designed to give a voice to children with speech and communication difficulties. By utilizing an intuitive visual vocabulary board, predictive suggestions, and text-to-speech technologies, Auris empowers children to express their needs, emotions, and thoughts efficiently.

---

##  Table of Contents
- [Overview](#-overview)
- [The Problem It Solves](#-the-problem-it-solves)
- [Target Audience](#-target-audience)
- [Key Features](#-key-features)
- [Architectural Overview](#-architectural-overview)
- [Tech Stack](#-tech-stack)
- [How to Set Up & Run](#-how-to-set-up--run)
- [Current Project Status](#-current-project-status)
- [Future Roadmap](#-future-roadmap)

---

## 🔍 Overview
Auris is designed with both children and parents in mind. It consists of a parent-controlled administrative flow where vocabulary, languages, and settings can be tailored based on the child's age group (ranging from 0 to 13 years). For the child, it acts as an easy-to-use communication board that reads out tapped vocabulary or builds sentences using text-to-speech.

## 🎯 The Problem It Solves
Children with conditions such as non-verbal autism, speech delays, motor impairments, or cognitive disabilities often find it challenging to communicate their daily needs and emotions. This communication barrier can lead to frustration and isolation. 
Auris provides an accessible, digital voice, offering visual cues (icons) and audio outputs to bridge the communication gap, allowing these children to be understood by their caregivers and peers effortlessly.

## 👥 Target Audience
- **Children (Ages 0-13):** Non-verbal children, late talkers, or those with speech language delays.
- **Parents & Caregivers:** To customize the communication experience to best fit the child's specific developmental stage and needs.
- **Therapists:** Speech-language pathologists looking for a customizable digital tool for AAC therapy.

## ✨ Key Features

### 🧑‍💼 Parent Profile Control
Auris includes a dedicated **Registration and Profile Page** (`registration_page.dart` & `profile_page.dart`) ensuring parents have full control. Parents can set up the child's age range (0-3, 4-6, 7-9, 10-13), select a primary language, and use the **Design Page** (`design_page.dart`) to add, categorize, or remove specific vocabulary words tailored to their child's daily life.

### 🗣️ Multi-Language Speech Output
Powered by `flutter_tts`, Auris can output speech in a wide array of languages. Available languages include English, Hindi, Tamil, Telugu, Kannada, Malayalam, Marathi, Bengali, French, Spanish, German, and Italian. It seamlessly reads out the visual vocabulary in the selected native tongue.

### 💾 Persistent Data Storage
Using `shared_preferences`, Auris stores user settings locally. Data such as the selected language, child's age range, and the comprehensively designed custom vocabulary categories are saved persistently across app sessions—no need to set up the board every time the app opens.

### � Predictive Word Suggestion & Sentence Builder
For older age groups (7-9 and 10-13), the app transitions from single-word outputs to a **Sentence Builder**. As the child forms sentences, Auris uses a predictive suggestion engine (`child_page.dart`) to suggest the next logical words (e.g., tapping "I" predicts "want", "feel", "need").

---

## 🏗️ Architectural Overview
The app follows a standard Flutter architectural pattern, utilizing Stateful and Stateless widgets for the Presentation Layer with localized state management (`setState`).

1. **Presentation Layer:** Contains UI components and screens (`main.dart`, `splash_screen.dart`, `registration_page.dart`, `profile_page.dart`, `design_page.dart`, `child_page.dart`).
2. **Business Logic Layer:** Handled within the Stateful widgets, manipulating vocabulary structures, filtering predictions, and processing UI events.
3. **Data Layer:** Utilizes local key-value storage (`shared_preferences`) to persist user vocabulary (stored as serialized JSON strings) and app configuration.
4. **Hardware/Service Integration Layer:** Interfaces with native device text-to-speech engines through the `flutter_tts` package.

---

## 🛠️ Tech Stack
- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.11.0)
- **Language:** Dart
- **State Management:** Core `setState`
- **Key Dependencies:** 
  - `flutter_tts` (^3.6.3): Text-to-speech functionality.
  - `shared_preferences` (^2.2.2): Local persistent data storage.
  - `animated_text_kit` (^4.2.2): Smooth text animations and visual transitions.

---

## 🚀 How to Set Up & Run
To run Auris locally, ensure you have the Flutter SDK installed on your machine.

**1. Clone the repository:**
```bash
git clone <repository_url>
cd auris_app
```

**2. Get dependencies:**
```bash
flutter pub get
```

**3. Run on different environments:**
- **To run on an attached physical device or emulator:**
  ```bash
  flutter run
  ```
- **To build an Android APK:**
  ```bash
  flutter build apk --release
  ```
- **To build an iOS App (Requires macOS and Xcode):**
  ```bash
  flutter build ios --release
  ```

---

## 🚦 Current Project Status
- **Status:** **Fully Functional MVP**
- The app's core frontend and localized state are complete. 
- Parent registration, dynamic vocabulary board generation, text-to-speech integration, multi-language support, persistent local storage, and contextual word predictions are all operational.

---

## 🗺️ Future Roadmap
1. **Cloud Synchronization:** Integrate Firebase or Supabase to allow profiles and custom vocabulary to sync across multiple devices.
2. **Advanced AI Predictions:** Implement a local machine learning model or integrate an LLM API to provide context-aware, highly accurate predictive natural language completions.
3. **Custom Image Uploads:** Allow parents to upload photos of real-world objects from their device gallery instead of relying solely on default Material icons.
4. **Analytics Dashboard:** Provide insights to parents and therapists showing the most frequently used words and tracking the child's communication progress over time.
5. **Gamification & Rewards:** Introduce mini-games to encourage the child to use and learn new vocabulary.
