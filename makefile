all: Design.csv MDS_V3_3.csv 

CoreMDS33.xml:
	wget 'http://art-decor.org/decor/services/RetrieveTransaction?id=2.16.840.1.113883.3.1937.777.64.4.4&effectiveDate=2023-11-28T00%3A00%3A00&language=en-US&ui=de-DE&format=xml' -O $@

Design33.xml:
	wget 'http://art-decor.org/decor/services/RetrieveTransaction?id=2.16.840.1.113883.3.1937.777.64.4.8&effectiveDate=2023-12-21T00%3A00%3A00&language=en-US&ui=de-DE&format=xml' -O $@

clean: 
	rm -f Design.csv MDS_V3_3.csv

distclean: clean
	rm -f CoreMDS33.xml Design33.xml Saxon-HE-12.4.jar xmlresolver-6.0.4.jar

Design.csv: Design33.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

MDS_V3_3.csv: CoreMDS33.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

Saxon-HE-12.4.jar:
	mvn dependency:copy -Dartifact=net.sf.saxon:Saxon-HE:12.4 -DoutputDirectory=.

xmlresolver-6.0.4.jar:
	mvn dependency:copy -Dartifact=org.xmlresolver:xmlresolver:6.0.4 -DoutputDirectory=.

