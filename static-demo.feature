Feature: Demo of viewing and executing static rules

  Background:
    * url 'http://localhost:9000'

  # Example of a static rule that was loaded from a file
  Scenario:
    Given path '/person/1'
    When method GET
    Then status 200
    And header Content-Type = 'application/json'
    And match response == { name : "Homer Simpson", pets : ["Snowball", "Santas Little Helper"]}

  #  Another example of a static expectation that was loaded from a file
  Scenario:
    Given path '/hello'
    When method GET
    Then status 200
    And header Content-Type = 'application/txt'
    And match response == 'hello world'

  # This will fail because there is no rule for handling GET /fubar
  Scenario:
    Given path '/fubar'
    When method GET
    Then status 404

  # Example scenario of a POST rule from a static file
  Scenario:
    Given path '/person'
    And request "this is ignored for now"
    When method post
    Then status 201
    And response.id == 12345

  # Make a call and check that is added to the call history
  Scenario:
    # Make a call to some random non-existent uri
    Given path '/atlantis'
    When  method GET
    Then  status 404
    # Get the call history
    Given path '/_history'
    When  method GET
    Then  status 200
    And   print response
    And   match response[*].uri contains '/atlantis'

  Scenario: Get all the rules
    Given path '/_rules'
    When method GET
    Then status 200
    And header Content-Type = 'application/json'
    And match response == '#[]'
    * def req = response[0].request
    * def resp = response[0].response
    And match req == { method : '#string', uri : '#string' }
    And match resp == { headers  : '##object', body : '#present', status : '#number' }

  Scenario: Get the details of a particular rule
    Given path '/_rule/1'
    When method GET
    Then status 200
    * def res = response.response
    And match res.body == "hello world"
    And match res.status == 200
    And match res.headers == { "Content-Type": "application/txt" }
