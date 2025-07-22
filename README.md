# NotiSKKU

> **노티스꾸**: 한눈에 보이는 공지 모음 앱  
> 성균관대학교 재학생이라면 누구나 자신의 과와 관심 분야에 맞춘 공지사항을 빠르게 확인할 수 있다!

## 📖 개요
- **프로젝트 이름**: notiskku  
- **설명**:  
  - 성균관대학교 재학생을 위한 공지사항 통합!
  - 자신의 학과, 단과대, 키워드를 기준으로 필터링된 공지사항을 한눈에 확인 가능!
  - 즐겨찾기, 키워드 알림, 학사일정 달력 기능 제공!

## 🚀 주요 기능
1. **사용자 설정**  
   - 학과 선택  
   - 관심 키워드 및 알림 키워드 설정  
2. **홈 화면**  
   - 전체·단과대·학과별 공지사항 탭  
   - 필터링된 키워드별 공지사항  
   - 즐겨찾기(별표) 등록  
3. **키워드 알림**  
   - 설정한 키워드가 포함된 새 공지사항에 대한  푸시 알림  
4. **학사일정 달력**  
   - 주요 학교 이벤트 달력 뷰  
5. **Cross‑Platform**  
   - Android & iOS 지원

## 🏗 프로젝트 구조
```text
notiskku/
├─ lib/
│ ├─ data/
│ ├─ models/
│ ├─ notice_functions/
│ ├─ providers/
│ ├─ screen/
│ ├─ tabs/
│ ├─ edit/
│ ├─ services/
│ └─ widget/
├─ assets/
├─ test/
└─ pubspec.yaml
```

## 디렉터리 설명

- **lib/data/**  
  키워드·학과 데이터를 담고 있는 파일들  
- **lib/models/**  
  앱에서 사용하는 데이터 모델 정의  
- **lib/notice_functions/**  
  공지 크롤링·URL 실행 등 공지 관련 로직  
- **lib/providers/**  
  상태 관리(Riverpod/Provider) 모듈  
- **lib/screen/**  
  온보딩·메인 탭 등 화면 전체 스크린  
- **lib/tabs/**  
  메인 탭별 하위 화면(공지·검색·키워드 등)  
- **lib/edit/**  
  편집용 화면(편집 스크린)  
- **lib/services/**  
  SharedPreferences 등 서비스 레이어  
- **lib/widget/**  
  재사용 UI 컴포넌트(버튼·다이얼로그·바·검색·리스트)  
- **assets/**  
  이미지·폰트 등 정적 리소스  
- **test/**  
  단위 테스트 코드  

## ⚙️ 설치 및 실행

### ✅ 요구 사항

- Flutter SDK 
- Dart 
- Android Studio / Xcode (최신 버전 권장)

### 📦 설치

```text
git clone https://github.com/your-org/notiskku.git
cd notiskku
flutter pub get
```

### ▶️ 실행

#### Android
```text
flutter run -d android
```

#### iOS
```text
flutter run -d ios
```


## 📌 커밋 컨벤션

| 태그 | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `design` | UI/UX 변경 |
| `style` | 코드 포맷 (기능 변경 없음) |
| `refactor` | 코드 구조 개선 |
| `docs` | 문서/주석 변경 |
| `test` | 테스트 코드 추가/수정 |
| `chore` | 번들/패키지 설치, 빌드 설정 |
| `rename` | 파일/폴더명 변경 |
| `ci` | CI/CD 설정 변경 |
| `perf` | 성능 최적화 |
| `revert` | 이전 커밋 되돌리기 |


## 📸 스크린샷

> 추가 예정

<!--
![온보딩 화면](assets/images/onboarding.png)
![홈 화면](assets/images/home.png)
![달력 화면](assets/images/calendar.png)
-->


## 📝 라이선스

This project is licensed under the **MIT License**.\
See the [LICENSE](./LICENSE) file for details.


## 🙋‍♂️ 기여 방법

1. 이 저장소를 **Fork** 합니다.  
2. 새로운 브랜치를 생성합니다.  

```text
git checkout -b feature/XYZ
```

3. 커밋 메시지 컨벤션을 지켜서 커밋합니다.  
4. Pull Request를 생성 후 리뷰를 요청합니다.

## ❓ 추가할 내용 (TODO)

- [ ] 