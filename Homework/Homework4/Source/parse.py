import csv
import cPickle as pickle
import numpy as np

with open("header.sql","r") as f:
    content = f.readlines()
for l in content:
  print l[:len(l) - 1]

filename = 'prices9-11-2017'

prices = dict()
with open(filename + '.csv') as csvfile:
  reader = csv.DictReader(csvfile)
  ticker = ""
  data = list()
  counter = 0
  for row in reader:
    d = row['date']
    s = "insert into Prices values ( '" + str(row['ticker']) + "', '" + str(d) + "', " + str(row['open']) + ", " + str(row['close']) + ", " + str(row['high']) + ", " + str(row['low']) + ");"
    print s
    
    s = "insert into Volume values ( '" + str(row['ticker']) + "', '" + str(d) + "', " + str(row['volume']) + ", " + str(row['adj_volume']) + ");"
    print s
    
    s = "insert into AdjPrices values ( '" + str(row['ticker']) + "', '" + str(d) + "', " + str(row['adj_open']) + ", " + str(row['adj_close']) + ", " + str(row['adj_high']) + ", " + str(row['adj_low']) + ");"
    print s
    
    s = "insert into Misc values ( '" + str(row['ticker']) + "', '" + str(d) + "', " + str(row['ex-dividend']) + ", "+ str(row['split_ratio']) + ");"
    print s
    
    counter += 1
    if counter > 100000:
      break