.PHONY: activate

activate: py_env/bin/activate
	@bash --rcfile "$(CURDIR)/py_env/bin/activate" -i
