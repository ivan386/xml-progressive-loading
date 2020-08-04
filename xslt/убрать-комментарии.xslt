<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- копирующий шаблон -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/">
		<!-- добавляем шаблон прогрессивной загрузки -->
		<xsl:processing-instruction name="xml-stylesheet">href="../прогрессивная-загрузка.xslt" type="text/xsl"</xsl:processing-instruction>
		
		<!-- переходим сразу к статье -->
		<xsl:apply-templates select="статья" />
	</xsl:template>
	
	<!-- удаляем все комментарии -->
	<xsl:template match="комментарий"/>
</xsl:stylesheet>