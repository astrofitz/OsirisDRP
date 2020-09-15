import numpy as np
import pandas as pd

def extract_kbb_map():
    '''
    Extract the kbb mapping of rectification slice to lenslet array
    from the LensletMapping.xlsx file.
    NOTE: the excel file has the first two rows masked, but we will not consider
    them here. The first row is where there is actually flux, corresponding to
    the first slice in the rect. matrix.

    2017-03-28 - T. Do
    '''

    tab = pd.read_excel('LensletMapping.xlsx',sheet_name='K1 QL2 Kbb 35',
                        parse_cols='C:U',skiprows=4)
    tab = tab[:64]
    t2 = np.array(tab,dtype=int)
#    t2[:,0] = t2[:,0]+2
    
    # save the lenslet mapping
    np.savetxt('kbb_2016_lenslet_mapping.txt',t2,delimiter=' ',fmt='%i')

    # we can also unravel the lenslet mapping
    s = np.shape(t2)
    output = open('kbb_2016_slice_to_lenslet.txt','w')
    print(s)
    for i in range(s[0]):
        for j in range(s[1]):
            row = t2[i,0]+2  # the rows start at 2
            col = j
            output.write('%i %i %i\n' % (t2[i,j],row,col))
    output.close()

def extract_kn3_map():
    '''
    Extract the kn3 mapping of rectification slice to lenslet array
    from the LensletMapping.xlsx file.
    NOTE: the excel file has the first two rows masked, but we will not consider
    them here. The first row is where there is actually flux, corresponding to
    the first slice in the rect. matrix.

    2017-03-28 - T. Do
    2019-4-25 - MPF
    '''

    tab = pd.read_excel('LensletMapping.xlsx',sheet_name='K1 QL2 Kn3 20',
                        usecols='C:BA',skiprows=2)
    tab = tab[:66]
    t2 = np.array(tab,dtype=int)

    # save the lenslet mapping
    np.savetxt('kn3_2016_lenslet_mapping.txt',t2,delimiter=' ',fmt='%i')

    # we can also unravel the lenslet mapping
    s = np.shape(t2)
    output = open('kn3_2016_slice_to_lenslet.txt','w')
    print(s)
    for i in range(s[0]):
        for j in range(s[1]):
            row = i
            col = j
            if (t2[i,j] < 0) or (row < 0) or (col < 0): continue
            output.write('%i %i %i\n' % (t2[i,j],row,col))
    output.close()
