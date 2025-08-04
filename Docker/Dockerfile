FROM ocaml/opam:ubuntu-22.04-ocaml-4.14

# Installer les dépendances système
RUN sudo apt-get update && \
    sudo apt-get install -y python3-pip python3-venv

# Configurer le projet
WORKDIR /app
COPY . .

# Configurer l'environnement OPAM et compiler
RUN opam init -a --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    eval $(opam env) && \
    make

# Configurer l'environnement Python
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install flask gunicorn

ENV FLASK_APP=app.py

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]