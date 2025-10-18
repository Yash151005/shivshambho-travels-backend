from django.db import models

class Booking(models.Model):
    """
    Model to store bus booking information
    """
    GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Other', 'Other'),
    ]

    date = models.CharField(max_length=100)
    trip = models.CharField(max_length=200)
    seat_number = models.IntegerField()
    passenger_name = models.CharField(max_length=200)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES)
    phone_number = models.CharField(max_length=15)
    from_location = models.CharField(max_length=100)
    to_location = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        unique_together = ['date', 'trip', 'seat_number']

    def __str__(self):
        return f"{self.passenger_name} - Seat {self.seat_number} ({self.trip} - {self.date})"
