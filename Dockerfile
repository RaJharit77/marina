FROM ocaml/opam:ubuntu-22.04-ocaml-4.14

# Installer les dépendances système
RUN sudo apt-get update && \
    sudo apt-get install -y python3 python3-pip python3-venv make

# Définir le répertoire de travail
WORKDIR /app

# Copier tous les fichiers
COPY . .

# Construire le projet OCaml
RUN opam init -a --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    eval $(opam env) && \
    make

# Rendre le binaire OCaml exécutable
RUN chmod +x ./marina

# Vérifier que le binaire a été créé correctement
RUN ls -l ./marina && file ./marina

# Installer Flask et Gunicorn dans ~/.local
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --user flask gunicorn

# Ajouter le répertoire local de pip à PATH
ENV PATH="${PATH}:/home/opam/.local/bin"

# Définir les variables d'environnement Flask
ENV FLASK_APP=server.py
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

# Lancer le serveur Flask avec Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server:app"]
