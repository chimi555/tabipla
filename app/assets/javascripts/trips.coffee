$(document).on 'turbolinks:load', ->
  $('#trip-tags').tagit
    fieldName: 'tag_list'
    singleField: true
  $('#trip-tags').tagit()
  tag_string = $("#tag_hidden").val()
  try
    tag_list = tag_string.split(',')
    for tag in tag_list
      $('#trip-tags').tagit 'createTag', tag
  catch error