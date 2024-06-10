from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://postgres.mdnugaskvkpelxzwgzje:%40bpXmmrR2XbFrZP@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres"

db.init_app(app)

class SupaUser(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True, nullable=False)
    email = db.Column(db.String)

@app.route("/")
def root():  # Changed function name for clarity
    return "Success"

@app.route("/users", methods=["POST"])
def add_user():
    try:
        data = request.get_json()
        username = data.get("username")
        email = data.get("email")

        if not username or not email:
            return jsonify({"error": "Missing username or email"}), 400
        new_user = SupaUser(username=username, email=email)
        db.session.add(new_user)
        db.session.commit()
        return jsonify({"message": "User Created Successfully", "user": new_user.serialize()}), 201
    except Exception as e:
        print("Error while adding user:", e)
        return jsonify({"error": "An error occurred"}), 500

@app.route("/users/<int:user_id>", methods=["PUT"])
def update_user(user_id):
    try:
        data = request.get_json()
        username = data.get("username")
        email = data.get("email")
        user = db.session.get(SupaUser, user_id)
        if not user:
            return jsonify({"error": f"User with ID {user_id} not found"}), 404
        if user:
            if username:
                user.username = username
            if email:
                user.email = email
            db.session.commit()
            return jsonify({"message": "User updated successfully", "user": user.serialize()}), 200
    except Exception as e:
        print(f"An error occurred while updating user: {e}")
        return jsonify({"error": "An error occurred"}), 500

@app.route("/users/<int:user_id>", methods=["DELETE"])
def delete_user(user_id):
    try:
        user = db.session.get(SupaUser, user_id)
        if not user:
            return jsonify({"error": f"User with ID {user_id} not found"}), 404
        if user:
            db.session.delete(user)
            db.session.commit()
        return jsonify({"message": "User deleted successfully"}), 204
    except Exception as e:
        print(f"An error occurred while deleting user: {e}")
        return jsonify({"error": "An error occurred"}), 500

def serialize(self):
    return {
        "id": self.id,
        "username": self.username,
        "email": self.email
    }

SupaUser.serialize = serialize

if __name__ == "__main__":
    app.run(debug=True)