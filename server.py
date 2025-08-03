from flask import Flask, request, jsonify # type: ignore
import subprocess

app = Flask(__name__)

@app.route('/solve', methods=['POST'])
def solve():
    data = request.get_json()
    formula = data.get('formula')
    if not formula:
        return jsonify({"error": "Missing 'formula' in JSON"}), 400
    
    try:
        result = subprocess.run(
            ['marina', formula],
            capture_output=True,
            text=True,
            timeout=5
        )
        return jsonify({
            "assignment": result.stdout.strip(),
            "stderr": result.stderr.strip(),
            "status": result.returncode
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)