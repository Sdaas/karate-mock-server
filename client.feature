Feature: Sample client for mock server

  Background:
    * url 'http://localhost:9000'

  #  Example of a static expectation that was loaded from a file
  Scenario:
    Given path '/hello'
    When method GET
    And status 200
    And match response == 'hello world'

  # Create a rule on the fly and read the URI
  Scenario: Create a uri for Teapot
    # Create a URI that will resond to /teapot
    Given path '/_rule'
    Given def rule =
    """
      {
        "uri" : "/teapot",
        "response" : "I am a teapot",
        "status" : 419
      }
    """
    And request rule
    And header Accept = 'application/json'
    When method POST
    Then status 200
    And match response == 'OK'