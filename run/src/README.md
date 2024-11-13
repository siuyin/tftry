# Running Locally
```
go run main.go

curl localhost:8080
```

# Building
```
skaffold build --kubeconfig=/dev/null
```
The `--kubeconfig` flag is needed to ask skaffold to not look for a kubernetes cluster.

note the git commit and update ../variables.tf  image variable
