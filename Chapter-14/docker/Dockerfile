FROM julia:latest

COPY Project.toml server.jl nqueens/

WORKDIR nqueens

RUN julia -e "using Pkg; pkg\"activate .\"; pkg\"instantiate\"; "

CMD julia server.jl
