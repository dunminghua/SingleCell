import pandas as pd

# load metadata
df = pd.read_table('GSE146397_metadata.cells_contacts_100k.txt.gz', header=None)

counts = df[1].value_counts()

for i,v in counts.items():
    new_df = df[df[1] == i]
    #print(f'{i} has {v} cells')
    length = len(new_df)
    print(length == v)
    filename = i.split(' ')
    name = '_'.join(filename)
    new_df.to_csv('cell_type_ID/' + name + '.txt', index=False, sep='\t', header=False)

