from fastapi import FastAPI, Request
from fastapi.responses import FileResponse
from floor_plan.text_processor import extract_house_details
from floor_plan.plan_generator import generate_floor_plan
from floor_plan.cad_exporter import export_to_cad
import os

app = FastAPI()

# Ensure static folder exists
os.makedirs("static", exist_ok=True)

@app.post("/extract")
async def extract_details(request: Request):
    data = await request.json()
    house_data = extract_house_details(data["text"])
    return {"house_data": house_data}

@app.post("/generate-plan")
async def generate_plan(request: Request):
    data = await request.json()
    house_data = extract_house_details(data["text"])
    generate_floor_plan(house_data)
    return {"message": "Floor plan generated", "image_url": "/static/floor_plan.png"}

@app.get("/export-cad")
async def export_cad():
    house_data = {"rooms": {"bedroom": 3, "bathroom": 2}, "width": 50, "height": 40}
    export_to_cad(house_data)
    return FileResponse("static/floor_plan.dxf", media_type="application/dxf")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
