# ccextractor

- Used as a base image to build and install into other docker images.
- Can also be used as-is
- Built on ubuntu

To install ccextractor in a docker image:

```COPY --from=djaydev/ccextractor:latest /usr/local/bin /usr/local/bin
```
