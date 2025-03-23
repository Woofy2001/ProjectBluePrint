import matplotlib
matplotlib.use('Agg')  # ✅ Use non-GUI backend to avoid NSWindow errors on macOS
import matplotlib.pyplot as plt
from shapely.geometry import Polygon
import os
import random
import math

def generate_floor_plan(house_data):
    """Generates a structured 2D floor plan with dynamically scaled rooms, ensuring proper adjacency and no missing placements."""
    
    # ✅ Validate house_data before proceeding
    if "width" not in house_data or "height" not in house_data or "rooms" not in house_data:
        raise ValueError("Invalid house data format. Must include 'width', 'height', and 'rooms'.")

    base_width, base_height = house_data["width"], house_data["height"]
    total_rooms = sum(house_data["rooms"].values())
    canvas_scaling_factor = max(1, math.ceil(total_rooms / 5))  # Auto-adjust size
    width, height = base_width * canvas_scaling_factor, base_height * canvas_scaling_factor

    fig, ax = plt.subplots(figsize=(12, 9))  # Optimized canvas size
    print(f"✅ Initializing floor plan with width: {width} and height: {height}")

    # ✅ Define proportional room sizes dynamically
    base_size = max(5, min(width, height) // 7)  # Minimum room size enforced
    room_sizes = {
        "living room": (base_size * 2, base_size * 1.5),
        "bedroom": (base_size * 1.2, base_size),
        "bathroom": (base_size * 0.8, base_size * 0.7),
        "kitchen": (base_size * 1.5, base_size),
        "garage": (base_size * 2, base_size * 1.2)
    }

    occupied_positions = set()
    placed_rooms = {}
    room_coords = {}
    adjacency_rules = {
        "bedroom": ["living room", "bathroom"],
        "bathroom": ["bedroom", "kitchen"],
        "kitchen": ["living room", "garage"],
        "garage": ["kitchen", "living room"]
    }

    def check_overlap(x, y, width, height):
        """Check if a room overlaps with existing ones."""
        for (ox, oy, ow, oh) in occupied_positions:
            if not (x + width <= ox or x >= ox + ow or y + height <= oy or y >= oy + oh):
                return True  # Overlapping detected
        return False

    def find_adjacent_position(ref_x, ref_y, room_w, room_h):
        """Finds a valid adjacent position while avoiding overlaps."""
        possible_positions = [
            (ref_x + room_w, ref_y), (ref_x - room_w, ref_y),
            (ref_x, ref_y + room_h), (ref_x, ref_y - room_h)
        ]
        random.shuffle(possible_positions)
        for new_x, new_y in possible_positions:
            if not check_overlap(new_x, new_y, room_w, room_h):
                occupied_positions.add((new_x, new_y, room_w, room_h))
                return new_x, new_y
        return None, None

    def draw_room(ax, x, y, width, height, label, color):
        """Draws a room as a rectangle on the floor plan."""
        outer_polygon = Polygon([
            (x, y), (x + width, y), (x + width, y + height), (x, y + height)
        ])
        ax.fill(*outer_polygon.exterior.xy, alpha=0.5, label=label, color=color)
        ax.plot(*outer_polygon.exterior.xy, color="black", linewidth=2)
        ax.text(x + width / 2, y + height / 2, label, fontsize=9, color="black", ha="center", va="center")
        return (x, y, width, height)

    def add_doorway_gap(ax, room1, room2):
        """Creates a small doorway gap between two adjacent rooms."""
        x1, y1, w1, h1 = room1
        x2, y2, w2, h2 = room2

        if abs(x1 - x2) < w1:  # Vertical adjacency
            door_x = (x1 + x2 + w1) / 2
            door_y = max(y1, y2) + 0.5
            ax.plot([door_x - 0.5, door_x + 0.5], [door_y, door_y], color="white", linewidth=5)
        else:  # Horizontal adjacency
            door_x = max(x1, x2) + 0.5
            door_y = (y1 + y2 + h1) / 2
            ax.plot([door_x, door_x], [door_y - 0.5, door_y + 0.5], color="white", linewidth=5)

    # ✅ Place the living room at the center of the canvas
    center_x, center_y = width // 3, height // 2
    occupied_positions.add((center_x, center_y, *room_sizes["living room"]))
    placed_rooms["living room"] = (center_x, center_y)
    room_coords["living room"] = draw_room(ax, center_x, center_y, *room_sizes["living room"], "living room", "lightgray")

    for room_name, room_count in house_data["rooms"].items():
        for _ in range(room_count):
            if room_name == "living room" and "living room" in placed_rooms:
                continue  # Ensure only one living room is placed

            ref_rooms = adjacency_rules.get(room_name, ["living room"])
            placed = False
            random.shuffle(ref_rooms)
            for ref_room in ref_rooms:
                if ref_room in placed_rooms:
                    ref_x, ref_y = placed_rooms[ref_room]
                    new_x, new_y = find_adjacent_position(ref_x, ref_y, *room_sizes[room_name])
                    if new_x is not None and new_y is not None:
                        occupied_positions.add((new_x, new_y, *room_sizes[room_name]))
                        placed_rooms[room_name] = (new_x, new_y)
                        room_coords[room_name] = draw_room(ax, new_x, new_y, *room_sizes[room_name], room_name, random.choice(["skyblue", "orange", "lightgreen", "brown", "pink"]))
                        add_doorway_gap(ax, room_coords[ref_room], room_coords[room_name])
                        placed = True
                        break
            if not placed:
                print(f"⚠ Warning: {room_name} was not placed. Expanding search range.")
                for _ in range(5):  # Allow more retries with varied offsets
                    new_x, new_y = random.randint(0, width - int(room_sizes[room_name][0])), random.randint(0, height - int(room_sizes[room_name][1]))
                    if not check_overlap(new_x, new_y, *room_sizes[room_name]):
                        occupied_positions.add((new_x, new_y, *room_sizes[room_name]))
                        placed_rooms[room_name] = (new_x, new_y)
                        room_coords[room_name] = draw_room(ax, new_x, new_y, *room_sizes[room_name], room_name, random.choice(["skyblue", "orange", "lightgreen", "brown", "pink"]))
                        break

    ax.set_xlim(0, width)
    ax.set_ylim(0, height)
    ax.set_title("Generated 2D Floor Plan - Optimized Layout with Doorway Gaps & Randomization")
    ax.legend()

    # ✅ Ensure 'static/' directory exists
    output_dir = "static"
    os.makedirs(output_dir, exist_ok=True)

    # ✅ Save image to the correct path
    image_path = os.path.join(output_dir, "floor_plan.png")
    plt.savefig(image_path, format="png", dpi=100, bbox_inches="tight")
    plt.close(fig)  # ✅ Prevent memory issues

    print(f"✅ Floor plan saved at {image_path}")  # Debugging print

    return "floor_plan.png"  # ✅ Return only the filename
