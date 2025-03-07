import matplotlib.pyplot as plt
from shapely.geometry import Polygon
import os
import random

def generate_floor_plan(house_data):
    """Generates a structured 2D floor plan with rooms placed adjacently, avoiding floating and ensuring randomness."""
    width, height = house_data["width"], house_data["height"]

    fig, ax = plt.subplots(figsize=(16, 12))  # Optimized canvas size
    print("Initializing floor plan with width:", width, "and height:", height)

    # Define smaller rectangular room sizes for better fit
    room_sizes = {
        "living room": (12, 8),
        "bedroom": (8, 6),
        "bathroom": (5, 4),
        "kitchen": (10, 6),
        "garage": (14, 8)
    }

    occupied_positions = set()
    placed_rooms = {}
    adjacency_rules = {
        "bedroom": ["living room", "bathroom"],
        "bathroom": ["bedroom", "kitchen"],
        "kitchen": ["living room"],
        "garage": ["kitchen", "living room"]
    }

    def find_adjacent_position(ref_x, ref_y, room_w, room_h):
        possible_positions = [
            (ref_x + room_w + 1, ref_y), (ref_x - room_w - 1, ref_y),
            (ref_x, ref_y + room_h + 1), (ref_x, ref_y - room_h - 1)
        ]
        random.shuffle(possible_positions)
        for new_x, new_y in possible_positions:
            if (new_x, new_y) not in occupied_positions:
                occupied_positions.add((new_x, new_y))
                return new_x, new_y
        return None, None

    def draw_room(ax, x, y, width, height, label, color):
        outer_polygon = Polygon([
            (x, y), (x + width, y), (x + width, y + height), (x, y + height)
        ])
        ax.fill(*outer_polygon.exterior.xy, alpha=0.5, label=label, color=color)
        ax.plot(*outer_polygon.exterior.xy, color="black", linewidth=3)
        ax.text(x + width / 2, y + height / 2, label, fontsize=10, color="black", ha="center", va="center")
        return (x, y, width, height)

    def add_doorway_gap(ax, room1, room2):
        x1, y1, w1, h1 = room1
        x2, y2, w2, h2 = room2

        if abs(x1 - x2) < w1:  # Vertical adjacency
            door_x = (x1 + x2 + w1) / 2
            door_y = max(y1, y2) + 0.5
            ax.plot([door_x - 0.8, door_x + 0.8], [door_y, door_y], color="white", linewidth=6)
        else:  # Horizontal adjacency
            door_x = max(x1, x2) + 0.5
            door_y = (y1 + y2 + h1) / 2
            ax.plot([door_x, door_x], [door_y - 0.8, door_y + 0.8], color="white", linewidth=6)

    # Start placing rooms
    start_x, start_y = 10, 10  # Start position for layout
    occupied_positions.add((start_x, start_y))
    placed_rooms["living room"] = (start_x, start_y)
    room_coords = {"living room": draw_room(ax, start_x, start_y, *room_sizes["living room"], "living room", "lightgray")}

    for room_name in house_data["rooms"]:
        for _ in range(house_data["rooms"][room_name]):
            ref_rooms = adjacency_rules.get(room_name, ["living room"])
            placed = False
            random.shuffle(ref_rooms)
            for ref_room in ref_rooms:
                if ref_room in placed_rooms:
                    ref_x, ref_y = placed_rooms[ref_room]
                    new_x, new_y = find_adjacent_position(ref_x, ref_y, *room_sizes[room_name])
                    if new_x is not None and new_y is not None:
                        placed_rooms[room_name] = (new_x, new_y)
                        room_coords[room_name] = draw_room(ax, new_x, new_y, *room_sizes[room_name], room_name, random.choice(["skyblue", "orange", "lightgreen", "brown", "pink"]))
                        add_doorway_gap(ax, room_coords[ref_room], room_coords[room_name])
                        placed = True
                        break

    ax.set_xlim(0, width)
    ax.set_ylim(0, height)
    ax.set_title("Generated 2D Floor Plan - Optimized Layout with Doorway Gaps")
    ax.legend()

    save_path = "assets/generated_plans"
    os.makedirs(save_path, exist_ok=True)
    plt.savefig(os.path.join(save_path, "floor_plan.png"))
    plt.show()
    print("Floor plan generation complete.")