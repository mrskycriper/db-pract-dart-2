FROM dart:latest

RUN dart pub global activate dart_frog_cli

WORKDIR /app
COPY . .

RUN dart pub get
RUN dart pub install mysql_client

ENV PATH="$PATH:/root/.pub-cache/bin"
CMD ["dart", "srv.dart"]