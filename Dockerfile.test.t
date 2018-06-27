# -*- mode: dockerfile -*-
### stage0
FROM <REPO_NAME>:<CIRCLE_SHA1>-build as build

COPY app /tmp/build
RUN /bin/herokuish buildpack build \
 && /bin/herokuish slug generate

### stage1
FROM <REPO_NAME>:<CIRCLE_SHA1>

COPY --from=build /tmp/slug.tgz /tmp
RUN mkdir -p /app \
 && tar x -C /app -f /tmp/slug.tgz \
 && rm /tmp/slug.tgz
COPY test.sh /
CMD ["bash", "/test.sh"]
