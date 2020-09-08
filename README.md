# Compare Similarity

Project introduction:
  This software makes the comparison of two json objects and gives a score between 0 and 1 depending on the level of equal between them.

Comparison rules:
  The total score is given considering 3 points:
  - if the number of keys in both files is equal, so the maximum score is given, otherwise the score suffer penalties
  - if both files have the same keys, they receive the maximum score in this category, otherwise they suffer penalties.
  - equal values, if all values ​​are equal, is given maximum score in this category, otherwise you will suffer penalties.

how to run the project:
- this project was done using ruby ​​2.6.3 and ubuntu 18
- it is necessary to run bundle to install the project's dependencies:

Ex: bundle install

- to execute it is necessary to call the input file (bin/index.rb) and pass as an argument the path of two json files as follows:
Ex: ruby ​​bin/index.rb data/BreweriesSample2.json data/BreweriesMaster.json

Rakefile:
the project has 6 test files, to execute all possible test combinations among them execute:

Ex: rake run

tests:
- The tests were done using RSpec, to run the tests run:
Ex: rspec spec