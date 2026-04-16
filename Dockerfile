FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    cmake \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv (pinned)
COPY --from=ghcr.io/astral-sh/uv:0.10.12 /uv /usr/local/bin/uv

# Install Rust (needed by setuptools-rust)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

COPY . .

# Reproducible install from uv.lock; excludes dev and extras groups
RUN uv sync --frozen --no-default-groups

ENV PATH="/app/.venv/bin:${PATH}"

CMD ["bash"]