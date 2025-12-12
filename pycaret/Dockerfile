FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gfortran libgomp1 libopenblas-dev \
    libfreetype6-dev libpng-dev fonts-dejavu-core \
	 wget \
  && rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/no-code-pycaret/*
RUN mkdir /usr/no-code-pycaret

WORKDIR /usr/no-code-pycaret

RUN wget https://raw.githubusercontent.com/aphrc-nocode/no-code-app/refs/heads/main/py/main.py
RUN wget https://raw.githubusercontent.com/aphrc-nocode/no-code-app/refs/heads/main/py/requirements.txt

# ---- Create writable directories ----
RUN mkdir -p /usr/no-code-pycaret/logs \
    /usr/no-code-pycaret/models

# ---- Define volumes ----
VOLUME ["/usr/no-code-pycaret/logs", \
        "/usr/no-code-pycaret/models"]

RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

EXPOSE 8000
CMD ["uvicorn","main:app","--host","0.0.0.0","--port","8000"]
