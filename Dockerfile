FROM ocaml/opam:ubuntu-22.04-ocaml-4.14

# Installer dépendances système
RUN sudo apt-get update && \
    sudo apt-get install -y python3 python3-pip python3-venv make

# Répertoire de travail
WORKDIR /app

# Copier les fichiers
COPY . .

# Compiler l'application OCaml
RUN opam init -a --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    eval $(opam env) && \
    make

# Rendre le binaire exécutable
RUN chmod +x ./marina

# Installer Flask + Gunicorn de manière fiable
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install flask gunicorn

# Définir les variables d'environnement
ENV FLASK_APP=server.py
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

# Commande de démarrage
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server:app"]
