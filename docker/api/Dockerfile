# Provides: Southeast and South Atlantic API and Background Worker image

FROM osgeo/gdal:ubuntu-small-3.4.3

RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    # dependencies for Weasyprint
    libcairo2 \
    libcairo-gobject2 \
    libpango1.0 \
    # dependencies for pymgl
    libicu66 \
    libjpeg-turbo8 \
    libpng16-16 \
    libprotobuf17 \
    libuv1 \
    libx11-6 \
    libegl1 \
    libopengl0 \
    xvfb \
    x11-utils

# Install fonts for both South Atlantic and Southeast apps
# South Atlantic: Montserrat & Lora
# Southeast: Raleway & Source Sans Pro
RUN mkdir /usr/share/fonts/google && \
    curl https://fonts.google.com/download?family=Montserrat --output /tmp/Montserrat.zip && \
    unzip -o /tmp/Montserrat.zip -d /usr/share/fonts/google && \
    curl https://fonts.google.com/download?family=Lora --output /tmp/Lora.zip && \
    unzip -o /tmp/Lora.zip -d /usr/share/fonts/google && \
    curl https://fonts.google.com/download?family=Raleway --output /tmp/Raleway.zip && \
    unzip -o /tmp/Raleway.zip -d /usr/share/fonts/google && \
    mv /usr/share/fonts/google/static/* /usr/share/fonts/google/ && \
    curl https://fonts.google.com/download?family=Source+Sans+Pro --output /tmp/SourceSansPro.zip && \
    unzip -o /tmp/SourceSansPro.zip -d /usr/share/fonts/google && \
    fc-cache -fv

# Cleanup
RUN apt-get remove -y curl && \
    rm -rf "/var/lib/apt/lists/*"

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
# NOTE: these are the same between South Atlantic and Southeast
COPY ./*requirements.txt /tmp/

# Uninstall existing numpy first so we can upgrade it and pin specific version
RUN rm -rf /usr/lib/python3/dist-packages/numpy* && \
    pip3 install --no-warn-script-location -r /tmp/install_requirements.txt && \
    pip3 install --no-warn-script-location --no-binary  ":all:" --no-build-isolation -r /tmp/binary_requirements.txt && \
    pip3 install --no-warn-script-location -r /tmp/requirements.txt && \
    # pymgl is only available for Ubuntu, not manylinux, so we need to specify URL
    pip3 install --no-warn-script-location https://github.com/brendan-ward/pymgl/releases/download/v0.2.1/pymgl-0.2.1-cp38-cp38-linux_x86_64.whl


