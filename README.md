# c-compiler

This is a small school project. The goal was to implement a simple compiler from c to p-code. The p-code is actually just c code that emulate p-code through macros. Unfortunately this part was supposed to be done by the teacher but in the end it is not functionnal so let's just say the project compile c code into (not working) p-code and nothing more. 

## What can be compiled ?
The project obviously do not compile every c code but can do few things:
- Managing simple arithmetic expressions with constants,
- Type management: verification and conversions,
- Managing global variables,
- Branching management (if, else, while),
- Sub-block management,
- Function call management.


## Files
The repository is separated into 3 folders:
- `src`: contains main files such as `lang.l` and `lang.y` to compile c to p-code,
  - `run`: little script to run the project (see below),
  - `Makefile`: usual makefile to compile everything,
  - `Table_des_symboles.h/c`: code used to create a symbol table (for variables and functions),
  - `lang.l`: lex file to detect the c code lexic,
  - `lang.y`: yacc file to determine the c code syntax (my job),
  - `Table_des_chaines`: useless file, dont look,
- `Pcode`: contains files related to p-code,
  - `Pcode.h/c` : macros given by my teacher,
- `Examples`: contains example files to test the project.

## How to run
In order to compile the project, go to `src` folder (`cd ./src`). Then type `make` to compile the whole project. Finally run the following command to compile the file `ExX.myc` into `ExX_pcode.c`:
```bash
./run X
```
Use the `make clean` command to clear all compiled files.
