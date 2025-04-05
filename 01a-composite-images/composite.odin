package composite_app_raylib

import "core:fmt"
import rl "vendor:raylib"

main :: proc(){
    // section raylib-setup
    UI_WIDTH :: 256
    WINDOW_WIDTH :: 1024 + UI_WIDTH
    WINDOW_HEIGHT :: 512
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "UTAH CS4600 FALL 2020 Project 1 - Compositing Images")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    // endsection raylib-setup

    background_image : rl.Image = rl.LoadImage("./background.png")
    fmt.println(background_image.width, background_image.height)
    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        if rl.IsImageValid(background_image){
            texture := rl.LoadTextureFromImage(background_image)
            rl.DrawTextureV(texture, {0,0}, rl.WHITE)
        }



        rl.EndDrawing()
    }
}
