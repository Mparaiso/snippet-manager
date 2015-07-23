# move app to VCS

commit:

	git add . 
	git commit -am"update" 
	git push github master --tags

# deploy the app

deploy:

	git add. 
	git commit -am"update before deploy" 
	git push origin master -f

# test php app

test:

	phpunit
