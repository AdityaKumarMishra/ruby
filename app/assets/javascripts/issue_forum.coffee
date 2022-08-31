$ ->
  initTagNavigator = (parentNode) ->
    currentNode = this

    container = $('<div />').insertAfter(this)

    $(this).change ->
      dataUrl = $(currentNode).find(':selected').data('url')
      answererUrl = $(currentNode).find(':selected').data('answererUrl')

      container.empty()

      $.get(dataUrl, (data) ->
        if (data.length > 0)
          selectTag = $('<select />')
            .attr('name', $(currentNode).attr('name'))
            .attr('class', $(currentNode).attr('class'))

          selectTag.append $('<option />').text("Please select a tag")

          container.append selectTag

          for tag in data
            option = $('<option />')
              .attr("value", tag.id)
              .text(tag.name)
              .data('url', tag.children)
              .data('answererUrl', tag.answerers)
            selectTag.append option

          initTagNavigator.call(selectTag[0], parentNode)
          parentNode.trigger("answererUrl:changed", null)
        else
          parentNode.trigger("answererUrl:changed", answererUrl)

      , 'json')

  $('.tag-navigator').each ->
    currentNode = $(this)
    dataUrl = $(this).data('url')

    $.get(dataUrl, (data) ->
      currentNode.append $('<option />')
      for tag in data
        currentNode.append $('<option />').attr("value", tag.id).text(tag.name).data('url', tag.children).data('answererUrl', tag.answerers)
    , 'json')


    initTagNavigator.call(this, currentNode)
    currentNode.trigger("answererUrl:changed", null)


  $('.tag-answerer[data-selector]').each ->
    selectTag = $(this)
    selector = $(this).data('selector')

    $(selector).on "answererUrl:changed", (event, url) ->
      selectTag.empty()
      selectTag.append $('<option />').text("Please select a user")

      if url?
        $.get(url, (data) ->
          for answerer in data
            option = $('<option />')
              .attr("value", answerer.id)
              .text(answerer.name)
            selectTag.append option

        , 'json')
