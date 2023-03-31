# Provides: Southeast and SSA API and Background Worker image

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.6.3

RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    # dependencies for Weasyprint
    libcairo2 \
    libcairo-gobject2 \
    libpango1.0 \
    # dependencies for pymgl
    libicu70 \
    libjpeg-turbo8 \
    libpng16-16 \
    libprotobuf23 \
    libuv1 \
    libx11-6 \
    libegl1 \
    libopengl0 \
    xvfb \
    x11-utils

# Install fonts for both Southeast apps Raleway & Source Sans Pro
RUN mkdir /usr/share/fonts/google && \
    curl https://fonts.google.com/download?family=Raleway --output /tmp/Raleway.zip && \
    unzip -o /tmp/Raleway.zip -d /usr/share/fonts/google && \
    mv /usr/share/fonts/google/static/* /usr/share/fonts/google/ && \
    curl https://fonts.google.com/download?family=Source+Sans+Pro --output /tmp/SourceSansPro.zip && \
    unzip -o /tmp/SourceSansPro.zip -d /usr/share/fonts/google && \
    fc-cache -fv

RUN useradd --create-home app
WORKDIR /home/app
# Note: we are not able to use a user here because we have to mount a volume
# for sharing between containers, which can only be done as root.

ENV PYTHONPATH="${PYTHONPATH}:/home/app"
ENV PYTHONUNBUFFERED 1
ENV DISPLAY :99

COPY ./run_xvfb.sh /home/app/
RUN chmod a+x /home/app/run_xvfb.sh


# Setup Python dependencies used by API and background worker
COPY ./*requirements.txt /tmp/

# Uninstall existing numpy first so we can upgrade it and pin specific version
RUN rm -rf /usr/lib/python3/dist-packages/numpy* && \
    pip install --no-warn-script-location -r /tmp/install_requirements.txt && \
    pip install --no-warn-script-location --no-binary  ":all:" --no-build-isolation -r /tmp/binary_requirements.txt && \
    # install geopandas without dependencies to prevent installing Fiona
    pip install --no-warn-script-location geopandas==0.12.2 --no-deps && \
    pip install --no-warn-script-location -r /tmp/requirements.txt && \
    # pymgl is only available for Ubuntu, not manylinux, so we need to specify URL with version
    curl -L https://github.com/brendan-ward/pymgl/releases/download/v0.3.1/pymgl-0.3.1-cp310-cp310-linux_x86_64.whl.ubuntu-22.04 --output /tmp/pymgl-0.3.1-cp310-cp310-linux_x86_64.whl && \
    pip install --no-warn-script-location /tmp/pymgl-0.3.1-cp310-cp310-linux_x86_64.whl

# Cleanup
RUN apt-get remove -y curl && \
    rm -rf "/var/lib/apt/lists/*"