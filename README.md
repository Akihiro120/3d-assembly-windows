# 3D Cube
#
I made a 3D program using NASM Assembly on the Windows 64x Architecture and Raylib

<img src="https://github.com/Akihiro120/3d-assembly-windows/assets/127700131/7321e66e-740a-4e33-8a1b-57544cc58715" width="400" height="300">

# Features:
<ul>
  <li>3D Rendering</li>
  <li>Text Rendering</li>
</ul>

# How to Compile
```
make
```

or

```
nasm -f win64 main.asm
gcc main.obj -o main -L"lib" -lraylib -lopengl32 -lgdi32 -lwinmm
main.exe
```
