# Base Image
FROM ubuntu:18.04 as base

# set working directory
WORKDIR /news

# set default environment variables
ENV PYTHONUNBUFFERED 1
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install Ubuntu dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        libopencv-dev \
        build-essential \
        libssl-dev \
        libpq-dev \
        libcurl4-gnutls-dev \
        libexpat1-dev \
        gettext \
        unzip \
        python3-setuptools \
        python3-pip \
        python3-dev \
        python3-venv \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install environment dependencies
RUN pip3 install --upgrade pip

# Install project dependencies
COPY ./requirements.txt /news/
RUN pip install -r requirements.txt

# copy project to working dir
COPY . /news

CMD gunicorn core.wsgi:application --bind 0.0.0.0:$PORT