import os
import ezdxf
from layout_generator import generate_layout
from ezdxf.enums import TextEntityAlignment  # ✅ Import correct alignment class

def generate_dxf(layout, filename="output/floor_plan.dxf"):
    """Generate a CAD file (DXF format) for the floor plan."""

    # ✅ Ensure 'output' directory exists
    os.makedirs("output", exist_ok=True)

    doc = ezdxf.new()
    msp = doc.modelspace()

    for room in layout:
        x, y, w, h = room["x"], room["y"], room["width"], room["height"]
        # Draw room rectangle
        msp.add_lwpolyline([(x, y), (x + w, y), (x + w, y + h), (x, y + h), (x, y)], close=True)
        # ✅ Correct text placement
        text = msp.add_text(room["room"], dxfattribs={"height": 0.5})
        text.set_placement((x + w / 2, y + h / 2), align=TextEntityAlignment.MIDDLE_CENTER)

    # ✅ Save DXF file safely
    doc.saveas(filename)
    print(f"✅ DXF file successfully saved as {filename}")

if __name__ == "__main__":
    test_layout = generate_layout({'bedroom': 2, 'kitchen': 1})
    generate_dxf(test_layout)
