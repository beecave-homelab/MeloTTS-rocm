FROM python:3.9-slim
WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app
RUN pip install -r requirements.txt --no-cache-dir

COPY requirements-rocm.txt /app
RUN pip install --force-reinstall -r requirements-rocm.txt --no-cache-dir

COPY melo /app/melo

RUN python -m unidic download
RUN python -m melo.init_downloads
RUN python -m nltk.downloader averaged_perceptron_tagger
RUN python -m nltk.downloader averaged_perceptron_tagger_eng

CMD ["python", "-m", "melo.app", "--host", "0.0.0.0", "--port", "8888"]
