Feature: Mock Service

  # This is a mock server. See  https://github.com/intuit/karate/tree/master/karate-netty

  Background:
    * def expectations =
    * def history = []


  # The hello world API just to make sure the darn thing is up and running
  Scenario: pathMatches('/hello')
    * def response = 'Hello World'

  # Get the call history
  Scenario: pathMatches('/_history')
    * def response = history

  # The default scenario to execute if there are no matches
  Scenario:
    * print requestUri
    * set history[] = requestUri
    * def response = 'Ok'
    * def responseStatus = 200