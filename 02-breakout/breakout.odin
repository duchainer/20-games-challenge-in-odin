package breakout

import rl "vendor:raylib"
import "core:math/linalg"
import "core:fmt"

main :: proc() {

    // region raylib-setup
    WINDOW_WIDTH :: 800 //*2
    WINDOW_HEIGHT :: 450 //*2
    title :: "duchainer's Breakout"
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, title)
    defer rl.CloseWindow()

    // rl.SetWindowState(rl.ConfigFlags)

    rl.SetTargetFPS(60)
    // endregion raylib-setup

    PADDLE_SIZE :: rl.Vector2{150, 10}
    Paddle :: struct{
        rect: rl.Rectangle,
        color: rl.Color,
    }
    paddle := Paddle{
        rect = rl.Rectangle{
            x      = 400 - PADDLE_SIZE.x/2,
            y      = WINDOW_HEIGHT - 50,
            width  = PADDLE_SIZE.x,
            height = PADDLE_SIZE.y,
        },
        color = rl.WHITE,
    }
    paddle_speed := rl.Vector2{4, 4}

    BALL_SIZE :: rl.Vector2{10, 10}
    Ball :: struct{rect:rl.Rectangle, dir: rl.Vector2, speed: f32}
    ball : Ball

    reset_ball :: proc(ball: ^Ball, paddle: Paddle){
        ball^ = Ball{
            rect = rl.Rectangle{
                x      = rect_center(paddle.rect).x,
                y      = WINDOW_HEIGHT - 150,
                width  = BALL_SIZE.x,
                height = BALL_SIZE.y,
            },
            dir = linalg.normalize0(rl.Vector2{
                0,
                1,
            }),
            speed = 5,
        }
	for !rl.WindowShouldClose(){
		if rl.IsKeyPressed(.SPACE) || rl.IsMouseButtonPressed(.LEFT){
			break // wait for input
		}
	}
    }
    reset_ball(&ball, paddle)

    live_count := 3

    BRICK_SIZE :: rl.Vector2{30, 10}
    BRICKS_WIDTH :: 17 //* 2
    BRICKS_HEIGHT :: 17 //* 2
    bricks : [BRICKS_WIDTH * BRICKS_HEIGHT]rl.Rectangle

    reset_bricks :: proc(bricks: []rl.Rectangle){
        for i in 0..<BRICKS_HEIGHT{
            for j in 0..<BRICKS_WIDTH{
                bricks[i*BRICKS_WIDTH + j] = {
                    x = 25+1.5*BRICK_SIZE.x*f32(j),
                    y = 20 + 20*f32(i),
                    width = BRICK_SIZE.x,
                    height = BRICK_SIZE.y,
                }
            }
        }
    }
    reset_bricks(bricks[:])

    game_loop: for !rl.WindowShouldClose(){

        input(&paddle, paddle_speed, &ball)

        ball_had_collision := false
        for single_brick, i in bricks {
            if new_ball_dir2, did_hit2 := ball_dir_calculate(ball.rect, single_brick); did_hit2 {
                // Brick, bounces the ball, then brick disappears
                ball.dir = new_ball_dir2
                bricks[i] = {}
                break
            }
        }

        if ball_had_collision{
            // Nothing, just prevent all the other else if when we already had one collision
            // The ball can only collide a single brick or a paddle on the same frame
        } else if new_ball_dir, did_hit := ball_dir_calculate(ball.rect, paddle.rect); did_hit {
            // Paddle, bounces the ball
            ball.dir = new_ball_dir
            ball.speed *= 1.05
        } else if ball.rect.x > WINDOW_WIDTH || ball.rect.x < 0{
            // Sides of Window, bounces the ball
            ball.dir.x *= -1
        } else if ball.rect.y < 0 {
            // Top of Window, bounces the ball
            ball.dir.y *= -1
        } else if ball.rect.y > WINDOW_HEIGHT{
            // Bottom of Window, loses the ball
            if live_count >= 1{
                // live_count -= 1
                reset_ball(&ball, paddle)
                // reset_paddle(&paddle)
            } else {
                fmt.println("GAME OVER")
                break game_loop
            }
        } else {
            // fmt.println("ball.rect: %v",ball.rect)
        }

        ball.rect.x += ball.dir.x * ball.speed
        ball.rect.y += ball.dir.y * ball.speed


        rl.BeginDrawing()

        rl.ClearBackground(rl.BLACK)
        rl.DrawRectangleRec(paddle.rect, rl.WHITE)
        rl.DrawRectangleRec(ball.rect, rl.WHITE)

        for rect in bricks{
            rl.DrawRectangleRec(rect, rl.WHITE)
        }

        //
        // DRAW UI
        //
        for i := 0; i < live_count; i += 1{
            ball_in_ui := rl.Rectangle{
                x      = WINDOW_WIDTH - BALL_SIZE.x*2 - f32(i * 15),
                y      = WINDOW_HEIGHT - BALL_SIZE.y*2,
                width  = BALL_SIZE.x,
                height = BALL_SIZE.y,
            }
            rl.DrawRectangleRec(
                ball_in_ui,
                rl.WHITE,
            )
        }

        rl.EndDrawing()

    }

    rect_center :: proc (rect: rl.Rectangle) -> rl.Vector2 {
        return rl.Vector2{
            rect.x + rect.width /2,
            rect.y + rect.height /2,
        }
    }

    ball_dir_calculate :: proc(next_ball_rect: rl.Rectangle, paddle: rl.Rectangle) -> (rl.Vector2, bool) {
        if rl.CheckCollisionRecs(next_ball_rect, paddle) {
            ball_center := rect_center(next_ball_rect)
            paddle_center := rect_center(paddle)
            return linalg.normalize0(ball_center - paddle_center), true
        }
        return {}, false
    }

    input:: proc(paddle : ^Paddle, paddle_speed : rl.Vector2, ball : ^Ball){
        paddle.rect.x = f32(rl.GetMouseX())
        if rl.IsKeyDown(.D){
            reset_ball(ball, paddle^)
        //     paddle.rect.x += paddle_speed.x
        }
        // if rl.IsKeyDown(.A){
        //     paddle.rect.x -= paddle_speed.x
        // }
    }


}
