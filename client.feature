Feature: Sample client for mock server

  Background:
    * url 'http://localhost:9000'

  #  Example of a static expectation that was loaded from a file
  Scenario:
    Given path '/hello'
    When method GET
    And status 200
    And match response == 'hello world'