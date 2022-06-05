import optool
name   = 'data/ch3oh-a-Gerakines2020.wnk'
target = 'ch3oh-a-Gerakines2020.lnk'
x=optool.lnktable(name)
x.fromwav()
x.smooth(200)
x.decimate(size=1000)
x.klimit(1e-5)
x.write(target)
x.plot()

name   = 'data/ch3oh-c-Gerakines2020.wnk'
target = 'ch3oh-c-Gerakines2020.lnk'
x=optool.lnktable(name)
x.fromwav()
x.smooth(200)
x.decimate(size=1000)
x.klimit(1e-5)
x.write(target)
x.plot()

name   = 'data/co2-a-Gerakines2020.wnk'
target = 'co2-a-Gerakines2020.lnk'
x=optool.lnktable(name)
x.fromwav()
x.smooth(200)
x.decimate(size=1000)
x.klimit(1e-5)
x.write(target)
x.plot()

name   = 'data/co2-c-Gerakines2020.wnk'
target = 'co2-c-Gerakines2020.lnk'
x=optool.lnktable(name)
x.fromwav()
x.smooth(200)
x.decimate(size=1000)
x.klimit(1e-5)
x.write(target)
x.plot()

name   = 'data/ch4-a-Gerakines2020.wnk'
target = 'ch4-a-Gerakines2020.lnk'
x=optool.lnktable(name)
x.fromwav()
x.smooth(200)
x.decimate(size=1000)
x.klimit(1e-5)
x.write(target)
x.plot()

name   = 'data/ch4-c-Gerakines2020.wnk'
target = 'ch4-c-Gerakines2020.lnk'
x=optool.lnktable(name)
x.fromwav()
x.smooth(200)
x.decimate(size=1000)
x.klimit(1e-5)
x.write(target)
x.plot()
