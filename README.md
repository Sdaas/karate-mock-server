

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
To see the current rules
```
curl -v http://localhost:9000/_rules | jsonpp
```
To see execution history
```
curl -v http://localhost:9000/_history | jsonpp
```


# References

* [Karate](https://github.com/intuit/karate)
* [Mock Server Using Karate](https://github.com/intuit/karate/tree/master/karate-netty)
