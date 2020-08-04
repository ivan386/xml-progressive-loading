<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:x="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	
	<!-- ключь который выбирает ответы на комментарий -->
	<xsl:key name="ответы" match="комментарий" use="@на"/>
	
	<!-- копирующий шаблон -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" />
		</xsl:copy>
	</xsl:template>
  
	<!-- основной xHTML код -->
  	<xsl:template match="статья">
		<html>
			<head>
				<!-- в статье для хранения заголовка и цитаты использованы  xHTML теги title и meta -->
				<!-- вставляем эти теги на их положенные места -->
				<xsl:copy-of select="x:title | x:meta[@name = 'description']"/>
				
				<style>
					.комментарий {
						padding: 1vw;
						min-width: 20em;
						border: 1px solid gray;
						color: black;
						background-color: white;
					}

					.текст {
						max-width: 46em; 
						margin: auto;
						text-align: justify;
					}
				</style>
			</head>
			<body>
				<!-- копируем атрибуты(они должны идти до дочерних элементов)-->
				<xsl:apply-templates select="@*" />
				<div class="текст">
					<!-- берём содержимое тега 'title' как заголовок статьи -->
					<h1><xsl:value-of select="x:title"/></h1>
					
					<!-- берём 'content' тега 'meta' как цитату для статьи -->
					<i><xsl:value-of select="x:meta[@name = 'description']/@content"/></i>
					
					<!-- берём содержимое тега 'текст' как текст для статьи -->
					<p><xsl:apply-templates select="текст/node()" /></p>
				</div>
				
				<!-- вызываем шаблон для блока с комментариями -->
				<xsl:apply-templates select="." mode="комментарии"/>
			</body>
		</html>
	</xsl:template>
	
	<!-- блок с комментариями отдельно для возможности его замены -->
	<xsl:template match="статья" mode="комментарии">
		<details id="комментарии" open=''>
			<summary>Комментарии</summary>
			
			<!-- выбираем комментарии которые не являются ответом @на другие комментарии --> 
			<xsl:apply-templates select="комментарий[not(@на)]"/>
		</details>
	</xsl:template>
	
	<!-- оформляем комментарий -->
	<xsl:template match="комментарий">
		<!-- добавляем класс "комментарий" и индекс комментария как идентификатор -->
		<div class="комментарий" id="{@индекс}">
			
			<!-- копируем остальные атрибуты комментария -->
			<xsl:apply-templates select="@*" />
			
			<!-- показываем индекс комментария и делаем его ссылкой -->
			<a href="#{@индекс}"><xsl:value-of select="@индекс"/></a><xsl:text>: </xsl:text>
			
			<div class="текст">
				<!-- выводим текст комментария -->
				<xsl:apply-templates select="node()" />	
			</div>
			
			<!-- вызываем шаблон для блока ответов -->
			<xsl:apply-templates select="." mode="ответы"/>	
		</div>
	</xsl:template>
	
	<!-- блок с ответами отдельно для возможности его замены -->
	<xsl:template match="комментарий" mode="ответы">
		<!-- проверяем есть ли ответы на комментарий -->
		<xsl:if test="key('ответы', @индекс)">
			<details open=''>
				<summary>Ответы</summary>
				
				<!-- показываем ответы -->
				<xsl:apply-templates select="key('ответы', @индекс)"/>
			</details>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>