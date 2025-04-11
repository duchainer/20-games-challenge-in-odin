package composite_app_raylib

import "core:fmt"
import "core:mem"

import rl "vendor:raylib"


main :: proc() {
    // We should be doing any allocation on the Odin side
    context.allocator = mem.panic_allocator()
    context.temp_allocator = mem.panic_allocator()

    MAX_IMAGE_WIDTH :: 1024
    MAX_IMAGE_HEIGHT:: 512
    // section raylib-setup
    UI_WIDTH :: 256

    WINDOW_WIDTH :: MAX_IMAGE_WIDTH + UI_WIDTH
    WINDOW_HEIGHT :: MAX_IMAGE_HEIGHT
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "UTAH CS4600 FALL 2020 Project 1 - Compositing Images")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    // endsection raylib-setup

    // background_image : rl.Image = rl.LoadImage("./background.png")
    background_image : rl.Image = rl.LoadImage("./star.png")
    defer rl.UnloadImage(background_image)
    foreground_image : rl.Image = rl.LoadImage("./background.png")
    defer rl.UnloadImage(foreground_image)
    // foreground_image : rl.Image = rl.LoadImage("./teapot.png")


    background_texture : rl.Texture2D
    background_texture = rl.LoadTextureFromImage(background_image)

    foreground_texture : rl.Texture2D
    // background_texture : rl.Texture2D
    fmt.println(background_image.width, background_image.height)
    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        // if background_texture != {}{
        //     rl.DrawTextureV(background_texture, {0,0}, rl.WHITE)
        // }

        background_mask : rl.Image
        defer rl.UnloadImage(background_mask)

        {
            background_mask1 := rl.ImageCopy(background_image)
            defer rl.UnloadImage(background_mask1)
            rl.ImageResizeCanvas(
                &background_mask1,
                MAX_IMAGE_WIDTH, MAX_IMAGE_HEIGHT, // new size
                0, 0,     // offset
                {1,0,0,0}, // color of new pixels
            )

            background_mask2 := rl.ImageCopy(background_image)
            defer rl.UnloadImage(background_mask2)
            rl.ImageResizeCanvas(
                &background_mask2,
                MAX_IMAGE_WIDTH, MAX_IMAGE_HEIGHT, // new size
                250, 250, // offset
                {1,0,0,0}, // color of new pixels
            )

            background_mask3 := rl.ImageCopy(background_image)
            defer rl.UnloadImage(background_mask3)
            rl.ImageResizeCanvas(
                &background_mask3,
                MAX_IMAGE_WIDTH, MAX_IMAGE_HEIGHT, // new size
                500, 0, // offset
                {1,0,0,0}, // color of new pixels
            )

            background_mask = rl.ImageCopy(background_mask2)
            rl.ImageClearBackground(&background_mask, {})

            rl.ImageDraw(
                    &background_mask, background_mask1,
                {0,0, f32( background_mask1.width ),  f32( background_mask1.height)  } ,
                {0,0, f32( background_mask.width ),  f32( background_mask.height)  } ,
                rl.WHITE,
            )
            rl.ImageDraw(
                    &background_mask, background_mask2,
                {0,0, f32( background_mask2.width ),  f32( background_mask2.height)  } ,
                {0,0, f32( background_mask.width ),  f32( background_mask.height)  } ,
                rl.WHITE,
            )
            rl.ImageDraw(
                    &background_mask, background_mask3,
                {0,0, f32( background_mask3.width ),  f32( background_mask3.height)  } ,
                {0,0, f32( background_mask.width ),  f32( background_mask.height)  } ,
                rl.WHITE,
            )
        }


        if rl.IsImageValid(foreground_image){
            rl.ImageAlphaMask(&foreground_image, background_mask)
            rl.UnloadTexture(foreground_texture)
            foreground_texture = rl.LoadTextureFromImage(foreground_image)
            rl.DrawTextureV(foreground_texture, {0,0}, rl.WHITE)
        }

        // assert(foreground_image2 != {})
        // if rl.IsImageValid(foreground_image2){
        //     rl.ImageAlphaMask(&foreground_image2, background_mask)
        //     texture := rl.LoadTextureFromImage(foreground_image2)
        //     rl.DrawTextureV(texture, {0,0}, rl.WHITE)
        // }



        rl.EndDrawing()
    }
}
