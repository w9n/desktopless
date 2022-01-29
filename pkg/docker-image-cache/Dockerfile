FROM wiin/alpine: AS build

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    busybox

# Remove apk residuals. We have a read-only rootfs, so apk is of no use.
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

RUN rm -rf /out/var/run && ln -nfs /run /out/var/run

FROM scratch
WORKDIR /
COPY --from=build /out /
COPY --from=docker:17.11.0-ce-dind /usr/local/bin/docker /usr/local/bin/docker
COPY dl/*.tar /images/
COPY images.lst /images.lst
COPY init.sh /usr/bin
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "init.sh" ]
