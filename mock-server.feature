Feature: Mock Service

  # This is a mock server. See  https://github.com/intuit/karate/tree/master/karate-netty

  Background:
    * def tempRuleList = read('rules.json')
    * def history = []
    * def convertToMap =
    """
    function(data){
      var out = {}
      for(var i=0; i<data.length; i++){
        var key = data[i].uri
        out[key] = data[i]
      }
      return out;
    }
    """
    # As the name implies, productMap is a map where the key(s) are the productId, and the values are the productDetails
    * def ruleMap = convertToMap(tempRuleList)


  # Get the rules
  Scenario: pathMatches('/_rules')
    * def response = ruleMap

  # Create a new rule
  Scenario: pathMatches('/_rule') && methodIs('post')
    * def id = request.uri
    * def rule =
    """
    {
      uri : '#(request.uri)',
      response : '#(request.response)',
      status : '#(request.status)'
    }
    """
    * ruleMap[id] = rule
    * print ruleMap
    * def response = "OK"

  # Get the call history
  Scenario: pathMatches('/_history')
    * def response = history

  # The Heart of the server ... Every request is compared against the ruleset ...
  Scenario:
    # Add this request to the history
    * set history[] = requestUri
    * print 'Uri = ' + requestUri
    * def out = ruleMap[requestUri]
    * def response = out ? out.response : "I have no idea what you are talking about"
    * def responseStatus = out ? out.status : 404
    * def responseStatus = 200