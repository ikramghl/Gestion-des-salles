# RFID-Based Academic Room Management and Monitoring System

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Web%20%2B%20Arduino-green.svg)]()
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Version](https://img.shields.io/badge/version-1.2.0-orange.svg)]()

---

## Overview

The **RFID-Based Academic Room Management and Monitoring System** is a hybrid web and embedded solution designed to automate, secure, and monitor the usage of rooms within an academic department.  

The project integrates:
- A **web application** for administrators, professors, and supervisors to manage schedules, reservations, and access rights.
- A **hardware module** based on **Arduino Nano** and **RFID** technology to control physical access to rooms.  

The main goal is to ensure that only authorized professors can access assigned rooms, reduce scheduling conflicts, and provide real-time monitoring through an intuitive online dashboard.

---

## Objectives

- Secure physical access to rooms using RFID authentication.  
- Simplify scheduling and room reservation management.  
- Provide real-time room status (Free, Reserved, Occupied, Maintenance).  
- Automatically log all access events for auditing and monitoring.  
- Offer a unified dashboard accessible via the web.

---

## System Components

### 1. **Web Application (Management & Monitoring Layer)**

#### Roles and Permissions
- **Admin**  
  - Manage user accounts (add/remove professors and supervisors).  
  - Configure room details (capacity, equipment, location).  
  - Assign rooms to professors.  

- **Professor**  
  - Reserve rooms for classes or labs.  
  - Access assigned rooms using an RFID card.  
  - View personal schedules and access logs.  

- **Supervisor**  
  - Monitor room usage in real time.  
  - Validate system logs and detect anomalies (unauthorized attempts).  
  - Generate usage and attendance reports.  

#### Main Functionalities
- Authentication and secure login (Firebase).  
- Real-time room monitoring dashboard (Flutter Web).  
- Conflict-free scheduling and reservations.  
- Visual indicators for room status.  
- Notifications for access events and system alerts.  
- Exportable logs (CSV / PDF).  

---

### 2. **Hardware Module (Access Control Layer)**

#### Hardware Components
- **Microcontroller:** Arduino Nano (recommended for compact size).  
- **RFID Reader:** RC522 module to read authorized RFID tags.  
- **Relay Module:** Controls door lock mechanism or indicator circuit.  
- **Buzzer and LEDs:** Indicate access status (Granted / Denied).  
- **Power Supply:** 5V regulated.  
- **WiFi Module (optional):** ESP8266 or ESP01 for online synchronization.

#### Operating Principle
1. Professor presents RFID card at room entrance.  
2. Arduino Nano reads the card’s unique ID.  
3. The system checks the card ID:
   - If authorized and room assigned → Door unlocks, access logged.  
   - If unauthorized → Access denied, buzzer and red LED activated.  
4. Access data is sent to Firebase for synchronization with the web dashboard.  
5. Admins and supervisors can view access events in real time.

---

## System Architecture

The solution operates across two integrated layers:

