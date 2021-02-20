Feature: Sample client for mock server

  Background:
    * url 'http://localhost:9000'

  #  Check if the server is up and running
  Scenario:
    Given path '/hello'
    When method GET
    Then print response
    And status 200
    And match response == 'Hello World'