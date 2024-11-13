package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"

	firestore "cloud.google.com/go/firestore/apiv1"
	firestorepb "cloud.google.com/go/firestore/apiv1/firestorepb"
	"google.golang.org/api/iterator"
)

const publicHTML = "/tmp/data/public"
const dataDir = "/tmp/data/logs"

var firestoreClient *firestore.Client
var err error

func main() {
	log.Println("starting app...")
	defer firestoreClient.Close()

	http.HandleFunc("/hello", helloHandler)
	http.HandleFunc("/customers", customerHandler)

	http.Handle("/", http.FileServer(http.Dir(publicHTML)))
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func init() {
	os.MkdirAll(publicHTML, 0775)
	os.MkdirAll(dataDir, 0775)
	firestoreClient, err = firestore.NewClient(context.Background())
	if err != nil {
		log.Fatal("could not create firestore client")
	}
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	tm := "hello called: " + time.Now().Format("2006-01-02T15:04:05.000000")
	io.WriteString(w, tm)
	fmt.Println(tm)
}

func customerHandler(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "customer handler here")
	listDocuments(w)
}

func listDocuments(w http.ResponseWriter) {
	ctx := context.Background()
	req := &firestorepb.ListDocumentsRequest{
		Parent: "projects/lsy1030/databases/(default)/documents",
	}
	it := firestoreClient.ListDocuments(ctx, req)
	for {
		resp, err := it.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Println(err)
		}

		io.WriteString(w, resp.String())

		// If you need to access the underlying RPC response,
		// you can do so by casting the `Response` as below.
		// Otherwise, remove this line. Only populated after
		// first call to Next(). Not safe for concurrent access.
		_ = it.Response.(*firestorepb.ListDocumentsResponse)
	}
}
