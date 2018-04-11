FROM alpine:3.7

RUN apk --no-cache add dpkg rpm yarn bash git fakeroot zip tar

CMD [ "./integrity.sh", "release" ]
# CMD /bin/bash -c "while [ true ]; do sleep 10000; done;"