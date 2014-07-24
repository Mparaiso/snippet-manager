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
push: commit
	@git push origin master
start:
	@clear
	@supervisor  -e 'js|coffee'  --ignore 'node_modules,trash,.openshift,.settings,.git,assets,public,views' server
	.js &
cluster:
	@clear
	@supervisor  -e 'js|coffee'  --ignore 'node_modules|trash|.openshift|.settings|.git|assets|public|views' cluster
	.js &
.PHONY: start
