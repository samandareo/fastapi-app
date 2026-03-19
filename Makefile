.PHONY: install lint format test run docker-build clean

PYTHON = python
PIP = pip

install:
	$(PIP) install -r requirements.txt -r requirements-dev.txt
	pre-commit install
	pre-commit install --hook-type commit-msg

lint:
	ruff check .
	mypy .

format:
	ruff check --fix .
	ruff format .

test:
	pytest

run:
	uvicorn main:app --reload

docker-build:
	docker build -t fastapi-template .

clean:
	rm -rf .venv __pycache__ .mypy_cache .ruff_cache .pytest_cache
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.py[co]" -delete
