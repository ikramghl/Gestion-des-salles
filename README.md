<<<<<<< HEAD
# sallemanager

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# RFID-Based Room Access Control System

A smart and secure access management solution designed for university departments. The system uses RFID technology to regulate and monitor room access while providing a real-time management dashboard for the room administrator.

Only authorized professors can unlock rooms at their scheduled times using RFID cards. The manager can monitor room status, view access history, and visualize availability directly from a desktop dashboard built with Flutter and Firebase.

---

## Table of Contents
- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [System Workflow](#system-workflow)
- [Firebase Integration](#firebase-integration)
- [Dashboard Screenshots](#dashboard-screenshots)
- [Hardware Setup](#hardware-setup)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

The **RFID-Based Room Access Control System** automates and secures the access to classrooms and meeting rooms within a university department. Each professor is assigned an RFID card associated with their ID and timetable.

When a card is scanned:
- The system verifies the card ID in Firebase.
- If the access time and identity match, the door unlocks.
- The dashboard updates in real time, showing room status and logging the event.

The goal is to ensure controlled access, prevent unauthorized entry, and provide complete visibility to the room manager.

---

## System Architecture

### Hardware Components
- **RFID Reader (RC522)**: Reads the unique ID of RFID cards.
- **Arduino Microcontroller**: Processes card IDs and communicates with Firebase.
- **Relay Module**: Controls the door locking mechanism.
- **LED and Buzzer**: Provide visual and audio feedback.
- **LCD Display (optional)**: Displays messages such as "Access Granted" or "Access Denied".

### Software Components
- **Flutter Frontend (Desktop)**: Used by the room manager to visualize and manage room access.
- **Firebase Realtime Database / Firestore**: Stores user data, access logs, and schedules.
- **Firebase Authentication**: Secures dashboard access for the manager.
- **Arduino Firmware**: Handles RFID reading and door control.

---

## Features

- Secure access control using RFID authentication
- Real-time synchronization with Firebase
- Role-based dashboard (only accessible by room manager)
- Visualization of room occupancy (green = available, red = occupied)
- Access history log with timestamps
- Timetable-based access authorization
- Automatic door locking after session ends
- Audit trail for security compliance
- Modular design for scalability and maintenance

---

## Technologies Used

| Category | Technology |
|-----------|-------------|
| Frontend | Flutter (Desktop) |
| Backend | Firebase (Realtime Database / Firestore, Authentication) |
| Embedded | Arduino with RFID RC522 |
| Programming Languages | Dart, C/C++ |
| Communication | Serial / Wi-Fi (ESP8266 or similar) |
| Hardware Interface | SPI Protocol for RFID |

---

## Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Arduino IDE (1.8.x or higher)
- Firebase account
- RFID RC522 module
- Arduino board (Uno, Mega, or ESP8266)

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/RFID-Room-Access-System.git
cd RFID-Room-Access-System
```

### 2. Setup Firebase

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Authentication** (Email/Password for admin login)
3. Enable **Cloud Firestore** or **Realtime Database**
4. Download configuration files:
   - For Flutter: Download `google-services.json` (Android) or use FlutterFire CLI
   - Run: `flutterfire configure`
5. Add your app configuration to `lib/firebase_options.dart`

### 3. Configure Arduino

1. Install required libraries in Arduino IDE:
   - MFRC522 (for RFID)
   - Firebase ESP8266/ESP32 library
   - ArduinoJson

2. Open `arduino/rfid_reader.ino`

3. Update Firebase credentials:
```cpp
#define FIREBASE_HOST "your-project.firebaseio.com"
#define FIREBASE_AUTH "your-database-secret"
#define WIFI_SSID "your-wifi-name"
#define WIFI_PASSWORD "your-wifi-password"
```

4. Upload the sketch to your Arduino board

### 4. Run the Flutter App

```bash
cd flutter_dashboard
flutter pub get
flutter run -d windows
```

For Linux or macOS:
```bash
flutter run -d linux
flutter run -d macos
```

---

## System Workflow

1. **Professor scans RFID card** at room entrance
2. **Arduino reads the card ID** and sends it to Firebase
3. **Firebase verifies**:
   - Card authenticity
   - Corresponding professor's scheduled class time
   - Room availability
4. **If valid**, the relay activates to unlock the door
5. **The Flutter dashboard updates in real-time** to:
   - Mark the room as "Occupied" (red indicator)
   - Log access time and professor's name
   - Update room status display
6. **When the session ends**, the room status returns to "Available" (green indicator)

### Access Denial Scenarios
- Invalid RFID card
- Access outside scheduled time
- Room already occupied
- System maintenance mode

---

## Firebase Integration

### Data Structure (Firestore)

```
/rooms
   /room_A
      status: "available"  // "available" | "occupied" | "maintenance"
      current_user: null
      last_access: timestamp
      capacity: 50

/users
   /prof_1234
      name: "Dr. A. Smith"
      email: "a.smith@university.edu"
      rfid_id: "E3F29A4B"
      department: "Computer Science"
      schedule: {
         monday: ["09:00-11:00", "14:00-16:00"],
         wednesday: ["13:00-15:00"],
         friday: ["10:00-12:00"]
      }

/access_logs
   /log_001
      user_id: "prof_1234"
      user_name: "Dr. A. Smith"
      room_id: "room_A"
      timestamp: "2025-11-06T09:05:00Z"
      status: "granted"  // "granted" | "denied"
      reason: "scheduled_access"
```

### Real-time Updates

The Flutter dashboard listens to Firestore streams:

```dart
FirebaseFirestore.instance
  .collection('rooms')
  .snapshots()
  .listen((snapshot) {
    // Update UI with real-time room status
  });
```

---

## Dashboard Screenshots

### Main Dashboard
- Room status overview with color-coded indicators
- Real-time occupancy display
- Quick access to logs and schedules

### Access History
- Chronological log of all access attempts
- Filter by date, room, or professor
- Export functionality for reports

### Room Management
- Add/edit room details
- Set maintenance mode
- View room utilization statistics

---

## Hardware Setup

### Wiring Diagram

```
RFID RC522 → Arduino
SDA    → Pin 10
SCK    → Pin 13
MOSI   → Pin 11
MISO   → Pin 12
GND    → GND
RST    → Pin 9
3.3V   → 3.3V

Relay Module → Arduino
IN     → Pin 7
VCC    → 5V
GND    → GND

LED Indicators → Arduino
Green  → Pin 5 (Access Granted)
Red    → Pin 6 (Access Denied)

Buzzer → Arduino
Signal → Pin 8
GND    → GND
```

### Physical Installation
1. Mount RFID reader at door entry point (chest height)
2. Install relay module near door lock mechanism
3. Connect Arduino to power supply and network
4. Secure all wiring in protective conduit
5. Test system before deployment

---

## Future Enhancements

- Web-based dashboard for remote supervision
- Email or SMS alerts for unauthorized access attempts
- Integration with university attendance tracking systems
- Face recognition as secondary authentication
- Mobile version of the dashboard for on-site monitoring
- QR code backup authentication method
- Analytics dashboard with usage statistics
- Multi-campus support
- Visitor access management
- Integration with campus security systems

---

## Contributing

We welcome contributions from the community!

1. Fork the repository
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/your-feature
   ```
5. Open a pull request

### Contribution Guidelines
- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

---

## License

This project is licensed under the **MIT License**. You are free to use, modify, and distribute this software with attribution.

See the [LICENSE](LICENSE) file for details.

---

## Contact

**Project Maintainer:** University Department RFID Access Team  
**Email:** your.email@example.com  
**Project Link:** [https://github.com/your-username/RFID-Room-Access-System](https://github.com/your-username/RFID-Room-Access-System)

---

## Acknowledgments

- University Department for project support
- Firebase team for excellent documentation
- Arduino community for hardware guidance
- Flutter team for cross-platform framework

---

**Built with ❤️ for academic excellence and campus security**
>>>>>>> 1e03ceaba551a2c3d77bdcdde231d4b5bc547764
