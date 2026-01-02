# EcoHabits 🌱

EcoHabits adalah aplikasi pelacak kebiasaan ramah lingkungan yang dibangun menggunakan Flutter. Proyek ini dikembangkan dengan fokus utama pada **Quality Assurance**, **Testing**, dan **Clean Code Architecture**.

---

## 📊 Status Pengujian & Kualitas Kode

Proyek ini telah memenuhi standar pengujian sistem sebagai berikut:

| Kriteria | Status | Tools / Metode |
| :--- | :--- | :--- |
| **Unit Testing** | ✅ **Passed** | `flutter test` (TDD) |
| **Static Code Analysis** | ✅ **Clean** | Flutter Lints (`analysis_options.yaml`) |
| **Code Coverage** | 📈 **> 80%** | LCOV Report |
| **CI/CD Pipeline** | ✅ **Active** | GitHub Actions |
| **Security** | 🛡️ **Grade A** | SonarQube Analysis |
| **Reliability** | 💎 **Grade A** | SonarQube Analysis |
| **Maintainability** | 🛠️ **Grade A** | SonarQube Analysis |

---

## 🚀 Fitur Pengujian (Testing Strategy)

### 1. Unit Testing (TDD)
Kami menerapkan **Test-Driven Development (TDD)** untuk memastikan logika bisnis valid sebelum kode implementasi ditulis.
- **Lokasi Test:** `test/validator_test.dart`
- **Lokasi Logic:** `lib/utils/validator.dart`
- **Cara Jalankan:**
  ```bash
  flutter test