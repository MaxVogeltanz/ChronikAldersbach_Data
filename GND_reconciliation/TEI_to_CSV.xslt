<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="text" indent="no" encoding="UTF-16"/>

    <!--erstellt eine CSV-Datei aus allen //person Elementen im Header der Aldersbach-Kodierung der ÖAW; Muster = ID,Name(Vorname+Nachname),Rolle-->
    <xsl:template match="/">

        <!-- = Tabellenspalten-->
        <xsl:text>"ID","Name","Rolle"</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:for-each-group select="//tei:sourceDesc//tei:person" group-by="@xml:id">
            <xsl:sort select="."/>
            <xsl:text>"</xsl:text>

            <!--transformiert jede //person/@xml:id zur Spalte "ID"-->
            <xsl:value-of select="current-grouping-key()"/>

            <xsl:text>",</xsl:text>
            <xsl:text>"</xsl:text>

            <!--transformiert //person/persName/forename + //person/persName/surname in die Spalte "Name"-->
            <xsl:value-of select="tei:persName/tei:forename"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="tei:persName/tei:surname"/>

            <xsl:text>",</xsl:text>
            <xsl:text>"</xsl:text>

            <!--transformiert jede //person/persName/roleName in die Spalte "Rolle" (sofern vorhanden, ansonsten erscheint Text "unknown")-->
            <xsl:choose>
                <xsl:when test="tei:persName/tei:roleName">
                    <xsl:value-of select="tei:persName/tei:roleName/@role"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>unknown</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>"</xsl:text>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:for-each-group>
    </xsl:template>


</xsl:stylesheet>
