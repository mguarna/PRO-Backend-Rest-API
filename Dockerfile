FROM python:3.12-alpine
#FROM python:3.9-alpine3.13

LABEL maintainer="matidev"

# * ensure Python output is sent directly to the terminal without buffering
ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# * app will cotain our Django app
COPY ./app  /app
WORKDIR /app

# * Expose this port from the container to our machine
EXPOSE 8000

# * This can be override through Dockerfile
ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# * Updates the environment variable inside the image
# * This way when we run a command we don't have to provide the entire path to our venv folder
ENV PATH="/py/bin:$PATH"

USER django-user