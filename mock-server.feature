Feature: Mock Service

  # This is a mock server. See  https://github.com/intuit/karate/tree/master/karate-netty

  Background:
    * def id = 1
    * def history = []
    * def staticRuleList = read('rules.json')
    * def nextId = function(){ return ~~id++ }
    * def createRules =
    """
    function(data){
      var rules = {}
      var ruleDetails = {}
      for(var i=0; i<data.length; i++){
        var key = nextId()
        var v1 = data[i].request.method.toUpperCase() + '_' + data[i].request.uri.toUpperCase()
        rules[key] = v1
        ruleDetails[v1] = data[i]
      }
      return { "rules" : rules, "ruleDetails" : ruleDetails }
    }
    """
    * def temp = createRules(staticRuleList)
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
  Scenario: pathMatches('/_rule/{id}') && methodIs('get')
    * def temp = createRuleList(rules,ruleDetails)
    * def response = temp[pathParams.id]
    * print response
    * def responseStatus = response ? 200 : 404

  # Create a new rule
  # TODO Needs work
  Scenario: pathMatches('/_rule') && methodIs('post')
    # The rule is specified in the request body
    * def rule = request
    # use the next Id for this rule
    * def id = nextId()
    # TODO Refactor for DRY
    * def v1 = rule.request.method.toUpperCase() + '_' + rule.request.uri.toUpperCase()
    * rules[id] = v1
    * ruleDetails[v1] = rule
    # create the response
    * def responseStatus = 201
    * def response = id

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
    * def key = requestMethod.toUpperCase() + '_' + requestUri.toUpperCase()
    * print key
    * def val = ruleDetails[key]
    * def response = val ? val.response.body : "I have no idea what you are talking about"
    * def responseHeaders = val ? val.response.headers : {}
    * def responseStatus = val ? val.response.status : 404
    # add delays if needed