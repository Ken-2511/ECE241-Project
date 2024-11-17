import os
import numpy as np


def array2memory(array, bits_per_color_channel, depth, filename=None):
    # Convert from Python list to memory format
    width = bits_per_color_channel * 3
    memory = f"WIDTH = {width};\nDEPTH = {depth};\nADDRESS_RADIX = HEX;\nDATA_RADIX = BIN;\n\nCONTENT\nBEGIN\n"
    count = 0
    for i in range(array.shape[0]):
        for j in range(array.shape[1]):
            d = ""
            for k in range(array.shape[2]):
                # Convert the channel value to binary representation with the specified bits
                d += format(array[i, j, k], f'0{bits_per_color_channel}b')
            memory += f"{count:X}\t:\t{d};\n"
            count += 1
    memory += "END;\n"
    # Save the memory to a file
    if filename:
        with open(filename, "w", encoding="utf-8") as f:
            f.write(memory)

    return memory


def convert_picture(image_path, bits_per_color_channel=8):
    import cv2
    import numpy as np

    # Read the image
    image = cv2.imread(image_path)

    # Get the original image dimensions
    original_height, original_width = image.shape[:2]

    # Calculate the scaling factor and resize the image
    scale_factor = min(320 / original_width, 240 / original_height)
    new_width = int(original_width * scale_factor)
    new_height = int(original_height * scale_factor)
    resized_image = cv2.resize(image, (new_width, new_height), interpolation=cv2.INTER_AREA)

    # Pad the image to 240x320 size
    top_pad = (240 - new_height) // 2
    bottom_pad = 240 - new_height - top_pad
    left_pad = (320 - new_width) // 2
    right_pad = 320 - new_width - left_pad

    # Pad the image with a black border
    padded_image = cv2.copyMakeBorder(resized_image, top_pad, bottom_pad, left_pad, right_pad, cv2.BORDER_CONSTANT, value=[0, 0, 0])

    # Convert the image from BGR to RGB format
    rgb_image = cv2.cvtColor(padded_image, cv2.COLOR_BGR2RGB)

    # Apply the bit depth quantization
    max_value = (2 ** bits_per_color_channel) - 1
    quantized_image = (rgb_image // (256 // (max_value + 1))).astype(np.uint8)

    # Check the result
    print("Original size:", original_width, "x", original_height)
    print("Resized size:", new_width, "x", new_height)
    print("Padded size:", quantized_image.shape)

    # Save or display the quantized image (optional)
    cv2.imwrite("processed_image.jpg", (quantized_image * (255 // max_value)))  # Scale back for visualization
    print(f"Image shape: {quantized_image.shape}")
    return quantized_image


if __name__ == '__main__':
    # Specify bit depth per channel
    bits_per_channel = 4  # Example: 4 bits per color channel
    converted_image = convert_picture("test_picture.png", bits_per_color_channel=bits_per_channel)
    memory = array2memory(converted_image, bits_per_channel, 240 * 320, "my_mem.mif")
