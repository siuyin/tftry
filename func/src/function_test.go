package helloworld

import (
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func Test_FuncGet(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(helloHTTP))
	defer ts.Close()

	res, err := http.Get(ts.URL)
	if err != nil {
		t.Error("could not get URL:", ts.URL)
	}

	greeting, err := io.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		t.Error("could not read result body")
	}

	if string(greeting) != "Hello, World!" {
		t.Error("incorrect body content:", string(greeting))
	}
}

func Test_FuncPost(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(helloHTTP))
	defer ts.Close()

	res, err := http.Post(ts.URL, "application/json", strings.NewReader(`{"name":"Gerbau"}`))
	if err != nil {
		t.Error("could not get URL:", ts.URL)
	}

	greeting, err := io.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		t.Error("could not read result body")
	}

	if string(greeting) != "Hello, Gerbau!" {
		t.Error("incorrect body content:", string(greeting))
	}
}

func Test_FuncPostNoData(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(helloHTTP))
	defer ts.Close()

	res, err := http.Post(ts.URL, "application/json", nil)
	if err != nil {
		t.Error("could not get URL:", ts.URL)
	}

	greeting, err := io.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		t.Error("could not read result body")
	}

	if string(greeting) != "Hello, World!" {
		t.Error("incorrect body content:", string(greeting))
	}
}
