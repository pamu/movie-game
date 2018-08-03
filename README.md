# Movie game

### Build

```
stack build
```

### Test

```
stack test
```

### Install and Run

```
[movie-game] stack install

Copied executables to /Users/foobar/.local/bin:
- movie-game-exe

[movie-game] stack exec movie-game-exe

I bet you can't tell me a movie I don't know in 3 tries!

Name a movie:
```

### Test

```
stack test
```

output:

```
Game
  play game function
    terminates after 3 trials
    ignores case and spaces around
    terminates immediately when it fails to find movie for given name
    terminates immediately when error like network error occurs
Winner
  decision
    returns Nobody when error occurs
    returns computer when trials is equal to computer win streak and trials >= 3
    returns Human when trials is greater than computer win streak
    returns movies after one round which are sorted by year

Finished in 0.0013 seconds
8 examples, 0 failures

movie-game-0.1.0.0: Test suite movie-game-test passed
Completed 2 action(s).
ExitSuccess
```


```bash
I bet you can't tell me a movie I don't know in 3 tries!

Name a movie:
Jobs

I know it:


Title: "Jobs"
Plot: "The story of Steve Jobs' ascension from college dropout into one of the most revered creative entrepreneurs of the 20th century."
Year: 2013



Name a movie:
Batman begins

I know it:


Title: "Batman Begins"
Plot: "After training with his mentor, Batman begins his fight to free crime-ridden Gotham City from the corruption that Scarecrow and the League of Shadows have cast upon it."
Year: 2005



Name a movie:
avatar

I know it:


Title: "Avatar"
Plot: "A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home."
Year: 2009


***************************
I won
***************************

The movies that I knew about:


Title: "Batman Begins"
Plot: "After training with his mentor, Batman begins his fight to free crime-ridden Gotham City from the corruption that Scarecrow and the League of Shadows have cast upon it."
Year: 2005




Title: "Avatar"
Plot: "A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home."
Year: 2009




Title: "Jobs"
Plot: "The story of Steve Jobs' ascension from college dropout into one of the most revered creative entrepreneurs of the 20th century."
Year: 2013

```
