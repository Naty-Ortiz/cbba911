$ ->
  initialize_users_typeahead = ->
    users_typeahead = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace(
        "name"
      ),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      prefetch: "/complains/autocomplete"
    )

    users_typeahead.initialize()

    $(".js-user-autocomplete").typeahead null,
      displayKey: "email"
      source: users_typeahead.ttAdapter()
      templates:
        suggestion: Handlebars.compile("
          <div>
          
              Name: <strong>{{name}}</strong>
            
          </div>
        ")

  initialize_users_typeahead()