# Étape 1: Construction de l'exécutable OCaml
FROM ocaml/opam:alpine AS builder

# Copie des sources
WORKDIR /app
COPY . .

# Correction des permissions
RUN sudo chown -R opam:opam /app

# Installation des dépendances
RUN sudo apk add --no-cache m4
RUN opam install ocamlfind ounit2

# Compilation avec opam exec
RUN opam exec -- make

# Étape 2: Environnement d'exécution
FROM python:3.9-alpine

# Installation des dépendances Python
RUN pip install flask gunicorn

# Copie de l'exécutable OCaml
COPY --from=builder /app/marina /usr/bin/marina

# Vérification que l'exécutable existe
RUN ls -l /usr/bin/marina && chmod +x /usr/bin/marina

# Copie du serveur web
COPY server.py /app/server.py

# Configuration
WORKDIR /app
EXPOSE 5000

# Point d'entrée
CMD ["gunicorn", "-b", "0.0.0.0:5000", "server:app"]