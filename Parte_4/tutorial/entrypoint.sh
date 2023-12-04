#!/bin/sh
apt-get install python3-venv -y

python3 -m venv venv
. venv/bin/activate

export FLASK_APP=flaskr
export FLASK_ENV=development

if [ ! -f "/usr/src/app/instance/flaskr.sqlite" ]; then
    echo "Initializing database"
    flask init-db
fi

flask run --host=0.0.0.0
