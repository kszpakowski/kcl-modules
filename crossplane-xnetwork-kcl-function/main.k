import vpc
import xcell

oxr: xcell.xCell = option("params")?.oxr

items = [vpc.makeVPC(oxr)]
