# FamMes

FamMes - мобильное iOS-приложение, которое объединяет мессенджер и систему личных и общих заметок. Пользователь может общаться с другими участниками, создавать личные записи, вести общие заметки с выбранными людьми и хранить важные договоренности прямо рядом с перепиской.

Главная идея проекта - сделать приложение не только для общения, но и для сохранения задач, идей, планов и другой информации, которая обычно теряется в чатах.

## Основные функции

- Регистрация и вход в аккаунт.
- Сохранение текущей пользовательской сессии.
- Список чатов и поиск пользователей по имени или username.
- Создание нового диалога и отправка сообщений.
- Локальное сохранение истории сообщений.
- Личные заметки: создание, просмотр, редактирование и удаление.
- Общие заметки: выбор участников, создание и редактирование общей записи.
- Профиль пользователя с аватаром и описанием.
- Экран аккаунта с советом дня.
- Поддержка светлой и темной темы.

## Архитектура

Проект построен по MVVM. SwiftUI-экраны отвечают за интерфейс, ViewModel хранит состояние экранов и бизнес-логику, а работа с данными вынесена в репозитории. Для хранения пользователей, чатов, сообщений, заметок и текущей сессии используется SwiftData.

```text
projectFamMes/
├── Models/                 # Доменные модели: User, Chat, Message, Notes, Room
├── NotesView/              # Экраны личных и общих заметок
├── ChatsView/              # Список чатов и экран переписки
├── AccountView/            # Профиль и карточка совета дня
├── UIKitIntegration/       # Интеграция PHPicker для выбора изображения
└── Data/
    ├── Presentation/       # ViewModel для Auth, Notes, Chats, FamilyTip
    ├── Mocks/              # Mock-репозитории для демо-данных
    ├── Services/           # FamilyTipService и сетевой сервис
    ├── SwiftDataEntities.swift
    ├── SwiftDataChatRepository.swift
    └── SwiftDataNotesRepository.swift
```

Основные слои:

- `View`: `LoginView`, `RootView`, `NotesHomeView`, `ChatView`, `AccountView`.
- `ViewModel`: `AuthViewModel`, `NotesViewModel`, `ChatsHomeViewModel`, `ChatViewModel`, `FamilyTipViewModel`.
- `Repository`: `ChatRepository`, `NotesRepository`, `SwiftDataChatRepository`, `SwiftDataNotesRepository`.
- `Model`: `User`, `Chat`, `Message`, `PersonalNote`, `SharedNote`, `FamilyTip`.
- `Persistence`: SwiftData entities для локального хранения данных.

Dependency Injection используется для передачи репозиториев и сервисов снаружи. Благодаря этому mock-реализации можно заменять на SwiftData или будущий серверный API без полной переработки интерфейса.

## Используемые технологии

- Swift
- SwiftUI
- SwiftData
- Observation / `@Observable`
- MVVM
- Dependency Injection
- XCTest
- Kingfisher `8.9.0`
- PhotosUI / UIKit integration

## Как запустить проект

1. Откройте проект в Xcode:

```bash
open projectFamMes/projectFamMes.xcodeproj
```

2. Выберите схему `projectFamMes`.
3. Выберите iPhone Simulator или реальное iOS-устройство.
4. Нажмите `Run` в Xcode.

Для запуска из терминала нужен установленный полный Xcode и выбранный developer directory:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcodebuild -project projectFamMes/projectFamMes.xcodeproj \
  -scheme projectFamMes \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

Если симулятор с таким именем отсутствует, посмотрите доступные устройства командой:

```bash
xcrun simctl list devices available
```

## Как запустить тесты

Через Xcode:

1. Откройте `projectFamMes/projectFamMes.xcodeproj`.
2. Выберите схему `projectFamMes`.
3. Нажмите `Product` -> `Test` или используйте `Cmd + U`.

Через терминал:

```bash
xcodebuild test \
  -project projectFamMes/projectFamMes.xcodeproj \
  -scheme projectFamMes \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

В проекте есть unit-тесты для `NotesViewModel`: проверяется успешная загрузка заметок, пустое состояние, обработка ошибки, создание и удаление личной заметки.

## Какие LLM-инструменты использовались

- OpenAI Codex - анализ структуры проекта, извлечение информации из презентации и подготовка README.

## Скриншоты

| Вход | Регистрация | Чаты |
| --- | --- | --- |
| <img src="docs/screenshots/login.png" width="220" alt="Экран входа"> | <img src="docs/screenshots/register.png" width="220" alt="Экран регистрации"> | <img src="docs/screenshots/chats.png" width="220" alt="Список чатов"> |

| Переписка | Заметки | Редактирование общей заметки |
| --- | --- | --- |
| <img src="docs/screenshots/chat.png" width="220" alt="Экран переписки"> | <img src="docs/screenshots/notes.png" width="220" alt="Список заметок"> | <img src="docs/screenshots/shared-note-edit.png" width="220" alt="Редактирование общей заметки"> |

| Аккаунт |
| --- |
| <img src="docs/screenshots/account.png" width="220" alt="Экран аккаунта"> |
