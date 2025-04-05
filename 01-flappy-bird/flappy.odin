package flappy

import rl "vendor:raylib"
import "core:math/rand"
import "core:fmt"
import "core:math"

main :: proc(){

    // section raylib-setup
    WINDOW_WIDTH :: 800
    WINDOW_HEIGHT :: 450
    title :: "duchainer's Flappy Bird"
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, title)
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    // endsection raylib-setup

    generate_obstacle:: proc(height:i32) -> rl.Rectangle {
        return rl.Rectangle{
            x=f32(WINDOW_WIDTH),
            y=f32(height) - WINDOW_HEIGHT/2,
            width=60,
            height=WINDOW_WIDTH/2.5,
        }
    }

    Bird :: struct{
        using rect: rl.Rectangle,
        vertical_speed: f32,
    }

    bird : Bird

    obstacles_arr : [3][2]rl.Rectangle

    obstacles_speed :f32

    GROUND_HEIGHT :: 5
    ceiling : rl.Rectangle
    ground : rl.Rectangle

    UI_HEIGHT :: 30
    ui_background := rl.Rectangle{
        x=0,
        y=0,
        width = WINDOW_WIDTH,
        height = UI_HEIGHT,
    }
    traveled_distance: f64
    score :i32 = 0

    GLOBAL_GAME_STATE :: enum{
        MAIN_MENU,
        GAME_START,
        GAME_RUNNING,
        GAME_ENDED,
    }

    global_game_state := GLOBAL_GAME_STATE.GAME_START

    for !rl.WindowShouldClose(){
        switch global_game_state{
        case .MAIN_MENU: {
                global_game_state = .GAME_RUNNING
        }
        case .GAME_START: {
            bird = Bird{
                rect= rl.Rectangle{
                    x=WINDOW_WIDTH/2,
                    y=WINDOW_HEIGHT/2,
                    width=20,
                    height=20,
                },
                vertical_speed = -1, // Towards the top of the window
            }
            rand_height := rand.int31_max(WINDOW_HEIGHT/2)
            obstacles_arr = [3][2]rl.Rectangle{
                {
                    generate_obstacle(rand_height),
                    generate_obstacle(rand_height+WINDOW_HEIGHT),
                },
                {},
                {},
            }

            obstacles_speed = -3
            ceiling = rl.Rectangle{
                x=0,
                y= UI_HEIGHT,
                width = WINDOW_WIDTH,
                height = GROUND_HEIGHT,
            }

            ground = rl.Rectangle{
                x=0,
                y= WINDOW_HEIGHT - GROUND_HEIGHT,
                width = WINDOW_WIDTH,
                height = GROUND_HEIGHT,
            }

            traveled_distance = 0
            score = 0

            global_game_state = .GAME_RUNNING
            fallthrough
        }
        case .GAME_RUNNING :{
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
            for &obstacles_pair in obstacles_arr{
                for &obstacle in obstacles_pair{
                    obstacle.x += obstacles_speed
                    if rl.CheckCollisionRecs(bird, obstacle){
                        global_game_state = .GAME_ENDED
                        continue
                    }
                }
            }
            // ceiling check
            if rl.CheckCollisionRecs(bird, ceiling){
                global_game_state = .GAME_ENDED
                continue
            }
            // ground check
            if rl.CheckCollisionRecs(bird, ground){
                global_game_state = .GAME_ENDED
                continue
            }

            // scoring
            traveled_distance -= f64(obstacles_speed)
            // Why 0.5 + ... ?
            // Because we start half a screen away from the first obstacle
            score = i32(0.5 + math.floor(traveled_distance) / (WINDOW_WIDTH) )

            if i32(traveled_distance) % WINDOW_WIDTH < i32(-obstacles_speed){
                rand_height := rand.int31_max(WINDOW_HEIGHT/2)
                obstacles_arr[score % i32(len(obstacles_arr))] = {
                    generate_obstacle(rand_height),
                    generate_obstacle(rand_height+ WINDOW_HEIGHT),
                }
            }
            // endsection process


            // section drawing
            rl.BeginDrawing()
            rl.ClearBackground(rl.BLACK)

            rl.DrawRectangleRec(bird, rl.WHITE)
            for obstacles_pair in obstacles_arr{
                for obstacle in obstacles_pair{
                    rl.DrawRectangleRec(obstacle, rl.WHITE)
                }
            }
            rl.DrawRectangleRec(ceiling, rl.WHITE)
            rl.DrawRectangleRec(ground, rl.WHITE)

            // ui
            rl.DrawRectangleRec(ui_background, rl.BLACK)
            score_text := fmt.caprintf("{}", score, allocator=context.temp_allocator)
            rl.DrawText(score_text, WINDOW_WIDTH/2, 5, 25, rl.WHITE)

            rl.EndDrawing()
            // endsection drawing
        }

        case .GAME_ENDED:  {
            // section input
            if rl.IsKeyPressed(.SPACE){
                global_game_state = .GAME_START
                continue
            }
            // endsection input

            // section drawing
            rl.BeginDrawing()
            game_over_center :[2]i32: {WINDOW_WIDTH/2, WINDOW_HEIGHT/8}
            rl.DrawRectangle(game_over_center.x-30, game_over_center.y-5, 75, 20, rl.GRAY)
            rl.DrawText("Game Over", game_over_center.x-20, game_over_center.y, 10, rl.WHITE)
            rl.EndDrawing()
            // endsection drawing
        }
        }
        free_all(context.temp_allocator)
    }

}
