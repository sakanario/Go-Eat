# Go-Eat
Gp-Eat is a command line program to order food.


## Getting Started
To run the app, open cmd in the file folder and write : 

```
ruby run.rb
```

or simply click run.rb<br /><br />

The app can run with argument too : 

```
ruby run.rb 20 15 2
```

first argument (n, for instance) is the size of the generated map (n*n),<br />
second and third is user location. <br />


## How to Interact with the App
Simply enter the numbers listed on the selected menu.


## Assumption
Map is open world and consist with user, driver, and store that build on n*n 2D cartesius diagram.<br />
The Delivery fee is 300 per unit distance.


## App Design
The main file is run.rb that requiere back_end/logic.rb for it class and back_end/module.rb for it module.<br />
All the logic about map, driver location, user location, and store location stored on class Map. <br />
The app creates log.txt (replace log.txt if exist) for keeping history. <br />
The app uses sleep function to make the app more realistic.


## Bug
The app suppose to delete log.txt when exit, but sometimes it error(access denied).


## Note 
The app display work best when the map size is (10*10). <br /><br />

Importan!<br />
Always **use fullscreen window** when use [Show Map] fiture.


Repository Link : 
https://github.com/sakanario/Go-Eat



