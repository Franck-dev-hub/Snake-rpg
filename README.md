# Snake RPG
## 📌 Description
Snake RPG is a Snake game with RPG elements developed in Lua with LÖVE.
The player controls a snake that evolves by gaining XP, unlocking powers, and facing enemies across levels.

## 🚀 Getting Started
### ✅ Prerequisites
   - Lua v5.4.7 or higher.
   - LÖVE (Love2D) v11.5 or higher.
   - Tested on Windows.

### 🛠️ Technologies Used
[![Lua](https://img.shields.io/badge/Lua-%232C2D72.svg?logo=lua&logoColor=white)](#)

### 📥 Installation and Run
1. Clone the repository.
2. Navigate to the project folder.
3. Windows: Double-click `run.bat` to launch the game.
4. Linux/macOS: Use the command `love .` in the project directory.

## 💡 Gameplay
- Control your snake using the arrow keys.
- Collect fruits to gain XP and level up.
- Unlock special powers as you level up.
- Face dangerous enemies in different zones.

## 📁 Projet Structure
```
.
├── ai
│   └── bfs.lua
├── assets
│   └── font
├── game
│   ├── food.lua
│   ├── lvl_ups.lua
│   ├── main_game.lua
│   ├── player.lua
│   └── state.lua
├── libs
│   └── json.lua
├── LICENSE
├── love.exe
├── main.lua
├── menu
│   ├── demo_menu.lua
│   ├── gameover_menu.lua
│   ├── main_menu.lua
│   └── menu_generic.lua
├── README.md
└── run.bat
```

## ❓ Help
If you encounter issues:
   - Ensure Lua is properly installed (`lua -v` in your terminal).
   - Ensure LÖVE is properly installed (`love --version`).
   - Make sure your GPU drivers are up to date (especially on Windows).

## 👥 Author
- [Franck-dev-hub](https://github.com/Franck-dev-hub) – Franck S.

## 📝 Version History
- **v1.3.0**:
  - Add level-up system
  - Display walls
- **v1.2.0**:
  - Add debug mode for AI demo
  - Code optimisation
- **v1.1.0**:
  - Add menus
  - Add score tracking
  - BFS demo
  - Bug fix
- **v1.0.0**:
  - Base Snake gameplay.

## 📜 License
- This project is licensed under GNU GPL v3.0 - see the LICENSE.
