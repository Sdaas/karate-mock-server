Feature: Demo of viewing and executing static rules

  Background:
    * url 'http://localhost:9000'

  #  Example of a static expectation that was loaded from a file
  Scenario:
    Given path '/hello'
    When method GET
    And status 200
    And header Content-Type = 'application/txt'
    And match response == 'hello world'

  #  Another example of a static expectation that was loaded from a file
  Scenario:
    Given path '/person/1'
    When method GET
    And status 200
    And header Content-Type = 'application/json'
    And match response == { name : "Homer Simpson", pets : ["Snowball", "Santas Little Helper"]}

  # Example scenario of a POST rule from a static file
  # TODO

  # Example of making a call to a non-existent rule
  # TODO

  # Example to see that every call is part of the history
  # TODO

  # Example scenario to get list of all the rules
  Scenario:
    Given path '/_rules'
    When method GET
    And status 200
    And header Content-Type = 'application/json'
    And match response == { 1 : #present, 2 : #present }
