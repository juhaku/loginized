FROM alpine:3.7

ARG user
ARG gid

RUN apk --no-cache add dpkg rpm yarn bash git fakeroot zip tar
RUN addgroup $user
RUN adduser -u $gid -S -G $user $user


USER $user:$user
# RUN chown -R $user:$user /var/tmp 

CMD [ "./integrity.sh", "release" ]
# CMD /bin/bash -c "while [ true ]; do sleep 10000; done;"