; store external calls to the other libraries

; -------------------------------------------------------
; raylib

; windowing
extern InitWindow
extern CloseWindow
extern WindowShouldClose

; drawing
extern ClearBackground
extern BeginDrawing
extern EndDrawing
extern DrawGrid

; rectangles
extern DrawRectangleRec

; cubes
extern DrawCubeV
extern DrawCubeWiresV

; text
extern DrawText

; camera
extern BeginMode3D
extern EndMode3D
