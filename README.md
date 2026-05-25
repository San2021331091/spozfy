<p align="center">
  <img src="assets/icon.png" width="120" alt="Spozfy Logo">
</p>
# Spozfy – Live Sports Streaming Platform

A complete live sports streaming platform built with:

* **Flutter Mobile App** (Android)
* **Go Fiber Backend API**
* **Node.js Admin Panel**
* **PostgreSQL Database**

This project allows administrators to manage live sports streams, notifications, banners, and content while users watch live sports directly from the Flutter app.

---

# Tech Stack

## Mobile App

* Flutter 3
* GetX
* Dio
* Video Player
* Shared Preferences
* Local Notifications

## Backend API

* Go 1.26.3
* Fiber v2
* PostgreSQL
* UUID
* Godotenv

## Admin Panel

* Node.js
* Express
* AdminJS
* Sequelize
* PostgreSQL

---

# Project Structure

```bash
spozfy/
│
├── backend/          # Go Fiber API
├── adminpanel/       # Node.js Admin Dashboard
├── lib/           # Flutter App
└── README.md
```

---

# Features

## Flutter App

* Live sports streaming
* Match banners
* Push notifications
* Cached images
* External link support
* Video playback
* Dark modern UI

## Backend API

* REST API
* PostgreSQL integration
* Environment configuration
* UUID-based resources
* JSON APIs

## Admin Panel

* Manage matches
* Manage live streams
* Manage banners
* Manage notifications
* Database management UI

---

# Backend Setup (Go Fiber)

## Requirements

* Go 1.26+
* PostgreSQL

## Install Dependencies

```bash
go mod tidy
```

## Environment Variables

Create `.env`


## Run Backend

```bash
go run main.go
```

Backend runs on:

```bash
http://localhost:8000
```

---

# Admin Panel Setup

## Requirements

* Node.js 20+
* PostgreSQL

## Install Dependencies

```bash
npm install
```

## Environment Variables

Create `.env`

## Run Admin Panel

```bash
node index.js
```

Admin panel runs on:

```bash
http://localhost:3000
```

---

# Flutter App Setup

## Requirements

* Flutter SDK 3.3+
* Android Studio

## Install Packages

```bash
flutter pub get
```

## Create `.env`


## Run App

```bash
flutter run
```

---

# Flutter Dependencies

```yaml
dio
get
flutter_dotenv
video_player
cached_network_image
shared_preferences
flutter_local_notifications
url_launcher
```


---

# Database

PostgreSQL is used for:

* Matches
* Streams
* Notifications
* Banners
* Users

---

# Production Deployment

## Backend

Build binary:

```bash
go build -o spozfy-backend
```

Run:

```bash
./spozfy-backend
```

## Flutter APK

```bash
flutter build apk --release
```

APK output:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

---

# Recommended Server

* Ubuntu 22.04
* Nginx
* PostgreSQL 15+
* PM2 (for admin panel)

---

# Security Notes

* Never expose `.env`
* Use HTTPS in production
* Validate stream URLs
* Protect admin routes
* Use strong session secrets

---

# License

MIT License

---

# Author

Spozfy Team


# APK Link : [Download apk](https://drive.google.com/file/d/16UIXtmVeGMznD-HgVigMtNjF63yOCZp6/view?usp=sharing)
# AAB Link : [Download aab](https://drive.google.com/file/d/1K9d_QAODz19sa87u9cE-dS9ER1yBER1z/view?usp=sharing)

# Landing page link: (https://soft-khapse-d251f4.netlify.app/)