# Go-Eat

Go-Eat adalah program berbasis command line untuk memesan makanan.

## Getting Started

To run the app, open cmd in the file folder and write : 

```
ruby run.rb
```

or simply click run.rb
<br /><br />
The app can run with argument too: 
<br /><br />
To run with argument
```
ruby run.rb 20 15 2
```

first argument (n, for instance) is the size of the generated map (n*n)
<br />
second and third is user location 
<br />

## Assumption

Map is open world and consist with user, driver, and store that build on n*n 2D cartesius diagram.



## App Design



The main file is run.rb that requiere back_end/logic.rb for it class and back_end/module.rb for it module.<br />
All the logic about map, driver location, user location, and store location stored on class Map. <br />
The app creates log.txt (replace log.txt if exist) for keeping history.

## Note 

The app display work best when the map size is (10*10).


Repository Link : 
https://github.com/sakanario/Go-Eat



