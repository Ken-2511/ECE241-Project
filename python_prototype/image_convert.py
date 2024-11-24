import os
import numpy as np
import cv2


def array2memory(array, bits_per_color_channel, depth, filename=None):
    # Convert from Python list to memory format
    width = bits_per_color_channel if len(array.shape) == 2 else bits_per_color_channel * 3
    memory = f"WIDTH = {width};\nDEPTH = {depth};\nADDRESS_RADIX = HEX;\nDATA_RADIX = BIN;\n\nCONTENT\nBEGIN\n"
    count = 0
    for i in range(array.shape[0]):
        for j in range(array.shape[1]):
            if len(array.shape) == 2:  # Monochrome image
                d = format(array[i, j], f'0{bits_per_color_channel}b')
            else:  # RGB image
                d = ""
                for k in range(array.shape[2]):
                    d += format(array[i, j, k], f'0{bits_per_color_channel}b')
            memory += f"{count:X}\t:\t{d};\n"
            count += 1
    memory += "END;\n"
    # Save the memory to a file
    if filename:
        with open(filename, "w", encoding="utf-8") as f:
            f.write(memory)

    return memory


def convert_picture(image_path, bits_per_color_channel=8, target_width=320, target_height=240, pad=False, monocolor=False):
    # Read the image
    image = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)

    # Convert the image from BGR to RGB format
    rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    if pad:
        # Resize the image while maintaining aspect ratio and add padding
        scale_factor = min(target_width / rgb_image.shape[1], target_height / rgb_image.shape[0])
        new_width = int(rgb_image.shape[1] * scale_factor)
        new_height = int(rgb_image.shape[0] * scale_factor)
        resized_image = cv2.resize(rgb_image, (new_width, new_height), interpolation=cv2.INTER_LINEAR)

        # Calculate padding for each side to make the resized image match the target size
        top_pad = (target_height - new_height) // 2
        bottom_pad = target_height - new_height - top_pad
        left_pad = (target_width - new_width) // 2
        right_pad = target_width - new_width - left_pad

        # Add padding with black color (0, 0, 0)
        final_image = cv2.copyMakeBorder(resized_image, top_pad, bottom_pad, left_pad, right_pad,
                                         cv2.BORDER_CONSTANT, value=[0, 0, 0])
    else:
        # Directly resize the image to the target size, stretching or compressing it as necessary
        final_image = cv2.resize(rgb_image, (target_width, target_height), interpolation=cv2.INTER_LINEAR)

    if monocolor:
        # Convert the image to grayscale
        gray_image = cv2.cvtColor(final_image, cv2.COLOR_RGB2GRAY)

        # Normalize the grayscale image to 8 bits
        quantized_image = (gray_image // (256 // 2)).astype(np.uint8)  # 1-bit quantization for monocolor

        print("Converted to monochrome.")
    else:
        # Apply the bit depth quantization for RGB
        max_value = (2 ** bits_per_color_channel) - 1
        quantized_image = np.round(final_image / (256 / (max_value + 1))).astype(np.uint8)

    # Save or display the quantized image (optional)
    if monocolor:
        cv2.imwrite("processed_image_monochrome.jpg", quantized_image * 255)  # Scale for visualization
    else:
        cv2.imwrite("processed_image.jpg", (quantized_image * (255 // max_value)))  # Scale back for visualization

    print(f"Image shape: {quantized_image.shape}")
    return quantized_image


if __name__ == '__main__':
    # Specify parameters
    bits_per_channel = 4  # Example: 4 bits per color channel
    target_width = 160    # Custom width
    target_height = 120   # Custom height
    pad = False           # Enable padding or disable for stretching
    monocolor = True      # Convert to monochrome or not

    # Convert and process the image
    converted_image = convert_picture("game_over_screen.png", bits_per_color_channel=bits_per_channel,
                                      target_width=target_width, target_height=target_height, pad=pad, monocolor=monocolor)

    # Generate memory file
    depth = target_width * target_height
    memory = array2memory(converted_image, 1 if monocolor else bits_per_channel, depth, "game_over_screen.mif")
