package helloworld

import (
	"context"
	"encoding/json"
	"fmt"
	"html"
	"log"
	"net/http"
	"time"

	"cloud.google.com/go/pubsub"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"github.com/siuyin/dflt"
)

var (
	ps  *pubsub.Client
	err error
)

func init() {
	functions.HTTP("HelloHTTP", helloHTTP)
	ps, err = pubsub.NewClient(context.Background(), dflt.EnvString("PROJECT_ID", "lsy1030"))
	if err != nil {
		log.Fatal("could not create pubsub client", err)
	}
}

// helloHTTP is an HTTP Cloud Function with a request parameter.
func helloHTTP(w http.ResponseWriter, r *http.Request) {
	var d struct {
		Name string `json:"name"`
	}
	if err := json.NewDecoder(r.Body).Decode(&d); err != nil {
		fmt.Fprint(w, "Hello, World!")
		publishHello()
		return
	}
	if d.Name == "" {
		fmt.Fprint(w, "Hello, World!")
		return
	}
	fmt.Fprintf(w, "Hello, %s!", html.EscapeString(d.Name))
	publishWithName(d.Name)
}

func publishHello() {
	ctx := context.Background()
	topic := ps.Topic(dflt.EnvString("TOPIC", "gerbau"))
	if ok, err := topic.Exists(ctx); !ok || err != nil {
		log.Fatal("topic issue:", err)
	}

	topic.Publish(ctx, &pubsub.Message{Data: []byte("to gerbau from serpau")})
}

func publishWithName(name string) {
	ctx := context.Background()
	topic := ps.Topic(dflt.EnvString("TOPIC", "gerbau"))
	if ok, err := topic.Exists(ctx); !ok || err != nil {
		log.Fatal("topic issue:", err)
	}

	topic.Publish(ctx,
		&pubsub.Message{
			Data: []byte(fmt.Sprintf("Hello: %s. The time is %s", name, time.Now().Format("2006-01-02 15:04:05.000000"))),
		},
	)
}
