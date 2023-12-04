FROM python:3.9-slim-buster

# Para evitar que aparezcan dialogos interactivos
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/src/app

COPY . .

RUN pip install -r requirements.txt

RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]