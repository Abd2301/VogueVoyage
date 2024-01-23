import pandas as pd
import os

def create_yolo_annotations(csv_file_path, image_folder, output_folder, class_mapping):
    # Read the CSV file into a DataFrame
    df = pd.read_csv(csv_file_path)

    # Check if 'id' and 'articleType' columns exist
    required_columns = ['id', 'articleType']
    if not all(col in df.columns for col in required_columns):
        print("Error: Required columns not found in the CSV file.")
        return

    # Iterate over rows in the DataFrame
    for _, row in df.iterrows():
        image_id = row['id']
        class_name = row['articleType']

        # Get the class index based on the class_mapping
        class_index = class_mapping.get(class_name, -1)
        
        # Skip if the class index is not found
        if class_index == -1:
            continue

        # Set bounding box coordinates to cover the entire image
        x_min, y_min, x_max, y_max = 0.0, 0.0, 1.0, 1.0

        # Create a YOLO annotation line
        yolo_annotation = f"{class_index} {0.5 * (x_min + x_max)} {0.5 * (y_min + y_max)} {x_max - x_min} {y_max - y_min}"

        # Create a txt file for each image
        txt_filename = f"{image_id}.txt"
        txt_path = os.path.join(output_folder, txt_filename)

        with open(txt_path, 'w') as txt_file:
            txt_file.write(yolo_annotation)

if __name__ == "__main__":
    csv_file_path = "path/to/your/csv_file.csv"
    image_folder_path = "path/to/your/imagesedited"
    output_folder_path = "path/to/your/yolo_annotations"
    
    # Class mapping dictionary (replace with your actual class mapping)
    class_mapping = {'Shirts': 0, 'Jeans': 1, 'Track Pants': 2}
    desired_classes = ['Shirt', 'Blazers', 'Hoodies', 'Skirts', 'Jeans', 'Casual Pants', 'Tshirts', 'Tops', 'Sweatshirts', 'Shorts', 'Sarees', 'Dresses', 'Shrugs', 'Jackets', 'Sweaters', 'Leggings', 'Kurtas'] 

    # Ensure the output folder exists, create if not
    os.makedirs(output_folder_path, exist_ok=True)

    create_yolo_annotations(csv_file_path, image_folder_path, output_folder_path, class_mapping)
