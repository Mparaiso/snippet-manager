test: coffee tests
	@npm test &
ct: coffee tests
	@npm run ct &
commit:
	@git add .
	@git commit -am"$(message) `date`" | :
deploy: views coffee commit
	@git push origin master
start:
	@supervisor  -e 'js|coffee'  --ignore node_modules server.js &
.PHONY: start
