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
const dataDir = "/tmp/data"

func main() {
	fmt.Println("starting app...")

	http.HandleFunc("/hello", helloHandler)

	http.Handle("/", http.FileServer(http.Dir(publicHTML)))
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "hello world\n")
	fn := time.Now().Format("2006-01-02T15:04:05.000000.txt")

	if err := os.WriteFile(dataDir+"/"+fn, []byte("hello endpoint called"), 0664); err != nil {
		log.Println("error: writing:", fn)
	}
}
