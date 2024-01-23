import pandas as pd
import os
import shutil

def filter_images_by_classes(image_folder, csv_file_path, output_folder, desired_classes):
    # Read the CSV file into a DataFrame
    df = pd.read_csv(csv_file_path)

    # Check if 'id' and 'articleType' columns exist
    if 'id' not in df.columns or 'articleType' not in df.columns:
        print("Error: 'id' or 'articleType' columns not found in the CSV file.")
        return

    # Iterate over rows in the DataFrame
    for _, row in df.iterrows():
        image_id = row['id']
        class_name = row['articleType']

        if class_name in desired_classes:
            # Assuming your images have filenames like 'image_id.jpg'
            image_name = f"{image_id}.jpg"
            image_path = os.path.join(image_folder, image_name)

            if os.path.exists(image_path):
                # Copy the image to the output folder
                output_path = os.path.join(output_folder, image_name)
                shutil.copy(image_path, output_path)

if __name__ == "__main__":
    image_folder_path = "S:/Repo/archive/archive(2)/images"
    csv_file_path = "S:/Repo/archive/archive(2)/stylesedited.csv"
    output_folder_path = "S:/Repo/archive/archive(2)/imagesedited"
    desired_classes = ['Shirt', 'Blazers', 'Hoodies', 'Skirts', 'Jeans', 'Casual Pants', 'Tshirts', 'Tops', 'Sweatshirts', 'Shorts', 'Sarees', 'Dresses', 'Shrugs', 'Jackets', 'Sweaters', 'Leggings'] 

    # Ensure the output folder exists, create if not
    os.makedirs(output_folder_path, exist_ok=True)

    filter_images_by_classes(image_folder_path, csv_file_path, output_folder_path, desired_classes)
