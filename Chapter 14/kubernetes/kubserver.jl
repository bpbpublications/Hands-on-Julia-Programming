using Pkg

Pkg.activate(dirname(@__FILE__))
Pkg.instantiate()

using Kuber
ctx = Kuber.KuberContext()

kubqueens_pod = kuber_obj(ctx, """{
                  "kind": "Pod",
                  "metadata":{
                      "name": "kubqueens-pod",
                      "namespace": "default",
                      "labels": {
                          "name": "kubqueens-pod"
                      }
                  },
                  "spec": {
                      "containers": [{
                          "name": "kubqueens",
                          "image": "hojpreg.azurecr.io/kubqueens",
                          "ports": [{"containerPort": 8888}]
                      }]
                  }
              }""")

kubqueens_service = kuber_obj(ctx, """{
                  "kind": "Service",
                  "metadata": {
                      "name": "kubqueens-service",
                      "namespace": "default",
                      "labels": {"name": "kubqueens-service"}
                  },
                  "spec": {
                      "type": "LoadBalancer",
                      "ports": [{"port": 8888}],
                      "selector": {"name": "kubqueens-pod"}
                  }
              }""")

put!(ctx, kubqueens_pod)
put!(ctx, kubqueens_service)

while true
    println("waiting for loadbalancer to be configured...")
    status = get(ctx, :Service, "kubqueens-service").status
    if nothing !== status.loadBalancer.ingress && !isempty(status.loadBalancer.ingress)
        println(status.loadBalancer.ingress[1])
        break
    end
    sleep(5)
end


# To clean up the services you can use the commented commands below.

println("To clean up the services you can use the commented commands below:")

println("delete!(ctx, kubqueens_service)")
println("delete!(ctx, kubqueens_pod)")
