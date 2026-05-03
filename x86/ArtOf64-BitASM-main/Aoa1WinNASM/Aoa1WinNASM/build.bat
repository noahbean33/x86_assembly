echo off
nasm -Ov -f win64 %1.asm -o %1.obj
cl /nologo /O2 /Zi /utf-8 /EHa /Fe%1.exe c.cpp %1.obj
