#!/bin/bash

if [ "$1" == "clean" ] || [ "$1" == "force" ]
then
    # echo "clean"
    rm -rf ./assemblies
    rm -rf ./bom
    rm -rf ./dxfs
    rm -rf ./stls
    rm -rf ./tmp
    rm -rf ./openscad.echo
    rm -rf ./openscad.log
    rm -rf ./printme.html
    rm -rf ./readme.html
    rm -rf ./readme.md
fi

if [ "$1" != "clean" ];
then
    # echo "make"
    make_all.py
fi
