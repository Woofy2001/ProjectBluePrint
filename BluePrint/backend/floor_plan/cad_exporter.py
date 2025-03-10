import os
import ezdxf

def export_to_cad(house_data, filename="static/floor_plan.dxf"):
    """Exports the generated floor plan to a DXF (CAD) file."""
    
    # Ensure directory exists
    save_path = os.path.dirname(filename)
    os.makedirs(save_path, exist_ok=True)

    doc = ezdxf.new()
    msp = doc.modelspace()

    # Room dimensions from previous code
    room_widths = {"bedroom": 20, "living room": 30, "kitchen": 24, "bathroom": 12, "garage": 40}
    room_heights = {"bedroom": 24, "living room": 36, "kitchen": 20, "bathroom": 12, "garage": 16}

    # Draw rooms and walls based on the room positions in house_data
    current_x = 2
    current_y = 2
    for room_name in house_data["rooms"]:
        width = room_widths[room_name]
        height = room_heights[room_name]
        msp.add_lwpolyline([(current_x, current_y), 
                             (current_x + width, current_y), 
                             (current_x + width, current_y + height), 
                             (current_x, current_y + height), 
                             (current_x, current_y)], close=True)
        current_y += height + 2  # Adjust space between rooms

    doc.saveas(filename)
    print(f"CAD file saved as {filename}")
