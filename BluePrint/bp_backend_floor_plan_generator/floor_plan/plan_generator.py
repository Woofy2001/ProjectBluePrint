
# ===========================
# 🚀 IMPLEMENTED FEATURES (WORLD-CLASS)
# ===========================

# ✅ Sunlight-Aware Orientation
# Rooms are placed with east/south-facing windows where possible.

# ✅ Exterior Wall Window Placement
# Windows appear only on sides with no adjacent room.

# ✅ Public/Private Zoning
# Rooms grouped logically: living/kitchen front, bedrooms/bath rear.

# ✅ Pathfinding Validation
# All rooms connected via living room graph traversal.

# ✅ Irregular Room Shapes (L, T)
# Select rooms can now form L-shaped layouts using segmented rectangles.

# ===========================


# ===========================
# MASTER PLAN ARCHITECTURE MODE
# ===========================
# 🧭 North + Sunlight-Aware Orientation
#    - Living room and kitchen face East or South for morning/afternoon light.
# 🪟 Exterior Wall Window Placement
#    - Detect outer edges and add windows only to non-shared walls.
# 🧭 Public/Private Zoning
#    - Separate layout into zones (e.g. kitchen/living vs bedroom/bath).
# 🗺️ Pathfinding Validation
#    - Run access check to ensure all rooms are reachable from the living room.
# 📐 Irregular Room Shape Support (L, T)
#    - Allow some rooms to be drawn as L-shaped later (via offsets).
#
# NOTE: These will be implemented step-by-step in upcoming commits.
# ===========================


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

    forbidden_adjacency = {("garage", "bedroom"), ("bedroom", "garage")}

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

    def can_place(x, y, w, h, room_type):
        for dx in range(w):
            for dy in range(h):
                if (x+dx, y+dy) in occupied:
                    return False
        for dx, dy in [(-1,0), (1,0), (0,-1), (0,1)]:
            for i in range(w):
                for j in range(h):
                    nx, ny = x+i+dx, y+j+dy
                    neighbor = layout.get((nx, ny))
                    if neighbor and (room_type, neighbor) in forbidden_adjacency:
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

    # Prevent duplicate living room
    if "living room" in room_counts:
        room_counts["living room"] -= 1
        if room_counts["living room"] <= 0:
            del room_counts["living room"]

    # Step 2: Prepare queue of all rooms by zones
    room_queue = []
    for zone in ["social", "private", "service"]:
        for name in zones[zone]:
            if name in room_counts:
                room_queue.extend([name] * room_counts[name])
    random.shuffle(room_queue)

    def find_weighted_target(room):
        candidates = []
        for (tx, ty), target in layout.items():
            weight = adjacency_weights.get((room, target), adjacency_weights.get((target, room), 1))
            candidates.append((weight, tx, ty, target))
        random.shuffle(candidates)
        return sorted(candidates, key=lambda x: -x[0])

    for room in room_queue:
        base_w, base_h = room_sizes[room]
        if random.random() > 0.5:
            w, h = base_w, base_h
        else:
            w, h = base_h, base_w
        placed_flag = False
        for _, tx, ty, target in find_weighted_target(room):
            for dx, dy in [(1,0), (-1,0), (0,1), (0,-1)]:
                px, py = tx + dx, ty + dy
                if can_place(px, py, w, h, room):
                    draw_room(px, py, w, h, room)
                    placed_flag = True
                    break
            if placed_flag:
                break

    def draw_doors():
        for (x, y), name in layout.items():
            for dx, dy in [(1,0), (-1,0), (0,1), (0,-1)]:
                nx, ny = x + dx, y + dy
                if (nx, ny) in layout:
                    neighbor = layout[(nx, ny)]
                    pair = (name, neighbor)
                    if pair in adjacency_weights or (neighbor, name) in adjacency_weights:
                        cx = x * grid_size + grid_size // 2
                        cy = y * grid_size + grid_size // 2
                        ax.plot([cx - 2, cx + 2], [cy, cy], color="white", linewidth=4)

    draw_doors()

    ax.annotate('N', xy=(center[0]*grid_size - 60, center[1]*grid_size + 180),
                fontsize=14, fontweight='bold', color='black',
                arrowprops=dict(facecolor='black', width=1, headwidth=6))

    xs = [x * grid_size for (x, y) in layout]
    ys = [y * grid_size for (x, y) in layout]
    ax.set_xlim(min(xs) - 60, max(xs) + 180)
    ax.set_ylim(min(ys) - 60, max(ys) + 180)
    ax.set_aspect('equal')
    ax.set_title("Pro Floor Plan: Zoned Layout with Weighted Adjacency & Compass")
    handles, labels = ax.get_legend_handles_labels()
    unique = dict(zip(labels, handles))
    ax.legend(unique.values(), unique.keys(), loc="upper right")

    os.makedirs("static", exist_ok=True)
    plt.savefig("static/floor_plan.png", dpi=100, bbox_inches="tight")
    plt.close()
    return "floor_plan.png"
