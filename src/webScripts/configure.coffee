include "mustache.js"
include "util.js"

template = include "adminTemplate.html"
accessDeniedTemplate = include "accessDeniedTemplate.html"

# POST and GET controllers
post = ->
	# grab data from POST
	view =
		expectedData:  request.data.expectedData
		filename: request.data.filename

	# set activity page data
	try
		OpenLearning.page.setData view, request.user
	catch err
		view.error = 'Something went wrong: Unable to save data'
	
	return view

get = ->
	view = {}

	# get activity page data
	try
		data = OpenLearning.page.getData( request.user )
	catch err
		view.error = 'Something went wrong: Unable to load data'
	
	if not view.error?
		# build view from page data
		view.expectedData  = data.expectedData
		view.filename = data.filename

	return view


checkPermission 'write', accessDeniedTemplate, ->
	if request.method is 'POST'
		render template, post()
	else
		render template, get()

