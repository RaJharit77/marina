FROM ocaml/opam:ubuntu-ocaml-4.14

RUN sudo apt-get update && \
    sudo apt-get install -y m4 pkg-config libgmp-dev && \
    sudo rm -rf /var/lib/apt/lists/*

RUN sudo mkdir -p /app && sudo chown -R opam:opam /app
WORKDIR /app
COPY --chown=opam:opam . .

RUN opam install -y cohttp-lwt-unix lwt ounit

USER opam
RUN eval $(opam env) && opam exec -- make

EXPOSE 10000

CMD ["./marina"]