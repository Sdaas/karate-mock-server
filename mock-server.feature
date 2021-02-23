Feature: Mock Service

  # This is a mock server. See  https://github.com/intuit/karate/tree/master/karate-netty

  Background:
    * def tempRuleList = read('rules.json')
    * def id = 0
    * def history = []
    * def createRules =
    """
    function(data){
      var rules = {}
      var ruleDetails = {}
      for(var i=0; i<data.length; i++){
        id = id + 1
        var key = id
        var v1 = data[i].request.method.toUpperCase() + '_' + data[i].request.uri
        rules[key] = v1
        ruleDetails[v1] = data[i]
      }
      return { "rules" : rules, "ruleDetails" : ruleDetails }
    }
    """
    * def temp = createRules(tempRuleList)
    # Key = id, value = method_uri
    * def rules = temp.rules
    # Key = method_uri, value = rules
    * def ruleDetails = temp.ruleDetails
    * def createRuleList =
    """
    function(rules, ruleDetails) {
      var out = {}
      for(var k in rules) {
        var v1 = rules[k]
        var v2 = ruleDetails[v1]
        out[k]=v2
      }
      return out
    }
    """

  # Get list of the rules along with their ids
  Scenario: pathMatches('/_rules')
    * def response = createRuleList(rules,ruleDetails)

  # Get a rule specified by its Id
  Scenario: pathMatches('/_rule/{id}')
    * def temp = createRuleList(rules,ruleDetails)
    * def response = temp[pathParams.id]
    * print response
    * def responseStatus = response ? 200 : 404

  # Create a new rule
  # TODO Needs work
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
    * def r = { method : #(requestMethod), uri : #(requestUri), headers : #(requestHeaders) }
    * if ( requestMethod == 'POST' || requestMethod == 'PUT' ) r["body"] =  request
    * set history[] = r
    # Which uri is being requested ?
    * print '*** got dynamic call ***'
    * print 'Uri = ' + requestUri
    # Create the response ...
    * def key = requestMethod + '_' + requestUri
    * def val = ruleDetails[key]
    * def response = val ? val.response.body : "I have no idea what you are talking about"
    * def responseHeaders = val ? val.response.headers : {}
    * def responseStatus = val ? val.response.status : 404
    # add delays if needed