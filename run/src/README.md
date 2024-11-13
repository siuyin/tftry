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

You can also get the same effect with `export KUBECONFIG=/dev/null`.
Then you can just issue `skaffold build`.

note the git commit and update ../variables.tf  image variable
