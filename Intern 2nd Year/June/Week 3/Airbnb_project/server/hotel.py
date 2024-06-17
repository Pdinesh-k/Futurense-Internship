from flask import Blueprint, request, jsonify
from models import db, Property, Booking
from flask_jwt_extended import jwt_required, get_jwt_identity

hotel_blueprint = Blueprint('hotel', __name__)

@hotel_blueprint.route('/properties', methods=['POST'])
@jwt_required()
def post_property():
    data = request.json
    user_id = get_jwt_identity()
    title = data.get('title')
    description = data.get('description')
    price = data.get('price')

    new_property = Property(user_id=user_id, title=title, description=description, price=price)
    db.session.add(new_property)
    db.session.commit()

    return jsonify({'message': 'Property posted successfully.'}), 201

@hotel_blueprint.route('/bookings', methods=['POST'])
@jwt_required()
def book_property():
    data = request.json
    property_id = data.get('property_id')
    user_id = get_jwt_identity()
    check_in = data.get('check_in')
    check_out = data.get('check_out')

    new_booking = Booking(property_id=property_id, user_id=user_id, check_in=check_in, check_out=check_out)
    db.session.add(new_booking)
    db.session.commit()

    return jsonify({'message': 'Booking successful.'}), 201

@hotel_blueprint.route('/mybookings', methods=['GET'])
@jwt_required()
def my_bookings():
    user_id = get_jwt_identity()
    bookings = Booking.query.filter_by(user_id=user_id).all()
    result = [
        {
            'property_id': booking.property_id,
            'check_in': booking.check_in,
            'check_out': booking.check_out
        } for booking in bookings
    ]
    return jsonify(result), 200
