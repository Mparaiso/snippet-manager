test: coffee tests
	@npm test &
ct: coffee tests
	@npm run ct &
commit:
	@git add .
	@git commit -am"$(message) `date`" | :
push: commit
	@git push origin master
heroku: commit
	@git push heroku master
openshift: commit
	@git push openshift master
start:
	@clear
	@supervisor  -e 'js|coffee'  --ignore 'node_modules,trash,.openshift,.settings,.git,assets,public,views' server.js &
cluster:
	@clear
	@supervisor  -e 'js|coffee'  --ignore 'node_modules|trash|.openshift|.settings|.git|assets|public|views' cluster.js &
.PHONY: start push
