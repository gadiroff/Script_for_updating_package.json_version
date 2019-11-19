#!/usr/bin/python3

import os
import sys
import subprocess as sp

cmd1 = 'git branch'
branch = sp.getoutput(cmd1)
branch = branch.split(" ")
print(branch)

v = 3
class CharList(list):

    def __init__(self, s):
        list.__init__(self, s)

    @property
    def list(self):
        return list(self)

    @property
    def string(self):
        return "".join(self)

    def __setitem__(self, key, value):
        if isinstance(key, int) and len(value) > v:
            cls = type(self).__name__
            raise ValueError("attempt to assign sequence of size {} to {} item of size 1".format(len(value), cls))
        super(CharList, self).__setitem__(key, value)

    def __str__(self):
        return self.string

    def __repr__(self):
        cls = type(self).__name__
        return "{}(\'{}\')".format(cls, self.string)

with open('package.json', 'r+') as f:
    all_ = f.readlines()
    line_old = all_[2]
    print(line_old)
    line_new = CharList(line_old)
    release_count = int(line_new[18])
    if line_new[19] == '"':
        release_count += 1
        line_new[18]  = str(release_count)
    elif line_new[19] <= '8':
        release_count = int(line_new[19])
        release_count += 1
        line_new[19]  = str(release_count)
    elif line_new[19] == '9':
        release_count = int(line_new[18])
        release_count += 1
        line_new[18]  = str(release_count)
        line_new[19] = '0'
    print(line_new)


s = open("package.json").read()
for key, value  in enumerate(branch):
    if 'release' == value[:7] and branch[(branch.index(value) - 1)][-1]  == '*':
        s = s.replace(str(line_old), str(line_new))
        f = open("package.json", 'w')
        f.write(s)
        f.close()

cmd2 = 'git add . && git commit -m "Increase package.json file version" && git push'
os.system(cmd2)

