package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
)

const publicHTML = "/tmp/public"

func main() {
	fmt.Println("starting app...")

	http.HandleFunc("/hello", helloHandler)

	http.Handle("/", http.FileServer(http.Dir(publicHTML)))
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "hello world\n")
}
