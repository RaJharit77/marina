# Étape 1 : image OCaml + python
FROM ocaml/opam:ubuntu-22.04-ocaml-4.14

# Installer dépendances système
RUN sudo apt-get update && \
    sudo apt-get install -y python3-pip python3-venv make

# Créer répertoire de travail
WORKDIR /app

# Copier les sources OCaml, Python, Makefile, etc.
COPY . .

# Initialiser et installer les packages OCaml nécessaires
RUN opam init -a --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    eval $(opam env) && \
    make

# Rendre le binaire exécutable
RUN chmod +x ./marina

# Installer les dépendances Python
RUN pip3 install flask gunicorn

# Exposer le port
EXPOSE 5000

# Définir les variables d'environnement
ENV FLASK_APP=server.py
ENV PYTHONUNBUFFERED=1

# Commande de démarrage
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server:app"]
