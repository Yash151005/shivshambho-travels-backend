from django.contrib import admin
from .models import Booking

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = [
        'passenger_name',
        'seat_number',
        'trip',
        'date',
        'phone_number',
        'gender',
        'created_at'
    ]
    list_filter = ['date', 'trip', 'gender', 'created_at']
    search_fields = ['passenger_name', 'phone_number', 'seat_number']
    readonly_fields = ['created_at', 'updated_at']
    ordering = ['-created_at']
