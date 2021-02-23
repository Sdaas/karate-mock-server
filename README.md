
**WORK IN PROGRESS**

# Instructions

Start the mock server. The mock server will run in a docker container, and will load the rules specified in `rules.json`
```
docker-compose up
```
Execute a canned rule (that was loaded from `rules.json`)
```
curl -v http://localhost:9000/hello 
```
To see the current rules
```
curl -v http://localhost:9000/_rules | jsonpp
curl -v http://localhost:9000/rule/{id} | jsonpp
```
To see the call history
```
curl -v http://localhost:9000/_history | jsonpp
```

Run the client to exercise the mock-server
```
java -jar karate.jar static-demo.feature
```

# References

* [Karate](https://github.com/intuit/karate)
* [Mock Server Using Karate](https://github.com/intuit/karate/tree/master/karate-netty)
