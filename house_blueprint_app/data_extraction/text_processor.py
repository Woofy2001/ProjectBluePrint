import re
import nltk

nltk.download("punkt")

def extract_house_details(user_input):
    """Extracts structured details from user input."""
    room_pattern = r"(\d+)\s*(bedroom|bathroom|kitchen|living room|garage)"
    dimension_pattern = r"(\d+)\s*x\s*(\d+)\s*(feet|meters)"
    
    rooms = re.findall(room_pattern, user_input.lower())
    dimensions = re.search(dimension_pattern, user_input.lower())

    room_dict = {room_type: int(count) for count, room_type in rooms}
    width, height = (int(dimensions[1]), int(dimensions[2])) if dimensions else (50, 50)

    return {"rooms": room_dict, "width": width, "height": height}
