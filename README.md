# RFID-Based Room Access Control System

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Arduino-green.svg)]()
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Version](https://img.shields.io/badge/version-1.0.0-orange.svg)]()

---

## Overview

The **RFID-Based Room Access Control System** is a security solution designed to regulate and monitor access to a restricted area using RFID (Radio Frequency Identification) technology. Each authorized user is provided with an RFID tag that grants entry when scanned by the system. Unauthorized tags trigger a denial response, ensuring secure and reliable access management.

This project demonstrates how embedded systems and IoT concepts can be integrated to enhance physical security through automation.

---

## Features

- Secure room access using RFID authentication  
- Real-time access validation and control  
- LCD feedback display for user interaction  
- LED and buzzer indicators for access status  
- Modular code structure for easy updates and scalability  
- Optional database or IoT integration for logging access events  

---

## System Architecture

The system consists of the following key components:

1. **RFID Reader (RC522):** Reads unique tag IDs.  
2. **Arduino Microcontroller:** Processes input data and controls outputs.  
3. **LED & Buzzer:** Provide visual and audible access status feedback.  
4. **Relay (optional):** Controls door locking mechanism.  
5. **LCD Display:** Displays messages such as "Access Granted" or "Access Denied."  
6. **Power Supply:** Provides regulated voltage to the system components.

