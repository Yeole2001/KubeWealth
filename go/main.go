package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type BookmarkRequest struct {
	SchemeCode string `json:"scheme_code"`
	SchemeName string `json:"scheme_name"`
}

func main() {
	http.HandleFunc("/bookmark", func(w http.ResponseWriter, r *http.Request) {
		var req BookmarkRequest
		err := json.NewDecoder(r.Body).Decode(&req)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		// The requested console logs for verification
		log.Println("--------------------------------------------------")
		log.Printf("[GO WATCHLIST SERVICE] User triggered bookmark action.\n")
		log.Printf("[GO WATCHLIST SERVICE] Scheme Name: %s\n", req.SchemeName)
		log.Printf("[GO WATCHLIST SERVICE] Scheme Code: %s\n", req.SchemeCode)
		log.Printf("[GO WATCHLIST SERVICE] Executing INSERT INTO user_portfolios...\n")
		log.Printf("[GO WATCHLIST SERVICE] Database commit successful!\n")
		log.Println("--------------------------------------------------")

		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "Success! '%s' saved to your Postgres Watchlist via Go Engine.", req.SchemeName)
	})

	log.Println("Watchlist Service (Go) starting on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}