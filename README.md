# Mental Health Companion 

A comprehensive, full-stack mental health support application designed to provide emotional guidance, mood tracking, relaxation utilities, and crisis support. 

Developed as a **Major Project** for the **BCA 6th Semester**.

---

##  Project Overview
In today’s fast-paced world, stress, anxiety, and mental health challenges have become increasingly prevalent. The **Mental Health Companion** is designed to serve as a secure, personal space for users to monitor their emotional well-being. By combining modern mobile application design (Flutter) with secure backend microservices (Node.js/Express) and relational database persistence (PostgreSQL), the app offers a variety of tools to guide users toward better mental health.

---

##  Core Features

### 1.  Dual-Language AI Virtual Therapist
* **Bilingual Emotional Support:** Integrated with Google's **Gemini-1.5-Flash** API to act as a virtual therapist in both **English** ([chatbot.dart](FRONTEND/mental_health_app/lib/chatbot.dart)) and **Malayalam** ([mallu_chatbot.dart](FRONTEND/mental_health_app/lib/mallu_chatbot.dart)).
* **Context-Aware Conversations:** Personalized greeting based on the user's registered name and a warm, empathetic therapy-focused prompting style.
* **Persistent Logs:** All chat histories are securely logged on the PostgreSQL server for reference.

### 2.  Mood Tracker & Interactive Analytics
* **Daily Mood Logging:** Users select from various emotional states (Happy, Sad, Angry, Calm, Anxious) and append a personal note ([mood_tracker.dart](FRONTEND/mental_health_app/lib/mood_tracker.dart)).
* **Data Visualization:** Built-in analytics engine that groups mood history and renders a clean, interactive **Pie Chart** using `fl_chart` to highlight emotional trends ([progress_tracking.dart](FRONTEND/mental_health_app/lib/progress_tracking.dart)).

### 3.  Calm Sounds Hub
* **Audio Streaming:** Calming soundscapes categorized into nature sounds (Gentle Rain, Ocean Waves, Stream Water, Calm Forest, Birds Chirping) and acoustic melodies (Soft Piano, Meditation Bells) ([calm_music.dart](FRONTEND/mental_health_app/lib/calm_music.dart)).
* **Background Playback:** Utilizes `just_audio` and `audio_service` to allow seamless background streaming while navigating other parts of the app.

### 4.  Relaxation Game: "Calm Tap"
* **Mindfulness Tap Utility:** An interactive game where a circle expands and contracts in a slow, rhythmic 3-second cycle simulating breathing. Users tap when the circle reaches its ideal size ([relaxation_game.dart](FRONTEND/mental_health_app/lib/relaxation_game.dart)).
* **Immediate Feedback:** Promotes mindfulness and focus, helping users regulate breathing patterns during stressful episodes.

### 5.  Emergency Help Center
* **Crisis Hotlines:** Direct access to major Indian national helplines including snehi, AASRA, iCall, Kiran, and the Vandrevala Foundation ([emergency_help.dart](FRONTEND/mental_health_app/lib/emergency_help.dart)).
* **One-Tap Quick Actions:** Direct dial and SMS capabilities using `url_launcher`.
* **Custom Emergency Contacts:** Users can add and manage personal emergency contacts, stored securely using `SharedPreferences`.

### 6.  Habit & Daily Task Planner
* **Daily Checklists:** An interactive task dashboard to complete micro-habits (drinking water, taking a walk, listing gratitudes) ([tasks.dart](FRONTEND/mental_health_app/lib/tasks.dart)).
* **Progress Tracking & Achievements:** Gamified achievements like "Goal Master" or "Halfway There" dynamically unlocked based on task completion rates.

---

##  Tech Stack

| Layer | Technology | Key Packages / Libraries |
| :--- | :--- | :--- |
| **Frontend** | **Flutter (Dart)** | `fl_chart`, `just_audio`, `shared_preferences`, `url_launcher`, `http` |
| **Backend** | **Node.js (Express)** | `express`, `bcrypt`, `cors`, `pg` (PostgreSQL client), `axios` |
| **Database** | **PostgreSQL** | Relational queries, foreign keys, cascade deletes |
| **APIs** | **Google Gemini API** | `gemini-1.5-flash` model for conversational NLP |

---

##  System Architecture & Diagrams

The project employs a robust **Client-Server Architecture** utilizing HTTP REST APIs for communication.

* **DFD Level 0 (Context Diagram):** Illustrates the high-level data flow between the user, the app client, the server, and external APIs (Gemini).
* **DFD Level 1:** Details the internal sub-processes such as user registration, mood logging, chatbot processing, and analytics retrieval.
* **ER Diagram:** Outlines the relational database tables, attributes, primary/foreign key mappings, and entity relationships.

### View Diagrams:
📁 **[Entity Relationship (ER) Diagram](ER_Diagram.png)**  
📁 **[MHC Level 0 Data Flow Diagram](MHC_LEVEL_0_DFD.png)**  
📁 **[MHC Level 1 Data Flow Diagram](MHC_LEVEL_1_DFD.png)**  

---

##  Database Schema

Run the following SQL commands to initialize the PostgreSQL database schema for the application:

```sql
-- 1. Create Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. Create Mood Logs Table
CREATE TABLE mood_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    mood VARCHAR(50) NOT NULL,
    note TEXT,
    logged_at TIMESTAMP DEFAULT NOW()
);

-- 3. Create Chat Logs Table
CREATE TABLE chat_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    response TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

---

##  Getting Started

###  Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd BACKEND
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure your environment variables. Create a `.env` file in the `BACKEND` directory:
   ```env
   DB_HOST=localhost
   DB_USER=your_postgres_username
   DB_PASSWORD=your_postgres_password
   DB_NAME=mental_health_app
   DB_PORT=5432
   GEMINI_API_KEY=your_gemini_api_key
   ```
4. Start the server using Nodemon (for hot reloading):
   ```bash
   npm start
   ```
   *The server runs by default on `http://localhost:5000`.*

###  Frontend Setup
1. Navigate to the Flutter app directory:
   ```bash
   cd FRONTEND/mental_health_app
   ```
2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```
3. Configure your API base URL. Update [config.dart](FRONTEND/mental_health_app/lib/config.dart) with your local machine's IP address (needed for connecting virtual/physical mobile devices to local server):
   ```dart
   class Config {
     static const String baseUrl = "http://192.168.XXX.XXX:5000";
   }
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

##  Project Structure

```text
MENTAL_HEALTH_APP/
├── BACKEND/
│   ├── .env                  # Configuration variables
│   ├── db.js                 # PostgreSQL Pool connection initialization
│   ├── index.js              # Express core server and authentication endpoints
│   ├── chatbot.js            # Gemini API integration router
│   ├── moodLogs.js           # Mood tracking database transaction endpoints
│   └── package.json          # Node dependencies
├── FRONTEND/
│   └── mental_health_app/
│       ├── lib/
│       │   ├── calm_music.dart       # Relaxation audio player
│       │   ├── chatbot.dart          # English AI therapist UI
│       │   ├── mallu_chatbot.dart    # Malayalam AI therapist UI
│       │   ├── mood_tracker.dart     # Mood logger & Pie Chart analytics
│       │   ├── progress_tracking.dart# Dashboard & task reports
│       │   ├── relaxation_game.dart  # Calm Tap breathing game
│       │   ├── emergency_help.dart   # crisis hotlines & custom contact dialer
│       │   ├── tasks.dart            # To-do checklist UI
│       │   ├── home.dart             # Home dashboard with quick actions
│       │   ├── login.dart            # User login verification
│       │   ├── register.dart         # User signup
│       │   └── main.dart             # Route registry & Theme setting
│       └── pubspec.yaml              # Flutter dependency manifests
├── ER_Diagram.png                    # System database visual mapping
├── MHC_LEVEL_0_DFD.png               # High level Context Diagram
└── MHC_LEVEL_1_DFD.png               # Process level Data Flow Diagram
```

---

##  Future Enhancements
* **Appointment Booking:** Add scheduling modules for certified clinical psychologists and mental health counselors.
* **Sentiment Trend Alerts:** Automatic warning triggers to reach out to emergency contacts if logged mood trends decline consecutively for 7 days.
* **Offline Synchronization:** Local SQLite database support to sync local data seamlessly back to the main PostgreSQL server when network connectivity is restored.
* **Group Support Forums:** Secure, peer-to-peer anonymous community chatrooms.
