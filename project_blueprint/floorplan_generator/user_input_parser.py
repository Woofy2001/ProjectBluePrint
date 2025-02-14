import re

ROOM_SIZES = {
    "bedroom": (3, 4), 
    "kitchen": (3, 3),
    "bathroom": (2, 2),
    "living_room": (4, 5),
    "dining_room": (3, 4),
}

def parse_user_input(user_input):
    """Extract room types and counts from user input text."""
    room_counts = {}
    for room in ROOM_SIZES.keys():
        pattern = rf"(\d+)\s*{room}"
        match = re.search(pattern, user_input.lower())
        if match:
            room_counts[room] = int(match.group(1))
    return room_counts

if __name__ == "__main__":
    user_prompt = input("Enter house description: ")
    print(parse_user_input(user_prompt))
