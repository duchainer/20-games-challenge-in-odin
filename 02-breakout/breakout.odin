package breakout

import rl "vendor:raylib"
import "core:math/linalg"
import "core:fmt"
import "core:strings"

main :: proc() {

    // region raylib-setup
    GAME__WINDOW_WIDTH :: 800 //*2
    GAME__WINDOW_HEIGHT :: 500 //*2
    FULL__WINDOW_WIDTH :: GAME__WINDOW_WIDTH * 2
    FULL__WINDOW_HEIGHT :: GAME__WINDOW_HEIGHT * 2

    title :: "duchainer's Breakout"
    rl.InitWindow(FULL__WINDOW_WIDTH, FULL__WINDOW_HEIGHT, title)
    defer rl.CloseWindow()

    // rl.SetWindowState(rl.ConfigFlags)

    rl.SetTargetFPS(60)
    // endregion raylib-setup

    PADDLE_SIZE :: rl.Vector2{200, 10}
    Paddle :: struct{
        rect: rl.Rectangle,
        color: rl.Color,
    }
    paddle := Paddle{
        rect = rl.Rectangle{
            x      = 400 - PADDLE_SIZE.x/2,
            y      = GAME__WINDOW_HEIGHT - 50,
            width  = PADDLE_SIZE.x,
            height = PADDLE_SIZE.y,
        },
        color = rl.WHITE,
    }
    paddle_speed := rl.Vector2{4, 4}

    BALL_SIZE :: rl.Vector2{10, 10}
    Ball :: struct{rect:rl.Rectangle, dir: rl.Vector2, speed: f32}
    ball : Ball

    GLOBAL_GAME_STATE :: enum{
        // MAIN_MENU,
        JUST_SPAWNED_BALL,
        GAME_RUNNING,
        // GAME_ENDED,
    }
    global_game_state := GLOBAL_GAME_STATE.JUST_SPAWNED_BALL

    reset_ball :: proc(ball: ^Ball, paddle: Paddle){
        ball^ = Ball{
            rect = rl.Rectangle{
                x      = (GAME__WINDOW_WIDTH - BALL_SIZE.x)/2, //rect_center(paddle.rect).x,
                y      = GAME__WINDOW_HEIGHT - 150,
                width  = BALL_SIZE.x,
                height = BALL_SIZE.y,
            },
            dir = linalg.normalize0(rl.Vector2{
                1,
                1,
            }),
            speed = 7,
        }

    }
    reset_ball(&ball, paddle)
    global_game_state = .JUST_SPAWNED_BALL

    live_count : int = 3

    BRICK_SIZE :: rl.Vector2{30, 10}
    BRICKS_WIDTH :: 17 //* 2
    BRICKS_HEIGHT :: 13 //* 2
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


    // clamped_mouse_pos : rl.Vector2

    text_box_text := "HELLO WORLD"
    c_text_box_text := strings.clone_to_cstring(text_box_text, context.allocator)
    fmt.println(c_text_box_text)
    game_loop: for !rl.WindowShouldClose(){

        // We set the game on the left side, and capture the mouse in it.
        // That way the rest is the "code editor"

        // We have to sync the mouse pos on the 2 render swap buffer, so this is an attempt
        // TODO: Try to run the game at 90 FPS, as 120 FPS didn't look to have that issue
        // if clamped_mouse_pos != {FULL__WINDOW_WIDTH, FULL__WINDOW_HEIGHT}{
        //     rl.SetMousePosition(i32(clamped_mouse_pos.x), i32(clamped_mouse_pos.y))
        //     // Clamp the mouse with the latest position, next frame
        //     clamped_mouse_pos = {FULL__WINDOW_WIDTH, FULL__WINDOW_HEIGHT}
        // }else{
        //     // Clamp the mouse with this same position, next frame
        //     clamped_mouse_pos = rl.Vector2Clamp(
        //         rl.GetMousePosition(), {0, 0}, {GAME__WINDOW_WIDTH, GAME__WINDOW_HEIGHT},
        //     )
        //     fmt.println("clamped_mouse_pos", clamped_mouse_pos, "rl.GetMousePosition()", rl.GetMousePosition())
        //     rl.SetMousePosition(i32(clamped_mouse_pos.x), i32(clamped_mouse_pos.y))
        // }
        text_box_rect := rl.Rectangle{
            x = FULL__WINDOW_WIDTH - GAME__WINDOW_WIDTH,
            y = FULL__WINDOW_HEIGHT - GAME__WINDOW_HEIGHT,
            width = FULL__WINDOW_WIDTH - GAME__WINDOW_WIDTH,
            height = 15,//FULL__WINDOW_HEIGHT - GAME__WINDOW_HEIGHT,
        }
        // TODO Figure out how to properly set the c_text_box_text for no Seg Fault on long text.
        // TODO Figure multi-line text editor for Code Editor
        // NOTE: No Seg Fault with 100 chars it seems, for a 11 char-length "HELLO WORLD" text_box_text
        // But seems like that is mostly because I could write over other data, it seems, because the cstring
        //  is only 1 byte longer than a odin string, the null "terminating" byte
        //   clone_to_cstring :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (res: cstring, err: mem.Allocator_Error) #optional_allocator_error {
        //   	c := make([]byte, len(s)+1, allocator, loc) or_return
        //   	copy(c, s)
        //   	c[len(s)] = 0
        //   	return cstring(&c[0]), nil
        //   }
        text_max_length : i32 = 100
        can_edit := true
        rl.GuiTextBox(text_box_rect, c_text_box_text, text_max_length, can_edit)

        // fmt.println(rl.GuiGetFont())
        // DEFAULT rl.GuiGetFont()
        // Font{
        //     baseSize = 10,
        //     glyphCount = 224,
        //     glyphPadding = 0,
        //     texture = Texture{
        //         id = 2,
        //         width = 128,
        //         height = 128,
        //         mipmaps = 1,
        //         format = "UNCOMPRESSED_GRAY_ALPHA"
        //     },
        //     recs = &Rectangle{
        //         x = 1, y = 1, width = 3, height = 10
        //     },
        //     glyphs = &GlyphInfo{
        //         value =  ,
        //         offsetX = 0,
        //         offsetY = 0,
        //         advanceX = 0,
        //         image = Image{
        //             data = 0x315EF050,
        //             width = 3,
        //             height = 10,
        //             mipmaps = 1,
        //             format = "UNCOMPRESSED_GRAY_ALPHA"
        //         }
        //     }
        // }

        switch global_game_state{
        case .JUST_SPAWNED_BALL: {
            if rl.IsKeyPressed(.SPACE) || rl.IsMouseButtonPressed(.LEFT){
                global_game_state = .GAME_RUNNING
            }

            draw(paddle, ball, bricks[:], live_count, "Press SPACE or LEFT CLICK")
        }
        case .GAME_RUNNING: {
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
            } else if new_ball_dir, did_hit := ball_dir_calculate(ball.rect, paddle.rect, {0, 50}); did_hit {
            // Paddle, bounces the ball
            ball.dir = new_ball_dir
            ball.speed *= 1.01
            } else if ball.rect.x > GAME__WINDOW_WIDTH || ball.rect.x < 0{
            // Sides of Window, bounces the ball
            ball.dir.x *= -1
            } else if ball.rect.y < 0 {
            // Top of Window, bounces the ball
            ball.dir.y *= -1
            } else if ball.rect.y > GAME__WINDOW_HEIGHT{
            // Bottom of Window, loses the ball
            if live_count >= 1{
                // live_count -= 1
                // reset_ball(&ball, paddle)
                // global_game_state = .JUST_SPAWNED_BALL
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


            draw(paddle, ball, bricks[:], live_count, "")
        }}
        // free_all(context.temp_allocator)
    }

    rect_center :: proc (rect: rl.Rectangle) -> rl.Vector2 {
        return rl.Vector2{
            rect.x + rect.width /2,
            rect.y + rect.height /2,
        }
    }

    ball_dir_calculate :: proc(next_ball_rect: rl.Rectangle, other: rl.Rectangle, other_center_offset: rl.Vector2={}) -> (rl.Vector2, bool) {
        if rl.CheckCollisionRecs(next_ball_rect, other) {
            ball_center := rect_center(next_ball_rect)
            // Why have a `other_center_offset`?
            // Because we want angles to be closer to a 45 total deg around the y axis,
            // not the whole 180 degrees
            // In other words:
            //  - balls going sideways are not fun:
            //   - They take a while to reach a brick
            //   - They will often hit a brick
            //   - They take a while to come back
            // So this `other_center_offset` is a workaround to fix when the breakout paddle
            // is wider than the pong paddle was.
            other_center := rect_center(other) + other_center_offset
            return linalg.normalize0(ball_center - other_center), true
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

    draw:: proc(paddle: Paddle, ball: Ball, bricks: []rl.Rectangle, live_count: int, message: string){
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
                x      = GAME__WINDOW_WIDTH - BALL_SIZE.x*2 - f32(i * 15),
                y      = GAME__WINDOW_HEIGHT - BALL_SIZE.y*2,
                width  = BALL_SIZE.x,
                height = BALL_SIZE.y,
            }
            rl.DrawRectangleRec(
                ball_in_ui,
                rl.WHITE,
            )
        }

        if message != "" {
            rl.DrawRectangleRec(rl.Rectangle{
                200-10, 200 -10, 405, 50,
            }, rl.GRAY)

            padded_message := strings.center_justify(message, 27, " ", context.temp_allocator)
            c_message := strings.clone_to_cstring(padded_message, context.temp_allocator)
            rl.DrawText(c_message, 200, 200, 25, rl.WHITE)
            // free_all(context.temp_allocator)
        }

        rl.EndDrawing()
    }

}
