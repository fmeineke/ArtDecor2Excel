CSV_FILES = MDS_Core_V3_4.csv MDS_Design_V3_4.csv MDS_NutritionalEpidemiology_V3_4.csv MDS_ChronicDiseases_V3_4.csv MDS_RecordLinkage_V3_4.csv
CSV_FILES_MAIN = MDS_Core_V3_4.csv MDS_Design_V3_4.csv

all: MDS_V3_4.csv MDS_Core_Design_V3_4.csv MDS_Design_V3_4.csv MDS_Core_V3_4.csv MDS_RecordLinkage_V3_4.csv MDS_NutritionalEpidemiology_V3_4.csv MDS_ChronicDiseases_V3_4.csv

MDS_Core_V3_4.xml:
	curl --location -H "Accept: application/xml" 'http://art-decor.org/exist/apps/api/dataset/2.16.840.1.113883.3.1937.777.64.1.2/2025-05-02T12%3A26%3A57/$$extract?language=en-US&format=xml&download=true' -o $@

MDS_Design_V3_4.xml:
	curl --location -H "Accept: application/xml" 'http://art-decor.org/exist/apps/api/dataset/2.16.840.1.113883.3.1937.777.64.1.2/2025-02-28T09%3A51%3A27/$$extract?language=en-US&format=xml&download=true' -o $@

MDS_RecordLinkage_V3_4.xml:
	curl --location -H "Accept: application/xml" 'http://art-decor.org/exist/apps/api/dataset/2.16.840.1.113883.3.1937.777.64.1.5/2026-02-20T10%3A42%3A34/$$extract?language=en-US&format=xml&download=true' -o $@

MDS_NutritionalEpidemiology_V3_4.xml:
	curl --location -H "Accept: application/xml" 'http://art-decor.org/exist/apps/api/dataset/2.16.840.1.113883.3.1937.777.64.1.3/2025-05-08T11%3A45%3A50/$$extract?language=en-US&format=xml&download=true' -o $@

MDS_ChronicDiseases_V3_4.xml:
	curl --location -H "Accept: application/xml" 'http://art-decor.org/exist/apps/api/dataset/2.16.840.1.113883.3.1937.777.64.1.4/2025-12-09T14%3A56%3A50/$$extract?language=en-US&format=xml&download=true' -o $@

clean: 
	rm -f $(CSV_FILES)

distclean: clean
	rm -f MDS_Core_V3_4.xml MDS_Design_V3_4.xml MDS_RecordLinkage_V3_4.xml MDS_NutritionalEpidemiology_V3_4.xml MDS_ChronicDiseases_V3_4.xml Saxon-HE-12.4.jar xmlresolver-6.0.4.jar

MDS_Design_V3_4.csv: MDS_Design_V3_4.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

MDS_Core_V3_4.csv: MDS_Core_V3_4.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

MDS_RecordLinkage_V3_4.csv: MDS_RecordLinkage_V3_4.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

MDS_NutritionalEpidemiology_V3_4.csv: MDS_NutritionalEpidemiology_V3_4.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

MDS_ChronicDiseases_V3_4.csv: MDS_ChronicDiseases_V3_4.xml ArtDecor2Excel.xsl Saxon-HE-12.4.jar xmlresolver-6.0.4.jar
	java -cp "*" net.sf.saxon.Transform -xsl:ArtDecor2Excel.xsl -s:$< -o:$@

MDS_Core_Design_V3_4.csv: $(CSV_FILES_MAIN)
# print column headers
	head -n 1 MDS_Core_V3_4.csv > $@
# print rows
	for file in $(CSV_FILES_MAIN); do \
		tail -n+2 $$file && echo ""; \
	done >> $@

MDS_V3_4.csv: $(CSV_FILES)
# print column headers
	head -n 1 MDS_Core_V3_4.csv > $@
# print rows
	for file in $(CSV_FILES); do \
		tail -n+2 $$file && echo ""; \
	done >> $@

Saxon-HE-12.4.jar:
	mvn dependency:copy -Dartifact=net.sf.saxon:Saxon-HE:12.4 -DoutputDirectory=.

xmlresolver-6.0.4.jar:
	mvn dependency:copy -Dartifact=org.xmlresolver:xmlresolver:6.0.4 -DoutputDirectory=.

