import re

def extract_house_details(user_input):
    """
    Extract house-related details from user input.
    If the input does not describe a house, return an error message.
    """
    # Define valid house-related keywords
    valid_keywords = {"bedroom", "bathroom", "kitchen", "living room", "garage", "balcony", "hall", "dining room"}
    
    # Convert input to lowercase
    user_input_lower = user_input.lower()
    
    # Check if any valid house-related words exist in the input
    if not any(word in user_input_lower for word in valid_keywords):
        return {"error": "Invalid prompt. Please enter a house description, e.g., '2 bedrooms, 1 kitchen, 1 living room'."}

    # Extract number of rooms using regex
    room_counts = {}
    for room in valid_keywords:
        match = re.search(rf"(\d+)\s*{room}", user_input_lower)
        if match:
            room_counts[room] = int(match.group(1))

    # Default values if no rooms are specified
    if not room_counts:
        return {"error": "Incomplete house description. Please specify the number of rooms."}

    return {"rooms": room_counts, "width": 50, "height": 50}
