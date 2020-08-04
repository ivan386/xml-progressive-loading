<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:x="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	
	<!-- подключаем шаблон "статья.xslt" -->
	<xsl:include href="%D1%81%D1%82%D0%B0%D1%82%D1%8C%D1%8F.xslt"/>
	
	<xsl:template match="статья" mode="комментарии">
	
		<!-- в этом фрейме будет загружаться статья вместе с комментариями -->
		<iframe style="display:none;" id="фрейм-загрузчик" src="0.xml"/>
	
		
		<script><![CDATA[
			setTimeout(function(){
				var фрейм = document.querySelector("#фрейм-загрузчик");
				if (фрейм && фрейм.contentDocument)
				{
					var комментарии = фрейм.contentDocument.getElementById('комментарии');
					
					// ждём пока во фрейме появится блок комментариев
					if (комментарии)
					{
						// добавляем этот блок на эту страницу
						document.body.appendChild(комментарии);
						return;
					}
				}
				
				// ставим новый Timeout пока не выполнятся все условия
				setTimeout(arguments.callee, 100);
			}, 100)]]>
		</script>
		<noscript>
			<!-- Если на странице запрещён JavaScript пользователь может вручную перейти на статью с комментариями -->
			<a href="0.xml">Комментарии</a>
		</noscript>
	</xsl:template>
</xsl:stylesheet>