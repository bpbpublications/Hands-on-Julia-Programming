using Pkg
pkg"activate ."
pkg"instantiate"

using JuliaWebAPI

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

webqueens(N)=queens(parse(Int, N))

process(
    JuliaWebAPI.create_responder([
        (webqueens, true)
    ], "tcp://127.0.0.1:9999", true, ""), async=true
)

const apiclnt = APIInvoker("tcp://127.0.0.1:9999")

run_http(apiclnt, 8888)
