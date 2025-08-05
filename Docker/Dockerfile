# Utiliser la même image pour le build et l'exécution
FROM ocaml/opam:ubuntu-22.04-ocaml-4.14

# Installer les dépendances système
RUN sudo apt-get update && \
    sudo apt-get install -y python3-pip python3-venv

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers sources
COPY . .

# Construire l'application
RUN opam init -a --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    eval $(opam env) && \
    make

# Installer les dépendances Python
RUN pip install flask gunicorn

# Rendre le binaire exécutable
RUN chmod +x marina

ENV FLASK_APP=server.py

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server:app"]