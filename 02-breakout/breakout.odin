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

    PADDLE_SIZE :: rl.Vector2{50, 10}
    paddle := rl.Rectangle{
        x      = 400 - PADDLE_SIZE.x/2,
        y      = 400,
        width  = PADDLE_SIZE.x,
        height = PADDLE_SIZE.y,
    }
    paddle_speed := rl.Vector2{4, 4}

    BALL_SIZE :: rl.Vector2{10, 10}
    ball := rl.Rectangle{
        x      = 400 - BALL_SIZE.x/2,
        y      = 300,
        width  = BALL_SIZE.x,
        height = BALL_SIZE.y,
    }

    for !rl.WindowShouldClose(){

        if rl.IsKeyDown(.D){
            paddle.x += paddle_speed.x
        }
        if rl.IsKeyDown(.A){
            paddle.x -= paddle_speed.x
        }

        draw(paddle, ball)

    }

    draw :: proc(paddle, ball: rl.Rectangle){
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawRectangleRec(paddle, rl.WHITE)
        rl.DrawRectangleRec(ball, rl.WHITE)
        rl.EndDrawing()
    }

}
