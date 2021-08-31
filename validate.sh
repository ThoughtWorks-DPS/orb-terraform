#!/usr/bin/env bash

# quick validation check for local development
circleci orb pack src
circleci orb pack src > orb.yml
circleci orb validate orb.yml
rm orb.yml
