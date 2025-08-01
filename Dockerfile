FROM ocaml/opam:ubuntu-ocaml-4.14

# Installer les dépendances
RUN sudo apt-get update && \
    sudo apt-get install -y m4 && \
    sudo rm -rf /var/lib/apt/lists/*

# Créer et configurer le répertoire de travail
RUN sudo mkdir -p /app && sudo chown -R opam:opam /app
WORKDIR /app

# Copier les fichiers et fixer les permissions
COPY --chown=opam:opam . /app

# Installer les dépendances OPAM et initialiser l'environnement
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