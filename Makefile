push:
	@cd learning_app; \
	flutter clean; \
	cd ..; \
	git add .; \
	read -p "Commit message: " MSG; \
	git commit -m "$$MSG"; \
	git push origin master;