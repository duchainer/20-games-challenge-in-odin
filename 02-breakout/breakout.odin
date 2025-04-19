package breakout

import rl "vendor:raylib"
import "core:math/linalg"
// import "core:fmt"

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
    Paddle :: struct{
        rect: rl.Rectangle,
        color: rl.Color,
    }
    paddle := Paddle{
        rect = rl.Rectangle{
            x      = 400 - PADDLE_SIZE.x/2,
            y      = 400,
            width  = PADDLE_SIZE.x,
            height = PADDLE_SIZE.y,
        },
        color = rl.WHITE,
    }
    paddle_speed := rl.Vector2{4, 4}

    BALL_SIZE :: rl.Vector2{10, 10}
    Ball :: struct{rect:rl.Rectangle, dir: rl.Vector2, speed: f32}
    ball := Ball{
        rect = rl.Rectangle{
            x      = 350 - BALL_SIZE.x/2,
            y      = 300,
            width  = BALL_SIZE.x,
            height = BALL_SIZE.y,
        },
        dir = linalg.normalize0(rl.Vector2{
            1,
            2,
        }),
        speed = 5,
    }

    for !rl.WindowShouldClose(){

        input(&paddle, paddle_speed)

        if new_ball_dir, did_hit := ball_dir_calculate_if_collision(ball.rect, paddle.rect); did_hit {
            ball.dir = new_ball_dir
        } else if ball.rect.x > WINDOW_WIDTH || ball.rect.x < 0{
            // Sides of Window, bounces the ball
            ball.dir.x *= -1
        } else if ball.rect.y < 0 {
            // Top of Window, bounces the ball
            ball.dir.y *= -1
        } else if ball.rect.y > WINDOW_HEIGHT{
            // Bottom of Window, loses the ball
        } else {
            // fmt.println("ball.rect: %v",ball.rect)
        }

        ball.rect.x += ball.dir.x * ball.speed
        ball.rect.y += ball.dir.y * ball.speed


        rl.BeginDrawing()

        rl.ClearBackground(rl.BLACK)
        rl.DrawRectangleRec(paddle.rect, rl.WHITE)
        rl.DrawRectangleRec(ball.rect, rl.WHITE)

        rl.EndDrawing()

    }

    rect_center :: proc (rect: rl.Rectangle) -> rl.Vector2 {
        return rl.Vector2{
            rect.x + rect.width /2,
            rect.y + rect.height /2,
        }
    }

    ball_dir_calculate_if_collision :: proc(next_ball_rect: rl.Rectangle, paddle: rl.Rectangle) -> (rl.Vector2, bool) {
        if rl.CheckCollisionRecs(next_ball_rect, paddle) {
            ball_center := rect_center(next_ball_rect)
            paddle_center := rect_center(paddle)
            return linalg.normalize0(ball_center - paddle_center), true
        }
        return {}, false
    }

    input:: proc(paddle : ^Paddle, paddle_speed : rl.Vector2){
        if rl.IsKeyDown(.D){
            paddle.rect.x += paddle_speed.x
        }
        if rl.IsKeyDown(.A){
            paddle.rect.x -= paddle_speed.x
        }
    }


}
