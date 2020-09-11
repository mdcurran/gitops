package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

type server struct {
	router *httprouter.Router
}

func (s *server) helloWorld(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	w.WriteHeader(http.StatusOK)

	err := json.NewEncoder(w).Encode(map[string]string{"message": "Hello, World!"})
	if err != nil {
		panic(err)
	}
}

func main() {
	s := &server{
		router: httprouter.New(),
	}

	s.router.GET("/", s.helloWorld)

	fmt.Println("starting HTTP server")
	err := http.ListenAndServe(":8080", s.router)
	if err != nil {
		panic(err)
	}
}
