web: bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0 -e ${RACK_ENV:-development} 

worker: env QUEUE=* TERM_CHILD=1 REQUE_TERM_TIMEOUT=8 COUNT=4 bundle exec rake resque:work
