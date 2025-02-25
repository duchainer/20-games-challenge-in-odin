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
    paddle_left := rl.Rectangle{
        x = 0,
        y = 0,
        width = 10,
        height = 50
    }
    for !rl.WindowShouldClose(){
        if rl.IsKeyDown(.W){
            paddle_left.y -= 10 // Move up
        }
        if rl.IsKeyDown(.S){
            paddle_left.y += 10 // Move down
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawText("Hellope", 100, text_height, 25, rl.WHITE)
        rl.DrawRectangleRec(paddle_left, rl.WHITE)
        rl.EndDrawing()
    }

}
