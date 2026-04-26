package main

import (
    "fmt"
    "log"
    "net/http"
)

func transferHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method == http.MethodPost {
        // Log the intent for observability practice later
        fmt.Println("Transaction received: Processing transfer...")
        w.WriteHeader(http.StatusAccepted)
        fmt.Fprintf(w, "Transaction Successful (Go Service)")
    } else {
        http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
    }
}

func main() {
    http.HandleFunc("/transfer", transferHandler)
    fmt.Println("Transaction Service (Go) starting on port 8080...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}