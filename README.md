# lod2xdxf
Transforming LOD.lu database to xdxf-like dictionary format

## Background
There is an official Luxembourgish online dictionary at https://www.lod.lu which is available only... online (from best of my knowledge). 
Sometimes it is needed to access the data without the Internet. From there came an idea to convert the LOD-xml file to a format readable by some dictionary software. 

This is an attempt to have a way of getting an offline Luxembourgish dictionary with the official articles.

## The flow

![Image](../master/screenshots/flow.svg?raw=true&sanitize=true)

LOD XML file can be downloaded from the public luxembourg data, then this repository contains an xsl tranformation to produce out of it an xdxf-like formatted dictionary (using, for example, `xsltproc`). Later, applying pyglossary converter, one can get this dictionary in stardict format which is understood by some mobile free software (some of them might also understand directly the xdxf file). 

## What do I do with that? 

Two main options:
1. You download the processed dictionary and upload it to your dictionary. Then you don't need this repository. The already converted version might be available here: https://letzebuergesch.review/ufiles/lod.zip  or https://letzebuergesch.review/ufiles/lod.tar.bz2 or https://letzebuergesch.review/ufiles/lod.tar.gz

2. You convert it using this script from the latest LOD raw data, which is shortly described in the next session. This enables you to apply modifications and improve the script.

## Howto build 

Here are instructions for debian-based Linux distributions. If you spot a mistake, or if something is missing, please create an issue or better provide a pull request.

```bash
mkdir lodstuff
cd lodstuff
# Downlaod the official raw data .zip file. Note: this is a permalink for one of the versions. To have the latest one, use the link in **Sources** section
wget https://data.public.lu/en/datasets/r/d47c6b52-22b1-46e3-83e8-9feb72335159
# unarchive
tar xaf d47c6b52-22b1-46e3-83e8-9feb72335159
# install xsltproc, git
apt install xsltproc git
# clone this repository 
git clone https://github.com/tigran-a/lod2xdxf.git
# generate xdxf
xsltproc lod2xdxf/lodxdxf.xslt *.xml -o lod.xdxf
# Here you got an xdxf file which might be directly used with some dictionaries.

# Clone pyglossary
git clone https://github.com/tigran-a/pyglossary.git
## Please follow here the instructions from that repository to install dependencies if needed!

mkdir lod
# converting xdxf to stardict
pyglossary/main.py --read-format=Xdxf --write-format=Stardict ./lod.xdxf ./lod/lod.ifo
## the dictionary in stardict format is in ./lod directory
## you can now create a zip archive if needed
apt install zip
zip -r lod.zip lod

# lod.zip is the archived LOD dictionary in Stardict format.
```


## (free) Dictionary software

Feel free to test and add more. 

Note: some cons stated here might be due to the wrong usage of xdxf tags or markup in general and no knowledge of the "right way" of using these dictionaries.

### Linux
#### GoldenDict
![Image](../master/screenshots/Linux/GoldenDict/1.png?raw=true)
![Image](../master/screenshots/Linux/GoldenDict/2.png?raw=true)

Pros: 
- display layout is OK
- supports colors
- finds dictionary easily

Cons: 
- verbs/adjectives forms are a bit unalligned

### iOS
#### EBPocket Basic
![Image](../master/screenshots/iOS/ebpocket/ebpocket.basic.1.png?raw=true)

Pros: 
- display layout is correct

Cons: 
- Need to upload via FTP
- Does not display colors
- translations from all languages are merged into one line

#### Dicty
![Image](../master/screenshots/iOS/dicty/dicty.1.png?raw=true)

Pros: 
- display colors
- can download dictionary via an http(s) link

Cons: 
- Does not display all possible articles for the same word (!)
- "tables" with verb and adjective forms have no desired layout 

### Android

#### EBPocket Free
![Image](../master/screenshots/Android/ebpocket/ebpocket.free.1.jpg?raw=true)

Pros: 
- displays verb/adjective form in a good layout

Cons:
- translations from all languages are merged into one line
- Need to upload via FTP
- Does not display colors

#### GoldenDict Free
![Image](../master/screenshots/Android/goldendict/goldendict.free.1.jpg?raw=true)

Pros: 
- works

Cons:
- display spacing is not too good
- Need to unarchive the dictionary data
- Does not display colors

## Sources

#### Converter
Original converter
https://github.com/ilius/pyglossary

Two symbols changed version (put back removed support of xdxf, required for what is done here)
https://github.com/tigran-a/pyglossary

#### Raw data
Here is the raw publicly available data used by the LOD dictionary: 
https://data.public.lu/en/datasets/letzebuerger-online-dictionnaire-raw-data/

#### XDXF format

A description of XDFD format: https://github.com/soshial/xdxf_makedict/blob/master/format_standard/xdxf_description.md
Its schema: https://raw.githubusercontent.com/soshial/xdxf_makedict/master/format_standard/xdxf_strict.dtd

#### Stardict format
http://stardict-4.sourceforge.net/StarDictFileFormat

