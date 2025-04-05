package composite_app_raylib

import rl "vendor:raylib"

main :: proc(){
    // section raylib-setup
    WINDOW_WIDTH :: 750
    WINDOW_HEIGHT :: 750
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "UTAH CS4600 FALL 2020 Project 1 - Compositing Images")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    // endsection raylib-setup

    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.EndDrawing()
    }
}
