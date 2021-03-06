# from ubuntu (includes python3)
FROM ubuntu:18.04

# Install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    # build essentials
    build-essential locales \
    # python3
    python3 python3-pip python3-dev\
    # python-psycopg2
    libpq-dev \
    # pysam
    zlib1g-dev libbz2-dev liblzma-dev \
    # ldap
    libldap2-dev libsasl2-dev ldap-utils python-tox lcov valgrind \
    # other
    curl

# set locale (pip ascii issue with some packages)
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install pipenv
RUN pip3 install pipenv==2020.6.2
ENV PIPENV_VENV_IN_PROJECT=1

WORKDIR /app

# Copy requiremets and install
# Runs both `pipenv install ...` and `npm ci`
COPY Pipfile Pipfile.lock \
    ./
RUN pipenv install --deploy --ignore-pipfile --dev

# Copy the working dirs
COPY stockfish_experiments stockfish_experiments
COPY manage.py ./

CMD pipenv run server
