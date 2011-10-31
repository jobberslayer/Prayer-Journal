function toggle_prayer_updates(prayer_request_id) {
	$('prayer_updates_prayer_request_id').value = prayer_request_id
	my_toggle('prayer_updates_container_' + prayer_request_id, 'showupdate', 'toggle_button_' + prayer_request_id)
}

function my_toggle(div_id, button, toggle_button) {
	if ( $(div_id).innerHTML.length == 0 ) {
		$(button).click()
	}
	$(div_id).toggle();

  if ($(toggle_button).title == 'Show Updates') {
    $(toggle_button).title = 'Hide Updates';
    $(toggle_button).src = '/images/minus.png'
  } else {
    $(toggle_button).title = 'Show Updates';
    $(toggle_button).src = '/images/plus.png'
  }
	$(toggle_button).src = toggle_text($(toggle_button).title, 'Show Updates', 'Hide Updates')
}
