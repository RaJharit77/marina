FROM ocaml/opam:ubuntu-ocaml-4.14

RUN sudo apt-get update && \
    sudo apt-get install -y m4 pkg-config libgmp-dev && \
    sudo rm -rf /var/lib/apt/lists/*

# Créer le répertoire avec les bonnes permissions
RUN sudo mkdir -p /app && sudo chown -R opam:opam /app
WORKDIR /app
COPY --chown=opam:opam . .

# Installer les dépendances
RUN opam install -y cohttp-lwt-unix lwt ounit

# Compiler avec les permissions opam
USER opam
RUN eval $(opam env) && make

EXPOSE 10000

CMD ["./marina"]