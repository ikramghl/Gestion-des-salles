# RFID-Based Academic Room Management System

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Web%20%26%20Arduino-green.svg)]()
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Version](https://img.shields.io/badge/version-1.1.0-orange.svg)]()

---

## Overview

The **RFID-Based Academic Room Management System** is a hybrid web and embedded solution designed to modernize and secure the management of university classrooms.  
It allows authorized users (Admins, Professors, Supervisors) to manage rooms, schedules, and access permissions through a web interface, while **physical access to rooms** is controlled via **RFID authentication** connected to an **Arduino Nano** microcontroller.

This system eliminates unauthorized room usage, prevents scheduling conflicts, and provides real-time visibility of room availability and access logs.

---

## Features

- **RFID Authentication for Physical Access**  
  Each authorized professor is assigned an RFID card.  
  The Arduino Nano scans RFID tags and grants or denies access based on data stored in the Firebase database.  

- **User Roles and Permissions**  
  - **Admin:** Manages users, rooms, and schedules.  
  - **Professor:** Can reserve assigned rooms and access them via RFID.  
  - **Supervisor:** Monitors access events and room status.  

- **Room Assignment**  
  Each room is assigned to a professor. Unauthorized cards cannot unlock or activate the room.  

- **Real-Time Monitoring**  
  Dashboard displays room occupancy (Free, Reserved, Occupied, Maintenance) in real time.

- **Reservation Management**  
  Professors can reserve rooms for classes or labs through the web interface.  
  Conflict detection prevents double booking.

- **Access Logging**  
  Every RFID scan (granted or denied) is recorded in the system for security auditing.

---

## System Architecture

The system is divided into two main layers:

### 1. Web Application (Management Layer)
- **Frontend:** Flutter  
- **Backend:** Firebase & Supabase  
- **Database:** Firestore (stores user, room, and reservation data)  
- **Authentication:** Email/password login for Admin and Supervisor roles  

### 2. Embedded Access Control (Hardware Layer)
- **Microcontroller:** Arduino Nano (recommended for compact and efficient control)  
- **RFID Reader:** RC522 module to read tag IDs  
- **Relay Module:** Controls the door lock or electronic mechanism  
- **LED & Buzzer:** Provide feedback (Access Granted / Denied)  
- **Communication:** Arduino interacts with Firebase or a local server to validate access  

---

## Installation and Setup

### Web Application
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/rfid-room-management.git
   cd rfid-room-management
