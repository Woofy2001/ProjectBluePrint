
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import os
import random

def generate_floor_plan(house_data):
    if "rooms" not in house_data:
        raise ValueError("Missing room config")

    room_counts = house_data["rooms"]
    grid_size = 30
    fig, ax = plt.subplots(figsize=(16, 12))

    room_sizes = {
        "living room": (3, 2),
        "kitchen": (2, 1),
        "bedroom": (2, 1),
        "bathroom": (1, 1),
        "hallway": (1, 3),
        "garage": (2, 2)
    }

    zones = {
        "social": ["living room", "hallway"],
        "private": ["bedroom", "bathroom"],
        "service": ["kitchen", "garage"]
    }

    adjacency_weights = {
        ("bedroom", "bathroom"): 10,
        ("bedroom", "living room"): 8,
        ("kitchen", "living room"): 10,
        ("bathroom", "hallway"): 7,
        ("garage", "kitchen"): 8,
        ("hallway", "bedroom"): 5,
        ("hallway", "bathroom"): 5,
        ("hallway", "kitchen"): 5
    }

    colors = {
        "living room": "lightgray",
        "kitchen": "skyblue",
        "bedroom": "salmon",
        "bathroom": "lightgreen",
        "hallway": "wheat",
        "garage": "silver"
    }

    placed = []
    occupied = set()
    layout = {}
    room_locations = {}

    center = (100 + random.randint(0, 10), 100 + random.randint(0, 10))

    def mark_occupied(x, y, w, h, name):
        for dx in range(w):
            for dy in range(h):
                occupied.add((x+dx, y+dy))
                layout[(x+dx, y+dy)] = name
        room_locations.setdefault(name, []).append((x, y, w, h))

    def can_place(x, y, w, h):
        for dx in range(w):
            for dy in range(h):
                if (x+dx, y+dy) in occupied:
                    return False
        return True

    def draw_room(x, y, w, h, name):
        px, py = x * grid_size, y * grid_size
        rect = Rectangle((px, py), w * grid_size, h * grid_size,
                         facecolor=colors.get(name, "gray"), edgecolor="black", linewidth=2)
        ax.add_patch(rect)
        ax.text(px + w * grid_size / 2, py + h * grid_size / 2, name,
                ha="center", va="center", fontsize=9)
        mark_occupied(x, y, w, h, name)
        placed.append((name, x, y, w, h))

    # Step 1: Place Living Room at center
    lx, ly = center
    lw, lh = room_sizes["living room"]
    draw_room(lx, ly, lw, lh, "living room")
    access_set = {(x, y) for x in range(lx, lx+lw) for y in range(ly, ly+lh)}

    # Step 2: Build queue of all rooms except living room
    full_room_list = []
    for name, count in room_counts.items():
        if name != "living room":
            full_room_list.extend([name] * count)
    random.shuffle(full_room_list)

    def find_weighted_target(room):
        # Return best target room and position near it
        candidates = []
        for (tx, ty), target in layout.items():
            weight = adjacency_weights.get((room, target), adjacency_weights.get((target, room), 1))
            candidates.append((weight, tx, ty, target))
        random.shuffle(candidates)
        return sorted(candidates, key=lambda x: -x[0])

    for room in full_room_list:
        w, h = room_sizes[room]
        placed_flag = False
        for _, tx, ty, target in find_weighted_target(room):
            for dx, dy in [(1,0), (-1,0), (0,1), (0,-1)]:
                px, py = tx + dx, ty + dy
                if can_place(px, py, w, h):
                    draw_room(px, py, w, h, room)
                    access_set.update((px+i, py+j) for i in range(w) for j in range(h))
                    placed_flag = True
                    break
            if placed_flag:
                break

    # Step 3: Draw doors between adjacent rooms
    def draw_doors():
        for (x, y), name in layout.items():
            for dx, dy in [(1,0), (-1,0), (0,1), (0,-1)]:
                nx, ny = x + dx, y + dy
                if (nx, ny) in layout and layout[(nx, ny)] != name:
                    cx = x * grid_size + grid_size // 2
                    cy = y * grid_size + grid_size // 2
                    ax.plot([cx - 2, cx + 2], [cy, cy], color="white", linewidth=4)

    draw_doors()

    xs = [x * grid_size for (x, y) in layout]
    ys = [y * grid_size for (x, y) in layout]
    ax.set_xlim(min(xs) - 60, max(xs) + 180)
    ax.set_ylim(min(ys) - 60, max(ys) + 180)
    ax.set_aspect('equal')
    ax.set_title("Pro Floor Plan: Zoned Layout with Weighted Adjacency")
    handles, labels = ax.get_legend_handles_labels()
    unique = dict(zip(labels, handles))
    ax.legend(unique.values(), unique.keys(), loc="upper right")

    os.makedirs("static", exist_ok=True)
    plt.savefig("static/floor_plan.png", dpi=100, bbox_inches="tight")
    plt.close()
    return "floor_plan.png"
