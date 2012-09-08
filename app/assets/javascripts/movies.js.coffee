# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
    $("#select_date").change ->
        $("#select_options_form").submit()

    $("[id^=theater_id_]").change ->
        $("#select_options_form").submit()
