web: bundle exec puma -t 5:5 -p ${PORT:-9292} -e ${RACK_ENV:-production}
worker: bundle exec shoryuken -q foodegrient -r ./workers/image_worker.rb