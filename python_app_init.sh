#!/bin/bash

set -eu

echo '
requests
pylint
pytest
' > requirements.txt

git init
touch .env 

echo '
.env
sample.egg-info
venv
.pytest_cache
' > .gitignore

echo '
.PHONY: help prepare-dev test lint run doc

VENV_NAME?=venv
VENV_ACTIVATE=. $(VENV_NAME)/bin/activate
PYTHON=${VENV_NAME}/bin/python3

.DEFAULT: help
help:
	@echo "make prepare-dev"
	@echo "       prepare development environment, use only once"
	@echo "make test"
	@echo "       run tests"
	@echo "make lint"
	@echo "       run pylint and mypy"
	@echo "make run"
	@echo "       run project"
	@echo "make doc"
	@echo "       build sphinx documentation"

prepare-dev:
	sudo apt-get -y install python3.8 python3-pip
	python3 -m pip install virtualenv
	make venv

# Requirements are in setup.py, so whenever setup.py is changed, re-run installation of dependencies.
venv: $(VENV_NAME)/bin/activate
$(VENV_NAME)/bin/activate: setup.py
	test -d $(VENV_NAME) || virtualenv -p python3 $(VENV_NAME)
	${PYTHON} -m pip install -U pip
	${PYTHON} -m pip install -r requirements.txt
	touch $(VENV_NAME)/bin/activate

init: venv
	${PYTHON} -m pip install -r requirements.txt

test: venv
	${PYTHON} -m pytest

lint: venv
	${PYTHON} -m pylint
	${PYTHON} -m mypy

run: venv
	${PYTHON} app/app.py

doc: venv
	$(VENV_ACTIVATE) && cd docs; make html

' > Makefile

echo '
from setuptools import setup

setup(
    name="sample",
    version="0.1.0",
    description="sample",
    long_description="sample",
    author="sample",
    author_email="sample",
    url="sample",
    license="license"
)

' > setup.py

mkdir app && cd app

echo '
from .app import hmm
' > __init__.py

echo '
from . import helpers

def get_hmm():
    """Get a thought."""
    return "hmmm..."

def hmm():
    """Contemplation..."""
    if helpers.get_answer():
        print(get_hmm())

' > core.py

echo '
def get_answer():
    """Get an answer."""
    return True

' > helpers.py

cd .. && mkdir test && cd test

echo '
# test_core.py

def capital_case(x):
    if not isinstance(x, str):
        raise TypeError("Please provide a string argument")
    return x.capitalize()
' > test_core.py