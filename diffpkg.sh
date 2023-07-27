#!/bin/bash

excmd=$(cat required.txt | xargs | sed 's@ @ -e @g')
grep -v -e $excmd packages.deepin.txt > packages2.txt

excmd=$(cat base.txt | sed 's@ @ -e @g')
grep -v -e $excmd packages2.txt > packages.txt
