using Pkg

Pkg.activate(dirname(@__FILE__))
Pkg.instantiate()

using HTTP
using JSON
using Blink
using WebIO

function draw_queens(url; N=8, W=30)
    try
        resp = HTTP.get(url*"/webqueens/$N")
        json = JSON.parse(String(resp.body))
        allqueens = json["data"]
        w = Window()
        body!(w, dom"div"(
            dom"canvas.#ChessBoard[width=$(N*W), height=$(N*W)]"(),
            dom"script"(
                """
                    function draw_queen(ctx, sx, sy){
                        ctx.fillStyle = "#C0C0C0";
                        ctx.fillText("Q", sx+$W/5, sy+4*$W/5);
                        ctx.fillStyle = "#000000";
                    }

                    function draw_board(ctx, queens){
                        n = queens.length
                        ctx.fillStyle = "#FFFFFF";
                        ctx.fillRect(0, 0, n*$W, n*$W);
                        ctx.fillStyle = "#000000";
                        sx = 0; sy = 0;

                        for (i=n-1; i >= 0; i--){
                            for (j=0; j < n; j++){
                                if ((i+j)%2 == 0) 
                                    ctx.fillRect(sx, sy, $W, $W);
                                if (j == queens[i] - 1)
                                    draw_queen(ctx, sx, sy)
                                sx += $W;
                            }
                            sy += $W; sx = 0;
                        }
                    }
        
                    var c = document.getElementById("ChessBoard"); 
                    var ctx = c.getContext("2d"); 
                    ctx.font = "$(4*div(W,5))px sans-serif"; 
                    draw_board(ctx, $([allqueens...]));
                """
            )
        ))
    catch e
        return "Error occurred : $e"
    end
end

