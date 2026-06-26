# AttendanceApp

A modern, geolocation-based attendance management application built with Flutter. Designed for company that need a reliable and precise way to track employee clock-ins based on their physical location.

---

## 📋 Overview

AttendanceApp allows employees to clock in only when they are physically within a defined radius (50 meters) of their registered office location. Admins can manage office locations, monitor attendance logs, and maintain a full history of employee check-ins — all from within the app.

---

## ✨ Features

### 👤 User
- **Geofenced Clock-In**: Submit attendance only when within 50 meters of a registered work location.
- **Location Selector**: Choose from a list of registered office locations before clocking in.
- **Status Tracking**: Attendance is automatically marked as **On Time** (before 09:00) or **Late** (09:00 and after).

### 🛠️ Admin
- **Location Management**: Add, edit, and delete work office locations.
- **Map Picker**: Pinpoint office coordinates directly on an interactive map with Light/Dark mode support.
- **Attendance Logs**: View a full history of all employee clock-ins, grouped by date.
- **Log Management**: Delete individual logs or clear the entire history.

---

## 🏗️ Architecture

This project follows a **Clean Architecture** approach with a feature-first folder structure:

```
lib/
├── core/
│   └── services/          # Shared services (LocationService)
└── modules/
    ├── attendance/         # Clock-in logic and UI
    ├── location/           # Office location management & Map Picker
    ├── login/              # Authentication
    └── report/             # Attendance logs & Admin reporting
```

Each module follows the BLoC/Cubit pattern:
- `data/` — Models & local data sources (Hive)
- `presentation/` — Screens, Widgets, and Cubits

---

## 📦 Key Dependencies

| Package | Purpose |
|:---|:---|
| `flutter_bloc` | State management |
| `hive_flutter` | Local data persistence |
| `flutter_map` + `latlong2` | Interactive map rendering |
| `geolocator` | Real-time GPS positioning |
| `flutter_animate` | Premium UI animations |
| `uuid` | Unique ID generation for logs |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Android device/emulator with Location Services enabled

### Installation

```bash
# Clone the repository
git clone https://github.com/RafiPutraa/attendance_app.git

# Navigate to the project directory
cd attendance_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Permissions

Ensure the following permissions are declared in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

---

## 🔗 Repository

> **GitHub**: [\[Link to Repository\]](https://github.com/RafiPutraa/attendance_app)

