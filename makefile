deploy: views coffee
	@git add .
	@git commit -am"$(message) `date`"
	@git push origin master
start:
	@supervisor  -e 'js|coffee'  --ignore node_modules server.js &
.PHONY: start
