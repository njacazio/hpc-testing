#!/usr/bin/python

import sys

from commands import getoutput
from time     import sleep
from re       import compile

tobig_single = 30720  # 30MB
tobig_total  = 102400 # 100MB

memory = {
    "total": 0,
    "largest": 0,
}

cputime=0
CUR_USER = getoutput("whoami")

check = "ps -u %s -o rss,cputime,etime,pid,command|grep o2|awk -F'[-: ]+' '/:/ {print $1,$2*3600+$3*60+$4,$4*60+$5,$5,$6,$7,$8,$9,$(10),$(11)}'" % (CUR_USER)

regex = compile("^\s*(?P<memory>\d+)\s+(?P<time>\d+)\s+(?P<etime>\d+)\s+(?P<process>.*)")

memcheck = "ps aux |grep %s|grep o2|grep -v grep|awk '{print $2}' >id; for pid in $(cat id); do cat /proc/$pid/smaps; done | awk '/Pss/ {mem += $2} END {print mem}'" % (CUR_USER)

memusage = int(float(getoutput(memcheck))/1024)

cmd =  "ps -u %s -o etime,args|grep -v grep|grep \"run.sh\"|awk -F':' '/:/ {print $1*60+$2}'" % CUR_USER
etime=int(getoutput(cmd))
cmd = "ps -u %s -o etime,args|grep -v grep|grep \"run.sh\"|awk -F':' '/:/ {print $3}'" % CUR_USER
checkfield=getoutput(cmd)
if checkfield != "":
  cmd = "ps -u %s -o etime,args|grep -v grep|grep \"run.sh\"|awk -F':' '/:/ {print $1*3600+$2*60+$3}'" % CUR_USER
  etime=int(getoutput(cmd))

for line in getoutput(check).split("\n"):
    m = regex.search(line)
    if m:
        mem = int(m.group("memory"))
        cpu = int(m.group("time"))
        cc = m.group("process")
        cputime += cpu
        if(cpu > 10):
            memory["total"] += mem
            if mem > memory["largest"]:
               memory["largest"] = mem
            if "-d" in sys.argv:
               print " %5.2fM %s" % (float(mem)/1024, m.group("process")[:100])

print "%d %d %d" % (memusage , cputime, etime)
