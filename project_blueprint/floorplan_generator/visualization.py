import matplotlib.pyplot as plt
from layout_generator import generate_layout

def draw_floor_plan(layout):
    """Draws the generated floor plan using Matplotlib."""
    fig, ax = plt.subplots()

    for room in layout:
        rect = plt.Rectangle((room["x"], room["y"]), room["width"], room["height"],
                             linewidth=2, edgecolor='black', facecolor='lightgray')
        ax.add_patch(rect)
        ax.text(room["x"] + room["width"] / 2, room["y"] + room["height"] / 2,
                room["room"], ha='center', va='center', fontsize=10, color='black')

    ax.set_xlim(0, sum([r["width"] for r in layout]) + 1)
    ax.set_ylim(0, max([r["height"] for r in layout]) + 1)
    ax.set_aspect('equal')
    plt.grid(True)
    plt.show()

if __name__ == "__main__":
    test_layout = generate_layout({'bedroom': 2, 'kitchen': 1})
    draw_floor_plan(test_layout)
