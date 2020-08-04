chcp 65001

rem Создаём дирректорию с именем исходного XML файла без расширения
md "%~dpn1"

rem Задаём межстраничные связи комментариев
msxsl.exe %1 "%~dp0xslt\задать-страницы-ответов.xslt" -xw -o "%~dpn1\index.xml" комментариев=%2

rem Определяем индекс последнего XML файла с комментариями
for /f "delims=" %%a in ('msxsl.exe %1 ^"%~dp0xslt\индекс-последней-страницы.xslt^" комментариев^=%2') do set последняя=%%a

rem Делим комметирии на диапазоны
for /l %%i in (0,1,%последняя%) do msxsl.exe -o "%~dpn1\%%i.xml" "%~dpn1\index.xml" "%~dp0xslt\выделить-диапазон.xslt" комментариев=%2 страница=%%i путь="%~n1"

rem Оставляем только текст статьи
msxsl.exe "%~dpn1\index.xml" "%~dp0xslt\убрать-комментарии.xslt" -o "%~dpn1\index.xml"