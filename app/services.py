import uuid
import hashlib
import random
from datetime import date, datetime, timedelta
from typing import Dict, Optional

from .models import Card, CardCreate, CardType

class CardService:
    def __init__(self):
        self.cards: Dict[str, Card] = {}  # card_number -> Card
        self.tokens: Dict[str, str] = {}  # token -> card_number

    def _generate_card_number(self) -> str:
        # Generate a simple 16-digit card number (for demonstration purposes)
        return ''.join([str(random.randint(0, 9)) for _ in range(16)])

    def _generate_cvv(self) -> str:
        # Generate a 3-digit CVV
        return ''.join([str(random.randint(0, 9)) for _ in range(3)])

    def create_card(self, card_data: CardCreate) -> Card:
        # Create a new card with generated number and CVV
        card = Card(
            holder_name=card_data.holder_name,
            card_type=card_data.card_type,
            expiry_date=card_data.expiry_date,
            card_number=self._generate_card_number(),
            cvv=self._generate_cvv()
        )
        self.cards[card.card_number] = card
        return card

    def tokenize_card(self, card_number: str) -> Optional[str]:
        if card_number not in self.cards:
            return None
        
        # Generate a unique token using UUID and hash it
        token_base = str(uuid.uuid4())
        token = hashlib.sha256(token_base.encode()).hexdigest()
        
        # Store the token mapping and update the card
        self.tokens[token] = card_number
        self.cards[card_number].token = token
        
        return token

    def validate_transaction(self, token: str, amount: float) -> tuple[bool, str, Optional[str]]:
        if token not in self.tokens:
            return False, "Invalid token", None

        card_number = self.tokens[token]
        card = self.cards[card_number]

        # Check if card is expired
        if card.expiry_date < date.today():
            return False, "Card expired", None

        # Generate a transaction ID for successful transactions
        transaction_id = str(uuid.uuid4())
        
        return True, "Transaction successful", transaction_id

# Create a global instance of CardService
card_service = CardService()