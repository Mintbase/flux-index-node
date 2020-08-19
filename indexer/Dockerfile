FROM rust

RUN mkdir /code
WORKDIR /code
ADD . /code/
RUN cargo build

# Start and listen on 8080
EXPOSE 8080
RUN bash scripts/init.sh testProtocol testFungible
