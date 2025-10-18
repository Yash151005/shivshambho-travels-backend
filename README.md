# Bus Booking Backend

Django REST Framework API for bus booking system.

## Quick Start

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac

# Install dependencies
pip install -r requirements.txt

# Configure database
# Copy .env.example to .env and fill in Supabase credentials

# Run migrations
python manage.py makemigrations
python manage.py migrate

# Create superuser (optional)
python manage.py createsuperuser

# Start server
python manage.py runserver 0.0.0.0:8000
```

## Admin Panel

Access at: http://localhost:8000/admin

## API Documentation

- GET /api/bookings/ - List bookings
- POST /api/bookings/ - Create booking
- GET /api/bookings/history/ - All bookings
- DELETE /api/bookings/delete-all/ - Delete all
