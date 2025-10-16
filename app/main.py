from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import logging
from datetime import datetime

from .models import CardCreate, TransactionRequest, TransactionResponse
from .services import card_service

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="Card Management API",
    description="API for card issuance, tokenization, and transaction authentication",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/cards/issue", tags=["cards"])
async def issue_card(card_data: CardCreate):
    """
    Issue a new card with the provided details.
    """
    logger.info(f"Issuing new {card_data.card_type} card for {card_data.holder_name}")
    card = card_service.create_card(card_data)
    logger.info(f"Card issued successfully: {card.card_number}")
    return card

@app.post("/cards/{card_number}/tokenize", tags=["cards"])
async def tokenize_card(card_number: str):
    """
    Generate a token for the specified card number.
    """
    logger.info(f"Tokenizing card: {card_number}")
    token = card_service.tokenize_card(card_number)
    if not token:
        logger.error(f"Card not found: {card_number}")
        raise HTTPException(status_code=404, detail="Card not found")
    
    logger.info(f"Card tokenized successfully")
    return {"token": token}

@app.post("/transactions/authenticate", tags=["transactions"])
async def authenticate_transaction(transaction: TransactionRequest) -> TransactionResponse:
    """
    Authenticate a transaction using a card token.
    """
    logger.info(f"Processing transaction for merchant: {transaction.merchant}")
    success, message, transaction_id = card_service.validate_transaction(
        transaction.token,
        transaction.amount
    )
    
    logger.info(f"Transaction result: {message}")
    return TransactionResponse(
        success=success,
        message=message,
        transaction_id=transaction_id
    )

@app.get("/health", tags=["health"])
async def health_check():
    """
    Health check endpoint.
    """
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}