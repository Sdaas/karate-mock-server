

# Instructions

Start the mock server. The mock server will run in a docker-container and will hot-reload
whenever the `mock-server.feature` file is updated.

```
docker-compose up
```
Run the client to exercise the mock-server
```
java -jar karate.jar client.feature
```

brew install jsonpp <- Json pretty printing

# References

* [Karate](https://github.com/intuit/karate)
* [Mock Server Using Karate](https://github.com/intuit/karate/tree/master/karate-netty)
