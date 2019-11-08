#!/usr/bin/env python3
import csv
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument('--locale', type=str, default='fr-CH')
parser.add_argument('csv')

args = parser.parse_args()

with open(args.csv) as csv_fd:
    data = csv.DictReader(csv_fd, delimiter=';')
    for idx, row in enumerate(data):
        d, m, y = row['Date'].split('.')
        print(f'holiday.{args.locale}{idx}.name={row["Description"]}')
        print(f'holiday.{args.locale}{idx}.date={y}{m}{d}')
