FROM ocaml/opam:ubuntu-22.04-ocaml-4.14 AS build

# Définir le répertoire de travail
WORKDIR /app

# Installer les dépendances système
RUN sudo apt-get update && \
    sudo apt-get install -y python3-pip python3-venv

# Copier uniquement les fichiers nécessaires pour la construction
COPY Makefile my.ml my.mli prop.ml prop.mli sat_ifexpr.ml sat_ifexpr.mli marina.ml marina.mli main.ml ./

# Construire l'application
RUN opam init -a --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    eval $(opam env) && \
    make

# Étape finale
FROM python:3.10-slim-bullseye

# Installer les dépendances Python
RUN pip install flask gunicorn

# Créer le répertoire de travail
WORKDIR /app

# Copier l'application compilée depuis l'étape de build
COPY --from=build /app/marina .
COPY server.py .

# Rendre le binaire exécutable
RUN chmod +x marina

ENV FLASK_APP=server.py

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server:app"]