FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install Flask

COPY calculator.py .

EXPOSE 8080

CMD ["gunicorn", "-b", "0.0.0.0:8080", "calculator:app"]

