# Checkers in Assembly
An x86 Assembly project that creates an interactive window and depicts a checkers game (initial) setting. 
As functionalities, it has two buttons - Terminate and Roll Dices

The project serves as foundation for further development of a checkers game.

![img_1](./Media/Screenshot%20from%202024-03-06%2012-02-52.png)
## Modules
- .asm files:
    - `example.asm` - main code file
    - `biblioteca_desen.asm`
      - contains handlers for procedures and functions
      - contains functions that "draw" text and other elements
    - `biblioteca_test.asm`
    - `amplasare_piese.asm`
      - draws Checkers pieces on specific coordinates on the screen (window)
- .inc files: here different symbols are represented as pixel matrices. Each different number corresponds to a colour
  - `ghinda.inc`
  - `letters.inc`
  - `piesa_alba.inc`
  - `podbal.inc`
  - `zaruri.inc`
- `example.exe` - executable for Windows OS and LinuxOS (the latter one by using [Wine](https://www.winehq.org/))
- `canvas.dll` - binary file for Windows OS, it generates the window
- `canvas.lib` - additional file for canvas.dll