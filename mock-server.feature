Feature: Mock Service

  # This is a mock server. See  https://github.com/intuit/karate/tree/master/karate-netty

  Background: This is executed once when the mock server starts up
    * def id = 1
    # Key = id, value = rule
    * def ruleMap = {}
    # Call history request
    * def history = []
    * def nextId = function(){ return ~~id++ }
    * def cleanup =
    """
    function(data) {
      data.request.method = data.request.method.toUpperCase()
      data.request.uri = data.request.uri.toUpperCase()
      return data
    }
    """
    * def addRule =
    """
    function(data) {
      var key = nextId().toString()
      cleanup(data)
      data.id = key
      ruleMap[key] = data
      return key
    }
    """
    * def createRuleMap =
    """
    function(data){
      for(var i=0; i<data.length; i++){
        addRule(data[i])
      }
    }
    """
    * def staticRuleList = read('rules.json')
    * createRuleMap(staticRuleList)


  # Get list of the rules along with their ids
  Scenario: pathMatches('/_rules') && methodIs('get')
    * def convertToList =
    """
    function(map) {
      var list = []
      for (var key in map) {
        list[key] = map[key]
      }
      return list
    }
    """
    * def response = convertToList(ruleMap)

  # Get a rule specified by its Id
  Scenario: pathMatches('/_rule/{id}') && methodIs('get')
    * def response = ruleMap[pathParams.id]
    * def responseStatus = response ? 200 : 404

  # Create a new rule
  Scenario: pathMatches('/_rule') && methodIs('post')
    # The rule is specified in the request body
    * def id = addRule(request)
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
    # Match the rule in the map
    * def findInRuleMap =
    """
    function(method, uri){
      method = method.toUpperCase()
      uri = uri.toUpperCase()
      for (var key in ruleMap) {
        var rule = ruleMap[key]
        if( rule.request.method === method && rule.request.uri === uri ) {
            return rule.response
        }
      }
      return null
    }
    """
    # Create the response
    * def r = findInRuleMap( requestMethod, requestUri )
    * def response = r ? r.body : "I have no idea what you are talking about"
    * def responseHeaders = r ? r.headers : {}
    * def responseStatus = r ? r.status : 404
    * def responseDelay = r ? (r.delay ? r.delay : 0 ) : 0
    # add delays if needed

