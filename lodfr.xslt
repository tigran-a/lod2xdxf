<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lod="http://www.lod.lu/" exclude-result-prefixes="lod">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="https://raw.github.com/soshial/xdxf_makedict/master/format_standard/xdxf_strict.dtd" />

    <!-- https://stackoverflow.com/questions/586231/how-can-i-convert-a-string-to-upper-or-lower-case-with-xslt -->
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

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
                        <abbr_k>vrb</abbr_k>
                        <abbr_v>verb</abbr_v>
                    </abbr_def>
                    <abbr_def>
                        <abbr_k>Pl.</abbr_k>
                        <abbr_k>pl.</abbr_k>
                        <abbr_v>Plural</abbr_v>
                    </abbr_def>
                </abbreviations>
            </meta_info>
            <lexicon>
                <xsl:apply-templates select="./lod:ITEM" />
            </lexicon>
        </xdxf>
    </xsl:template>
    <xsl:template match="lod:ITEM" name="ITEM">
        <ar>
            <xsl:apply-templates select="./lod:ARTICLE" />
            <!-- table about adjective forms -->
            <xsl:apply-templates select="./lod:FLX-ADJ" />
            <xsl:for-each select="./lod:FLX-VRB">
                <!-- table with the verb form -->
                <xsl:call-template name="recursive_table" />
            </xsl:for-each>

        </ar>

    </xsl:template>


    <xsl:template match="lod:ARTICLE">
        <!-- dictionary article -->
        <k id="{lod:ITEM-ADRESSE/@lod:ID-ITEM-ADRESSE}">
            <!-- key (word to translate) -->
            <xsl:value-of select="lod:ITEM-ADRESSE" />
        </k>
        <!-- if a word is a spelling variant or contraction -->
        <xsl:call-template name="reference" />
        <!-- translation details -->
        <xsl:apply-templates select="./lod:MICROSTRUCTURE" />
    </xsl:template>

    <xsl:template name="reference">
        <!-- extract somehow info about the referenced articles in case of spelling variations -->
        <xsl:if test="./lod:MICROSTRUCTURE//*[starts-with(local-name(), 'RENVOI-')]">
            <sr>
                <xsl:for-each select="./lod:MICROSTRUCTURE//*[starts-with(local-name(), 'RENVOI-')]">

                    <kref type="spv" idref="{@lod:REF-ID-ITEM-ADRESSE}">
                        <!-- too long to re-search all items 
                        <xsl:variable name="id_ref_spv">
                          <xsl:value-of select="@lod:REF-ID-ITEM-ADRESSE"></xsl:value-of>
                        </xsl:variable>
                        <xsl:value-of select="/lod:LOD/lod:ITEM/lod:ARTICLE/lod:ITEM-ADRESSE[@lod:ID-ITEM-ADRESSE = $id_ref_spv]" />
                        -->
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '1')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '2')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '3')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '4')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '5')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '6')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '7')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '8')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '9')" />
                        <xsl:value-of select="substring-before(@lod:REF-ID-ITEM-ADRESSE, '0')" />
                    </kref>
                </xsl:for-each>
            </sr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="lod:MICROSTRUCTURE//lod:UNITE-DE-SENS" name="TRANS">
        <!-- Word definition(translation) and grammar details -->
        <xsl:variable name="id_sens">
            <xsl:value-of select="@lod:ID-UNITE-DE-SENS"></xsl:value-of>
        </xsl:variable>
        <xsl:text>&#xa;❁ </xsl:text>
        <i>
            <xsl:apply-templates select="./lod:MARQUE-USAGE" />
        </i>
        <!-- part of speech -->
        <gr>
            <!--
                <xsl:value-of select="translate(../../../../*[starts-with(local-name(), 'CAT-GRAM-')]/@*[starts-with(local-name(), 'C-G-')], $uppercase, $lowercase)"></xsl:value-of>
            -->
            <xsl:for-each select="../../../../*[starts-with(local-name(), 'CAT-GRAM-')]">
                <xsl:value-of select="translate(substring-after(local-name(),'CAT-GRAM-'), $uppercase, $lowercase)"></xsl:value-of>
            </xsl:for-each>
        </gr>
        <!-- genre -->
        <xsl:for-each select="../../../../lod:GENRE">
            <gr>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="translate(@lod:GEN, $uppercase, $lowercase)"></xsl:value-of>
                <xsl:text>)</xsl:text>
            </gr>
        </xsl:for-each>
        <xsl:variable name="plural">
            <xsl:for-each select="../../../../lod:PLURIEL/*[not(@lod:REFS-IDS-UNITES-DE-SENS-COMPT) or contains(@lod:REFS-IDS-UNITES-DE-SENS-COMPT, $id_sens)]/lod:FORME-PLURIEL">
                <xsl:value-of select="." />
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$plural != ''">
            <gr>
                <xsl:text> (</xsl:text>
                <abbr>pl. </abbr>
                <xsl:value-of select="$plural" />
                <xsl:text>)</xsl:text>
            </gr>
        </xsl:if>
        <xsl:if test="lod:UNITE-POLYLEX-LUX">
            <def>
                <xsl:value-of select="lod:UNITE-POLYLEX-LUX" />
            </def>
        </xsl:if>
        <xsl:text>&#xa;</xsl:text>
        <def>
            <deftext>
                <c c="#ad6e00">
                    <xsl:text>FR: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-FR/lod:ETF-EXPLICITE/text()" />
                    <xsl:if test="lod:EQUIV-TRAD-FR/lod:RS-ETF-PRESENTE">
                        <i>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-FR/lod:RS-ETF-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
                        </i>
                    </xsl:if>
                    <xsl:text>&#xa;</xsl:text>
                </c>
                <c c="#0068ad">
                    <xsl:text>DE: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-ALL/lod:ETA-EXPLICITE/text()" />
                    <xsl:if test="lod:EQUIV-TRAD-ALL/lod:RS-ETA-PRESENTE">
                        <i>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-ALL/lod:RS-ETA-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
                        </i>
                    </xsl:if>
                    <xsl:text>&#xa;</xsl:text>
                </c>
                <c c="#ad3a00">
                    <xsl:text>EN: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-EN/lod:ETE-EXPLICITE/text()" />
                    <xsl:if test="lod:EQUIV-TRAD-EN/lod:RS-ETE-PRESENTE">
                        <i>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-EN/lod:RS-ETE-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
                        </i>
                    </xsl:if>
                    <xsl:text>&#xa;</xsl:text>
                </c>
                <c c="#00ad62">
                    <xsl:text>PT: </xsl:text>
                    <xsl:value-of select="lod:EQUIV-TRAD-PO/lod:ETP-EXPLICITE/text()" />
                    <xsl:if test="lod:EQUIV-TRAD-PO/lod:RS-ETP-PRESENTE">
                        <i>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="lod:EQUIV-TRAD-PO/lod:RS-ETP-PRESENTE/text()" />
                            <xsl:text>)</xsl:text>
                        </i>
                    </xsl:if>
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
                            <xsl:text>) </xsl:text>
                        </i>
                    </ex>
                </blockquote>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
            <xsl:if test="./lod:SYNONYMES//lod:TERME-SYN">
                <blockquote>
                    <b>
                        <xsl:text>Synonyms:</xsl:text>
                    </b>
                    <sr>
                        <xsl:for-each select="./lod:SYNONYMES//lod:TERME-SYN">
                            <kref type="syn">
                                <xsl:value-of select="." />
                            </kref>
                        </xsl:for-each>
                    </sr>
                </blockquote>
                <xsl:text>&#xa;</xsl:text>
            </xsl:if>
        </def>
    </xsl:template>

    <xsl:template name="examp">
        <!-- extract word usage examples -->
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
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="$fullword" />
                    <xsl:text>&#160;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="usage_style" match="lod:MARQUE-USAGE">
        <!-- word usage style -->
        <xsl:if test="@lod:STYLE">
            <xsl:choose>
                <xsl:when test="@lod:STYLE = 'ALLG'">
                    <xsl:text>∅</xsl:text>
                </xsl:when>
                <xsl:when test="@lod:STYLE = 'EGS'">
                    <xsl:text>ëmgangssproochlech</xsl:text>
                </xsl:when>
                <xsl:when test="@lod:STYLE = 'FAM'">
                    <xsl:text>graff</xsl:text>
                </xsl:when>
                <xsl:when test="@lod:STYLE = 'GEHUEW'">
                    <xsl:text>gehuewen</xsl:text>
                </xsl:when>
                <xsl:when test="@lod:STYLE = 'KANNERSPROOCH'">
                    <xsl:text>Kannersprooch</xsl:text>
                </xsl:when>
                <xsl:when test="@lod:STYLE = 'PEJ'">
                    <xsl:text>pejorativ</xsl:text>
                </xsl:when>
                <xsl:when test="@lod:STYLE = 'VEREELZT'">
                    <xsl:text>vereelzt</xsl:text>
                </xsl:when>
                <xsl:when test="@lod:STYLE = 'VULG'">
                    <xsl:text>vulgär</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>?</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
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

    <xsl:template name="flx-adj" match="lod:FLX-ADJ">
        <!-- adjective forms -->
        <gr>
            <blockquote>
                <xsl:if test="lod:GRONDFORMEN">
                    <u>Grond Formen:</u>
                    <c c="#888888">
                        <xsl:text>&#xa;Positiv: </xsl:text>
                    </c>
                    <xsl:value-of select="lod:GRONDFORMEN/lod:POSITIV"></xsl:value-of>
                    <c c="#888888">
                        <xsl:text>&#xa;Komparativ: </xsl:text>
                    </c>
                    <xsl:value-of select="lod:GRONDFORMEN/lod:KOMPARATIV"></xsl:value-of>
                    <c c="#888888">
                        <xsl:text>&#xa;Superlativ: </xsl:text>
                    </c>
                    <xsl:value-of select="lod:GRONDFORMEN/lod:SUPERLATIV"></xsl:value-of>
                </xsl:if>
            </blockquote>
            <xsl:for-each select="lod:DEKL/*">
                <xsl:call-template name="recursive_table"></xsl:call-template>
            </xsl:for-each>
        </gr>
    </xsl:template>

    <xsl:template name="recursive_table">
        <!-- print complex structures as they are ~ xml -> key/value -->
        <blockquote>
            <c c="#888888">
                <xsl:value-of select="local-name()"></xsl:value-of>
                <xsl:text>: </xsl:text>
            </c>
            <xsl:choose>
                <xsl:when test="./*">
                    <blockquote>
                        <xsl:for-each select="*">
                            <blockquote>
                                <xsl:call-template name="recursive_table" />
                            </blockquote>
                        </xsl:for-each>
                    </blockquote>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="text()"></xsl:value-of>
                </xsl:otherwise>
            </xsl:choose>
        </blockquote>
    </xsl:template>
    <!-- default rule not to copy text from unused nodes 
    https://stackoverflow.com/questions/3360017/why-does-xslt-output-all-text-by-default
   -->
    <xsl:template match="text()|@*"></xsl:template>
</xsl:stylesheet>