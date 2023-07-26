fx_version 'bodacious'
games { 'gta5' }

name "Forza Horizon 4 Speedometer"
description "The Forza Horizon 4 speedometer by Akkariin. Modified to have new features. Maybe assisted by artificial stuff."
author "Akkariin, The Project Fairness Labs"
url "https://discord.gg/D7cVc8TzPN"

ui_page "html/hud.html"

files {
	"html/hud.html",
	"html/js/gauge.min.js",
	"html/js/hud.js",
	"html/css/hud.css",
	"html/fonts/Oswald-Light.eot",
	"html/fonts/Oswald-Light.svg",
	"html/fonts/Oswald-Light.ttf",
	"html/fonts/Oswald-Light.woff",
	"html/fonts/Oswald-Light.woff2",
	"html/fonts/Oswald-Regular.eot",
	"html/fonts/Oswald-Regular.svg",
	"html/fonts/Oswald-Regular.ttf",
	"html/fonts/Oswald-Regular.woff",
	"html/fonts/Oswald-Regular.woff2",
	"html/images/speedcircle.png",
}

client_script "client.lua"
