# Shiny Apps IO

El proyecto fue publicado en la plataforma de Shiny Apps IO, la cual pueden encontrar [aqui](https://www.shinyapps.io/)

Adicionalmente, pueden encontrar nuestro proyecto específico haciendo click [aqui](https://jdufm.shinyapps.io/parcial2/)

O bien, el link directo: https://jdufm.shinyapps.io/parcial2/

# Source

En el directorio **shiny** estan los scripts para el Shiny:

- Shiny Server

- Shiny UI

Además, está dentro del mismo, otro directorio llamado **data** en donde se encuentran los tres archivos en formato CSV que fueron utilizados para el proyecto.

# Shiny App

La aplicación Shiny de este proyecto, cuenta con las siguientes pestañas y caracteristicas:

## Estadísticas de los datos

En esta pestaña, como su nombre lo indica, se encuentran las estadísticas generales de todos los vídeos del DataSet.

Se encuentra:

Una gráfica de frecuencia ordenada según la cantidad de views de los vídeos.

- El vídeo con mayor cantidad de likes

- El vídeo con mayor cantidad de views

- El vídeo con mayor cantidad de dislikes

- El vídeo con la mayor cantidad de 'Marcado como Favorito'

## Filtar la data por parámetros

En esta pestaña, se encuentra desplegado todo el DataSet con sus respectivas columnas, y la habilidad para poder filtrar en base a cada una de ellas. Adicionalmente, se puede dar click sobre una fila para seleccionar el vídeo, función que servirá en la siguiente pestaña.

## Video seleccionado

En esta pestaña, se encuentra desplegado el vídeo que el usuario haya seleccionado en la pestaña anterior.

Se encuentra:

El titulo del vídeo, la descripción del mismo, así como el vídeo en sí para poder visualizarlo desde la misma aplicación Shiny.

## Likes VS Visitas

En esta pestaña, se encuentra la compración entre cantidad de visitas y cantidad de 'Likes' por vídeo. Es un diagrama de disperción en el que se encuentran todos los vídeos del DataSet, pero se puede seleccionar uno o más puntos para tener información de ellos específicamente.

## Likes VS Comentarios

En esta pestaña, se encuentra la compración entre cantidad de comentarios y cantidad de 'Likes' por vídeo. Es un diagrama de disperción en el que se encuentran todos los vídeos del DataSet, pero se puede seleccionar uno o más puntos para tener información de ellos específicamente.

## Parámetros de la URL

Esta es la última pestaña. En ella se encuentran detallaod los parametros del URL para generar una WordCloud, que es una nube de frecuencia conformada por las palabras más utilizadas.

Se puede hacer en base a dos campos:

1. Títulos

2. Descripción

Adicionalmente, hay un slider de frecuencia, en el que puede seleccionar entre 1 y 50, según la frecuencia deseada.

Por último, se encuentra otro slider que controla la cantidad de palabras que se desea que aparezcan en la word cloud. Puede ir desde 1 hasta 75.

### Preview

![Preview](https://i.imgur.com/hJO3uoT.png)
