# Provides: Southeast and SSA API and Background Worker image

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.8.5

LABEL org.opencontainers.image.source="https://github.com/astutespruce/secas-docker"

RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    # dependencies for Weasyprint
    fontconfig \
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

RUN useradd --create-home app
WORKDIR /home/app
# Note: we are not able to use a user here because we have to mount a volume
# for sharing between containers, which can only be done as root.

ENV PYTHONPATH="${PYTHONPATH}:/home/app"
ENV PYTHONUNBUFFERED 1
ENV DISPLAY :99

# install fonts used in report
COPY ./fonts/*.ttf /usr/share/fonts/google
RUN  fc-cache -fv

COPY ./run_xvfb.sh /home/app/
RUN chmod a+x /home/app/run_xvfb.sh


# Setup Python dependencies used by API and background worker
COPY ./*requirements.txt /tmp/

# Uninstall existing numpy first so we can upgrade it and pin specific version
RUN rm -rf /usr/lib/python3/dist-packages/numpy* && \
    # use uv for much faster pip installs
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    # source the file to make uv available
    . $HOME/.cargo/env && \
    uv pip install --system -r /tmp/install_requirements.txt && \
    uv pip install --system --no-binary  ":all:" --no-build-isolation -r /tmp/binary_requirements.txt && \
    # install geopandas without dependencies to prevent installing Fiona
    uv pip install --system geopandas==0.14.0 --no-deps && \
    uv pip install --system -r /tmp/requirements.txt && \
    # pymgl is only available for Ubuntu, not manylinux, so we need to specify URL with version
    curl -L https://github.com/brendan-ward/pymgl/releases/download/v0.4.0/pymgl-0.4.0-cp310-cp310-linux_aarch64.whl.ubuntu-22.04 --output /tmp/pymgl-0.4.0-cp310-cp310-linux_aarch64.whl && \
    uv pip install --system /tmp/pymgl-0.4.0-cp310-cp310-linux_aarch64.whl

# Cleanup
RUN apt-get remove -y curl && \
    rm -rf "/var/lib/apt/lists/*"

