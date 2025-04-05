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

    // background_image : rl.Image = rl.LoadImage("./background.png")
    background_image : rl.Image = rl.LoadImage("./teapot.png")
    foreground_image : rl.Image = rl.LoadImage("./background.png")
    // foreground_image2 : rl.Image = rl.LoadImage("./u.png")


    background_texture : rl.Texture2D
    background_texture = rl.LoadTextureFromImage(background_image)
    // background_texture : rl.Texture2D
    fmt.println(background_image.width, background_image.height)
    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        if background_texture != {}{
            rl.DrawTextureV(background_texture, {0,0}, rl.WHITE)
        }

        background_mask := rl.ImageCopy(background_image)
        rl.ImageAlphaCrop(&background_mask, 0)

        foreground_texture : rl.Texture2D
        defer rl.UnloadTexture(foreground_texture)

        if rl.IsImageValid(foreground_image){
            rl.ImageAlphaMask(&foreground_image, background_image)
            foreground_texture = rl.LoadTextureFromImage(foreground_image)
            rl.DrawTextureV(foreground_texture, {0,0}, rl.WHITE)
        }

        // if rl.IsImageValid(foreground_image2){
        //     texture := rl.LoadTextureFromImage(foreground_image2)
        //     rl.DrawTextureV(texture, {0,0}, rl.WHITE)
        // }



        rl.EndDrawing()
    }
}
