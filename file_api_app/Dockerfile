FROM python:3.12-slim

WORKDIR /app

#Prevents Python from generating .pyc bytecode files.
#Avoids creating __pycache__ directories.
#Reduces unnecessary file writes inside the container.
#Does not prevent Python from compiling code in memory.

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY requirements.txt .

#Supressed root user package installation warning
#Does not impact package instalation and later run with non-root user
#Non-root user does not need to own them
RUN pip install \
    --root-user-action=ignore \
    --no-cache-dir \
    -r requirements.txt

# Create non-root user
RUN useradd --create-home appuser

# Copy application files with correct ownership
COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]