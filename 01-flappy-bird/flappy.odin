package flappy

import rl "vendor:raylib"

main :: proc(){

    rl.InitWindow(200, 200, "Flappy")

    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.EndDrawing()
    }

}
