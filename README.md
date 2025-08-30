# CPE222_FinalProject_FPGA-Tetris
This project implements the classic puzzle game **Tetris** on an FPGA board using **Verilog**. The game runs on a **Digilent Basys3 (Xilinx Artix-7)** and outputs graphics via **VGA**, with scores displayed on a **7-segment display**.

---

## 🎯 Objectives
- Apply knowledge from digital logic design to implement a working hardware-based game.
- Develop a **Tetris Game Engine** running entirely on FPGA.
- Implement VGA signal generation at **640×480 @ 60Hz**.
- Display scores in real time using a **7-segment display**.
- Practice hardware description programming using **Verilog**.

---

## 📌 Features
- **Game Display:**
  - Playfield grid: **10×20**.
  - VGA monitor resolution: **640×480**.
  - Score displayed on 7-segment display (up to 9999 points).

- **Tetromino Support:**
  - Includes all 7 standard Tetrimino shapes: **I, O, T, S, Z, J, L**.
  - Rotation supported (clockwise).

- **Controls (Basys3 Buttons & Switches):**
  - `BTN_LEFT` → Move left  
  - `BTN_RIGHT` → Move right  
  - `BTN_UP` → Rotate block  
  - `BTN_DOWN` → Soft drop (increase falling speed)  
  - `SW0` → Reset game  

- **Core Game Mechanics:**
  - Collision detection  
  - Line clearing (+10 points per line)  
  - Game over when blocks exceed top of grid  

---

## ⚙️ System Design
### Main Components
- **Input Controller:** Handles movement and rotation via push buttons and reset via slide switch.
- **Game Engine:** Controls block generation, movement, collisions, line clearing, scoring, and game state.
- **VGA Controller:** Generates VGA signals (H-sync, V-sync) and pixel clock (25.175 MHz).
- **7-Segment Controller:** Displays score in real-time.
- **Pseudorandom Generator:** LFSR-based random block generation.

### Graphics
- Blocks and grid displayed in different colors:
  - Empty cell → White  
  - Active falling block → Red  
  - Placed block → Green  

---

## 🚀 Results
- Successfully displayed Tetris on **VGA monitor** with smooth gameplay.
- Scores correctly updated and shown on **7-segment display**.
- Stable VGA output at **640×480 resolution**.
- Real-time controls with minimal input delay.

---

## 🛠️ Challenges & Solutions
1. **VGA output instability** → Adjusted pixel clock from 25 MHz to **25.175 MHz**.  
2. **Vivado 2D array limitations** → Used index offset instead.  
3. **Complex VGA conditions** → Suggested modularizing conditions with **state machine / lookup table**.  
4. **FPGA resource usage** → Optimized logic sharing to reduce unnecessary cell usage.  
5. **Random block generation** → Implemented **LFSR pseudorandom generator**.  
6. **Keyboard input delay** → Replaced with **Basys3 push buttons** for accuracy.  

---
![Example Image](./image/217627_0.png)