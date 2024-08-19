# `python-base` sets up all our shared environment variables
FROM python:3.10.14-slim-bookworm

    # python
ENV PYTHONUNBUFFERED=1 \
    # prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # poetry
    # https://python-poetry.org/docs/configuration/#using-environment-variables
    # make poetry install to this location
    POETRY_HOME="/opt/poetry" \
    # make poetry create the virtual environment in the project's root
    # it gets named `.venv`
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    \
    # paths
    # this is where our requirements + virtual environment will live
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"


# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
RUN apt update
RUN ln -sf /usr/bin/dpkg /usr/sbin/dpkg
RUN ln -sf /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
RUN ln -sf /usr/bin/dpkg-split /usr/sbin/dpkg-split
RUN ln -sf /usr/bin/tar /usr/sbin/tar
RUN ln -sf /usr/bin/rm /usr/sbin/rm
RUN apt install -y apt-utils
RUN apt install -y apt-transport-https ca-certificates
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib"  > /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib" >> /etc/apt/sources.list

RUN apt update \
    && apt install -y ssh vim curl git build-essential

# install poetry - respects $POETRY_VERSION & $POETRY_HOME \
RUN curl -sSL https://install.python-poetry.org | python3 -