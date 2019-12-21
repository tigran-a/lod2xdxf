# lod2xdxf
Transforming LOD.lu database to xdxf-like dictionary format

## Background
There is an official Luxembourgish online dictionary at https://www.lod.lu which is available only... online (from best of my knowledge). 
Sometimes it is needed to access the data without the Internet. From there came an idea to convert the LOD-xml file to a format readable by some dictionary software. 

This is an attempt to have a way of getting an offline Luxembourgish dictionary with the official articles.

## The flow

[ LOD XML ] --> lod2xdxf xslt --> [ LOD in XDXF XML format ] --> pyglossary --> [ LOD in stardict format ] --> any dictionary supporting stardict and upload custom dictionaries

## Howto

1. Downlaod the official raw data .zip file
2. unzip
3. install xsltproc
4. run xsltproc with this repo's xslt on LOD's XML to obtain lod.xdxf
5. run pyglossary (--read-format=Xdxf --write-format=Stardict)
6. Archive if needed the result and upload to your dictionary

Already converted version might be available here: https://letzebuergesch.review/ufiles/lod.zip  or https://letzebuergesch.review/ufiles/lod.tar.bz2 or https://letzebuergesch.review/ufiles/lod.tar.gz

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

