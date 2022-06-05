#!/Users/dominik/opt/anaconda3/bin/python

import numpy as np
def split():
    molecules = {
        "table2": "h2o:ch3oh:co:nh3=100:10:1:1",
        "table3": "h2o:ch3oh:co:nh3=100:50:1:1",
        "table4": "ch3oh",
        "table5": "h2o",
        "table6": "ch4",
        "table7": "co2",
        "table8": "ocs",
        "table9": "co:ch4=20:1",
        "table10": "co:ocs=20:1",
        # "table11": "co2:ch4=20:1",
        "table12": "co2:ocs=20:1",
        "table13": "h2o:ch4=20:1",
        "table14": "h2o:ocs=20:1",
        "table15": "h2o:ocs=2:1",
        "table16": "n2:ch4=20:1",
        "table17": "n2:ocs=20:1",
        "table18": "o2:ch4=20:1",
        "table19": "o2:ocs=20:1"
    }
    rho = {
        "table2": "0.92",
        "table3": "0.92",
        "table4": "0.779",
        "table5": "0.92",
        "table6": "0.47",
        "table7": "1.6",
        "table8": "ocs",
        "table9": "0.81",
        "table10": "0.81",
        # "table11": "1.6",
        "table12": "1.6",
        "table13": "0.92",
        "table14": "0.92",
        "table15": "0.77",
        "table16": "0.85",
        "table17": "0.85",
        "table18": "0.917",
        "table19": "0.917"
    }

    for file in molecules:
        print("file ",file)
        try:
            rfile = open("data/"+file+".dat", 'r')
        except:
            print('ERROR: file not found:',file)
            return -1
        dum  = rfile.readline()
        dum  = dum.split()
        temp = float(dum[0])
        tables = []
        lam0 = 10000./float(dum[1])
        n0   = float(dum[2]); k0   = float(dum[3])
        if (n0<=0): n0=1e-6
        if (k0<=0): k0=1e-6
        lam = [lam0 ]; n = [ n0 ]; k = [ k0 ]
        while True:
            dum = rfile.readline()
            if ((len(dum) == 0) or dum.isspace()):
                # No more data. Truncate the arrays and stop reading
                tables.append([temp,lam,n, k])
                break
            dum  = dum.split()
            if (float(dum[0]) > temp):
                tables.append([temp,lam,n,k])
                lam = []
                n   = []
                k   = []
            temp = float(dum[0])
            lam0 = 10000./float(dum[1])
            n0 = float(dum[2]); k0 = float(dum[3])
            if (n0<=0): n0=1e-6
            if (k0<=0): k0=1e-6
            lam.append(lam0)
            n.append(n0)
            k.append(k0)
        t = np.array(tables,dtype='object')
        name=file
        print(name)
        for i in range(len(t)):
            mm = molecules[name]
            mmu = mm.upper()
            fname = mm + ("-T%03dK-Hudgins1993.lnk" % t[i,0])
            print('Writing: ',fname)
            try:
                wfile = open(fname, 'w')
            except:
                print('ERROR: Cannot write to file: ',file)
                return -1
            wfile.write('# ' + mmu + '   at T = %3d K' % t[i,0] + '\n')
            wfile.write('# Hudgins et al. 1993, Astrophys. J. Suppl. Ser. 86, 713\n')
            wfile.write('# extracted from file ' + file[5:] + '\n')
            wfile.write('# \n')
            wfile.write('# Name:        '  + mmu + '   at T = %3d K' % t[i,0] + '\n')
            wfile.write('# State:       ?\n')
            wfile.write('# Formula:     ' + mmu + '\n')
            wfile.write('# Temperature: %d' % t[i,0] + '\n')
            wfile.write('# ADS-link:    https://ui.adsabs.harvard.edu/abs/1993ApJS...86..713H\n')
            wfile.write('# BibTeX-key:  1993ApJS...86..713H\n')
            wfile.write('#\n')
            wfile.write('# First line is N_lam and rho [g/cm^3], other lines are: lambda[um] n k\n')
            wfile.write('  %d  %s\n' % (len(t[i,1]),rho[name]) )
            for il in range(len(t[i,1]),0,-1):
                wfile.write(' %g %g %g\n' % (t[i,1][il-1],t[i,2][il-1],t[i,3][il-1]))
            wfile.close()

split()
