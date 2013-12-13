#Clean target directories
rm -rf dist/*

#Build main coffeescript
coffee -o dist/js -c coffee

#Build test coffeescript
coffee -o dist/js -c test-coffee

#Copy vendor files in
cp -r vendor/* dist/js
cp -r test-vendor/* dist/js

cd dist
npm install requirejs
npm install sinon
cd js
browserify Scrud.js --outfile ../Scrud-0.1.js
mocha -u tdd create-tests subscribe-tests

cd ../..


