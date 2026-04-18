# CV Studio Pro - Comprehensive Study Guide

This document is a complete breakdown of your `lib` folder. It is designed to help you prepare for your exam by explaining the architecture, services, features, and the purpose of every individual file in the codebase.

## 1. Project Architecture Overview

This Flutter project follows a **feature-first** architecture with a clear separation of concerns. It heavily utilizes **Riverpod** for state management and Dependency Injection, **Supabase** for Backend-as-a-Service (Auth & DB), and **GoRouter** for declarative routing.

The `lib` folder is organized into:
*   `main.dart` - Application entry point.
*   `core/` - Global configurations (routing, theming, colors, API keys).
*   `services/` - Independent logic like fetching weather, getting quotes, and generating the PDF.
*   `features/` - UI and localized business logic grouped by functionality (`auth`, `dashboard`, `editor`, `preview`).

---

## 2. Root Entry (`lib/main.dart`)

*   **`main.dart`**: This is where the app starts.
    *   It ensures Flutter widgets are initialized.
    *   Loads environment variables from `.env` using `flutter_dotenv`.
    *   Initializes `Supabase` using your `SupabaseConfig` API keys.
    *   Wraps the entire `CVStudioApp` widget in a `ProviderScope`, which is strictly required to use Riverpod state management.
    *   Passes the `GoRouter` instance to `MaterialApp.router`.

---

## 3. Core Layer (`lib/core/`)

This directory contains constants and configurations that are used app-wide.

### `core/constants/`
*   **`api_keys.dart`**: Safely reads external credentials from the `.env` configuration file, such as the `Supabase` URL, `Supabase` Anon Key, and `OpenWeatherMap` API key.
*   **`app_colors.dart`**: A centralized palette of colors following your modern, glassmorphic design theme. It defines variables like `canvas`, `ink`, `glassWhite`, `accent` (emerald green), and specific dark themes used in your Auth flow.

### `core/router/`
*   **`app_router.dart`**: This is the navigation brain of the app.
    *   Defines the `routerProvider` managed by Riverpod.
    *   Utilizes a `redirect` logic: If the user is not authenticated (checked via `authNotifier`/Supabase session), they are immediately routed to `/login`. If they are already logged in, they skip the Auth flow and go directly to `/dashboard`.
    *   Registers all paths: `/`, `/login`, `/signup`, `/dashboard`, `/editor`, and `/preview`. Uses `extra` parameters for passing complex objects (like `CVModel`) between screens.

### `core/theme/`
*   **`app_theme.dart`**: Defines standard `TextStyle` definitions (like `display`, `label`, `body`) using `GoogleFonts` (Outfit and Inter).
    *   Builds the `ThemeData` to use Material 3 principles, applying your `AppColors` seamlessly to standard Flutter Input decorations and AppBar themes across the whole app.

---

## 4. Services Layer (`lib/services/`)

These files handle independent tasks calling external APIs or doing heavy data processing.

*   **`quote_service.dart`**: Fetches the "Quote of the Day".
    *   Tries to get a cached quote using `SharedPreferences` to avoid spamming the network.
    *   If no cache, calls the ZenQuotes API (`zenquotes.io/api/today`).
    *   Falls back to local `_offlineQuotes` array based on the day of the year if there is no internet.
    *   Also has a deterministic `getTodayTip()` method that cycles through practical CV tips for the dashboard.
*   **`weather_service.dart`**: Used in the user's dashboard header.
    *   First relies on `SharedPreferences` cache (duration: 30 minutes).
    *   Uses `geolocator` to get device GPS position and fetches local weather from OpenWeatherMap API using coordinates.
    *   Parses weather into a Dart object and assigns a matching `emoji` (☀️, 🌧️, etc) based on the weather condition code.
*   **`pdf_service.dart`**: The heavy lifter for exporting the CV.
    *   Uses the `pdf` package to programmatically draw documents.
    *   Has 6 distinct template layout functions: `_generateClassic`, `_generateModern`, `_generateMinimal`, `_generateExecutive`, `_generateCreative`, and `_generateAcademic`.
    *   Each template reads properties from the `CVModel` and uses `pw.Widget` (printing widgets like `pw.Column`, `pw.Text`) to organize the UI cleanly into A4 page formats. Returns `Uint8List` bytes for saving/sharing.

---

## 5. Features - Auth (`lib/features/auth/`)

*   **`auth_service.dart`**: A wrapper around `SupabaseClient`.
    *   Has methods for `signUp`, `signIn`, and `signOut`.
    *   Upon `signUp`, it also inserts a row into the public DB table `profiles` to map the `user.id` to their `full_name`.
*   **`splash_screen.dart`**: The entry page (`/`). Shows an animated CV Studio Pro logo, waits 1.8 seconds, and then checks `Supabase.instance.client.auth.currentUser`. Evaluates if the user should go to Dashboard or Login.
*   **`login_screen.dart`**: A beautiful dark-green-themed form.
    *   Captures Email and Password. Performs form validation.
    *   Communicates with `AuthService` inside a `try/catch`. Captures specific Supabase errors into human-readable prompts.
    *   Also handles password resets via `_forgotPassword`.
*   **`signup_screen.dart`**: Similar to login, captures Name, Email, Password, and Confirmation. Interacts with `auth.signUp`.

---

## 6. Features - Dashboard (`lib/features/dashboard/`)

*   **`dashboard_screen.dart`**: The home hub of the app holding various modular widgets:
    *   **Studio Hero**: A dynamic glassmorphic card at the top. Streams the current device time `Timer.periodic`, displays user's first name, and watches the `weatherProvider` to show local weather data fetched from `WeatherService`.
    *   **Quick Actions Hub**: Action shortcuts (Gallery, Advisor, Scan) set up graphically.
    *   **Resume Library**: Uses Riverpod (`resumeListProvider`) to fetch and display the user's existing CVs via `ResumeService`. Rendered as interactive cards with a progress bar indicating "Profile Completeness" and showing assigned templates.
    *   **Cards**: Fetches and renders daily quotes and CV career tips using `quoteProvider` and `QuoteService`.

---

## 7. Features - Editor (`lib/features/editor/`)

This directory is the core logic surrounding CV data input and saving.

*   **`cv_model.dart`**: Defines standard classes used to serialize Data (from Dart to JSON payload for Supabase).
    *   Primary class `CVModel` contains lists of sub-classes (`Experience`, `Education`, `Project`, etc).
    *   Contains `toJson()` / `fromJson()` mapping.
    *   Contains the `completeness()` method evaluating which fields are populated to establish a 0-100 score.
*   **`resume_service.dart`**: Performs Create, Read, Update, Delete (CRUD) operations on the `resumes` table in Supabase.
    *   `createResume()` creates a blank entry.
    *   `saveResume()` pushes the full CVModel JSON tree to the DB.
*   **`input_screen.dart`**: The large, 4-step wizard UI for inputting CV details.
    *   Uses a `PageView` managed by `_pageController` for step-by-step navigation (Profile -> Career -> Portfolio -> References).
    *   Instantiates local controllers (e.g., `EducationForm`, `ProjectForm`) allowing users to dynamically add or remove arrays of fields via `setState`.
    *   **Auto-save System**: Instead of "Save" buttons, it listens to typing in fields. Triggers a 2-second `_saveDebounce` timer that calls Database upload when the user stops typing, reflecting a "saving/saved" spinning indicator in the top right.

---

## 8. Features - Preview (`lib/features/preview/`)

*   **`preview_screen.dart`**: Displays the final output of the generated resume.
    *   It uses `PdfPreview` (from the `printing` package) which renders the byte output from `PdfService.generateCV` onto the screen in real time.
    *   Has a horizontal scroll selector holding predefined `_templates` (Classic, Modern, Minimal, etc.). Selecting a new one triggers a screen re-draw with the new layout, and writes the selection background to Supabase.
    *   Handles sharing via PDF formatting using `Printing.sharePdf`.

---

## General Concepts to Remember

1.  **Riverpod**: Whenever you see `ref.watch()`, the UI is subscribing to a provider. If the data inside changes, ONLY that specific widget rebuilds. Used intensely in `dashboard_screen.dart` to watch DB resumes and Weather without rebuilding the full screen.
2.  **Supabase Auth state tracking**: Inside `app_router.dart`, the path router listens strictly to a `ValueNotifier` plugged directly into Supabase's Auth observer. This ensures that users are completely kicked out or allowed in if their access token expires automatically.
3.  **To JSON / From JSON**: All database calls (Supabase's JSONB row parsing) are heavily reliant on `cv_model.dart`'s `factory CVModel.fromJson(Map<String, dynamic> j)` to dynamically format random objects into strongly verified dart types.
