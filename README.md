# Water Pump SMS Industrial Controller 🚀

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Profile](https://img.shields.io/badge/Author-Alireza%20Hasanzadeh-blue?style=for-the-badge&logo=github)](https://github.com/pxf0rge)

> **Industrial IoT & agricultural water pump control via encrypted SMS commands.**  
> کنترلر صنعتی و کشاورزی پمپ‌های آب از راه دور از طریق دستورات پیامکی امن.

---

## 🌟 Key Features / قابلیت‌های کلیدی

### English
- Remote ON/OFF pump control
- Status & water flow querying
- Scheduled irrigation timers
- Hive DB history & telemetry log

### فارسی
- خاموش/روشن کردن پمپ آب از راه دور بدون نیاز به اینترنت
- استعلام وضعیت، ولتاژ و سنسورهای فشار
- تنظیم زمان‌بندی هوشمند آبیاری
- ثبت تاریخچه عملکرد و تله‌متری در Hive

---

## 🛠 Tech Stack / تکنولوژی‌های استفاده‌شده

`Flutter` `Telephony` `Hive` `Background Messenger`

- **Framework:** Flutter (Null-safety)
- **Language:** Dart
- **Architecture:** Clean Architecture & Modular Structure
- **Target Platforms:** Android, iOS, Web, Desktop (Linux, macOS, Windows)

---

## 🚀 Getting Started / راه‌اندازی پروژه

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extension

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/pxf0rge/water-pump-sms-controller.git
   cd water-pump-sms-controller
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure / ساختار پوشه‌ها

```
lib/
├── core/          # Core utilities, constants, theme, and network helpers
├── data/          # Models, repositories, and data sources (local / remote)
├── domain/        # Business logic, entities, and use cases
└── presentation/  # UI screens, widgets, controllers / state management
```

---

## 👤 Author / توسعه‌دهنده

**Alireza Hasanzadeh**
- GitHub: [@pxf0rge](https://github.com/pxf0rge)
- Email: [pxforge@proton.me](mailto:pxforge@proton.me)
- Location: Iran

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.
