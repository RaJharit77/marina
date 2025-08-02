FROM ocaml/opam:ubuntu-ocaml-4.14

RUN sudo apt-get update && \
    sudo apt-get install -y m4 && \
    sudo rm -rf /var/lib/apt/lists/*

RUN sudo mkdir -p /app && sudo chown -R opam:opam /app
WORKDIR /app
COPY --chown=opam:opam . /app

RUN opam install -y ounit ocamlfind && \
    opam init -y --disable-sandboxing && \
    eval $(opam env)

USER opam
RUN eval $(opam env) && make

EXPOSE 10000

CMD ["./marina", "a & b"]