#!/bin/bash

set -eu

npm init
npm install --save dotenv lodash request request-promise
npm install --save-dev eslint mocha karma
npx eslint --init
git init
touch index.js .env .gitignore