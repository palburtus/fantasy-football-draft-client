# Fantasy Football Draft Client
ReactJs client for displaying and handling the JSON generator in the python_sandbox

[![Apache 2.0 badge](http://img.shields.io/badge/license-apache_2.0-brightgreen.svg)](https://www.apache.org/licenses/LICENSE-2.0)
![node version badge](https://img.shields.io/badge/node-v12.11.1-blue?logo=Node.js "node version")
![npm version badge](https://img.shields.io/badge/npm-v6.13.4-blue?logo=npm "npm version")
![react version badge](https://img.shields.io/badge/react-v16.12.0-blue?logo=react "react version")
![react-router version badge](https://img.shields.io/badge/react_router-v5.1.2-blue "react dom version")
![express version badge](https://img.shields.io/badge/express-v4.17.1-blue "express version")
![concurrently version badge](https://img.shields.io/badge/concurrently-v5.0.2-blue "concurrently version")
![bootstrap version badge](https://img.shields.io/badge/bootstrap-v4.4.1-blue?logo=bootstrap "bootsrap version")
![jquery version badge](https://img.shields.io/badge/jQuery-v3.4.1-blue?logo=jquery "jQuery version")

## Setup
- clone the project
- cd into basenodereactproject
- checkout branch 
- npm install
- cd into client
- npm install

## Loading Fantasy Data
- run ```python --version``` to ensure a version of Python 3 is installed and configured
* updates the following files and paths for the new draft season
  * Rotoworld current year's rankings ```rotoworld_2021_rankings.csv```
  * Last years draft resutls ```2020-Draft.csv``` (copy and paste from ESPN website)
  * Air yards ```airyards_2020.csv``` from profootballreference.com
  * Running back workload ```runningback_workload.csv```
  * Keepers ```2021_keepers.csv``` 
  * Average Draft Position ```2021_adp.csv```
  * Add one sample note ```notes.csv```
- run ```main.py``` from the project [Football Directory of the Python Standbox](https://github.com/palburtus/python-sandbox/tree/master/football)

## Run the Client Locally
- cd into ```client``` directory
- run ```npm run start```
