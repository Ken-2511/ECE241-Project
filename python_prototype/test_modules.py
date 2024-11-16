import os
import numpy as np


def list_all_files():
    files = os.listdir('.')
    for file in files:
        if not file.endswith('.py'):
            continue
        with open(file, "r", encoding="utf-8") as f:
            content = f.read()
        print("#" * 20)
        print(f'# Path: {file}')
        print(content)
        print()


def array2memory(array, width, depth, filename=None):
    # convert from python list to the memory
    memory = f"WIDTH = {width};\nDEPTH = {depth};\nADDRESS_RADIX = HEX;\nDATA_RADIX = BIN;\n\nCONTENT\nBEGIN\n"
    count = 0
    for i in range(array.shape[0]):
        for j in range(array.shape[1]):
            d = ""
            for k in range(array.shape[2]):
                d += str(array[i, j, k])
            memory += f"{count:X}\t:\t{d};\n"
            count += 1
    memory += "END;\n"
    # save the memory to a file
    if filename:
        with open(filename, "w", encoding="utf-8") as f:
            f.write(memory)

    return memory


def convert_picture(image_path):
    import cv2
    import numpy as np

    # 读取图像
    image = cv2.imread(image_path)
    # if image_path.endswith(".png"):
        # image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    # 获取原始图像的尺寸
    original_height, original_width = image.shape[:2]

    # 计算缩放比例并按比例缩放图像
    scale_factor = min(320 / original_width, 240 / original_height)
    new_width = int(original_width * scale_factor)
    new_height = int(original_height * scale_factor)
    resized_image = cv2.resize(image, (new_width, new_height), interpolation=cv2.INTER_AREA)

    # 在宽度或高度方向上填充至 240x320 的大小
    top_pad = (240 - new_height) // 2
    bottom_pad = 240 - new_height - top_pad
    left_pad = (320 - new_width) // 2
    right_pad = 320 - new_width - left_pad

    # 使用填充值 0（黑色）对图像进行 padding
    padded_image = cv2.copyMakeBorder(resized_image, top_pad, bottom_pad, left_pad, right_pad, cv2.BORDER_CONSTANT, value=[0, 0, 0])

    # 将图像从 BGR 转换为 RGB 格式
    rgb_image = cv2.cvtColor(padded_image, cv2.COLOR_BGR2RGB)

    # 转换为 int8 并应用阈值操作（如果值大于127则为1，否则为0）
    threshold_image = (rgb_image > 127).astype(np.uint8)

    # 检查结果
    print("Original size:", original_width, "x", original_height)
    print("Resized size:", new_width, "x", new_height)
    print("Padded size:", threshold_image.shape)

    # 保存或显示图像
    cv2.imwrite("processed_image.jpg", (threshold_image * 255))  # 将二值图像保存为可视化的图片
    # cv2.imshow("Result", (threshold_image * 255))  # 可视化查看
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()
    print(f"image shape: {threshold_image.shape}")
    return threshold_image


if __name__ == '__main__':
    converted_image = convert_picture(r"C:\Users\IWMAI\Desktop\How-to-Win-Connect-4-Every-Time-1-v2.jpg")
    memory = array2memory(converted_image, 3, 240 * 320, "my_mem.mif")
    # BLOCK_ARRAY = [
    #     [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    #     [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
    #     [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1],
    #     [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    #     [1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    #     [1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    #     [1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1],
    #     [1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
    #     [1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
    #     [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    #     [1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1],
    #     [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
    #     [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    # ]
    # BLOCK_ARRAY = np.array(BLOCK_ARRAY, dtype=np.int8)
    # BLOCK_ARRAY = BLOCK_ARRAY.reshape(13, 29, 1)
    # memory = array2memory(BLOCK_ARRAY, 1, 13*29, "blocks.mif")