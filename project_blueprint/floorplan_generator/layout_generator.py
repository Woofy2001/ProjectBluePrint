import numpy as np
from user_input_parser import ROOM_SIZES

def generate_layout(parsed_rooms):
    """Generate a simple 2D layout placing rooms in a grid."""
    layout = []
    x_offset = 0

    for room, count in parsed_rooms.items():
        width, height = ROOM_SIZES[room]
        for _ in range(count):
            layout.append({
                "room": room,
                "x": x_offset,
                "y": 0,
                "width": width,
                "height": height
            })
            x_offset += width  # Shift right for the next room
    return layout

if __name__ == "__main__":
    test_rooms = {'bedroom': 2, 'kitchen': 1}
    print(generate_layout(test_rooms))
