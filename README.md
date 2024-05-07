# ArtDecor2Excel

Transform NFDI4Health Metadataschema from ArtDecor ot Excel Format.

## Prerequisites
*  mvn, make, wget and recent java runtime, eg. `sudo apt install make maven wget`

## Install
*  clone `git clone https://github.com/fmeineke/ArtDecor2Excel.git`
*  type `make`

This will
-	fetch needed libraries from maven
-	fetch CoreMDS3 and Design from ArtDecor
-	does transformations with XSLT Stylesheet 
-	creates csv files (one for Design, one for Core), which can be opened by excel

Version 2.2024 © F. Meineke for NFDI4Health

ART-DECOR® is a registered trademark.
