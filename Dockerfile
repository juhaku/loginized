FROM alpine:3.7

RUN apk --no-cache add dpkg rpm yarn bash

CMD [ "./integrity.sh", "release" ]