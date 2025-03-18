from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import FileResponse, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
import os
import json

# Importing functions from your backend
from floor_plan.text_processor import extract_house_details
from floor_plan.plan_generator import generate_floor_plan
from floor_plan.cad_exporter import export_to_cad

app = FastAPI()

# ✅ Enable CORS (for frontend connection)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)

# ✅ Pydantic model for house requests
class HouseRequest(BaseModel):
    text: str

@app.get("/")
def read_root():
    return {"message": "Welcome to Blueprint API"}

# ✅ Fix: Prevent 404 errors for `/favicon.ico`
@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return Response(status_code=204)  # No Content

# ✅ Mount static directory for generated images & CAD files
app.mount("/static", StaticFiles(directory="static"), name="static")

# ✅ Extract house details with validation
@app.post("/extract")
def extract_details(request: HouseRequest):
    house_data = extract_house_details(request.text)
    
    if "error" in house_data:
        raise HTTPException(status_code=400, detail=house_data["error"])

    return {"house_data": house_data}

# ✅ Generate floor plan if input is valid
@app.post("/generate-plan")
def generate_plan(request: HouseRequest):
    try:
        house_data = extract_house_details(request.text)

        if "error" in house_data:
            raise HTTPException(status_code=400, detail=house_data["error"])

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

