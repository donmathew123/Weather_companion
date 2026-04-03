# Weather Companion

**Product demo:** `[]`

**Download the apk using the link:** `[https://drive.google.com/file/d/1DQUhqzcczpnKlgtkEXMitDdM9LwEvxn4/view?usp=sharing]`

### OpenWeatherMap API Key Setup

1. Generated a personal API key from the [OpenWeatherMap Developer Platform](https://openweathermap.org/api).
2. Created an `.env` file at the root of the project to securely store the API key, keeping it out of version control via `.gitignore`.
3. Integrated the API into the project by loading the environment parameters and accessing them inside `lib/services/api_service.dart`.
4. Used this key in the string query parameters to authenticate all HTTP calls to the OpenWeatherMap API.

```dart
class ApiService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // OpenWeatherMap API Key
  String get _apiKey {
    return dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';
  }
  // ...
}
```

---

## Tech Note

### 1. Executive Summary

Weather Companion is a Flutter application designed for searching, viewing, and tracking real-time weather data and multi-day forecasts via the OpenWeatherMap API. It focuses on beautiful contextual designs, precise location-based services, and adhering to modern Material 3 design paradigms. The primary goal is to provide a seamless, dynamic user experience where the app visually transforms to reflect current weather conditions while keeping you informed.

### 2. Technology Stack & Dependencies

*   **Framework:** Flutter SDK (>= 3.11.0)
*   **State Management:** provider (^6.1.5+1)
*   **Networking:** http (^1.6.0)
*   **Environment Setup:** flutter_dotenv (^6.0.0)
*   **Location Services:** geolocator (^14.0.2)
*   **Time Formatting:** intl (^0.20.2)
*   **Loading UI Overlays:** shimmer (^3.0.0)
*   **App Icons Generation:** flutter_launcher_icons (^0.13.1)

### 3. Architecture Overview

**State Management (WeatherProvider)**
The application utilizes the `provider` package using the `ChangeNotifier` pattern for reactive state management.
*   **Centralized State:** `WeatherProvider` serves as the source of truth for the entire app, encapsulating states for `currentWeather`, `forecast` lists, `isLoading`, and `error` messages.
*   **Reactive UI:** Screens like `HomeScreen` listen to `WeatherProvider`. This allows for snappy UI updates—when a user searches for a new city or refreshes data, the application immediately reflects that transition while asynchronously handling the data fetch.

**Networking & API (ApiService)**
Network requests are isolated into a dedicated `ApiService` class.
*   **OpenWeather Integration:** The app fetches external data using the OpenWeatherMap REST API. It handles parallel architectures to pull weather either by exact geographic coordinates or by city text search.
*   **Error Handling:** Try-catch blocks and status code evaluations wrap all API calls to prevent the app from crashing on network failures, safely returning fallback UI states and throwing exceptions to the Provider.

**Geolocation Services (LocationService)**
The app features intelligent awareness through location services.
*   **Geolocator Implementation:** By hooking into the `geolocator` package, it requests the necessary permissions seamlessly and fetches a precise snapshot of the weather from the user's current physical area the moment the app boots up or they press a fallback prompt.

### 4. UI/UX and Theming

*   **Material 3 Guidelines:** The app fully embraces `useMaterial3: true`, utilizing modern layout structuring and typography.
*   **Adaptive Weather Theming:** A dynamic `WeatherBackground` widget drastically changes the application's gradient colors and overall theme based on current meteorological strings (e.g., sunny yields bright oranges, thunderstorms yield dark greys).
*   **Skeleton Skeleton Animations:** Leveraging the `shimmer` package, users are greeted with silky-smooth loading indicators when transitioning between city queries. 
*   **Glassmorphism Effects:** UI elements, like the hourly and daily forecast scrolls, use a semi-transparent container design mixed with blurred elements that elegantly sit on top of the dynamic weather background.

### 5. Security & Build Considerations

*   **API Key Management:** The OpenWeatherMap API key is secured through a local `.env` configuration file passed through `flutter_dotenv`. It is strictly masked from version control through the `.gitignore` setup, stopping the leak of private developer keys to public repositories.
*   **Dynamic Launcher Icons:** Uses the `flutter_launcher_icons` script to automatically forge and format scaled Android and iOS application icons directly from a single local image asset file, saving significant manual scaling efforts.
