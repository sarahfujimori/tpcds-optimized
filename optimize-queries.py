# This script takes as input a folder of .sql queries to optimize, and prints the optimized queries to a new folder.

import argparse
import glob
import os
import sys

import sqlglot
from sqlglot.optimizer import optimize
from tpcds_schema import TPCDS_SCHEMA

# Input: 
#   f           string representing a path to a .sql file
# Output: 
#   query       string containing the sql query in that file
#   name        name of the file
def get_query(f):
    with open(f) as file:
        query = "".join(file.readlines()[1:]) 
    name = f.split("/")[-1]
    return query, name

# Intput: 
#   query       string representing optimized query
#   name        name of original query
#   new_folder  folder to write optimized queries to
# Output: none
def write_optimized_query(query, name, new_folder):
    new_path = new_folder + "/" + name
    with open(new_path, "w") as file:
        file.write(query)
    return

def main():
    parser = argparse.ArgumentParser(description="Run SQLGlot optimizer on TPC-DS queries.")
    parser.add_argument('folder', default='tpcds', metavar='name of folder of queries')
    bool_checker = lambda x: False if (x == 'False' or x == 'false') else True
    parser.add_argument('-k', default=True, type=bool_checker, metavar='keep going if an error occurs with one of the queries')
    args = vars(parser.parse_args())

    folder = args['folder']; keep_going = args['k']
    new_folder = folder + "_optimized"
    try:
        os.mkdir(new_folder) 
    except FileExistsError:
        print("New folder already exists, continuing")

    files = glob.glob(folder + "/*.sql")
    for f in files:
        query, name = get_query(f)
        try:
            optimized = optimize(sqlglot.parse_one(query), schema=TPCDS_SCHEMA).sql(pretty=True) 
            write_optimized_query(optimized, name, new_folder)
        except Exception as e:
            print("error occurred with file " + name + ": " + str(e) + '\n')
            if keep_going: print("Continuing. \n"); continue
            else: print('Stopping. \n'); break
main()
