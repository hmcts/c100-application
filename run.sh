#!/bin/sh

set -o errexit
set -o nounset

cd /usr/src/app 2> /dev/null

bundle exec rake db:create db:migrate
bundle exec pumactl -F config/puma.rb start
