#!/usr/bin/python
# -*- coding: utf-8 -*-
# a helper to return a relative filepath to path from start
# Usage: python relpath.py path [start]

from __future__ import print_function

import os
import sys

argv = sys.argv

path = argv[1]
start = argv[2] if len(argv) >= 3 else os.curdir

print(os.path.relpath(path, start))
