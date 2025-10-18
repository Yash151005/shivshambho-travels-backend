from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.db.models import Q
from .models import Booking
from .serializers import BookingSerializer

class BookingViewSet(viewsets.ModelViewSet):
    """
    ViewSet for handling bus booking operations
    """
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

    def get_queryset(self):
        """
        Filter bookings by date and trip if provided in query params
        """
        queryset = Booking.objects.all()
        date = self.request.query_params.get('date', None)
        trip = self.request.query_params.get('trip', None)

        if date and trip:
            queryset = queryset.filter(date=date, trip=trip)
        elif date:
            queryset = queryset.filter(date=date)
        elif trip:
            queryset = queryset.filter(trip=trip)

        return queryset

    @action(detail=False, methods=['get'])
    def history(self, request):
        """
        Get all booking history
        """
        bookings = Booking.objects.all().order_by('-created_at')
        serializer = self.get_serializer(bookings, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['delete'])
    def delete_all(self, request):
        """
        Delete all bookings (use with caution!)
        """
        count = Booking.objects.count()
        Booking.objects.all().delete()
        return Response(
            {'message': f'{count} bookings deleted successfully'},
            status=status.HTTP_200_OK
        )

    @action(detail=False, methods=['get'])
    def search(self, request):
        """
        Search bookings by passenger name, phone, or seat number
        """
        query = request.query_params.get('q', '')
        if not query:
            return Response({'error': 'Search query parameter "q" is required'}, 
                          status=status.HTTP_400_BAD_REQUEST)

        bookings = Booking.objects.filter(
            Q(passenger_name__icontains=query) |
            Q(phone_number__icontains=query) |
            Q(seat_number__icontains=query)
        )
        
        serializer = self.get_serializer(bookings, many=True)
        return Response(serializer.data)
