server:
	NODE_ENV=development supervisor --no-restart-on error -- app.js 8765

clean:
	find . -name '*~' -exec rm {} ';'

.PHONY: clean
