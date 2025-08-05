FROM ocaml/opam:ubuntu-22.04-ocaml-4.14

RUN sudo apt-get update && \
    sudo apt-get install -y python3 python3-pip python3-venv make file

WORKDIR /app

COPY . .

RUN opam init -a --disable-sandboxing && \
    opam install -y ocamlfind ounit2 && \
    eval $(opam env) && \
    make

RUN chmod +x ./marina

RUN ls -l ./marina

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --user flask gunicorn

ENV PATH="${PATH}:/home/opam/.local/bin"

ENV FLASK_APP=server.py
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server:app"]
