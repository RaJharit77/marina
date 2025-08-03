FROM ocaml/opam:alpine AS builder
WORKDIR /app
COPY . .
RUN sudo apk add --no-cache m4
RUN opam install ocamlfind ounit2
RUN make

FROM python:3.9-alpine
RUN pip install flask gunicorn
COPY --from=builder /app/marina /usr/local/bin/
COPY server.py /app/server.py
WORKDIR /app
EXPOSE 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "server:app"]