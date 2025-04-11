package breakout

import rl "vendor:raylib"

main :: proc() {

    // region raylib-setup
    WINDOW_WIDTH :: 800
    WINDOW_HEIGHT :: 450
    title :: "duchainer's Breakout"
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, title)
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    // endregion raylib-setup

    paddle_pos := rl.Vector2{400, 400}
    paddle_speed := rl.Vector2{4, 4}
    for !rl.WindowShouldClose(){

        if rl.IsKeyDown(.D){
            paddle_pos.x += paddle_speed.x
        }
        if rl.IsKeyDown(.A){
            paddle_pos.x -= paddle_speed.x
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawRectangleV(paddle_pos, {50, 10}, rl.WHITE)
        rl.EndDrawing()
    }

}
