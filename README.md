# cassandra_example
A rather simplistic example of Cassandra usage with a Ruby client

# Requirements

* Apache Cassandra server runing on local machine.
* Ruby (tested with ruby-2.4.2).
* tested on Mac and Linux

# Usage

* Run ``` bundle install ```
* From the root directory run ```./bin/run```. It is going to keep running, generating and inserting data into the ```cassandra_example``` table. When you want to stop the script hit ```Ctrl-c```.
* In another tab (or the same one if you have stopped the script) start the web interface with ```cassandra-web```.

# What it does

It uses the [Faker](https://github.com/stympy/faker) gem to simulate an infinite stream of messages from four different users. Text is broken up with a simple split and counts are updated for each term using batch update. For each term user ID is inserted into the set table for the minute when the message happened.
[Cassandra Web](https://github.com/avalanche123/cassandra-web) is a simple interface you can use to inspect the data inserted.
You should see ```cassandra_example``` keyspace containing two tables ```terms_per_min``` and ```ids_per_term_per_min```.
