#!/bin/bash

mkdir all-mias
cd all-mias/
# Descargar tar.gz
wget http://peipa.essex.ac.uk/pix/mias/all-mias.tar.gz
# Descomprimir tar.gz
tar -xzvf all-mias.tar.gz
rm all-mias.tar.gz

# Convert PGM to PNG
mogrify -format png *.pgm
