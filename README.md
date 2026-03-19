# FastAPI Jinja SQLAlchemy SQLite3 Template

This is a reusable template for FastAPI microservices, configured with robust code quality tools, security scanning, and containerization standards.

## 🛠️ Features
- **FastAPI** with **Jinja2** templates and **SQLAlchemy** (SQLite).
- **Pre-commit Hooks**:
  - **Linting & Formatting**: Ruff (includes isort).
  - **Static Type Checking**: Mypy.
  - **Security**: Gitleaks (secrets), pip-audit (vulnerabilities).
  - **SQL Linting**: SQLFluff.
  - **Spell Checking**: typos.
  - **Git Hygiene**: trailing whitespace, end of file fixer, large files checks.
- **Commit Standards**: `commitlint` for Conventional Commits.
- **Docker**: Multi-stage, slim, non-root production-ready build.
- **CI/CD**: GitHub Actions workflow running tests and lints.

---

## 🚀 Getting Started

### 1. Prerequisites
- Python 3.11+
- Node.js (for commitlint)
- Docker (optional, for containerization)

### 2. Setup
Clone the repository, create a virtual environment, and install dependencies:

```bash
python -m venv venv
# On Windows:
# .\venv\Scripts\activate
# On Linux/macOS:
# source venv/bin/activate

# Install dependencies and setup pre-commit
make install
```

---

## 💻 Developer Workflow

Use the `Makefile` to automate common tasks:

| Command | Description |
| :--- | :--- |
| `make install` | Install `requirements.txt` + `requirements-dev.txt` and install pre-commit hooks |
| `make lint` | Run `ruff` and `mypy` type checking |
| `make format` | Run `ruff` auto-formatter and fixer |
| `make test` | Run `pytest` suite |
| `make run` | Starts the app with reload (`uvicorn main:app --reload`) |
| `make docker-build`| Build the production Docker image |
| `make clean` | Remove caches and temporary files |

### 🔍 Running Hooks Manually
To run all pre-commit hooks on all files:
```bash
pre-commit run --all-files
```

---

## 📝 Commit Standards

We enforce **Conventional Commits**. Setup hooks ensure commit messages follow the structure:
`<type>[optional scope]: <description>`

**Allowed Types:**
- `feat`: A new feature
- `fix`: A bug fix
- `chore`: Maintenance tasks, dependencies
- `docs`: Documentation changes
- `refactor`: Code changes that neither fix a bug nor add a feature

**Example:**
`feat: add user authentication endpoint`

---

## 🐳 Docker Usage

To build and run the application in a containerized environment:

### Build Image
```bash
make docker-build
```

### Run Container
```bash
docker run -p 8000:8000 fastapi-template
```
The app will be accessible at `http://localhost:8000`.

---

## 📂 Project Structure
```text
.
├── .github/workflows/ci.yml    # CI/CD Workflow
├── static/                     # Static files (CSS, JS)
├── templates/                  # Jinja2 templates
├── tests/                      # Pytest test suite
├── .dockerignore               # Docker ignore list
├── .pre-commit-config.yaml     # Pre-commit hooks definition
├── .sqlfluff                   # SQLFluff configuration
├── commitlint.config.js        # Commit standards configuration
├── Dockerfile                  # Multi-stage production Dockerfile
├── Makefile                    # Developer experience commands
├── pyproject.toml              # Ruff & Mypy configurations
├── requirements.txt            # App dependencies
├── requirements-dev.txt        # Dev dependencies
└── main.py                     # Entrypoint
```
