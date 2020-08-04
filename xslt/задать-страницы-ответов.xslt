<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:key name="ответы" match="комментарий" use="@на"/> 
	
	<!-- количество комментариев на страницу -->
	<xsl:param name="комментариев" />
	
	<!-- копирующий шаблон -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" />
		</xsl:copy>
	</xsl:template>
	
	<!-- обрабатываем все комментарии -->
	<xsl:template match="комментарий">
	
		<!-- определяем страницу этого комментария -->
		<xsl:param name="текущая-страница" select="floor(@индекс div $комментариев)" />
		
		<!-- находим ответы на других страницах -->
		<xsl:param name="ответы-дальше" select="key('ответы', @индекс)[floor(@индекс div $комментариев) > $текущая-страница]"/>
		
		<!-- копируем комментарий -->
		<xsl:copy>
			<!-- копируем атрибуты "индекс" и "на" -->
			<xsl:apply-templates select="@*" />
			
			<!-- если есть ответы на других страницах -->
			<xsl:if test="$ответы-дальше">
				<!-- добавляем атрибут "страницы-ответов" -->
				<xsl:attribute name="страницы-ответов">
					<!-- записываем в него номера страниц ответов -->
					<xsl:call-template name="страницы-ответов">
						
						<!-- передаём ответы с других страниц -->
						<xsl:with-param name="ответы" select="$ответы-дальше" />
						
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			
			<!-- копируем текст и другие элементы сообщения -->
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="страницы-ответов">
		<!-- ответы с этой и следующих страниц -->
		<xsl:param name="ответы"/>
		
		<!-- номер текущей страницы -->
		<xsl:param name="номер-страницы" select="floor($ответы[1]/@индекс div $комментариев)"/>
		
		<!-- находим ответы на следующих страницах -->
		<xsl:param name="ответы-дальше" select="$ответы[floor(@индекс div $комментариев) > $номер-страницы]"/>
		
		<!-- записываем номер текущей страницы -->
		<xsl:value-of select="$номер-страницы"/>
		
		<!-- если есть ответы на следующих страницах -->
		<xsl:if test="$ответы-дальше">
			<!-- отделяем пробелом номер следующей страницы -->
			<xsl:text> </xsl:text>
			
			<!-- вызываем это же шаблон -->
			<xsl:call-template name="страницы-ответов">
				<!-- передаём ответы со следующих страниц -->
				<xsl:with-param name="ответы" select="$ответы-дальше" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>