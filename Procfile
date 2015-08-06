web: bin/bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0 -e ${RACK_ENV:-development} 

# http://stackoverflow.com/questions/307503/whats-the-best-way-to-check-that-environment-variables-are-set-in-unix-shellscr

worker: QUEUE=* TERM_CHILD=1 REQUE_TERM_TIMEOUT=8 COUNT=4 bin/bundle exec rake resque:work 
