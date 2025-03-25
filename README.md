
# 🏗️ Blueprint App

Blueprint is an AI-powered floor plan generation and project management mobile application. Built with Flutter for the frontend and FastAPI for the backend, Blueprint allows users to design, manage, and share floor plans in a seamless and intuitive experience.

---

## 🚀 Features

- ✨ **AI-Based Floor Plan Generation**  
  Enter a prompt or use voice input to generate 2D floor plans in seconds.

- 📂 **Project Management**  
  Create, save, rename, or delete projects directly in the app.

- 🖼️ **Community Gallery**  
  Share your generated plans with others and explore designs created by the community.

- 🎤 **Voice Prompt Input**  
  Generate floor plans using your voice for a hands-free experience.

- 👷 **Professional Marketplace**  
  Contact industry professionals or post advertisements for your own services.

- 🔒 **User Authentication**  
  Secure login and registration for each user with profile customization.

---

## 📱 Tech Stack

### Frontend
- **Flutter**
- Firebase Auth & Firestore
- Provider State Management
- Firebase Storage

### Backend
- **FastAPI** (Python)
- Uvicorn
- Matplotlib, NumPy, Pillow
- Floor plan rendering via AI model
- RESTful API to communicate with Flutter frontend

---

## 🛠️ Setup Instructions

### Backend (FastAPI)

1. Navigate to the backend directory:
```bash
cd bp_backend_floor_plan_generator
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the server:
```bash
uvicorn main:app --reload
```

---

### Frontend (Flutter)

1. Navigate to the frontend directory:
```bash
cd bp_frontend
```

2. Get Flutter dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

> Make sure your Firebase setup (Auth, Firestore, Storage) is properly configured.

---

## 📂 Folder Structure

```
Blueprint/
│
├── bp_backend_floor_plan_generator/
│   ├── main.py
│   ├── models/
│   ├── static/
│   └── ...
│
├── bp_frontend/
│   ├── lib/
│   ├── assets/
│   └── ...
```

---

## 👤 Developed By

- 👨‍💻 Backend: FastAPI Developer
- 🎨 Frontend: Flutter UI Developer
- 🧠 AI & Rendering: ML Engineer
- 🔐 Auth & DB: Firebase Admin
- 🧪 Testing: QA Engineer
- 📱 UX/UI: Mobile Experience Designer

---

## 📃 License

This project is for educational and demonstration purposes only. All rights reserved © Blueprint Team.
