<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://www.w3.org/2005/xpath-functions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs x" 
	version="3.0">

<xsl:output method="text"/>
<xsl:mode on-no-match="shallow-skip"/>

<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

<xsl:template match="/dataset">
	<xsl:text>No 3_3;Item;Data Type;Cardinality;Allowed Values;Data element heading || Short name to display (display_name);Data element description (description);Data element additional information - general information (additional_information);Data element additional information - short input help (short_input_help);Data element additional information - input example (input_example)</xsl:text>
	<xsl:apply-templates select="concept">
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="cardinality">
	<xsl:variable name="cardinalityComment" select="comment[p[starts-with(normalize-space(.), 'Cardinality:')]][1]/p[1]"/>
	<!-- replace non-breaking spaces (&#160;) with regular spaces -->
	<!-- (non-breaking spaces are not handled by normalize-space) -->
	<xsl:value-of select="concat('&quot;', substring-after(normalize-space(translate($cardinalityComment, '&#160;', ' ')), 'Cardinality: '), '&quot;;')"/>
</xsl:template>

<!-- each code item on separate line - for excel: wrap all with quotes -->
<xsl:template name="allowedValues">
	<xsl:value-of select="'&quot;'"/>
	<xsl:for-each select="valueDomain/conceptList/concept/name">
		<xsl:value-of select="normalize-space(text())"/>
		 <xsl:if test="position() != last()">
			<xsl:value-of select="$newline"/>
		</xsl:if>
	</xsl:for-each>
	<xsl:value-of select="'&quot;;'"/>
</xsl:template>

<!-- XSLT magic for numbering - for exel quote like "=1.1" to prevent automatic date conversion -->
<xsl:template name="no">
	<xsl:value-of select="$newline"/>
	<xsl:value-of select="'=&quot;'"/>
	<xsl:number count="concept[@statusCode='final']" level="multiple"/>
	<xsl:value-of select="'&quot;;'"/>
</xsl:template>

<xsl:template name="item">
	<xsl:for-each select="ancestor::concept">
		<xsl:value-of select="name/text()"/>
		<xsl:value-of select="'.'"/>
	</xsl:for-each>
	<xsl:value-of select="concat(name/text(),';')"/>
</xsl:template>

<xsl:template name="heading">
	<xsl:value-of select="concat('&quot;', normalize-space(desc/p[1]),'&quot;;')"/>
</xsl:template>

<xsl:template name="description">
	<xsl:variable name="content">
		<xsl:apply-templates select="rationale/p[1]"/>
	</xsl:variable>
	<xsl:value-of select="concat('&quot;', $content, '&quot;;')"/>
</xsl:template>

<xsl:template name="additional_information">
	<xsl:variable name="additionalInformationComment" select="comment[p[starts-with(normalize-space(.), 'Additional information:')]][1]/p[1]"/>
	<xsl:variable name="content">
		<xsl:apply-templates select="$additionalInformationComment"/>
	</xsl:variable>
	<xsl:value-of select="concat('&quot;', $content, '&quot;;')"/>
</xsl:template>

<xsl:template name="short_input_help">
	<xsl:variable name="content">
		<xsl:apply-templates select="operationalization[1]/p[1]"/>
	</xsl:variable>
	<xsl:value-of select="concat('&quot;', $content, '&quot;;')"/>
</xsl:template>

<!-- Template for handling content of <p> elements -->
<xsl:template match="p">
	<xsl:for-each select="node()">
		<xsl:choose>
			<xsl:when test="self::text()">
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:when>
			<xsl:when test="self::br">
				<!-- Replace line breaks with spaces -->
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template name="input_example">
	<xsl:value-of select="concat('&quot;', normalize-space(valueDomain/example), '&quot;')"/>
</xsl:template>

<xsl:template match="concept[@statusCode='cancelled']" priority="1"/>

<xsl:template match="concept[@type='group']">
	<xsl:call-template name="no"/>
	<xsl:call-template name="item"/>
	<xsl:value-of select="'BackboneElement;'"/>
	<xsl:call-template name="cardinality"/>
	<xsl:value-of select="'-;'"/>
	<xsl:call-template name="heading"/>
	<xsl:call-template name="description"/>
	<xsl:call-template name="additional_information"/>
	<xsl:call-template name="short_input_help"/>
	<xsl:call-template name="input_example"/>
	<xsl:apply-templates select="concept"/>
</xsl:template>

<xsl:template match="concept[@type='item']">
	<xsl:call-template name="no"/>
	<xsl:call-template name="item"/>
	<xsl:choose>
		<xsl:when test="valueDomain[@type='code']">
			<xsl:value-of select="'CodeableConcept;'"/>
			<xsl:call-template name="cardinality"/>
			<xsl:call-template name="allowedValues"/>
		</xsl:when>
		<xsl:when test="valueDomain[@type='number' or @type='quantity']">
			<xsl:value-of select="'integer;'"/>
			<xsl:call-template name="cardinality"/>
			<xsl:value-of select="'-;'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat(valueDomain/@type,';')"/>
			<xsl:call-template name="cardinality"/>
			<xsl:value-of select="'-;'"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:call-template name="heading"/>
	<xsl:call-template name="description"/>
	<xsl:call-template name="additional_information"/>
	<xsl:call-template name="short_input_help"/>
	<xsl:call-template name="input_example"/>
</xsl:template>

</xsl:stylesheet>
