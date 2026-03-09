# 📱 Flutter Hybrid App Packaging Framework

이 프로젝트는 웹 기반 서비스를 모바일 앱으로 신속하게 전환하고, 네이티브 기능을 유연하게 확장할 수 있도록 설계된 **Flutter 하이브리드 앱 전용 프레임워크**입니다. 

2023년 10월 마지막 업데이트를 기점으로 안정화되었으며, 반복되는 하이브리드 앱 구축 로직을 모듈화하여 생산성을 극대화하는 데 초점을 맞췄습니다.

---

## 🏗 프로젝트 구조 (Architecture)

본 프레임워크는 관심사 분리(SoC)를 위해 **Layered & Modular Architecture**를 채택하고 있습니다.

### 📂 `lib/basic`
앱의 전반적인 동작을 제어하는 코어 로직이 포함되어 있습니다.
- **base / config / const / data**: 앱의 전역 설정, 상수, 데이터 모델 관리.
- **routes**: 네이티브 페이지 및 딥링크 라우팅 엔진.
- **views**: 메인 웹뷰 컨테이너 및 공통 UI 컴포넌트.
- **util**: 앱 전반에서 사용되는 유틸리티 함수군.

### 📂 `lib/modules` (Modular Extensions)
네이티브 기능별로 독립된 모듈 구조를 가집니다. 필요한 기능을 쉽게 추가하거나 제거할 수 있습니다.
- **sns_login**: 카카오, 구글, 네이버 등 통합 로그인 처리 (`sns_login_manager.dart`).
- **fcm**: Firebase 기반 푸시 알림 및 토큰 관리 로직.
- **bootpay**: 하이브리드 결제 연동 모듈.
- **background_location**: 백그라운드 위치 정보 수집 기능.
- **camera / sound / alarm**: 기기 하드웨어 제어 모듈.
- **dynamic_link / instagram**: 외부 공유 및 앱 전환 최적화.

### 📂 Root Files
- `hybrid_app.dart`: 앱의 메인 엔트리 포인트 및 위젯 트리 구성.
- `hybrid_manager.dart`: **Web-to-Native / Native-to-Web** 브릿지 통신 총괄.
- `main_init.dart`: 앱 구동 전 필요한 비동기 초기화(Firebase, 로그 등) 로직 집중 관리.

---

## ✨ 주요 특징 (Key Features)

- **High Modularity**: 각 기능(로그인, 결제, 푸시 등)이 `modules` 단위로 파편화되어 있어 유지보수가 용이합니다.
- **Bridge Integration**: `hybrid_manager.dart`를 통해 JavaScript 채널 통신을 중앙 집중식으로 관리합니다.
- **Flexible Scalability**: 새로운 네이티브 기능 필요 시 `lib/modules`에 추가하는 것만으로 확장이 가능합니다.
- **Production Ready**: 2023년 10월 기준 안정화된 패키징 구조를 제공합니다.

---

## 🚀 시작하기

1. **의존성 설치**
   ```bash
   flutter pub get