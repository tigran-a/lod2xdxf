<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lod="http://www.lod.lu/" exclude-result-prefixes="lod">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"  doctype-system="https://raw.github.com/soshial/xdxf_makedict/master/format_standard/xdxf_strict.dtd"/>

    <xsl:template match="/lod:LOD">
        <xdxf lang_from="LUX" lang_to="FRA" format="logical" revision="000">
            <meta_info>
                <title>LOD-based LB-FR</title>
                <full_title>Luxembourgish-French Dictionary</full_title>
                <description>Converted with losses from https://data.public.lu/en/datasets/letzebuerger-online-dictionnaire-raw-data/</description>
                <file_ver>000</file_ver>
                <last_edited_date>2019-12-16</last_edited_date>
                <abbreviations>
                    <abbr_def>
                        <abbr_k>n.</abbr_k>
                        <abbr_v>noun</abbr_v>
                    </abbr_def>
                    <abbr_def>
                        <abbr_k>v.</abbr_k>
                        <abbr_v>verb</abbr_v>
                    </abbr_def>
                    <abbr_def>
                        <abbr_k>Av.</abbr_k>
                        <abbr_k>Ave.</abbr_k>
                        <abbr_v>Avenue</abbr_v>
                    </abbr_def>
                </abbreviations>
            </meta_info>
            <lexicon>
                <xsl:apply-templates select="./lod:ITEM" />
            </lexicon>
        </xdxf>
    </xsl:template>

    <xsl:template match="lod:ITEM" name="ITEM">
        <xsl:apply-templates select="./lod:ARTICLE" />
        <!--<xsl:apply-templates select="./lod:ARTICLE" />-->
    </xsl:template>
    <xsl:template match="lod:ARTICLE">
        <ar>
            <k id="{lod:ITEM-ADRESSE/@lod:ID-ITEM-ADRESSE}">
                <xsl:value-of select="lod:ITEM-ADRESSE" />
            </k>
            <xsl:apply-templates select="./lod:MICROSTRUCTURE" />
        </ar>
    </xsl:template>
    <!--xsl:template match="lod:MS-TYPE-ADJ" name="MS-TYPE-ADJ">
       fffffff
  </xsl:template-->
    <xsl:template match="lod:MICROSTRUCTURE//lod:UNITE-DE-SENS" name="TRANS">
        <def>
            <deftext>
                <c color="#ffa200">
                    <xsl:text>FR: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-FR/lod:ETF-EXPLICITE/text()" />
                    <i>
                        <xsl:text> (</xsl:text><xsl:value-of select="lod:EQUIV-TRAD-FR/lod:RS-ETF-PRESENTE/text()" /><xsl:text>)</xsl:text>
                    </i>
                    <xsl:text>&#xa;</xsl:text>
                </c>
                <c color="#ff00ff">
                    <xsl:text>DE: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-ALL/lod:ETA-EXPLICITE/text()" />
                    <i>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="lod:EQUIV-TRAD-ALL/lod:RS-ETA-PRESENTE/text()" />
                        <xsl:text>)</xsl:text>
                    </i>
                    <xsl:text>&#xa;</xsl:text>
                </c>
                <c color="#220066">
                    <xsl:text>EN: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-EN/lod:ETE-EXPLICITE/text()" />
                    <i>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="lod:EQUIV-TRAD-EN/lod:RS-ETE-PRESENTE/text()" />
                        <xsl:text>)</xsl:text>
                    </i>
                    <xsl:text>&#xa;</xsl:text>
                </c>
                <c color="#10ee15">
                    <xsl:text>PT: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-PO/lod:ETP-EXPLICITE/text()" />
                    <i>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="lod:EQUIV-TRAD-PO/lod:RS-ETP-PRESENTE/text()" />
                        <xsl:text>)</xsl:text>
                    </i>
                    <xsl:text>&#xa;</xsl:text>
                </c>
            </deftext>
            <xsl:for-each select="./lod:EXEMPLIFICATION/lod:EXEMPLE[@lod:MARQUE-USAGE]">
                <blockquote>
                    <ex>
                        <xsl:call-template name="examp" />
                    </ex>
                </blockquote>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
            <!-- examples of sayings/ indirect meanings -->
            <xsl:for-each select="./lod:EXEMPLIFICATION/lod:EXEMPLE-GLOSE[@lod:MARQUE-USAGE]">
                <blockquote>
                    <ex>
                        <xsl:call-template name="examp" />
                        <i>
                            <xsl:text>  ⇨ (</xsl:text>
                            <xsl:value-of select="lod:GLOSE/*" />
                            )
                        </i>
                    </ex>
                </blockquote>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
            <xsl:if test="./lod:SYNONYMES//lod:TERME-SYN">
                <blockquote>
                    <b>Synonyms:</b>
                    <sr>
                        <xsl:for-each select="./lod:SYNONYMES//lod:TERME-SYN">
                            <kref type="syn">
                                <xsl:value-of select="." />
                            </kref>
                        </xsl:for-each>
                    </sr>
                </blockquote>
            </xsl:if>
        </def>
    </xsl:template>
    <!--
  <xsl:template match="person">
    <li>
      <xsl:value-of select="family-name"/><xsl:text>, </xsl:text><xsl:value-of select="name"/>
    </li>
  </xsl:template>
-->
    <xsl:template name="examp">
        <xsl:variable name="addr" select="./ancestor::lod:ARTICLE/lod:ITEM-ADRESSE" />
        <xsl:variable name="torepl" select="concat(substring($addr,1,1),'.')" />
        <xsl:for-each select="./lod:TEXTE-EX/*">
            <xsl:choose>
                <xsl:when test="name() = 'lod:ABREV-AD'">
                    <xsl:variable name="fullword">
                        <xsl:call-template name="string-replace-all">
                            <xsl:with-param name="text" select="text()" />
                            <xsl:with-param name="replace" select="$torepl" />
                            <xsl:with-param name="by" select="$addr" />
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="' '" />
                    <!--xsl:value-of select="replace(text(), $torepl, $addr)" /-->
                    <!--xsl:value-of select="$fullword" /-->
                    <xsl:value-of select="$fullword" />
                    <xsl:value-of select="' '" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
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


</xsl:stylesheet> <!-- 

            <xsl:for-each select="lod:EQUIV-TRAD-FR/*">
                <xsl:value-of select="."/>
            </xsl:for-each>
-->
