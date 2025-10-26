from pydantic import BaseModel, Field, field_validator
from enum import Enum
from typing import Optional
from datetime import date

class CardType(str, Enum):
    CREDIT = "credit"
    DEBIT = "debit"

class CardBase(BaseModel):
    holder_name: str = Field(min_length=2, max_length=100)
    card_type: CardType
    expiry_date: date

    @field_validator('holder_name')
    @classmethod
    def name_length(cls, v):
        if not (2 <= len(v) <= 100):
            raise ValueError('holder_name deve ter entre 2 e 100 caracteres')
        return v

class CardCreate(CardBase):
    pass

class CardUpdate(BaseModel):
    holder_name: Optional[str] = Field(min_length=2, max_length=100, default=None)
    expiry_date: Optional[date] = None

    @field_validator('holder_name')
    @classmethod
    def name_length(cls, v):
        if v is not None and not (2 <= len(v) <= 100):
            raise ValueError('holder_name deve ter entre 2 e 100 caracteres')
        return v

class Card(CardBase):
    card_number: str
    cvv: str
    token: Optional[str] = None

class TransactionRequest(BaseModel):
    token: str
    amount: float = Field(gt=0)
    merchant: str = Field(min_length=2, max_length=100)

    @field_validator('merchant')
    @classmethod
    def merchant_length(cls, v):
        if not (2 <= len(v) <= 100):
            raise ValueError('merchant deve ter entre 2 e 100 caracteres')
        return v

class TransactionResponse(BaseModel):
    success: bool
    message: str
    transaction_id: Optional[str] = None