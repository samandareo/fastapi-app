from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_read_home() -> None:
    response = client.get("/")
    assert response.status_code == 200
    # Templates might cause issues if not found, but they are in directory
    # Let's assume it renders or returns 200 if home.html exists.
