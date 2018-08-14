FROM python:3.7-alpine3.8

RUN apk add --no-cache \
    bash \
    build-base \
    cyrus-sasl-dev \
    graphviz \
    ttf-ubuntu-font-family \
    jpeg-dev \
    libpng-dev \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    openldap-dev \
    postgresql-dev \
    libpq \
    libssl1.0 \
    wget

RUN pip install \
# gunicorn is used for launching netbox
    gunicorn \
# napalm is used for gathering information from network devices
    napalm \
# ruamel is used in startup_scripts
    ruamel.yaml \
# we want ldap in production      
    django-auth-ldap \
    django-rq


WORKDIR /opt

ARG BRANCH=master
ARG URL=https://github.com/digitalocean/netbox/archive/$BRANCH.tar.gz
RUN wget -q -O - "${URL}" | tar xz \
    && mv netbox* netbox

WORKDIR /opt/netbox
RUN pip install -r requirements.txt

COPY docker/configuration.docker.py /opt/netbox/netbox/netbox/configuration.py
COPY docker/ldap_config.docker.py /opt/netbox/netbox/netbox/ldap_config.py
COPY configuration/ /etc/netbox/config/
COPY startup_scripts/ /opt/netbox/startup_scripts/
COPY initializers/ /opt/netbox/initializers/
COPY docker/nginx.conf /etc/netbox-nginx/nginx.conf
COPY docker/docker-entrypoint.sh docker-entrypoint.sh

WORKDIR /opt/netbox/netbox

ENTRYPOINT [ "/opt/netbox/docker-entrypoint.sh" ]

VOLUME ["/etc/netbox-nginx/"]

CMD ["gunicorn", "-c /etc/netbox/config/gunicorn_config.py", "netbox.wsgi"]

LABEL SRC_URL="$URL"

ARG NETBOX_DOCKER_PROJECT_VERSION=snapshot
LABEL NETBOX_DOCKER_PROJECT_VERSION="$NETBOX_DOCKER_PROJECT_VERSION"
