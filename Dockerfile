FROM ocaml/opam:ubuntu-ocaml-4.14

# Installation des dépendances
RUN sudo apt-get update && \
    sudo apt-get install -y m4 && \
    sudo rm -rf /var/lib/apt/lists/*

# Création et configuration du répertoire de travail
RUN sudo mkdir -p /app && sudo chown -R opam:opam /app
WORKDIR /app

# Copie les fichiers et fixe les permissions
COPY --chown=opam:opam . /app

# Installation des dépendances OPAM et initialisation de l'environnement
RUN opam install -y ounit ocamlfind && \
    opam init -y --disable-sandboxing && \
    eval $(opam env)

# Builder le projet en tant qu'utilisateur opam avec l'environnement initialisé
USER opam
RUN eval $(opam env) && make

# Port exposé
EXPOSE 10000

# Point d'entrée
ENTRYPOINT ["./marina"]
CMD ["'a & b'"]