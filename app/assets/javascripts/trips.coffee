$(document).on 'turbolinks:load', ->
  $('#trip-tags').tagit
    fieldName:   'tag_list'
    singleField: true
  $('#article-tags').tagit()
  tag_string = $("#tag_hidden").val()
  try
    tag_list = tag_string.split(',')
    for tag in tag_list
      $('#article-tags').tagit 'createTag', tag
  catch error