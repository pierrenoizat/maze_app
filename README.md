# README


* Ruby version 2.7.2

* Database initialization: none

* This app allows the creation of any maze simply by specifying the algorithm (aldous_broder gives the best, unbiased results), the palette and the color. If a palette is specified, the color is ignored hence you should leave the palette field blank if you want to specify a color. A black and white png image of the maze is created as a png file, along with a colored version. The colored version reveals the shortest path to the center whithe cell, going from the darker to the lighter cells all the way up to the center. Every cell is connected to the center (as a matter of fact to every other cell). The number of cells is specified through the number of rows and columns set in the maze creation form.

* The sand pile algorithm is an implementation of Per Bak's sand pile experiment. It is not a maze alogorithm.
It shows the result of a given number of iterations (sand grains added).

* Thanks to Jamis Buck for his talent and amazing work on mazes that inspired me to build this app.
