import os
from sys import argv
import numpy as np

script, inputfile, matfilelist, matfilelist2, outputfile = argv
class Sparse:
    """
    1.Add sparse matrix
    """
    # __repr__ is more for developers while __str__ is for end users
    # __str__ vs __repr__, print(repr(class))
    def __init__(self, rows, columns):
        self._matrix = []
        self._num = 0
        self._rows = rows
        self._columns = columns

    def __repr__(self):
        prnt = f"Shape: {self._rows} x {self._columns}\n"
        for lst in self._matrix:
            prnt += lst.__repr__() + '\n'
        prnt += f"Total: {self._num}"
        return prnt

    def insert(self, row, column, value):
        if row < 0 | column < 0 | row >= self._rows | column >= self._columns:
            raise ValueError("Invalid row or column")

        if(value == 0):
            raise ValueError("Zeroes are not included in a sparse matrix")

        filled = False
        # for and if, num is 0 in first
        for i in range(self._num):
            if(self._matrix[i][0] < row):
                continue
            elif(self._matrix[i][0] > row):
                self._matrix.insert(i, [row, column, value])
                self._num += 1
                filled = True
                break
            elif(self._matrix[i][1] < column):
                continue
            elif(self._matrix[i][1] > column):
                self._matrix.insert(i, [row, column, value])
                self._num += 1
                filled = True
                break
            else:
                raise ValueError("The position is already filled")
        if(filled == False):
            self._matrix.append([row, column, value])
            self._num += 1
        return

    def remove(self, row, column):
        if row < 0 | column < 0 | row >= self._rows | column >= self._columns:
            raise ValueError("Invalid row or column")

        for i in range(num):
            if(self._matrix[i][0] == row | self._matrix[i][1] == column):
                return pop(i)
        return None

    def size(self):
        return self._num

    def shape(self):
        return tuple((self._rows, self._columns))

    def display(self):
        print(self)

    def add(self, obj):
        if(isinstance(obj, Sparse) != True):
            raise TypeError("add() method needs an object of type Sparse")

        if(self.shape() == obj.shape()):
            result = Sparse(self._rows, self._columns)
        else:
            raise ValueError("Invalid row or columns")

        i = 0
        j = 0
        k = 0
        while((i < self._num) & (j < obj._num)):
            if(self._matrix[i][0] < obj._matrix[j][0]): #row
                result._matrix.insert(k, self._matrix[i])
                k += 1
                i += 1
            elif(self._matrix[i][0] > obj._matrix[j][0]):
                result._matrix.insert(k, obj._matrix[j])
                k += 1
                j += 1
            elif(self._matrix[i][1] < obj._matrix[j][1]):
                result._matrix.insert(k, self._matrix[i])
                k += 1
                i += 1
            elif(self._matrix[i][1] > obj._matrix[j][1]):
                result._matrix.insert(k, obj._matrix[j])
                k += 1
                j += 1
            else:
                result._matrix.insert(k, list([self._matrix[i][0], self._matrix[i][1], self._matrix[i][2] + obj._matrix[j][2]]))
                k += 1
                i += 1
                j += 1
        while(i < self._num):
            result._matrix.insert(k, self._matrix[i])
            k += 1
            i += 1
        while(j < obj._num):
            result._matrix.insert(k, obj._matrix[j])
            k += 1
            j += 1

        result._num = k
        return result

    def fast_transpose(self):
        occurrence = []
        index = []

        for i in range(self._columns):
            occurrence.append(0)
        for i in range(self._num):
            occurrence[self._matrix[i][1]] += 1

        index.append(0)
        for i in range(1, self._columns):
            index.append(index[i-1] + occurrence[i-1])

        result = Sparse(self._columns, self._rows)
        result._num = self._num
        for i in range(self._num): result._matrix.append(list())
        for i in range(self._num):
            result._matrix[index[self._matrix[i][1]]] = list([self._matrix[i][1], self._matrix[i][0], self._matrix[i][2]])
            index[self._matrix[i][1]] += 1
        return result


class LoadSparseMatWithIteration:
    """
    1.Read sparse mat in Iteration
    2.Using generator
    """
    def __init__(self, path):
        self.path = path

    def __iter__(self):
        for line in open(self.path):
            yield line.rstrip('\n').split('\t')


def loadSparseMat(filepath):
    """
    filepath is a chromosme filepath in single cell
    """
    tmp_sp = Sparse(3, 200000000)
    data = LoadSparseMatWithIteration(filepath)
    for start, end, counts in data:
        #tmp_sp.insert(float(start), float(end), float(counts))
        tmp_sp.insert(int(start), int(end), int(float(counts)))
        #invalid literal for int() with base 10: '2.0'
        #str -> float -> int

    return tmp_sp


def main(inputfile, matfilelist, matfilelist2, outputfile):
    """
    1.inputfile is cell_20, cell_50
    2.matfilelist is /lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Neuron
    2.matfilelist2 is /lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Oligo
    3.outputfile is /lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Neuron_merged

    """
    filelist = os.listdir(inputfile)
    filelist.sort()
    for file in filelist:
        #Neuron_1.txt
        if file[0] == 'N':
            matfile = matfilelist
        else:
            matfile = matfilelist2

        for i in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'X']:
            print(f'Processing for chr{i}')
            sp = Sparse(3,200000000)

            f = open(inputfile + '/' + file, 'r')
            for filepath in f.readlines():
                #remove trailing \n
                filepath = os.path.basename(filepath.rstrip('\n'))
                new_filepath = matfile + '/' + filepath #focus on sparseMat file directory
                tmp = loadSparseMat(new_filepath + '/' + 'chr' + i + '.txt')
                sp = sp.add(tmp)

            cell_ID= inputfile.split('/')[-1]
            #output = outputfile + '/' + cell_ID + '/' + file[:-4] +  '/' + 'chr' + i + '.txt'
            output_pre = os.path.join(outputfile, cell_ID, file[:-4])
            output = os.path.join(outputfile, cell_ID, file[:-4], 'chr' + i + '.txt')
            if not os.path.exists(output_pre):
                """
                1.Recursive directory creation function
                2.If exist_ok is False (the default), an FileExistsError is raised
                if the target directory already exists.
                """
                os.makedirs(output_pre, exist_ok=True)
                print(f'Has create {output_pre}')

            try:
                #with open(output, 'w') as out_f:
                out_f = open(output, 'w')
                print(f'Writing to {output}')
                for row in range(len(sp._matrix)):
                    for column in range(len(sp._matrix[0])):
                        out_f.write(str(sp._matrix[row][column]))
                        out_f.write('\t')
                    out_f.write('\n')
                out_f.close()
            except FileNotFoundError:
                print(f'{output} can not found!')

            f.close()


if __name__ == '__main__':
    main(inputfile, matfilelist, matfilelist2, outputfile)

