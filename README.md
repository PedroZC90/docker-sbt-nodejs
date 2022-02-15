# docker-sbt-nodejs
a docker image with sbt and nodejs

## References

1.  Alpine Linux
    -   https://hub.docker.com/_/alpine
2.  Node.js
    -   https://hub.docker.com/_/node
    -   https://github.com/oznu/alpine-node/blob/master/Dockerfile
    -   https://gist.github.com/neilstuartcraig/bd3f7010bae42292bc90d22f5773bae8
3.  SBT (SCALA)
    -   https://gist.github.com/gyndav/c8d65b59793566ee73ed2aa25aa10497

## Support

-   Node.js v10.24.1
-   OpenJDK 8u302
-   Scala Sbt 0.13.18

## Usage

```bash
docker run -it --rm --name play-builder pedrozc90/sbt-node bash
```

## License

Please, see [LICENSE](./LINCESE) file.
