package pong
import rl "vendor:raylib"
import "base:builtin"

rect_center :: proc(rect: rl.Rectangle) -> rl.Vector2{
    return rl.Vector2{
        rect.x + rect.width/2,
        rect.y + rect.height/2
    }
}


main :: proc(){

    WINDOW_WIDTH :: 800
    WINDOW_HEIGHT :: 450
    title :: "Pong without tutorial"
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, title)
    defer rl.CloseWindow();

    rl.SetTargetFPS(60);


    text_height : i32 = 100
    paddle_left := rl.Rectangle{
        x = 0,
        y = 0,
        width = 10,
        height = 50
    }
    ball := rl.Rectangle{
        x = WINDOW_WIDTH/2,
        y = WINDOW_HEIGHT/2,
        width = 10,
        height = 10
    }
    ball_speed := rl.Vector2{-5, -3}
    for !rl.WindowShouldClose(){

        // section paddle_movement
        if rl.IsKeyDown(.W){
            paddle_left.y -= 10 // Move up
        }
        if rl.IsKeyDown(.S){
            paddle_left.y += 10 // Move down
        }
        paddle_left.y = builtin.clamp(paddle_left.y, 0, WINDOW_HEIGHT - paddle_left.height)
        // endsection paddle_movement


        // section ball_movement
        // NOTE, we don't need delta time, because we always will run at 60 fps
        ball.x += ball_speed.x
        ball.y += ball_speed.y
        if  ball.x > WINDOW_WIDTH - ball.width{
            ball_speed.x *= -1
        }
        if ball.y < 0 || ball.y > WINDOW_HEIGHT- ball.height{
            ball_speed.y *= -1
        }

        if rl.CheckCollisionRecs(ball, paddle_left){
            ball_speed.x *= -1
        }
        // endsection ball_movement


        // section draw
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawText("Hellope", 100, text_height, 25, rl.WHITE)
        rl.DrawRectangleRec(paddle_left, rl.WHITE)
        rl.DrawRectangleRec(ball, rl.WHITE)
        rl.DrawRectangleV(rect_center(paddle_left) - {1,1}, rl.Vector2{2,2}, rl.RED)
        rl.EndDrawing()
        // endsection draw
    }

}
