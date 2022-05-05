"""
this it to generate random single cell list from two cell types,
produce  x numbers single cell path to a file
"""

from sys import argv
import os
import numpy as np
import pandas as pd

def random_cell(all_cell_number, number):
    """
    """
    # 0 ~ all_cell_number
    all_nums = np.random.choice(all_cell_number, number, replace=False)
    return all_nums

def generate_file(filelist, random_num, directory):
    file = []
    for i in random_num:
        path = directory + filelist[i]
        file.append(path)

    return pd.DataFrame({'filename':file})


def main(cell_type1, cell_type2, number1, number2, save_path, prefix1, prefix2):
    """
    1. cell_type1 and cell_type2 is two directory absolute filepath.
    2.save_path is also directory to save singlecell filepath

    """
    cell1 = os.listdir(cell_type1)
    cell2 = os.listdir(cell_type2)
    cell1.sort()
    cell2.sort()
    for i in range(1,11):
        random_cell1 = random_cell(int(len(cell1)), int(number1))
        random_cell2 = random_cell(int(len(cell2)), int(number2))

        #save random sample single cell file
        file_type1 = generate_file(cell1, random_cell1, cell_type1)
        file_type2 = generate_file(cell2, random_cell2, cell_type2)

        if not os.path.exists(save_path):
            os.mkdir(save_path)

        filepath1 = save_path + '/' + prefix1 + '_' + str(i) + '.txt'
        filepath2 = save_path + '/' + prefix2 + '_' + str(i) + '.txt'
        file_type1.to_csv(filepath1, index=False, header=False, sep='\t')
        file_type2.to_csv(filepath2, index=False, header=False, sep='\t')

        #file1 = open(filepath1, 'w')
        #file1.write(str(file_type1))
        #file1.close()
        #file2 = open(filepath2, 'w')
        #file2.write(str(file_type2))
        #file2.close()


if __name__ == "__main__":
    main(argv[1], argv[2], argv[3],argv[4], argv[5], argv[6], argv[7])





