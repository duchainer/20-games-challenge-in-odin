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

    obstacle_arr : [10]rl.Rectangle

    for &obstacle, i in obstacle_arr{
        obstacle = rl.Rectangle{
            x=f32(WINDOW_WIDTH*((i+1)/2)),
            y=-50,
            width=60,
            height=WINDOW_WIDTH/2,
        }
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

        rl.DrawRectangleRec(bird, rl.WHITE)
        for obstacle in obstacle_arr{
            rl.DrawRectangleRec(obstacle, rl.WHITE)
        }
        rl.EndDrawing()
        // endsection drawing

    }

}
