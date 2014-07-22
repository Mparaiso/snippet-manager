test: coffee tests
	@npm test &
ct: coffee tests
	@npm run ct &
commit:
	@git add .
	@git commit -am"$(message) `date`" | :
deploy: views coffee commit
	@git push origin master
heroku: views coffee commit
	@git push heroku master
start:
	@clear
	@supervisor  -e 'js|coffee'  --ignore node_modules server.js &
cluster:
	@clear
	@supervisor  -e 'js|coffee'  --ignore node_modules cluster.js &
.PHONY: start
