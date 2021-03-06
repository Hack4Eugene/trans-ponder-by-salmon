# To run from source: 
#    make install
#    make run 
# 
# Many recipes need to be run in the virtual environment, 
# so run them as $(INVENV) command
INVENV = . env/bin/activate ;

##
##  Virtual environment
##     
PYVENV = python3 -m venv
env:
	$(PYVENV)  env
	($(INVENV) pip install -r requirements.txt )

install:  env  credentials

# 'make run' runs the built-in Flask server.  Useful for debugging,
# but not suitable for long-running service.
#
credentials:  source/credentials.ini
source/credentials.ini:
	echo "You just install the database and credentials.ini for it"

run:	env credentials
	$(INVENV) cd source; python3 flask_main.py

# Loader utility to push data into the database
load:	env credentials
	$(INVENV) cd source/utility; python3 loadDB.py < data.txt

test:	env
	$(INVENV) cd meetings; nosetests

##
## Preserve virtual environment for git repository
## to duplicate it on other targets
##
dist:	env
	$(INVENV) pip freeze >requirements.txt

# 'clean' and 'veryclean' are typically used before checking 
# things into git.  'clean' should leave the project ready to 
# run, while 'veryclean' may leave project in a state that 
# requires re-running installation and configuration steps
# 
clean:
	cd source; rm -f *.pyc
	cd source; rm -rf __pycache__

veryclean:
	make clean
	rm -rf env

