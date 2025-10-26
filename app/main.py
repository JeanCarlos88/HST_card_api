from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
import logging
from datetime import datetime, timedelta

from .models import CardCreate, CardUpdate, TransactionRequest, TransactionResponse
from .services import card_service
from .auth import (
    Token, User, authenticate_user, create_access_token,
    get_current_active_user, fake_users_db, ACCESS_TOKEN_EXPIRE_MINUTES
)

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

@app.post("/token", tags=["auth"])
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()) -> Token:
    """
    OAuth2 compatible token login, get an access token for future requests.
    """
    user = authenticate_user(fake_users_db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return Token(access_token=access_token, token_type="bearer")

@app.post("/cards/issue", tags=["cards"])
async def issue_card(
    card_data: CardCreate,
    current_user: User = Depends(get_current_active_user)
):
    """
    Issue a new card with the provided details.
    """
    logger.info(f"Issuing new {card_data.card_type} card for {card_data.holder_name}")
    card = card_service.create_card(card_data)
    logger.info(f"Card issued successfully: {card.card_number}")
    return card

@app.post("/cards/{card_number}/tokenize", tags=["cards"])
async def tokenize_card(
    card_number: str,
    current_user: User = Depends(get_current_active_user)
):
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
async def authenticate_transaction(
    transaction: TransactionRequest,
    current_user: User = Depends(get_current_active_user)
) -> TransactionResponse:
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

@app.patch("/cards/{card_number}", tags=["cards"])
async def update_card(
    card_number: str,
    update_data: CardUpdate,
    current_user: User = Depends(get_current_active_user)
):
    """
    Update a card's information.
    """
    logger.info(f"Updating card: {card_number}")
    updated_card = card_service.update_card(card_number, update_data.dict(exclude_unset=True))
    if not updated_card:
        logger.error(f"Card not found: {card_number}")
        raise HTTPException(status_code=404, detail="Card not found")
    
    logger.info(f"Card updated successfully: {card_number}")
    return updated_card

@app.delete("/cards/{card_number}", tags=["cards"])
async def delete_card(
    card_number: str,
    current_user: User = Depends(get_current_active_user)
):
    """
    Delete a card by its number.
    """
    logger.info(f"Deleting card: {card_number}")
    if card_service.delete_card(card_number):
        logger.info(f"Card deleted successfully: {card_number}")
        return {"message": "Card deleted successfully"}
    else:
        logger.error(f"Card not found: {card_number}")
        raise HTTPException(status_code=404, detail="Card not found")

@app.get("/health", tags=["health"])
async def health_check():
    """
    Health check endpoint.
    """
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}