<?xml version="1.0" encoding="UTF-8"?>

<!--XSL-Dokument für die Transformation der Chronik Aldersbach (XML zu XML). Vervollständigungen, Änderungen, etc.--> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

    <!--lädt zweites Dokument: von csv konvertierte xml-Datei, enthält Normdatenreferenznummern der GND (für //person)-->
    <xsl:param name="convertedcsvtoxml"
        select="document('GND_reconciliation/convertedback_to_xml.xml')"/>

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:strip-space elements="*"/>

    <!-- MS: wenn man XML-Dokumente ausliest, die einen Namespace enthalten (siehe TEI-Dokument @xmlns im Wurzelelement), dann muss auch das 
    Stylesheet diesen Namespace enthalten. Siehe xmlns:tei als Attribut von xsl:stylesheet. Damit wird es möglich, alle TEI Elemente mit tei: (z.B. tei:text//tei:placeName) anzusprechen. -->



    <!-- kopiert das gesamte TEI Dokument - bei XSLT Version 1 und 2 -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <!--fügt ein author-Element & mehrere respStmt hinzu-->
    <xsl:template match="tei:titleStmt">
        <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="tei:title"/>
            <xsl:element name="author" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="ref">
                        <xsl:text>#GerhardH</xsl:text>
                    </xsl:attribute>
                    <xsl:text>Georg Hörger</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Robert Klugseder</xsl:text>
                </xsl:element>
                <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Herausgabe und Vorkodierung, Bereitstellung des Ausgangsmaterials</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Johannes Schwarz</xsl:text>
                </xsl:element>
                <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Transkription</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Maximilian Vogeltanz</xsl:text>
                </xsl:element>
                <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Transformation und Bearbeitung der TEI-Daten</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Martina Scholger</xsl:text>
                </xsl:element>
                <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Projektbetreuung und Umsetzung via GAMS</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Georg Vogeler</xsl:text>
                </xsl:element>
                <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Projektbetreuung</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--fügt idno für den Gams-Upload hinzu-->
    <xsl:template match="tei:publicationStmt/tei:p">
        <xsl:copy-of select="."/>
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:text>PID</xsl:text>
                </xsl:attribute>
                <xsl:text>o:aled.1</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--fügt das Element "facsimile" zwischen //teiHeader und //text ein, für Jedes pb-Element (=Seite) im Text wird ein surface/graphic-Element erzeugt.
        surface erhält eine id (={start} für GAMS-Upload), die dem Wert des @n-Attributes von pb entspricht.-->
    <xsl:template match="//tei:teiHeader">
        <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:element name="facsimile" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:for-each select="//tei:text//tei:pb">
                <!--für jedes pb-Element wird ein surface/graphic-Element erzeugt.-->
                <xsl:element name="surface" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="start">
                        <xsl:for-each select="@n">
                            <xsl:value-of select="concat('#', 'F', .)"/>
                            <!--die ID entspricht 'F' + dem Wert des @n Attributes von pb-->
                        </xsl:for-each>
                    </xsl:attribute>
                    <xsl:element name="graphic" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="mimeType">
                            <xsl:text>image/jpeg</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="url">
                            <xsl:for-each select="@n">
                                <xsl:value-of select="concat('KL_Aldersbach_15-', ., '.jpg')"/>
                            </xsl:for-each>
                        </xsl:attribute>
                        <xsl:attribute name="xml:id">
                            <xsl:for-each select="@n">
                                <xsl:value-of select="concat('IMG.', .)"/>
                            </xsl:for-each>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!--Jedes pb-Element im Text erhält ein zusätzliches xml:id-Attribut (wegen GAMS-Upload), welchem 'F' + der Wert des jeweiligen n-Attributes zugewiesen wird-->
    <xsl:template match="tei:text//tei:pb/@n">
        <xsl:copy-of select="."/>
        <xsl:attribute name="xml:id">
            <xsl:value-of select="concat('F', .)"/>
        </xsl:attribute>
    </xsl:template>

    <!--Fügt nach dem FileDesc eine profileDesc hinzu, diese enthält eine particDesc/listPerson mit allen eingetragenen Personen sowie eine settingDesc/listPlace mit allen Orten (normiert und distinct-values), die im Text vorkommen.
    Zusätzlich enthält jedes place-Element eine xml:id, die dem Inhalt des jeweiligen Elements entspricht (mit gesäuberten whitespaces) -->
    <xsl:template match="tei:fileDesc">
        <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:element name="profileDesc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="particDesc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates select="//tei:listPerson"/>
            </xsl:element>
            <xsl:element name="settingDesc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="listPlace" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each
                        select="distinct-values(//tei:text//tei:name[@type = 'place']/tei:choice/tei:reg)">
                        <xsl:element name="place" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="xml:id">
                                <xsl:value-of select="translate(., ' ', '')"/>
                            </xsl:attribute>
                            <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        <!--fügt eine charDecl hinzu, die eine eigene Glyphe für alle "m" mit Konsonantenlängung (Verdoppelung) definiert-->
        <xsl:element name="encodingDesc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="charDecl" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="glyph" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="xml:id">
                        <xsl:text>mGemination</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="glyphName" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:text>'m' mit Konsonantendopplung</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--Damit //bibl nach wie vor im sourceDesc bleibt-->
    <xsl:template match="tei:sourceDesc">
        <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="tei:bibl"/>
        </xsl:element>
    </xsl:template>

    <!--fügt dem Element bibl einen Titel hinzu-->
    <xsl:template match="tei:bibl">
        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:text>Chronik Aldersbach</xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!--passt betreffende //date@when-Attribute an: Aus der Form \d\d\d\d\d\d\d\d wird \d\d\d\d-\d\d-\d\d-->
    <xsl:template match="//tei:date/@when">
        <xsl:copy-of select="."/>
        <xsl:analyze-string select="." regex="\d\d\d\d\d\d\d\d">
            <xsl:matching-substring>
                <xsl:attribute name="when">
                    <xsl:value-of
                        select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"
                    />
                </xsl:attribute>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <!--ergänzt alle nicht unbekannten (=cert='unknown') Lebensdaten aller Personen im teiHeader mit passenden when-Attributen bei birth.-->
    <xsl:template match="tei:person/tei:birth/tei:date">
        <xsl:variable name="lifedate" select="."/>
        <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:for-each select=".">
                <!--erste Bedingung erfasst alle bekannten Lebensdaten mit einer Länge von mehr als 4 Zeichen. (zb 11.02.1604)-->
                <xsl:if
                    test="($lifedate[not(@cert = 'unknown')]) and ($lifedate/string-length() &gt; 4)">
                    <xsl:attribute name="when">
                        <xsl:value-of
                            select="replace($lifedate, $lifedate, concat($lifedate/substring(., 7, 8), '-', $lifedate/substring(., 4, 2), '-', $lifedate/substring(., 1, 2)))"
                        />
                    </xsl:attribute>
                </xsl:if>
                <!--Zweite Bedingung erfasst alle bekannten Lebensdaten mit einer Länge von unter 5 Zeichen. (zb. 1161)-->
                <xsl:if
                    test="($lifedate[not(@cert = 'unknown')]) and ($lifedate/string-length() &lt; 5)">
                    <xsl:attribute name="when">
                        <xsl:value-of select="$lifedate"/>
                    </xsl:attribute>
                </xsl:if>
                <!--Dritte Bedingung erfasst alle @cert-Attribute-->
                <xsl:if test="$lifedate[@cert]">
                    <xsl:attribute name="cert">
                        <xsl:value-of select="./@cert"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!--ergänzt alle nicht unbekannten (=cert='unknown') Lebensdaten aller Personen im teiHeader mit passenden when-Attributen bei death.-->
    <xsl:template match="tei:person/tei:death/tei:date">
        <xsl:variable name="lifedate" select="."/>
        <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:for-each select=".">
                <!--erste Bedingung erfasst alle bekannten Lebensdaten mit einer Länge von mehr als 4 Zeichen. (zb 11.02.1604)-->
                <xsl:if
                    test="($lifedate[not(@cert = 'unknown')]) and ($lifedate/string-length() &gt; 4)">
                    <xsl:attribute name="when">
                        <xsl:value-of
                            select="replace($lifedate, $lifedate, concat($lifedate/substring(., 7, 8), '-', $lifedate/substring(., 4, 2), '-', $lifedate/substring(., 1, 2)))"
                        />
                    </xsl:attribute>
                </xsl:if>
                <!--Zweite Bedingung erfasst alle bekannten Lebensdaten mit einer Länge von unter 5 Zeichen. (zb. 1161)-->
                <xsl:if
                    test="($lifedate[not(@cert = 'unknown')]) and ($lifedate/string-length() &lt; 5)">
                    <xsl:attribute name="when">
                        <xsl:value-of select="$lifedate"/>
                    </xsl:attribute>
                </xsl:if>
                <!--Dritte Bedingung erfasst alle @cert-Attribute-->
                <xsl:if test="$lifedate[@cert = 'unknown']">
                    <xsl:attribute name="cert">
                        <xsl:value-of select="./@cert"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!--Vervollständigt alle //person/persName/roleName mit einem Unterelement <date cert='unknown'>, sofern ein solches date-Element nicht vorhanden ist-->
    <xsl:template match="tei:listPerson/tei:person/tei:persName/tei:roleName[not(tei:date)]">
        <xsl:element name="roleName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="role">
                <xsl:value-of select="@role"/>
            </xsl:attribute>
            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="cert">
                    <xsl:text>unknown</xsl:text>
                </xsl:attribute>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <!--Ergänzt alle name-Elemente im Text, die eine Person bezeichnen, mit einem Attribut type='person'-->
    <xsl:template match="tei:text//tei:name/@ref">
        <xsl:copy-of select="."/>
        <xsl:attribute name="type">
            <xsl:text>person</xsl:text>
        </xsl:attribute>
    </xsl:template>

    <!--Löst die Choice-Konstruktion bei allen Orten im Text (name type='place') auf: Übrig bleibt nur mehr die originale Bezeichnung.
        Zusätzlich erhält jedes name-Element ein ref-Attribut, dass "#" + den Wert der normierten (reg) Bezeichnung enthält (whitespace gesäubert).
        Dieser deckt sich mit der jeweiligen xml:id im Header!-->
    <xsl:template match="//tei:text//tei:name[@type = 'place']/tei:choice">
        <xsl:attribute name="ref">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="translate(tei:reg, ' ', '')"/>
        </xsl:attribute>
        <xsl:apply-templates select="tei:orig"/>
    </xsl:template>

    <!--damit lb in orig erhalten bleibt-->
    <xsl:template match="tei:orig">
        <xsl:apply-templates/>
    </xsl:template>

    <!--Alle Personen im teiHeader, denen eine GND-Referenz zugewiesen werden kann, bekommen ein ref-Attribut, 
        welches die Standard-URN der GND + den Wert der jeweiligen GND-Nummer enthält (= Link zu Datensatz).
        Die Nummer wird aus einem externen XML-Dokument gezogen, welches das Ergebnis einer automatischen Konvertierung 
        einer CSV-Datei ist, die ursprünglich aus dem Aldersbach-TEI transformiert wurde und mittels OpenRefine 
        semiautomatisch mit Daten aus der GND angereichert wurde-->
    <xsl:template match="tei:person/tei:persName">
        <xsl:variable name="row" select="$convertedcsvtoxml//row"/>
        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:for-each select="./ancestor::tei:person/@xml:id">
                <xsl:variable name="current" select="."/>
                <!--Für alle persName-Elemente gilt: Für alle row-Elemente aus 2.File gilt: wenn PersonenID mit ID aus 2.File übereinstimmt, 
                    erstelle Attribut (ref), dass die zugehörige GND-Nummer als Wert hat.-->
                <xsl:for-each select="$row">
                    <xsl:if test="(./ID = $current) and (./GND-Nummer != '')">
                        <xsl:attribute name="ref">
                            <xsl:value-of select="concat('http://d-nb.info/gnd/', ./GND-Nummer)"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!--ergänzt alle lb-Elemente, die davor einen Bindestrich haben, mit einem break='no'-Attribut-->
    <xsl:template match="tei:lb">
        <xsl:variable name="Bindestrich"
            select="substring(preceding-sibling::text()[1], string-length(preceding-sibling::text()[1]), 1)"/>
        <xsl:choose>
            <xsl:when test="$Bindestrich = '-'">
                <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="break">
                        <xsl:text>no</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--löscht ein einzelnes vorkommendes '[?]' und kodiert stattdessen das Wort davor mit einem unclear-Element mit einem Attribut cert='unknown'-->
    <xsl:template match="//tei:sic[contains(., '[?]')]">
        <xsl:element name="sic" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="unclear" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="cert">
                    <xsl:text>unknown</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates select="translate(., '[?]', '')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--löscht Eckige Klammern bei allen Textelementen, die in eckige Klammern gesetzt sind und kodiert diese unterschiedlich (g, gap, supplied)-->
    <xsl:template match="tei:text/descendant-or-self::text()">
        <!--aus "m[m]" wird "<g ref='#mGemination'>m</g>"-->
        <xsl:analyze-string select="." regex="m\[m\]">
            <xsl:matching-substring>
                <xsl:element name="g" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="ref">
                        <xsl:text>#mGemination</xsl:text>
                    </xsl:attribute>
                    <xsl:text>m</xsl:text>
                </xsl:element>
            </xsl:matching-substring>

            <xsl:non-matching-substring>
                <!--aus "[...]" wird "<gap/>"-->
                <xsl:analyze-string select="." regex="\[\.\.\.\]">
                    <xsl:matching-substring>
                        <xsl:element name="gap" namespace="http://www.tei-c.org/ns/1.0"
                        > </xsl:element>
                    </xsl:matching-substring>

                    <xsl:non-matching-substring>
                        <!--alle restlichen Fälle, in denen Buchstaben innerhalb eckiger Klammern auftreten, werden in ein supplied-Element gesetzt 
                            und die Klammern werden gelöscht-->
                        <xsl:analyze-string select="." regex="\[[\sA-Za-züä]+\]">
                            <xsl:matching-substring>
                                <xsl:element name="supplied" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:value-of select="substring-before(substring(., 2), ']')"/>
                                </xsl:element>
                            </xsl:matching-substring>
                            <!--gibt den restlichen Text aus, in denen keine Ausdrücke innerhalb eckiger Klammern vorkommen-->
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>

                    </xsl:non-matching-substring>
                </xsl:analyze-string>

            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>


</xsl:stylesheet>
