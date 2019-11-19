#!/usr/bin/python3
import os
def get_branch():
    cmd = 'git branch'
    branch = os.system(cmd)
    return branch

a = get_branch()
print(a)
