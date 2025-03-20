package flappy

import rl "vendor:raylib"

main :: proc(){

    WINDOW_WIDTH :: 800
    WINDOW_HEIGHT :: 450
    title :: "duchainer's Flappy Bird"
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, title)
    defer rl.CloseWindow();

    rl.SetTargetFPS(60);

    Bird :: struct{
        using rect: rl.Rectangle,
        vertical_speed: f32,
    }

    bird := Bird{
        rect= rl.Rectangle{
            x=WINDOW_WIDTH/2,
            y=WINDOW_HEIGHT/2,
            width=20,
            height=20,
        },
        vertical_speed = -1 // Towards the top of the window
    }

    for !rl.WindowShouldClose(){
        // section input
        if rl.IsKeyPressed(.SPACE){
            // Towards the top of the window
            bird.vertical_speed -= 5
        }
        // endsection input

        // section process
        bird.y += bird.vertical_speed
        // bird.vertical_speed *= 0.9
        bird.vertical_speed += 0.2
        // endsection process

        // section drawing
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawRectangleRec(bird, rl.RED)
        rl.EndDrawing()
        // endsection drawing

    }

}
