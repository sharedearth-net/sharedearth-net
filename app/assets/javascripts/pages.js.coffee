jQuery -> 
	$('.my-activity').click (e) ->
		$('.my-activity').addClass('.active')
		$('.actions').removeClass('.active')
	$('.actions').click (e) ->
		$('.actions').addClass('.active')
		$('.my-activity').removeClass('.active')