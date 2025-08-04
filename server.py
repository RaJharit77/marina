from flask import Flask, request, jsonify # type: ignore
import subprocess
import os

app = Flask(__name__)

# Obtenir le port de Render.com ou utiliser 5000 par défaut
port = int(os.environ.get("PORT", 5000))

@app.route('/marina', methods=['POST'])
def solve_sat():
    data = request.get_json()
    if not data or 'prop' not in data:
        return jsonify({"error": "Missing 'prop' in JSON body"}), 400
    
    prop_str = data['prop']
    try:
        # Exécuter le solveur SAT sans shlex.quote
        result = subprocess.run(
            ['./marina', prop_str],
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
    return "SAT solver service is operational. Use POST /marina with {\"prop\": \"your_formula\"}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)