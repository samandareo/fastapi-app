from collections.abc import Generator  # Keep this as get_db still uses it
from typing import Any

from fastapi import Depends, FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel
from sqlalchemy.orm import Session

import models
from database import Base, SessionLocal, engine

app = FastAPI()

Base.metadata.create_all(bind=engine)

templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")


class StockRequest(BaseModel):
    symbols: str  # Comma or newline separated symbols


def get_db() -> Generator[Session, None, None]:
    try:
        db = SessionLocal()
        yield db
    finally:
        db.close()


@app.get("/", response_class=HTMLResponse)
def home(request: Request, db: Session = Depends(get_db)) -> HTMLResponse:
    stocks = db.query(models.Stock).all()
    return templates.TemplateResponse(
        "home.html",
        {
            "request": request,
            "stocks": stocks,
        },
    )


@app.post("/stocks")
def add_stocks(payload: StockRequest, db: Session = Depends(get_db)) -> dict[str, Any]:
    # Parse symbols (split by comma and newline)
    symbols_list = [s.strip().upper() for s in payload.symbols.replace("\n", ",").split(",") if s.strip()]

    added = []
    for symbol in symbols_list:
        # Check if exists
        exists = db.query(models.Stock).filter(models.Stock.symbol == symbol).first()
        if not exists:
            # Create a mock stock for demo purposes
            stock = models.Stock(
                symbol=symbol,
                price=100.00,  # placeholder
                forward_pe=15.0,  # placeholder
                forward_eps=2.5,  # placeholder
            )
            db.add(stock)
            added.append(symbol)

    db.commit()
    return {"message": f"Added {len(added)} stocks", "symbols": added}
