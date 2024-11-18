import os
import numpy as np
import cv2


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


def convert_picture(image_path, bits_per_color_channel=8, target_width=320, target_height=240, pad=False):
    # Read the image
    image = cv2.imread(image_path)

    # Convert the image from BGR to RGB format
    rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    if pad:
        # Resize the image while maintaining aspect ratio and add padding
        scale_factor = min(target_width / rgb_image.shape[1], target_height / rgb_image.shape[0])
        new_width = int(rgb_image.shape[1] * scale_factor)
        new_height = int(rgb_image.shape[0] * scale_factor)
        resized_image = cv2.resize(rgb_image, (new_width, new_height), interpolation=cv2.INTER_NEAREST)

        # Calculate padding for each side to make the resized image match the target size
        top_pad = (target_height - new_height) // 2
        bottom_pad = target_height - new_height - top_pad
        left_pad = (target_width - new_width) // 2
        right_pad = target_width - new_width - left_pad

        # Add padding with black color (0, 0, 0)
        padded_image = cv2.copyMakeBorder(resized_image, top_pad, bottom_pad, left_pad, right_pad,
                                          cv2.BORDER_CONSTANT, value=[0, 0, 0])
        final_image = padded_image

    else:
        # Directly resize the image to the target size, stretching or compressing it as necessary
        final_image = cv2.resize(rgb_image, (target_width, target_height), interpolation=cv2.INTER_NEAREST)

    # Apply the bit depth quantization
    max_value = (2 ** bits_per_color_channel) - 1
    quantized_image = (final_image // (256 // (max_value + 1))).astype(np.uint8)

    # Check the result
    print("Original size:", image.shape[1], "x", image.shape[0])
    if pad:
        print("Resized size (with padding):", final_image.shape)
    else:
        print("Resized size (stretched):", final_image.shape)

    # Save or display the quantized image (optional)
    cv2.imwrite("processed_image.jpg", (quantized_image * (255 // max_value)))  # Scale back for visualization
    print(f"Image shape: {quantized_image.shape}")
    return quantized_image


if __name__ == '__main__':
    # Specify parameters
    bits_per_channel = 4  # Example: 4 bits per color channel
    target_width = 160    # Custom width
    target_height = 120   # Custom height
    pad = True            # Enable padding or disable for stretching

    # Convert and process the image
    converted_image = convert_picture("test_picture.png", bits_per_color_channel=bits_per_channel,
                                      target_width=target_width, target_height=target_height, pad=pad)

    # Generate memory file
    memory = array2memory(converted_image, bits_per_channel, target_width * target_height, "canvas.mif")
