# move app to VCS

commit:

	git add . \
	git commit -am"update" \
	git push github --all

# deploy the app

deploy:

	git add. \
	git commit -am"update before deploy" \
	git push origin 

# test php app

test:

	phpunit