FROM ocaml/opam:ubuntu-22.04-ocaml-4.14

# Install dependencies
RUN sudo apt-get update && \
    sudo apt-get install -y python3-pip python3-venv

# Configure project
WORKDIR /app
COPY . .

# Build OCaml project
RUN opam install ocamlfind ounit2 && \
    make

# Set up Python environment
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install flask gunicorn

ENV FLASK_APP=app.py

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]