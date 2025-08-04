FROM ocaml/opam:ubuntu-22.04-ocaml-4.14 AS build

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

# Copier l'application compilée depuis l'étape de build
COPY --from=build /app/marina /app/marina

RUN chmod +x /app/marina

# CORRECTION : Utiliser server.py au lieu de app.py
COPY server.py /app/server.py

WORKDIR /app
ENV FLASK_APP=server.py

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "server:app"]