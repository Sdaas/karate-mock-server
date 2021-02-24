Feature: Dynamically creating rules and executing them

  Background:
    * url 'http://localhost:9000'

  Scenario: Create a rule, execute it, and then finally delete it
    # When GET /motto is called, the server shoudl respond with veritas vos liberabit
    * def theMethod = 'get'
    * def theUri = '/motto'
    * def theResponse = 'Veritas vos Liberabit'
    * def theContentType = "application/txt"
    * def theStatus = 200

    # Creating the rule on the server
    Given path '/_rule'
    And request
    """
    {
      "request": {
        "method" : #(theMethod),
        "uri" : #(theUri)
      },
      "response" : {
        "headers": {
          "Content-Type": #(theContentType)
        },
        "body" : #(theResponse),
        "status" : #(theStatus)
      }
    }
    """
    When method post
    Then status 201
    And def ruleId = response
    And print response

    # Invoke the dynamically created uri
    Given path theUri
    When method GET
    # Then status 200  <-- this will work
    # Then status theStatus <-- this will not work
    Then match responseStatus == theStatus
    #And header Content-Type = 'application/txt' <-- This will work
    #And  header Content-Type = theContentType <-- this will NOT work
    And match responseHeaders['Content-Type'][0] == theContentType
    And match response == theResponse


