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
	<xsl:text>No 3_3;Item;Data Type;Cardinality;Allowed Values;Data element heading || Short name to display (display_name);Data element description (description)</xsl:text>
	<xsl:apply-templates select="concept">
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="cardinality">
	<xsl:value-of select="concat(@minimumMultiplicity,'..',@maximumMultiplicity,';')"/>
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
	<xsl:number count="concept[@statusCode='draft']" level="multiple"/>
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
	<xsl:value-of select="concat(normalize-space(desc/p[1]),';')"/>
</xsl:template>

<xsl:template name="description">
	<xsl:value-of select="concat(substring-after(normalize-space(rationale/p[1]),'Description: '),';')"/>
</xsl:template>

<xsl:template match="concept[@statusCode='cancelled']" priority="1"/>

<xsl:template match="concept[@type='group']">
	<xsl:call-template name="no"/>
	<xsl:call-template name="item"/>
	<xsl:value-of select="'BackboneElement;'"/>
	<xsl:call-template name="cardinality"/>
	<xsl:call-template name="heading"/>
	<xsl:call-template name="description"/>
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
		</xsl:when >
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
</xsl:template>

</xsl:stylesheet>