from flask import Flask, jsonify
from collections import defaultdict

app = Flask(__name__)

mem=defaultdict(lambda :"")
mem={"Tikku":"11", "aira":"play"}

@app.route('/members/<string:name>')
def member(name):
    return jsonify(mem[name]) 

@app.route('/')
def home():
    return "hey"
app.run(port=8000)