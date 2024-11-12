package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

const publicHTML = "/tmp/data/public"
const dataDir = "/tmp/data/logs"

func main() {
	fmt.Println("starting app...")

	http.HandleFunc("/hello", helloHandler)

	http.Handle("/", http.FileServer(http.Dir(publicHTML)))
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func init() {
	os.MkdirAll(publicHTML, 0775)
	os.MkdirAll(dataDir, 0775)
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "hello world\n")
	tm := "hello called: " + time.Now().Format("2006-01-02T15:04:05.000000")
	fmt.Println(tm)
}
