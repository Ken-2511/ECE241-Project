import numpy as np
from PIL import Image

# 读取 MIF 文件并提取数据
def read_mif_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    
    data = []
    in_content = False
    for line in lines:
        line = line.strip()
        if line.upper() == "CONTENT":
            in_content = True
        elif in_content:
            if line.upper() == "END;":
                break
            parts = line.split(':')
            if len(parts) == 2:
                value = int(parts[1].strip(';').strip(), 2)  # 以二进制读取值
                data.append(value)
    return data

# 将 MIF 数据转换为 RGB 图像
def mif_to_image(data, width, height):
    # 将一维数据转为二维数组
    array_2d = np.array(data).reshape((height, width))
    
    # 解码为 RGB 通道，假设每像素是 12 位 (4 位红，4 位绿，4 位蓝)
    img_array = np.zeros((height, width, 3), dtype=np.uint8)
    for i in range(height):
        for j in range(width):
            pixel = array_2d[i, j]
            red = (pixel >> 8) & 0xF  # 高 4 位是红色
            green = (pixel >> 4) & 0xF  # 中间 4 位是绿色
            blue = pixel & 0xF  # 低 4 位是蓝色
            # 将 4 位颜色扩展到 8 位 (范围从 0-15 扩展到 0-255)
            img_array[i, j, 0] = (red << 4) | red
            img_array[i, j, 1] = (green << 4) | green
            img_array[i, j, 2] = (blue << 4) | blue
    
    return Image.fromarray(img_array)

# 主程序
def mif_to_png(input_filename, output_filename):
    # 读取 MIF 文件
    data = read_mif_file(input_filename)
    width, height = 160, 120  # 固定为 160x120 分辨率
    # 转换为图像
    img = mif_to_image(data, width, height)
    # 保存为 PNG 文件
    img.save(output_filename)

# 使用示例
input_filename = "background_with_yellow.mif"  # 输入 MIF 文件
output_filename = "output.png"  # 输出 PNG 文件

# 运行程序
mif_to_png(input_filename, output_filename)
