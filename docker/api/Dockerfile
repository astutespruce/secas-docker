# Provides: Southeast and SSA API and Background Worker image

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.10.3

LABEL org.opencontainers.image.source="https://github.com/astutespruce/secas-docker"

WORKDIR /home/app

ENV PYTHONPATH "${PYTHONPATH}:/home/app"
ENV PYTHONUNBUFFERED 1
ENV DISPLAY :99
ENV LIBGL_ALWAYS_SOFTWARE 1
ENV VIRTUAL_ENV "/home/app/.venv"
ENV PATH "/home/app/.venv/bin:/root/.local/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    # git \
    build-essential \
    python3-dev \
    # dependencies for Weasyprint
    fontconfig \
    libcairo2 \
    libcairo-gobject2 \
    libpango1.0 \
    # runtime dependencies for pymgl (x11-utils for xdpyinfo and xvfb to run frameserver)
    libegl1 \
    x11-utils \
    xvfb && \
    # remove all pre-installed pip packages to avoid conflicts
    rm -rf /usr/lib/python3/dist-packages && \
    # use uv for much faster pip installs
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv venv /home/app/.venv && \
    . /home/app/.venv/bin/activate && \
    # cleanup
    apt-get remove -y curl && \
    rm -rf "/var/lib/apt/lists/*"

# Note: we are not able to use a user here because we have to mount a volume
# for sharing between containers, which can only be done as root.
# 1010 corresponds to uid for app user on staging / production
RUN groupadd --gid 1010 app \
    && useradd --uid 1010 --gid app --shell /bin/bash --create-home app

# install fonts used in report
COPY ./fonts/*.ttf /usr/share/fonts/google/
RUN  fc-cache -fv

# setup python dependencies
COPY ./secas-blueprint-requirements.txt /tmp/
COPY ./secas-ssa-requirements.txt /tmp/

# make sure to build pyogrio and rasterio against GDAL in this container
RUN uv pip install cython numpy setuptools versioneer  && \
    uv pip install -v -r /tmp/secas-blueprint-requirements.txt --no-binary pyogrio rasterio --no-build-isolation && \
    uv pip install -v -r /tmp/secas-ssa-requirements.txt && \
    uv pip uninstall setuptools cython versioneer

# Fix location for hardcoded certs file in different location on manylinux image for pymgl
RUN mkdir -p /etc/pki/tls/certs && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

COPY ./run_xvfb.sh /home/app/
RUN chmod a+x /home/app/run_xvfb.sh

