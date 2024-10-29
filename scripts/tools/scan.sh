#!/usr/bin/env bash

:'
scanimage options
ChatGPT powiedział:
ChatGPT

scanimage is a command-line tool for scanning using SANE (Scanner Access Now Easy) in Linux. Here are some common options you can use with scanimage to control your scanning process:
General Options

    -L or --list-devices: Lists available scanners.
    -d [device] or --device-name=[device]: Specifies the scanner device to use.
    --resolution=[DPI]: Sets the resolution in dots per inch (DPI).
    --mode=[mode]: Sets the scanning mode, like "Color", "Gray", or "Lineart".
    --format=[format]: Specifies output format (pnm, tiff, jpeg).
    --output-file=[filename]: Saves the scan directly to a file.

Image Size Options

    -l [x-coord] or --tl-x=[x-coord]: Sets the left X-coordinate in mm.
    -t [y-coord] or --tl-y=[y-coord]: Sets the top Y-coordinate in mm.
    -x [width] or --br-x=[width]: Sets the width in mm.
    -y [height] or --br-y=[height]: Sets the height in mm.

Additional Options

    --brightness=[level]: Adjusts brightness (may vary by scanner).
    --contrast=[level]: Adjusts contrast (may vary by scanner).
    --source=[source]: Selects the scanning source, e.g., Flatbed or Automatic Document Feeder.
    --batch: Enables batch scanning, useful for document feeders.

Example Command

To scan in color at 300 DPI and save the output as a JPEG file:

bash

scanimage --device-name=[device] --resolution 300 --mode Color --format jpeg --output-file output.jpg

For more device-specific options, you can list them by running:

bash

scanimage --help -d [device]

Or by using:

bash

scanimage -A
'


scanimage -d "brother4:bus1;dev5" --format=pdf --resolution=600 > /srv/SLOHSTRM/scanned_"$(date +"%Y_%m_%d_%H_%M_%S")".pdf


