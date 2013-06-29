nodemailer = require("nodemailer")

class Mail
	account: {}
	constructor: (@account)->
		if (account.auth.user == "" or account.auth.password == "")
			throw "[ERROR] Mail informations missing"

	send: (callback) ->
		mailOptions =
			from: "Node Server" 
			to: @account.auth.user 
			subject: "Slot available !" # Subject line
			text: "A slot is now available for an early pool !" # plaintext body
			html: "<b>A slot is now available for an early pool !</b>" # html body
		@getTransport().sendMail mailOptions, (error, response) ->
			if error
				console.log(error)
				throw "[Error] Mail#send - #{error} - #{response}"

	getTransport: () ->
		nodemailer.createTransport "SMTP", @account

exports = module.exports = Mail