import tkinter as tk
from tkinter import messagebox
from floor_plan.plan_generator import generate_floor_plan
from floor_plan.cad_exporter import export_to_cad
from data_extraction.text_processor import extract_house_details

def generate_plan():
    """Handles the user input and generates the floor plan."""
    user_input = user_input_entry.get("1.0", "end-1c")  # Retrieve user input
    house_data = extract_house_details(user_input)  # Extract structured data
    generate_floor_plan(house_data)  # Generate the floor plan based on the extracted data

def export_cad():
    """Exports the floor plan to a CAD file."""
    user_input = user_input_entry.get("1.0", "end-1c")
    house_data = extract_house_details(user_input)
    export_to_cad(house_data)
    messagebox.showinfo("Success", "Floor plan exported as CAD file.")  # Show confirmation message

# Create the main window for user input
root = tk.Tk()
root.title("Blueprint App")
root.geometry("400x300")

tk.Label(root, text="Enter house description:").pack()
user_input_entry = tk.Text(root, height=5, width=40)  # Text box for house description
user_input_entry.pack()

tk.Button(root, text="Generate Floor Plan", command=generate_plan).pack()
tk.Button(root, text="Export to CAD", command=export_cad).pack()

root.mainloop()
