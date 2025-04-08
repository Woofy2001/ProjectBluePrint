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

    colors = {
        "living room": "lightgray",
        "kitchen": "skyblue",
        "bedroom": "salmon",
        "bathroom": "lightgreen",
        "hallway": "wheat",
        "garage": "silver"
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

    layout = {}
    occupied = set()
    room_instances = []

    center = (100, 100)

    def mark_occupied(x, y, w, h, room_key):
        for dx in range(w):
            for dy in range(h):
                occupied.add((x + dx, y + dy))
                layout[(x + dx, y + dy)] = room_key

    def can_place(x, y, w, h):
        return all((x + dx, y + dy) not in occupied for dx in range(w) for dy in range(h))

    def draw_room(name, x, y, w, h, idx):
        px, py = x * grid_size, y * grid_size
        ax.add_patch(Rectangle((px, py), w * grid_size, h * grid_size, facecolor=colors[name], edgecolor="black", linewidth=2))
        ax.text(px + w * grid_size / 2, py + h * grid_size / 2, f"{name}", ha="center", va="center", fontsize=9)
        mark_occupied(x, y, w, h, (name, idx))
        room_instances.append({"name": name, "id": idx, "x": x, "y": y, "w": w, "h": h})

    lx, ly = center
    lw, lh = room_sizes["living room"]
    draw_room("living room", lx, ly, lw, lh, 0)
    if "living room" in room_counts:
        room_counts["living room"] -= 1
        if room_counts["living room"] <= 0:
            del room_counts["living room"]

    queue = []
    counter = {}
    for name, count in room_counts.items():
        for i in range(count):
            queue.append(name)
            counter[name] = counter.get(name, 0) + 1

    random.shuffle(queue)

    def neighbors(name):
        score = []
        for (x, y), (rtype, rid) in layout.items():
            weight = adjacency_weights.get((name, rtype), adjacency_weights.get((rtype, name), 1))
            score.append((weight, x, y))
        return sorted(score, key=lambda z: -z[0])

    idx_map = {}
    for name in queue:
        w, h = room_sizes[name]
        idx = idx_map.get(name, 1)
        idx_map[name] = idx + 1
        for _, tx, ty in neighbors(name):
            for dx, dy in [(1,0), (-1,0), (0,1), (0,-1)]:
                x, y = tx + dx, ty + dy
                if can_place(x, y, w, h):
                    draw_room(name, x, y, w, h, idx)
                    break
            else:
                continue
            break

    drawn = set()
    placed_doors = {}
    for r1 in room_instances:
        for r2 in room_instances:
            if r1 == r2 or ((r1["name"], r1["id"]), (r2["name"], r2["id"])) in drawn:
                continue
            if {r1["name"], r2["name"]} == {"bedroom"}:
                continue  # 🚫 No doors between bedrooms
            x1, y1, w1, h1 = r1["x"], r1["y"], r1["w"], r1["h"]
            x2, y2, w2, h2 = r2["x"], r2["y"], r2["w"], r2["h"]
            placed = False
            # right
            if x1 + w1 == x2 and y1 < y2 + h2 and y1 + h1 > y2:
                door_x = (x1 + w1) * grid_size
                door_y = max(y1, y2) * grid_size + grid_size // 2
                ax.plot([door_x, door_x], [door_y - 5, door_y + 5], color="white", linewidth=4)
                placed = True
            elif x2 + w2 == x1 and y1 < y2 + h2 and y1 + h1 > y2:
                door_x = x1 * grid_size
                door_y = max(y1, y2) * grid_size + grid_size // 2
                ax.plot([door_x, door_x], [door_y - 5, door_y + 5], color="white", linewidth=4)
                placed = True
            elif y1 + h1 == y2 and x1 < x2 + w2 and x1 + w1 > x2:
                door_x = max(x1, x2) * grid_size + grid_size // 2
                door_y = (y1 + h1) * grid_size
                ax.plot([door_x - 5, door_x + 5], [door_y, door_y], color="white", linewidth=4)
                placed = True
            elif y2 + h2 == y1 and x1 < x2 + w2 and x1 + w1 > x2:
                door_x = max(x1, x2) * grid_size + grid_size // 2
                door_y = y1 * grid_size
                ax.plot([door_x - 5, door_x + 5], [door_y, door_y], color="white", linewidth=4)
                placed = True

            if placed:
                key = r1["name"] + str(r1["id"]) if r1["name"] == "bathroom" else r2["name"] + str(r2["id"])
                if "bathroom" in {r1["name"], r2["name"]} and key in placed_doors:
                    continue
                placed_doors[key] = True
                drawn.add(((r1["name"], r1["id"]), (r2["name"], r2["id"])))

    for r in room_instances:
        if r["name"] == "living room":
            x, y, w, h = r["x"], r["y"], r["w"], r["h"]
            edges = {
                "bottom": [(x + i, y - 1) for i in range(w)],
                "top": [(x + i, y + h) for i in range(w)],
                "left": [(x - 1, y + i) for i in range(h)],
                "right": [(x + w, y + i) for i in range(h)],
            }
            for side, coords in edges.items():
                if all(c not in layout for c in coords):
                    if side == "bottom":
                        px = (x + w // 2) * grid_size
                        py = y * grid_size
                        ax.plot([px - 5, px + 5], [py, py], color="white", linewidth=4)
                    elif side == "top":
                        px = (x + w // 2) * grid_size
                        py = (y + h) * grid_size
                        ax.plot([px - 5, px + 5], [py, py], color="white", linewidth=4)
                    elif side == "left":
                        px = x * grid_size
                        py = (y + h // 2) * grid_size
                        ax.plot([px, px], [py - 5, py + 5], color="white", linewidth=4)
                    elif side == "right":
                        px = (x + w) * grid_size
                        py = (y + h // 2) * grid_size
                        ax.plot([px, px], [py - 5, py + 5], color="white", linewidth=4)
                    break
            break

    os.makedirs("static", exist_ok=True)
    plt.axis("off")
    plt.savefig("static/floor_plan.png", dpi=100, bbox_inches="tight")
    plt.close()
    return "floor_plan.png"
