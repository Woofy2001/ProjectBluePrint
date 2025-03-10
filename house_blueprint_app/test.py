import h5py

model_path = "room_extractor_model/tf_model.h5"

with h5py.File(model_path, 'r') as f:
    print("✅ Keys inside H5 file:", list(f.keys()))
    if 'model_weights' in f:
        print("✅ Found model weights!")
    else:
        print("❌ Model weights not found!")

    if 'model_config' in f:
        print("✅ Found model architecture!")
    else:
        print("❌ Model architecture not found!")

    print("✅ Layers inside H5 file:", list(f['model_weights'].keys()) if 'model_weights' in f else "No weights found.")
