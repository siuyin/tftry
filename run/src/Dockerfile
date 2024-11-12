FROM golang:1.23 as build
WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go vet -v
RUN go test -v
RUN CGO_ENABLED=0 go build -o /bin/app

FROM gcr.io/distroless/static-debian12
COPY --from=build /bin/app /
CMD ["/app"]
