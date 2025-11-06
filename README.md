# Academic Room Management System

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Web%20%26%20Mobile-green.svg)]()
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Version](https://img.shields.io/badge/version-1.0.0-orange.svg)]()

---

## Overview

The **Academic Room Management System** is a web and mobile application designed to streamline and secure the management of university classrooms.  
It enables authorized users (Admin, Professors, and Supervisors) to manage room schedules, reservations, and access permissions efficiently.

This system integrates **biometric (fingerprint) authentication** for professors, ensuring that only authorized personnel can access assigned rooms, thereby improving both **security** and **resource utilization**.

---

## Features

- **User Authentication and Role Management**  
  Secure login system with role-based permissions:  
  - **Admin:** Full control over users, rooms, and schedules.  
  - **Professor:** Can view and reserve assigned rooms; room access requires fingerprint verification.  
  - **Supervisor:** Can monitor room usage, validate access logs, and manage alerts.  

- **Biometric Access Control**  
  Professors can enter assigned rooms only through fingerprint authentication.  
  Rooms are automatically locked for other users.

- **Room Assignment**  
  Each room (“salle”) is assigned to a specific professor. Admins can reassign rooms as needed.

- **Scheduling and Reservations**  
  Simple and conflict-free reservation system for classes, labs, or meetings.

- **Real-Time Room Status**  
  Displays whether rooms are free, reserved, occupied, or under maintenance.

- **Notifications and Logs**  
  Generates access reports, alerts for unauthorized attempts, and system logs for auditing.

---

## System Architecture

1. **Frontend (Flutter):**  
   - Cross-platform interface for web and mobile devices.  
   - Responsive dashboard for all roles.  

2. **Backend (Firebase & Supabase):**  
   - Handles authentication, data storage, and access logic.  
   - Integrates with biometric (fingerprint) modules for secure access.  

3. **Database (Firestore):**  
   - Stores users, rooms, reservations, and access history.  

4. **Security Layer:**  
   - Role-based access control (RBAC).  
   - Fingerprint verification for professors.  
   - Password policy enforcing strong credentials.  

---

## Installation and Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/academic-room-management.git
   cd academic-room-management
