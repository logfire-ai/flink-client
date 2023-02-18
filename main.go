package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
)

func main() {
	port := "8080"
	log.Println("Do-Something")
	router := chi.NewRouter()
	router.Get("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Simple Server")
		log.Println("Started Server")
	})

	http.ListenAndServe(port, router)
}
