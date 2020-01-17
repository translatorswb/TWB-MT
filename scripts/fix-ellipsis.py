# -*- coding: utf-8 -*-

import getopt
import os
import sys
import codecs
import re
import regex
import csv

filestats = ""
input = sys.stdin
output = sys.stdout
file_name = ""

def help():
  print """\
  Usage: {0} [options] [input [output]]
  Optional parameters:
    input                input file
    output               output file
  Options:
    -s, --stats file     file to store a csv with the stats
    -h, --help           shows this help
    """.format(os.path.basename(sys.argv[0]))

# Parse options
try:
  opts, args = getopt.getopt(sys.argv[1:], "s:h", ["stats=","help"])
except getopt.GetoptError, err:
  help()
  sys.exit(2)

for o, v in opts:
  if o in ("-h", "--help"):
    help()
    sys.exit(0)
  elif o in ("-s", "--stats"):
    filestats=v

# Parse params
if not (len(args) in [0,1,2]):
  help()
  sys.exit(2)

# Loading output file
try:
  if len(args) == 2:
    output = open(args[1], "w")
except IOError:
  sys.stderr.write("Error: File '{0}' cannot be created.\n".format(args[1]))
  sys.exit(3)

try:
  if len(args) in [1,2]:
    input = open(args[0], "r")
    file_name = args[0]
except IOError:
  sys.stderr.write("Error: File '{0}' cannot be opened.\n".format(args[0]))
  sys.exit(3)

try:
  if filestats != "":
    filestats = open(filestats, "w")
except IOError:
  sys.stderr.write("Error: File '{0}' cannot be created.\n".format(filestats))
  sys.exit(3)

ellipsis_simplify=regex.compile('[.]{3,}')

ellipsis_commas = regex.compile('([ ]?,){3,}')
ellipsis_commas2 = regex.compile('[ ]?,[ ]?,([^,])')
count_ellipsis_commas = 0

ellipsis_2points = regex.compile('(?P<start>[^.]|^)[.]{2}[ ][.]+(?P<end>[^.])')
count_ellipsis_2points = 0
ellipsis_2points_alone = regex.compile('(?P<start>[^./]|^)[.]{2}(?P<end>[^./])')
count_ellipsis_2points_alone = 0
ellipsis_points_separated = regex.compile('(?P<start>[^.])[.][ ]([ ]*[.])+')
count_ellipsis_points_separated = 0

ellipsis_2groups_3points_separated = regex.compile('(?P<start>[^.]|^)[ ]*[.]{3,}[ ]([.]{3,}[ ]*)+(?P<end>[^.])')
count_ellipsis_2groups_3points_separated = 0
ellipsis_3points_separated_more_points = regex.compile('(?P<start>[^.]|^)[ ]*[.]{3,}[ ][.](?P<end>[^.])')
count_ellipsis_3points_separated_more_points = 0
ellipsis_more_than_3points = regex.compile('(?P<start>[^.]|^)[.]{3,}(?P<end>[^.])')
count_ellipsis_more_than_3points = 0

ellipsis_ini_long_blank = regex.compile("(?P<start>^[[:space:]]*)[.]([ ]*[.][ ]*)+")
count_ellipsis_ini_long_blank = 0
ellipsis_end_long_blank = regex.compile("[.]([ ]*[.][ ]*)+$")
count_ellipsis_end_long_blank = 0

ellipsis_absense_end_blank = regex.compile('(?P<start>[^. ])[.]{3,}(?P<end>[^ [:punct:]])')
count_ellipsis_absense_end_blank = 0
ellipsis_absense_end_blank_special_punct = regex.compile(u'(?P<start>[^.]|^)[.]{3,}(?P<end>[\¡\(\{])')
count_ellipsis_absense_end_blank_special_punct = 0

ellipsis_alnum_blank_ellipsis = regex.compile(u'(?P<start>[[:alnum:]])[ ]+[.]{3,}(?P<end>[^.])')
count_ellipsis_alnum_blank_ellipsis = 0
ellipsis_absense_blank_between_alnum = regex.compile(u'(?P<start>[[:alnum:]])[.]{3}(?P<end>[[:alnum:]])')
count_ellipsis_absense_blank_between_alnum = 0

for line in input:
  line=line.rstrip("\n").decode("utf-8")

  line=ellipsis_simplify.sub("...",line)

  line, nmatches = ellipsis_commas.subn("... ", line)
  count_ellipsis_commas += nmatches
  line, nmatches = ellipsis_commas2.subn(",\g<1>", line)
  count_ellipsis_commas += nmatches

  line, nmatches = ellipsis_2points.subn("\g<start>...\g<end>", line)
  count_ellipsis_2points += nmatches

  line, nmatches = ellipsis_2points_alone.subn("\g<start>...\g<end>", line)
  count_ellipsis_2points_alone += nmatches

  line, nmatches = ellipsis_points_separated.subn("\g<start>...", line)
  count_ellipsis_points_separated += nmatches

# L: double group of points is replaced with only one group
#   line, nmatches = ellipsis_2groups_3points_separated.subn("\g<start>... ...\g<end>", line)
  line, nmatches = ellipsis_2groups_3points_separated.subn("\g<start>... \g<end>", line)
  count_ellipsis_2groups_3points_separated += nmatches
  line, nmatches = ellipsis_3points_separated_more_points.subn("\g<start>... \g<end>",line)
  count_ellipsis_3points_separated_more_points += nmatches
  line, nmatches = ellipsis_more_than_3points.subn("\g<start>...\g<end>", line)
  count_ellipsis_more_than_3points += nmatches

  line, nmatches = ellipsis_ini_long_blank.subn("...", line)
  count_ellipsis_ini_long_blank += nmatches
  line, nmatches = ellipsis_end_long_blank.subn("...", line)
  count_ellipsis_end_long_blank += nmatches

  line, nmatches = ellipsis_absense_end_blank.subn("\g<start>... \g<end>", line)
  count_ellipsis_absense_end_blank += nmatches
  line, nmatches = ellipsis_absense_end_blank_special_punct.subn("\g<start>... \g<end>", line)
  count_ellipsis_absense_end_blank_special_punct += nmatches
  line, nmatches = ellipsis_alnum_blank_ellipsis.subn("\g<start>...\g<end>", line)
  count_ellipsis_alnum_blank_ellipsis += nmatches
  line, nmatches = ellipsis_absense_blank_between_alnum.subn("\g<start>... \g<end>", line)
  count_ellipsis_absense_blank_between_alnum += nmatches

  output.write(u"{0}\n".format(line.strip()).encode("utf-8"))


if filestats != "":
  #writing header in csv
  writer = csv.DictWriter(filestats, [
  "file",
  "count_ellipsis_commas",
  "count_ellipsis_2points",
  "count_ellipsis_2points_alone",
  "count_ellipsis_points_separated",
  "count_ellipsis_2groups_3points_separated",
  "count_ellipsis_3points_separated_more_points",
  "count_ellipsis_more_than_3points",
  "count_ellipsis_ini_long_blank",
  "count_ellipsis_end_long_blank",
  "count_ellipsis_absense_end_blank",
  "count_ellipsis_absense_end_blank_special_punct",
  "count_ellipsis_alnum_blank_ellipsis",
  "count_ellipsis_absense_blank_between_alnum"
  ],  dialect = "excel")


  writer.writerow({
  "file":"file",
  "count_ellipsis_commas":"count_ellipsis_commas",
  "count_ellipsis_2points":"count_ellipsis_2points",
  "count_ellipsis_2points_alone":"count_ellipsis_2points_alone",
  "count_ellipsis_points_separated":"count_ellipsis_points_separated",
  "count_ellipsis_2groups_3points_separated":"count_ellipsis_2groups_3points_separated",
  "count_ellipsis_3points_separated_more_points":"count_ellipsis_3points_separated_more_points",
  "count_ellipsis_more_than_3points":"count_ellipsis_more_than_3points",
  "count_ellipsis_ini_long_blank":"count_ellipsis_ini_long_blank",
  "count_ellipsis_end_long_blank":"count_ellipsis_end_long_blank",
  "count_ellipsis_absense_end_blank":"count_ellipsis_absense_end_blank",
  "count_ellipsis_absense_end_blank_special_punct":"count_ellipsis_absense_end_blank_special_punct",
  "count_ellipsis_alnum_blank_ellipsis":"count_ellipsis_alnum_blank_ellipsis",
  "count_ellipsis_absense_blank_between_alnum":"count_ellipsis_absense_blank_between_alnum"
  })

  #write in the csv
  writer.writerow({
  "file":file_name,
  "count_ellipsis_commas":count_ellipsis_commas,
  "count_ellipsis_2points":count_ellipsis_2points,
  "count_ellipsis_2points_alone":count_ellipsis_2points_alone,
  "count_ellipsis_points_separated":count_ellipsis_points_separated,
  "count_ellipsis_2groups_3points_separated":count_ellipsis_2groups_3points_separated,
  "count_ellipsis_3points_separated_more_points":count_ellipsis_3points_separated_more_points,
  "count_ellipsis_more_than_3points":count_ellipsis_more_than_3points,
  "count_ellipsis_ini_long_blank":count_ellipsis_ini_long_blank,
  "count_ellipsis_end_long_blank":count_ellipsis_end_long_blank,
  "count_ellipsis_absense_end_blank":count_ellipsis_absense_end_blank,
  "count_ellipsis_absense_end_blank_special_punct":count_ellipsis_absense_end_blank_special_punct,
  "count_ellipsis_alnum_blank_ellipsis":count_ellipsis_alnum_blank_ellipsis,
  "count_ellipsis_absense_blank_between_alnum":count_ellipsis_absense_blank_between_alnum
  })
