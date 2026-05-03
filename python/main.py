from fastapi import FastAPI, Depends, HTTPException, Header, Query
import httpx

app = FastAPI()

# MOCK MFDATA.IN DATABASE: This simulates the data your K8s CronJob will eventually scrape/load.
MFDATA_DB = {
    "122639": {"amc": "Parag Parikh", "aum_cr": 55000, "expense_ratio": 0.65},
    "120465": {"amc": "Axis", "aum_cr": 32000, "expense_ratio": 1.05},
    "118251": {"amc": "ICICI", "aum_cr": 7500, "expense_ratio": 0.75},
    "119062": {"amc": "HDFC", "aum_cr": 60000, "expense_ratio": 0.90},
    "120503": {"amc": "SBI", "aum_cr": 80000, "expense_ratio": 0.85},
}

def verify_token(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Unauthorized")
    return authorization.split(" ")[1]

@app.get("/search")
async def search_funds(
    q: str = Query(""),
    amc: str = Query("All"),
    aum: str = Query("All"),
    token: str = Depends(verify_token)
):
    # 1. Fetch live search results from mfapi.in
    async with httpx.AsyncClient() as client:
        search_url = f"https://api.mfapi.in/mf/search?q={q}" if q else "https://api.mfapi.in/mf/search?q=equity"
        response = await client.get(search_url)
        raw_results = response.json() if response.status_code == 200 else []

    enriched_results = []
    
    # 2. Enrich and Filter
    for fund in raw_results[:15]: # Limit to 15 results for performance
        code = str(fund.get("schemeCode"))
        
        # Simulate joining with mfdata.in data. Default to "Unknown" if not in our mock DB
        metadata = MFDATA_DB.get(code, {"amc": "Other", "aum_cr": 15000, "expense_ratio": "1.00"})
        
        # Apply AMC Filter
        if amc != "All" and metadata["amc"] != amc:
            continue
            
        # Apply AUM Filter
        if aum != "All":
            if aum == "0-10000" and metadata["aum_cr"] > 10000: continue
            if aum == "10000-50000" and (metadata["aum_cr"] < 10000 or metadata["aum_cr"] > 50000): continue
            if aum == ">50000" and metadata["aum_cr"] <= 50000: continue
            
        enriched_results.append({
            "scheme_code": code,
            "name": fund.get("schemeName"),
            "amc": metadata["amc"],
            "aum_cr": metadata["aum_cr"],
            "expense_ratio": metadata["expense_ratio"]
        })
        
    return {"results": enriched_results}