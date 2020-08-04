<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:x="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes" encoding="UTF-8"/>
	
	<!-- подключаем шаблон "статья.xslt" -->
	<xsl:include href="%D1%81%D1%82%D0%B0%D1%82%D1%8C%D1%8F.xslt"/>
	
	<!-- создаём ключь который автоматом выберет в текущем документе ответы на комментарий -->
	<xsl:key name="ответы" match="комментарий" use="@на"/>
	
	<xsl:param name="путь" select="статья/@путь"/>
	
	<xsl:template match="/">
		<!-- даём отработать шаблону "статья.xslt" -->
		<xsl:apply-templates select="document(concat($путь, '/index.xml'))/статья"/>
	</xsl:template>
	
	<!-- из подключённого шаблона мы вернёмся сюда -->
	<xsl:template match="статья" mode="комментарии">
		<details id="комментарии" open=''>
			<!-- на этом этапе основная страница уже сможет взять блок комментариев из фрейма -->
			<summary>Комментарии</summary>
			
			<!-- начинаем загрузку комментариев -->
			<xsl:call-template name="загрузить-страницу"/>
		</details>
	</xsl:template>
	
	<xsl:template name="загрузить-страницу">
	
		<!-- начинаем с XML с номером 0 -->
		<xsl:param name="номер" select="0"/>
		
		<!-- загружаем XML -->
		<xsl:param name="страница" select="document(concat($путь, '/', $номер, '.xml'))"/>
		
		<!-- если XML загружен -->
		<xsl:if test="$страница">
			
			<!-- запускаем обработку комментариев к статье -->
			<xsl:apply-templates select="$страница//комментарий[not(@на)]" />
			
			<!-- запускаем шаблон для следующего XML документа -->
			<xsl:call-template name="загрузить-страницу">
				<!-- задаём следующий номер XML -->
				<xsl:with-param name="номер" select="$номер + 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- для загрузки ответов на комментарии будет вызван этот шаблон -->
	<xsl:template match="комментарий" mode="ответы">
		<!-- проверяем есть ли ответы на комментарий в этом XML или на других страницах -->
		<xsl:if test="key('ответы', @индекс) or @страницы-ответов">
			<details open=''>
				<summary>Ответы</summary>
				
				<!-- показываем ответы из этого XML -->
				<xsl:apply-templates select="key('ответы', @индекс)"/>
				
				<!-- запускаем загрузку комментариев из других XML -->
				<xsl:call-template name="загрузить-ответы"/>
			</details>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="загрузить-ответы">
		<!-- получаем список номеров страниц -->
		<xsl:param name="страницы" select="concat(@страницы-ответов, ' ')"/>
		
		<!-- берём первый из списка -->
		<xsl:param name="номер" select="substring-before($страницы, ' ')"/>
		
		<!-- проверяем что он не пустой -->
		<xsl:if test="$номер">
			
			<!-- загружаем XML -->
			<xsl:apply-templates select="document(concat($путь, '/', $номер, '.xml'))" mode="ответы">
				<!-- передаём индекс комментария ответы на который надо загрузить -->
				<xsl:with-param name="на" select="@индекс"/>
			</xsl:apply-templates>

			<!-- вызываем снова этот же шаблон -->
			<xsl:call-template name="загрузить-ответы">
			
				<!-- передаём список оставшихся страниц -->
				<xsl:with-param name="страницы" select="substring-after($страницы, ' ')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="/" mode="ответы">
		<!-- это индекс комментария ответы на который надо получить -->
		<xsl:param name="на"/>
		
		<!-- отправляем на оформление ответы на комментарий -->
		<xsl:apply-templates select="key('ответы', $на)"/>
	</xsl:template>
	
</xsl:stylesheet>