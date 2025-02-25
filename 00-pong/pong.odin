package pong
import rl "vendor:raylib"

main :: proc(){

    width :: 800
    height :: 450
    title :: "Pong without tutorial"
    rl.InitWindow(width, height, title)
    defer rl.CloseWindow();

    rl.SetTargetFPS(60);


    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawText("Hellope", 100, 100, 25, rl.WHITE)
        rl.EndDrawing()
    }

}
