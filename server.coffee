Browser = require("zombie")
Cheerio = require("cheerio")
Mail = require("./Mail")


checkSlot = (account) ->
	currentTimestamp = new Date().getTime()
	time = new Date(currentTimestamp).toGMTString()
	host = "http://candidature.42.fr"
	path = "/users/sign_in"
	browser = new Browser()

	availableDate = []

	if account.website.email == "" or account.website.password == ""
		throw "[ERROR] Website informations missing"

	browser.visit host + path, {runScripts: false}, ->

		console.log " -- [#{time}] Connection to #{host}#{path}"
	  
		browser
			.fill("user[email]", account.website.email)
			.fill("user[password]", account.website.password)
			.pressButton("Se connecter")

		setTimeout ( ->
			location = browser.location.toString()
			$ = Cheerio.load(browser.html())
			if (location == host + "/piscines")
				console.log " -- [#{time}] Connected to 'Pool Registration'"
				i = 0;
				$("table tbody tr").each ->
					date = [];
					preRentre = $("table tbody tr").find('td')[i].children[0].data.replace(/(\r\n|\n|\r)/gm,"");
					rentre = $("table tbody tr").find('td')[i + 1].children[0].data.replace(/(\r\n|\n|\r)/gm,"");
					isAvailable = if $("table tbody tr").find('td')[i + 2].children[0].data.replace(/(\r\n|\n|\r)/gm,"") == "Plus de place" then false else true
					date['preRentre'] = preRentre
					date['rentre'] = rentre
					date['isAvailable'] = isAvailable
					availableDate.push(date)
					i += 4
				if availableDate[0]['isAvailable'] == true
					console.log " -- [#{time}] You can register for an early pool =D"
					mail = new Mail(account.email)
					mail.send()
					
				else
					console.log " -- [#{time}] No slot available for early pool :("
		), 2000


account =
	email:
		service: "Gmail" #https://github.com/andris9/Nodemailer#well-known-services-for-smtp
		auth:
			user: ""
			pass: ""
	website:
		email: ""
		password: ""

try
	setInterval(checkSlot(account), (1000 * 60) * 30)
catch e
	console.log e


