function fib(n)
    n < 3 ? 1 : fib(n-2) + fib(n-1)
end

"""
   This is code text.  
"""
function memoize(f)
    memo = Dict()
    (args...; kwargs...) -> begin
        x = (args, kwargs)
        haskey(memo, x) || (memo[x] = f(args..., kwargs...))
        memo[x]
    end
end

fib! = memoize(fib)

fib!(20)


