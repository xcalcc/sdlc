FROM hub.xcalibyte.co/sdlc/xcal.build.scanservice:1.1

COPY workdir/scanTaskService/src/scanTaskService $WORK_DIR/scanTaskService

COPY ./VER /VER

ENV PYTHONPATH=$WORK_DIR/scanTaskService/commondef/src:$WORK_DIR:$PYTHONPATH

WORKDIR $WORK_DIR

CMD ["python3","scanTaskService/scanApp.py"]

