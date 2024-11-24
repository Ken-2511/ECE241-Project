def convert_string_to_list(movement_string):
    # Split the string by commas and strip spaces
    parts = movement_string.split(',')
    x = int(parts[0].strip())
    y = int(parts[1].strip())
    direction = parts[2].strip()

    # Return as list
    return [x, y, direction]

def generate_mif_file(movements, filename="movements.mif"):
    # Define direction encoding
    direction_encoding = {
        "still": "0000",
        "right": "1010",
        "left": "0100",
        "up": "0010",
        "down": "1000"
    }

    # Create MIF file content
    WIDTH = 13
    DEPTH = 100

    mif_content = f"""WIDTH = {WIDTH};
DEPTH = {DEPTH};
ADDRESS_RADIX = DEC;
DATA_RADIX = BIN;

CONTENT
BEGIN
"""

    # Fill in the movements
    for i, movement in enumerate(movements):
        x_bin = format(movement[0], '05b')  # First 5 bits for x coordinate
        y_bin = format(movement[1], '04b')  # Next 4 bits for y coordinate
        dir_bin = direction_encoding.get(movement[2], "0000")  # Last 4 bits for direction
        mif_content += f"{i}   :   {x_bin}{y_bin}{dir_bin};\n"

    # Fill the rest with zeroes
    for i in range(len(movements), DEPTH):
        mif_content += f"{i}   :   0000000000000;\n"

    mif_content += "END;\n"

    # Write to file
    with open(filename, "w") as mif_file:
        mif_file.write(mif_content)

    print(f"MIF file '{filename}' has been created successfully.")

def main():
    # Read input from a file
    input_filename = f"{filename}.txt"
    movements = []

    with open(input_filename, "r") as file:
        lines = file.readlines()
        for line in lines:
            # Convert each line to a movement list
            movement = convert_string_to_list(line.strip())
            movements.append(movement)

    # Generate MIF file from the list of movements
    generate_mif_file(movements, filename=f"{filename}.mif")

if __name__ == "__main__":
    filename = input("Enter the base filename (without extension): ")
    main()
