#!/usr/bin/env bash

sudo scanimage -d "brother4:bus1;dev5" --format=pdf --resolution=600 > /srv/SLOHSTRM/scanned_"$(date +"%Y_%m_%d_%H_%M_%S")".pdf


