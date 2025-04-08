import pytest
from fastapi.testclient import TestClient
from main import app  # Ensure this imports the correct FastAPI app

client = TestClient(app)

# Test for missing file upload
def test_predict_no_file():
    response = client.post("/generate-plan")
    assert response.status_code == 400
    assert response.json() == {"detail": "No file uploaded"}

# Test for file upload (with temporary file using tempfile)
import tempfile

def test_predict_with_file():
    with tempfile.NamedTemporaryFile(delete=False) as f:
        f.write(b"test data")
        f.seek(0)  # Reset file pointer to the beginning
        response = client.post(
            "/generate-plan",
            files={"file": ("test_file.png", f, "image/png")}
        )
    assert response.status_code == 200
    assert "image_url" in response.json()
    assert "file_path" in response.json()

# Test for invalid file type
def test_invalid_file_type():
    with tempfile.NamedTemporaryFile(delete=False) as f:
        f.write(b"test data")
        f.seek(0)  # Reset file pointer to the beginning
        response = client.post(
            "/generate-plan",
            files={"file": ("test_file.txt", f, "text/plain")}
        )
    assert response.status_code == 400
    assert response.json() == {"detail": "Invalid file type"}

# Test for listing input files (assuming the endpoint is implemented)
def test_list_input_files():
    response = client.get("/list-input-files")
    assert response.status_code == 200
    assert "files" in response.json()
    assert isinstance(response.json()["files"], list)
