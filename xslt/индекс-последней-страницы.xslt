<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
	<!-- в данном случае нам нужно вывести только число поэтому переключаем 'method' на 'text' -->
	<xsl:output method="text" encoding="UTF-8"/>
	
	<!-- количество комментариев на один XML файл -->
	<xsl:param name="количество" select="100" />
	
	<xsl:template match="/">
		<!-- вычисляем и выводим индекс последнего XML файла -->
		<xsl:value-of select="floor(count(//комментарий) div $количество)"/>
	</xsl:template>
	
</xsl:stylesheet>