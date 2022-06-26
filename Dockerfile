FROM jokeswar/base-ctl

RUN echo "Hello from Docker"

COPY ./checker ${CHECKER_DATA_DIRECTORY}
