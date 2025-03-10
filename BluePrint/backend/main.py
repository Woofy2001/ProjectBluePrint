from fastapi import FastAPI, Request
from fastapi.responses import FileResponse
from floor_plan.text_processor import extract_house_details
from floor_plan.plan_generator import generate_floor_plan
from floor_plan.cad_exporter import export_to_cad
from fastapi import FastAPI
from pydantic import BaseModel 
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import os
from fastapi.staticfiles import StaticFiles
import json


app = FastAPI()

# ✅ Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)

class HouseRequest(BaseModel):
    text: str

@app.get("/")
def read_root():
    return {"message": "Welcome to Blueprint API"}

app.mount("/static", StaticFiles(directory="static"), name="static")

# ✅ Extract house details with validation
@app.post("/extract")
def extract_details(request: HouseRequest):
    house_data = extract_house_details(request.text)
    
    # If validation fails, return an error response
    if "error" in house_data:
        raise HTTPException(status_code=400, detail=house_data["error"])

    return {"house_data": house_data}

# ✅ Generate floor plan only if prompt is valid
@app.post("/generate-plan")
def generate_plan(request: HouseRequest):
    try:
        # ✅ Convert input text to structured house data
        house_data = extract_house_details(request.text)

        # ✅ If invalid input, return an error
        if "error" in house_data:
            raise HTTPException(status_code=400, detail=house_data["error"])

        # ✅ Ensure `house_data` is a dictionary
        if isinstance(house_data, str):
            house_data = json.loads(house_data)  # Convert string to dictionary

        # ✅ Generate floor plan image
        image_path = generate_floor_plan(house_data)

        return {"message": "Floor plan generated", "image_url": f"/static/{image_path}"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ✅ Export floor plan to CAD
@app.get("/export-cad")
def export_cad():
    dxf_path = export_to_cad()
    return {"message": "CAD file exported", "cad_url": f"/static/{dxf_path}"}

# ✅ Ensure the `static/` folder exists
if not os.path.exists("static"):
    os.makedirs("static")