# parse all f73 files in the folder using the utilities script
# saves the output as CSV files for later use within the processed folder

# import libaries
import glob
import numpy as np
import pandas as pd
from parse_f73_utils import parse_xml
import xml.etree.ElementTree as ET

# create a list of XML files within the raw data folder
file_list = glob.glob("Data/f73_raw/*.xml")

# loop through each XML file parse the data and save the parse data to CSV
for i in file_list:
    dat = parse_xml(i)
    section = i.split("/")[2]
    seg = section.split("-")[3]
    dat.to_csv('Data/f73_processed/' + seg + '_processed.csv', sep=",")
