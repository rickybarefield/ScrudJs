#!/bin/sh
#Clean target directories
rm -rf build/*
#Add test node libs
mkdir build/dist
mkdir build/test
cd build/test
npm install sinon
npm install websocket
