from flask import Flask, jsonify
from config import Config
from models import db, bcrypt, migrate
from auth import auth_blueprint
from hotel import hotel_blueprint
from flask_jwt_extended import JWTManager

app = Flask(__name__)
app.config.from_object(Config)

db.init_app(app)
bcrypt.init_app(app)
migrate.init_app(app, db)
jwt = JWTManager(app)

# Register blueprints
app.register_blueprint(auth_blueprint, url_prefix='/auth')
app.register_blueprint(hotel_blueprint, url_prefix='/api')

@app.route("/")
def sample():
    return jsonify({"Message": " Hello from AirBnB"})

if __name__ == '__main__':
    app.run(debug=True)
