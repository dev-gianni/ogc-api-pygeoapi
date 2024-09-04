# Start from ubuntu
FROM geopython/pygeoapi:0.17.0

# Update repos and install dependencies
RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install build-essential libsqlite3-dev zlib1g-dev

# Create a directory and copy in all files
RUN mkdir -p /tmp/tippecanoe-src
WORKDIR /tmp/tippecanoe-src
COPY ./tippecanoe /tmp/tippecanoe-src

# Build tippecanoe
RUN make \
  && make install

# De tiles genereren voor 1 van de datasets
RUN tippecanoe -r1 -pk -pf --output-to-directory=/pygeoapi/tests/data/ --force --maximum-zoom=10 \
  --extend-zooms-if-still-dropping --no-tile-compression /pygeoapi/tests/data/ne_110m_lakes.geojson

# Expose pygeoapi port
EXPOSE 80
