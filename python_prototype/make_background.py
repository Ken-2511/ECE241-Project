import numpy as np

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

# 将数据写入 MIF 文件
def write_mif_file(filename, data, width, depth):
    with open(filename, 'w') as file:
        file.write(f"WIDTH = {width};\n")
        file.write(f"DEPTH = {depth};\n")
        file.write("ADDRESS_RADIX = HEX;\n")
        file.write("DATA_RADIX = BIN;\n\n")
        file.write("CONTENT\nBEGIN\n")
        for i, value in enumerate(data):
            file.write(f"{i:X}\t: {value:012b};\n")  # 按 12 位二进制写入
        file.write("END;\n")

# 主程序
def process_mif_file(input_filename, output_filename, color1, color0):
    # 读取原始数据
    data = read_mif_file(input_filename)
    # 将一维数组转成 13x29 的二维数组
    array_2d = np.array(data[:13*29]).reshape((13, 29))
    # 将二维数组横纵扩展 5 倍
    expanded_array = np.kron(array_2d, np.ones((5, 5), dtype=int))
    
    # 映射值：将 1 映射为 color1，将 0 映射为 color0
    mapped_array = np.where(expanded_array == 1, color1, color0)
    
    # 填充到 160x120 的尺寸
    padded_array = np.zeros((120, 160), dtype=int)  # 初始化全为 color0
    padded_array[:expanded_array.shape[0], :expanded_array.shape[1]] = mapped_array

    # 展平结果为一维数组
    flattened_data = padded_array.flatten()
    # 写入新 MIF 文件
    write_mif_file(output_filename, flattened_data, width=12, depth=len(flattened_data))

# 使用示例
input_filename = "blocks.mif"  # 输入文件名
output_filename = "background.mif"  # 输出文件名

# 定义 color1 和 color0（4 位每通道的 12 位数）
# 示例：color1 = R:1010, G:1100, B:1110；color0 = R:0101, G:0011, B:0001
color1 = int("101011001110", 2)  # 红色通道: 1010, 绿色通道: 1100, 蓝色通道: 1110
color0 = int("010100110001", 2)  # 红色通道: 0101, 绿色通道: 0011, 蓝色通道: 0001

# 处理文件
process_mif_file(input_filename, output_filename, color1, color0)
