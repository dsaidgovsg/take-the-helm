########################
# Base Image
########################

FROM python:3.10-slim-buster as take-the-helm-base-image

ARG DEPENDENCY_GROUPS="default"

    # python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_PRE=1 \
    \
    # poetry
    POETRY_VERSION=1.2.0b1 \
    POETRY_NO_INTERACTION=1 \
    \
    # paths
    WORKDIR_PATH=/take-the-helm \
    VENV_PATH=/venv \
    \
    # runtime
    PORT=8000

WORKDIR $WORKDIR_PATH

########################
# Build Image
########################

FROM take-the-helm-base-image as take-the-helm-build-image

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install "poetry==$POETRY_VERSION" \
    && python3 -m venv $VENV_PATH

COPY poetry.lock pyproject.toml ./
RUN . $VENV_PATH/bin/activate && poetry install --no-root --with $DEPENDENCY_GROUPS

#######################
# Runtime Image
#######################

FROM take-the-helm-base-image as take-the-helm-runtime-image

ENV PATH="$VENV_PATH/bin:$PATH"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY --from=take-the-helm-build-image $WORKDIR_PATH/poetry.lock poetry.lock
COPY --from=take-the-helm-build-image $WORKDIR_PATH/pyproject.toml pyproject.toml
COPY --from=take-the-helm-build-image $VENV_PATH $VENV_PATH

RUN groupadd -r helm && useradd -r -s /bin/false -g helm helm \
    && chown -R helm:helm $WORKDIR_PATH
USER helm

COPY take_the_helm/ take_the_helm/

EXPOSE $PORT
CMD ["uvicorn", "--reload", "--host=0.0.0.0", "--port=8000", "take_the_helm.main:app"]
