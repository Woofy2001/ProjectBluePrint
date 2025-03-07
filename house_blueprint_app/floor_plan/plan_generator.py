import matplotlib.pyplot as plt
from shapely.geometry import Polygon
import os
import random

def generate_floor_plan(house_data):
    """Generates a structured 2D floor plan with rooms placed adjacently, avoiding floating and overlaps."""
    width, height = house_data["width"], house_data["height"]

    # Adjust grid size dynamically based on house size
    total_rooms = sum(house_data["rooms"].values())
    grid_size = max(6, int((total_rooms + 3) ** 0.5))
    base_size = min(width, height) // grid_size

    fig, ax = plt.subplots(figsize=(10, 6))
    print("Initializing floor plan with width:", width, "and height:", height)

    # Adjust room sizes to be smaller and fit within available space
    max_room_width = width // (grid_size * 2)
    max_room_height = height // (grid_size * 2)
    room_sizes = {
        "living room": (max_room_width * 2, max_room_height * 2),
        "bedroom": (max_room_width, max_room_height),
        "bathroom": (max_room_width // 1.5, max_room_height // 1.5),
        "kitchen": (max_room_width, max_room_height),
        "garage": (max_room_width * 1.8, max_room_height * 1.5)
    }

    wall_thickness = 0.3
    occupied_positions = set()
    placed_rooms = {}

    adjacency_rules = {
        "bedroom": ["living room", "bathroom"],
        "bathroom": ["bedroom", "kitchen"],
        "kitchen": ["living room"],
        "garage": ["kitchen", "living room"]
    }

    def find_adjacent_position(ref_x, ref_y):
        possible_positions = [
            (ref_x + 1, ref_y), (ref_x - 1, ref_y),
            (ref_x, ref_y + 1), (ref_x, ref_y - 1)
        ]
        random.shuffle(possible_positions)
        for new_x, new_y in possible_positions:
            if (new_x, new_y) not in occupied_positions and 0 <= new_x < grid_size and 0 <= new_y < grid_size:
                occupied_positions.add((new_x, new_y))
                return new_x, new_y
        return None, None

    def draw_room(ax, grid_x, grid_y, width, height, label, color):
        x = grid_x * base_size
        y = grid_y * base_size
        outer_polygon = Polygon([
            (x, y), (x + width, y), (x + width, y + height), (x, y + height)
        ])
        ax.fill(*outer_polygon.exterior.xy, alpha=0.5, label=label, color=color)
        ax.plot(*outer_polygon.exterior.xy, color="black", linewidth=2)
        ax.text(x + width / 2, y + height / 2, label, fontsize=8, color="black", ha="center", va="center")

    # Place rooms adjacently while ensuring no floating and following adjacency logic
    start_x, start_y = grid_size // 2, grid_size // 2
    occupied_positions.add((start_x, start_y))
    placed_rooms["living room"] = (start_x, start_y)
    draw_room(ax, start_x, start_y, *room_sizes["living room"], "living room", "lightgray")

    for room_name in house_data["rooms"]:
        for _ in range(house_data["rooms"][room_name]):
            ref_rooms = adjacency_rules.get(room_name, ["living room"])
            placed = False
            for ref_room in ref_rooms:
                if ref_room in placed_rooms:
                    ref_x, ref_y = placed_rooms[ref_room]
                    new_x, new_y = find_adjacent_position(ref_x, ref_y)
                    if new_x is not None and new_y is not None:
                        placed_rooms[room_name] = (new_x, new_y)
                        draw_room(ax, new_x, new_y, *room_sizes[room_name], room_name, random.choice(["skyblue", "orange", "lightgreen", "brown", "pink"]))
                        placed = True
                        break
            if not placed:
                print(f"Warning: Could not place {room_name}")

    ax.set_xlim(0, width)
    ax.set_ylim(0, height)
    ax.set_title("Generated 2D Floor Plan - Optimized Adjacency Layout")
    ax.legend()

    save_path = "assets/generated_plans"
    os.makedirs(save_path, exist_ok=True)
    plt.savefig(os.path.join(save_path, "floor_plan.png"))
    plt.show()
    print("Floor plan generation complete.")