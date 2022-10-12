#!/usr/bin/env python3

from icalendar import Calendar
from argparse import ArgumentParser
from datetime import timedelta

parser = ArgumentParser()
parser.add_argument('--locale', type=str, default='fr-CH')
# Can be obtained from https://www.ge.ch/vacances-scolaires-jours-feries
parser.add_argument('ics')

args = parser.parse_args()

with open(args.ics) as ics_fd:
    ical = Calendar.from_ical(ics_fd.read())
    idx = 0
    for event in ical.walk('vevent'):
        summary = event.get('summary')
        start = event.decoded('dtstart')
        end = event.decoded('dtend')
        while start < end:
            print(f'holiday.{args.locale}{idx}.name={summary}')
            print(f'holiday.{args.locale}{idx}.date={start.year}{start.month:02}{start.day:02}')
            start += timedelta(days=1)
            idx += 1
        
