# 🕐 Hoya - History's Own Your Adventure

> An AI-powered interactive storytelling app that takes you through different eras of history and mythology

[![Flutter](https://img.shields.io/badge/Flutter-3.10.7+-02569B?logo=flutter)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-3.2.0-5CB3FF)](https://riverpod.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Enabled-3ECF8E)](https://supabase.com)

## ✨ Features

- 🤖 **AI-Generated Stories** - Dynamic narratives powered by Google Gemini 1.5
- 🎨 **Era-Based Theming** - Immersive UI that adapts to different historical periods
- 📖 **Interactive Storytelling** - Make choices that shape your journey
- 🔐 **User Authentication** - Secure login with Supabase
- 💾 **Progress Tracking** - Save and resume your stories
- 📱 **Cross-Platform** - iOS, Android, Web, Desktop support
- 🌍 **Global Mythology** - Stories from Americas, Africa, Europe, Asia, and Oceania

## 🏗️ Architecture

**Hoya** follows a clean, feature-first architecture:

- **State Management:** [Riverpod 3](https://riverpod.dev) with code generation
- **Backend:** [Supabase](https://supabase.com) for authentication and database
- **Navigation:** [go_router](https://pub.dev/packages/go_router) with auth guards
- **AI:** [Google Gemini](https://ai.google.dev) 1.5 Flash for story generation
- **UI/UX:** flutter_animate, Google Fonts, Lottie animations

### Project Structure

```
lib/
├── core/
│   ├── ai/              # Gemini AI service
│   ├── config/          # Supabase configuration
│   ├── errors/          # Error handling & exceptions
│   ├── theme/           # Era-based theming
│   ├── utils/           # Logging and utilities
│   └── router.dart      # Navigation configuration
├── features/
│   ├── auth/            # Authentication
│   ├── portal/          # Story selection hub
│   └── story/           # Story experience
│       ├── data/        # Story library & repository
│       ├── domain/      # Models
│       ├── services/    # Business logic
│       └── widgets/     # Story UI components
│       └── widgets/     # Story UI components
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.10.7 or higher
- **Dart SDK** 3.10.7 or higher
- **Supabase account** ([Sign up](https://supabase.com))
- **Google AI API key** ([Get key](https://ai.google.dev))

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/hoya-app.git
   cd hoya-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and add your API keys:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   GEMINI_API_KEY=your-gemini-key
   ```

4. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run --dart-define-from-file=.env
   ```

### Supabase Setup

Create the following table in your Supabase project:

```sql
-- User Profiles
create table profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null,
  level integer default 1,
  xp integer default 0,
  created_at timestamp with time zone default now()
);

-- User Progress
create table user_progress (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  story_id text not null,
  current_node_id text,
  is_completed boolean default false,
  last_played_at timestamp with time zone default now(),
  unique(user_id, story_id)
);

-- Enable Row Level Security
alter table profiles enable row level security;
alter table user_progress enable row level security;

-- Policies
create policy "Users can view own profile"
  on profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on profiles for update
  using (auth.uid() = id);

create policy "Users can view own progress"
  on user_progress for select
  using (auth.uid() = user_id);

create policy "Users can insert own progress"
  on user_progress for insert
  with check (auth.uid() = user_id);

create policy "Users can update own progress"
  on user_progress for update
  using (auth.uid() = user_id);
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 📦 Building

Build for production:

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build windows --release
```

## 🛠️ Development

### Code Generation

After modifying files with `@riverpod` or `@JsonSerializable`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For continuous generation:
```bash
flutter pub run build_runner watch
```

### Skills Documentation

This project uses skill-based architectural conventions. See `.agent/skills/` for:

- **flutter-architecture** - Project structure guidelines
- **riverpod-state** - State management patterns
- **supabase-integration** - Backend integration
- **go-router-navigation** - Routing conventions
- **ui-motion-design** - Animation guidelines
- And more...

### Adding a New Story

1. Open `lib/features/story/data/story_library.dart`
2. Add `StoryMetadata` to the `storyLibrary` list
3. Add image generation prompt to `ASSET_PROMPTS.md`
4. Generate and add image to `assets/stories/`

## 🎨 Current Eras

- **Ancient Era** - Bronze tones, classical mythology
- **Future Era** - Cyan/tech aesthetic (Coming soon)

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Riverpod Documentation](https://riverpod.dev/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Google AI Documentation](https://ai.google.dev/docs)

## 🙏 Acknowledgments

- Story prompts inspired by global mythology and folklore
- UI design inspired by historical aesthetics
- Built with ❤️ using Flutter

---

**Made with Flutter** 🐦
