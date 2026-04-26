from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/balance/{user_id}")
async def get_balance(user_id: str):
    # Mock data for now
    print(f"Fetching balance for user: {user_id}")
    return {"user_id": user_id, "balance": 1000.00, "currency": "USD"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)