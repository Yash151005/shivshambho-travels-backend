from rest_framework import serializers
from .models import Booking

class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = [
            'id',
            'date',
            'trip',
            'seat_number',
            'passenger_name',
            'gender',
            'phone_number',
            'from_location',
            'to_location',
            'created_at',
            'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']

    def validate(self, data):
        # Check if seat is already booked for the same date and trip
        if self.instance is None:  # Creating new booking
            existing = Booking.objects.filter(
                date=data.get('date'),
                trip=data.get('trip'),
                seat_number=data.get('seat_number')
            ).exists()
            
            if existing:
                raise serializers.ValidationError(
                    f"Seat {data.get('seat_number')} is already booked for this trip."
                )
        
        return data
