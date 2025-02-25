package pong
import rl "vendor:raylib"

main :: proc(){

    width :: 800
    height :: 450
    title :: "Pong without tutorial"
    rl.InitWindow(width, height, title)
    defer rl.CloseWindow();

    rl.SetTargetFPS(60);


    text_height : i32 = 100
    for !rl.WindowShouldClose(){
        if rl.IsKeyPressed(.W){
            text_height -= 10 // Move up
        }
        if rl.IsKeyPressed(.S){
            text_height += 10 // Move down
        }



        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawText("Hellope", 100, text_height, 25, rl.WHITE)
        rl.EndDrawing()
    }

}
