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

**Hardware Components**
- **RFID Reader (RC522)**: Reads the unique ID of RFID cards.
- **Arduino Microcontroller**: Processes card IDs and communicates with Firebase.
- **Relay Module**: Controls the door locking mechanism.
- **LED and Buzzer**: Provide visual and audio feedback.
- **LCD Display (optional)**: Displays messages such as "Access Granted" or "Access Denied".

**Software Components**
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

---

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/RFID-Room-Access-System.git
cd RFID-Room-Access-System
2. Setup Firebase

Create a new Firebase project.

Enable Authentication (Email/Password for admin login).

Enable Cloud Firestore or Realtime Database.

Add your app configuration (google-services.json for Android / firebase_options.dart for Flutter).

3. Configure Arduino

Upload the RFID reading and Firebase communication code to your Arduino.

Connect the RC522 module, relay, and door lock.

Set your Firebase credentials in the Arduino sketch.

4. Run the Flutter App
flutter pub get
flutter run -d windows


(You can use Linux or macOS as well depending on your setup.)

System Workflow

Professor scans RFID card at room entrance.

Arduino reads the card ID and sends it to Firebase.

Firebase verifies:

Card authenticity

Corresponding professor’s scheduled class time

If valid, the relay activates to unlock the door.

The Flutter dashboard updates in real-time to:

Mark the room as "Occupied" (red indicator)

Log access time and professor’s name

When the session ends, the room status returns to "Available" (green indicator).

Firebase Integration

Data Structure Example (Firestore):

/rooms
   /room_A
      status: "available"
      current_user: null

/users
   /prof_1234
      name: "Dr. A. Smith"
      rfid_id: "E3F29A4"
      schedule: {
         monday: "09:00 - 11:00",
         wednesday: "13:00 - 15:00"
      }

/access_logs
   /log_001
      user: "Dr. A. Smith"
      room: "A"
      timestamp: "2025-10-30T09:05:00"
      status: "granted"

Future Enhancements

Web-based dashboard for remote supervision

Email or SMS alerts for unauthorized access attempts

Integration with attendance tracking systems

Face recognition as secondary authentication

Mobile version of the dashboard for on-site monitoring

Contributing

Fork the repository.

Create a new branch:

git checkout -b feature/your-feature


Commit your changes:

git commit -m "Add new feature"


Push to the branch and open a pull request.

License

This project is licensed under the MIT License. You are free to use, modify, and distribute this software with attribution.

Author: University Department RFID Access Team
Contact:
