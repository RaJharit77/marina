from flask import Flask, request, jsonify # type: ignore
import subprocess
import shlex

app = Flask(__name__)

@app.route('/marina', methods=['POST'])
def solve_sat():
    data = request.get_json()
    if not data or 'prop' not in data:
        return jsonify({"error": "Missing 'prop' in JSON body"}), 400
    
    prop_str = data['prop']
    try:
        result = subprocess.run(
            ['./marina', shlex.quote(prop_str)],
            capture_output=True,
            text=True,
            check=True
        )
        return jsonify({
            "assignment": result.stdout.strip(),
            "error": None
        })
    except subprocess.CalledProcessError as e:
        return jsonify({
            "assignment": None,
            "error": f"SAT solver error: {e.stderr}"
        }), 500

@app.route('/')
def health_check():
    return "Hello, I'm Flask! SAT solver service is operational. Use POST /marina with {\"prop\": \"your_formula\"}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)