attacks(x1, y1, x2, y2) = (x1 == x2 || y1 == y2 || x1 - y1 == x2 - y2 || x1 + y1 == x2 + y2)

function queens(N, xs...)
    lxs = length(xs)
    c = N - lxs
    c == 0 && return reverse(xs)
    for i=1:N
        any(1:lxs) do j
            attacks(xs[j], N-j+1, i, c)
        end && continue
        v = queens(N, xs..., i)
        v !== nothing && return v
    end
    return nothing
end

using WebIO

N, W = 8, 30
allqueens = queens(N)
println(allqueens)

using Blink
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

