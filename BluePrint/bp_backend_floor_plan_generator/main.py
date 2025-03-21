from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
import os
import json

# Importing functions from your backend modules
from floor_plan.text_processor import extract_house_details
from floor_plan.plan_generator import generate_floor_plan
from floor_plan.cad_exporter import export_to_cad

app = FastAPI()

# ✅ Enable CORS (for frontend connection)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (Change this in production)
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

# ✅ Prevent 404 errors for `/favicon.ico`
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

# ✅ **FIXED: Generate Floor Plan & Return Correct URL**
@app.post("/generate-plan")
async def generate_plan(request: Request):
    try:
        data = await request.json()
        prompt = data.get("prompt")

        if not prompt:
            return JSONResponse(content={"error": "Prompt is missing"}, status_code=400)

        # ✅ Extract house details
        house_data = extract_house_details(prompt)

        if "error" in house_data:
            raise HTTPException(status_code=400, detail=house_data["error"])

        if isinstance(house_data, str):
            house_data = json.loads(house_data)  # Convert string to dictionary if needed

        # ✅ Generate the floor plan image
        image_filename = generate_floor_plan(house_data)
        image_path = f"static/{image_filename}"

        print(f"✅ Floor plan saved at {image_path}")

        return JSONResponse(content={"image_url": f"/{image_path}"})  # Ensure proper URL

    except Exception as e:
        print(f"❌ [generate-plan] Error: {e}")
        return JSONResponse(content={"error": str(e)}, status_code=500)

# ✅ Export floor plan to CAD
@app.get("/export-cad")
def export_cad():
    dxf_path = export_to_cad()
    return {"message": "CAD file exported", "cad_url": f"/static/{dxf_path}"}

# ✅ Ensure the `static/` folder exists to prevent errors
if not os.path.exists("static"):
    os.makedirs("static")
