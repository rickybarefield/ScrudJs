#!/bin/sh

#Main
coffee -o build/dist/lib -c coffee
cp README.md build/dist/
cp package/package.json build/dist/
cd build/dist
npm update

#Test
cd ../..
coffee -o build/test -c test-coffee
cp -r test-vendor/* build/test
cd build/test
npm link Scrud
mocha -u tdd create-tests subscribe-tests

cd ../../..


