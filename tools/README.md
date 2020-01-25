## Tools

These are small tools to work with lod xml file. They are not used to produce the dictionary, but could be handy for other purposes

### removeaudio.xslt

This one just removes lod:AUDIO elements to get a smaller xml to work with, if the audio data is not used. 

Usage example: 

```
xsltproc -o lod-noaudio.xml removeaudio.xslt 2019-11-14-lod-opendata.xml 
```

From 1.3Gb to 90Mb.

### lod2json.xslt

An ugly tool to get a json with short translation out of the xml. After having prettified it may look like: 

Usage example: 

```
xsltproc -o lod.json lod2json.xslt lod-noaudio.xml
```

```
  "A": [
    {
      "fr": "œil (organe visuel)",
      "de": "Auge (Sehorgan)",
      "en": "eye (organ of sight)",
      "pt": "olho (órgão da visão)"
    },
    {
      "fr": "œil de graisse",
      "de": "Auge",
      "en": "fat globule",
      "pt": "olho (de gordura)"
    },
    {
      "fr": "œil (germe)",
      "de": "Auge",
      "en": "eye",
      "pt": "olho (germe)"
    },
    {
      "fr": "point (d'un dé)",
      "de": "Auge (eines Würfels)",
      "en": "pip (on a dice)",
      "pt": "ponto (de um dado)"
    }
  ],
```

Note: you can prettify this json with `jq` tool, but be aware that the initial json has duplicated keys, and jq will drop those...
