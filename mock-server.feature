Feature: Mock Service

  # This is a mock server. See  https://github.com/intuit/karate/tree/master/karate-netty

  Background:
    * def ruleList = read('rules.json')
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
    * def ruleMap = convertToMap(ruleList)

  # Get the expectations
  Scenario: pathMatches('/_rules')
    * def response = ruleList

  # Get the call history
  Scenario: pathMatches('/_history')
    * def response = history

  # The default scenario to execute if there are no matches
  Scenario:
    # Add this request to the history
    * set history[] = requestUri
    * print 'Uri = ' + requestUri
    * def out = ruleMap[requestUri]
    * print out
    * def response = out ? out.response : "I have no idea what you are talking about"
    * def responseStatus = out ? out.status : 404
    * def responseStatus = 200