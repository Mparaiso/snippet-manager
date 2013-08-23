# move app to VCS

github:
	git add .
	git commit -am"update"
	git push github --all

# deploy the app

deploy:
	git add.
	git commit -am"update before deploy"
	git push origin 

# test php app

test-php:
	phpunit