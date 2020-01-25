<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lod="http://www.lod.lu/" exclude-result-prefixes="lod">
    <xsl:output method="text" indent="yes" encoding="UTF-8" />

    <!-- https://stackoverflow.com/questions/586231/how-can-i-convert-a-string-to-upper-or-lower-case-with-xslt -->
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    <xsl:template match="/lod:LOD">
	    {
                <xsl:apply-templates select="./lod:ITEM" />
			"":[]
	    }
    </xsl:template>
    <xsl:template match="lod:ITEM" name="ITEM">
            <xsl:apply-templates select="./lod:ARTICLE" />

    </xsl:template>


    <xsl:variable name="quote">"</xsl:variable>
    <xsl:variable name="escquote">\"</xsl:variable>
    <xsl:variable name="fullword"> </xsl:variable>
    <xsl:template match="lod:ARTICLE">
	    "<xsl:value-of select="lod:ITEM-ADRESSE" />" :  [
	<xsl:for-each select = "lod:MICROSTRUCTURE//lod:UNITE-DE-SENS[not(lod:UNITE-POLYLEX-LUX)]">
		   { "fr" : 
                    "<xsl:value-of select="lod:EQUIV-TRAD-FR/lod:ETF-EXPLICITE/text()" />
                    <xsl:if test="lod:EQUIV-TRAD-FR/lod:RS-ETF-PRESENTE">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-FR/lod:RS-ETF-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
		     </xsl:if>",
				    
			     "de" :
			    "<xsl:value-of select="lod:EQUIV-TRAD-ALL/lod:ETA-EXPLICITE/text()" />
                    <xsl:if test="lod:EQUIV-TRAD-ALL/lod:RS-ETA-PRESENTE">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-ALL/lod:RS-ETA-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
			    </xsl:if>",
		    "en" : 
				    "<xsl:value-of select="lod:EQUIV-TRAD-EN/lod:ETE-EXPLICITE/text()" />
                    <xsl:if test="lod:EQUIV-TRAD-EN/lod:RS-ETE-PRESENTE">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-EN/lod:RS-ETE-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
                    </xsl:if>",
                     "pt": 
		    <!--
                    <xsl:variable name="fullword">
                        <xsl:call-template name="string-replace-all">
                            <xsl:with-param name="text" select="lod:EQUIV-TRAD-PO/lod:ETP-EXPLICITE/text()" />
			    <xsl:with-param name="replace" select="$quote"/>
			    <xsl:with-param name="by" select="$escquote"/>
                        </xsl:call-template>
			    </xsl:variable>
		    -->
                    "<xsl:value-of select="translate(lod:EQUIV-TRAD-PO/lod:ETP-EXPLICITE/text(), '&quot;', '`')" />
                    <xsl:if test="lod:EQUIV-TRAD-PO/lod:RS-ETP-PRESENTE">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-PO/lod:RS-ETP-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
                    </xsl:if>"

		    }<xsl:if test="position() != last()">,</xsl:if>
	    </xsl:for-each>
		    ],
    </xsl:template>

    <xsl:template match="lod:MICROSTRUCTURE//lod:UNITE-DE-SENS" name="TRANS">
        <def>
            <deftext>
                <c c="#ad6e00">
                    <xsl:text>FR: </xsl:text>
                    <xsl:text>&#xa;</xsl:text>
                </c>
            </deftext>
        </def>
    </xsl:template>

    <!--https://stackoverflow.com/questions/3067113/xslt-string-replace-->
    <xsl:template name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
            <xsl:when test="$text = '' or $replace = ''or not($replace)">
                <!-- Prevent this routine from hanging -->
                <xsl:value-of select="$text" />
            </xsl:when>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$by" />
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace" select="$replace" />
                    <xsl:with-param name="by" select="$by" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()|@*"></xsl:template>
</xsl:stylesheet>
