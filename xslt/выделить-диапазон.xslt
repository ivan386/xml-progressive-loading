<xsl:stylesheet
  version="1.0"
  xmlns:x="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:param name="путь" />
	
	<!-- количество комментариев на страницу -->
	<xsl:param name="комментариев"/>
	
	<!-- номер страницы для которой выбираем комментарии -->
	<xsl:param name="страница"/>
		
	<xsl:template match="/">
		<!-- задаём ссылку на шаблон который соберёт и загрузит статью полностью -->
		<xsl:processing-instruction name="xml-stylesheet">href="../сборка-статьи.xslt" type="text/xsl"</xsl:processing-instruction>
		
		<!-- переходим сразу к статье -->
		<xsl:apply-templates select="статья" />
	</xsl:template>
	
	<xsl:template match="статья">
		<статья путь="{$путь}">
			<!-- копируем title и meta теги -->
			<xsl:copy-of select="x:title | x:meta[@name = 'description']"/>
			
			<!-- копируем диапазон комментариев для заданной страницы -->
			<xsl:copy-of select="комментарий[floor(@индекс div $комментариев) = $страница]" />
		</статья>
	</xsl:template>
</xsl:stylesheet>