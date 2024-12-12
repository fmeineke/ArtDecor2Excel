CSV_FILES = Core.csv Design.csv NutritionalEpidemiology.csv ChronicDiseases.csv RecordLinkage.csv

all: MDS_V3_3.csv Design.csv Core.csv RecordLinkage.csv NutritionalEpidemiology.csv ChronicDiseases.csv

CoreMDS33.xml:
	wget 'http://art-decor.org/decor/services/RetrieveTransaction?id=2.16.840.1.113883.3.1937.777.64.4.4&effectiveDate=2023-11-28T00%3A00%3A00&language=en-US&ui=de-DE&format=xml' -O $@

Design33.xml:
	wget 'http://art-decor.org/decor/services/RetrieveTransaction?id=2.16.840.1.113883.3.1937.777.64.4.8&effectiveDate=2023-12-21T00%3A00%3A00&language=en-US&ui=de-DE&format=xml' -O $@

RecordLinkage33.xml:
	wget 'https://art-decor.org/decor/services/RetrieveTransaction?id=2.16.840.1.113883.3.1937.777.64.4.6&format=xml' -O $@

NutritionalEpidemiology33.xml:
	wget 'https://art-decor.org/decor/services/RetrieveTransaction?id=2.16.840.1.113883.3.1937.777.64.4.10&format=xml' -O $@

ChronicDiseases33.xml:
	wget 'https://art-decor.org/decor/services/RetrieveTransaction?id=2.16.840.1.113883.3.1937.777.64.4.12&format=xml' -O $@

clean: 
	rm -f $(CSV_FILES)

distclean: clean
	rm -f CoreMDS33.xml Design33.xml RecordLinkage33.xml NutritionalEpidemiology33.xml ChronicDiseases33.xml Saxon-HE-12.4.jar xmlresolver-6.0.4.jar

Design.csv: Design33.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

Core.csv: CoreMDS33.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

RecordLinkage.csv: RecordLinkage33.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

NutritionalEpidemiology.csv: NutritionalEpidemiology33.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

ChronicDiseases.csv: ChronicDiseases33.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

MDS_V3_3.csv: $(CSV_FILES)
	head -n 1 Core.csv > $@
	for file in $(CSV_FILES); do \
		tail -n+2 $$file && echo ""; \
	done >> $@

Saxon-HE-12.4.jar:
	mvn dependency:copy -Dartifact=net.sf.saxon:Saxon-HE:12.4 -DoutputDirectory=.

xmlresolver-6.0.4.jar:
	mvn dependency:copy -Dartifact=org.xmlresolver:xmlresolver:6.0.4 -DoutputDirectory=.

