import os
from termcolor import colored
import platform
import subprocess
import re

def clear_screen():
    """
    Clears the console screen.
    """
    if platform.system() == "Windows":
        subprocess.call("cls", shell=True)
    else:
        subprocess.call("clear", shell=True)

def search_string_in_v_files(search_string, full_word=False, directory="../"):
    """
    Search all .v files in the specified directory
    and print the line numbers and content where the search string is found.
    :param search_string: The string to search for
    :param full_word: Boolean indicating whether to search for full words only
    :param directory: The directory to search in (default is "../")
    """
    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a valid directory")
        return

    # Traverse all files in the directory
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.v'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        for line_number, line in enumerate(f, start=1):
                            if full_word:
                                pattern = r'\b' + re.escape(search_string) + r'\b'
                                if re.search(pattern, line):
                                    highlighted_line = re.sub(pattern, colored(search_string, 'red', attrs=['bold']), line)
                                    print(f"File: {colored(file_path, 'cyan')}, Line: {colored(line_number, 'yellow')}, Content: {highlighted_line.strip()}")
                            else:
                                if search_string in line:
                                    highlighted_line = line.replace(search_string, colored(search_string, 'red', attrs=['bold']))
                                    print(f"File: {colored(file_path, 'cyan')}, \tLine: {colored(line_number, 'yellow')}, \tContent: {highlighted_line.strip()}")
                except Exception as e:
                    print(f"Unable to read file {file_path} : {e}")

# Example usage
if __name__ == "__main__":
    clear_screen()
    user_input = input("Please enter the string to search (use -f for full word match): ")
    if user_input.endswith(" -f"):
        target_string = user_input[:-3].strip()
        search_string_in_v_files(target_string, full_word=True)
    else:
        target_string = user_input.strip()
        search_string_in_v_files(target_string)
