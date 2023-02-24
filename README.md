# Chiselled JRE

The different releases of this chiselled Ubuntu image are maintained via
channel branches (e.g. `channels/8/edge`).

Read more about the repository structure and build automation in [here](<https://github.com/ubuntu-rocks/.github/blob/main/profile/README.md#-joining-the-ubuntu-rocks-project>).


## Image characteristics

This section highlights differences with the `eclipse-temurin:8u352-b08-jre-jammy` image (as at the time of writing, 8u362 is not yet deployed to Jammy).

### Image size

|Image|Tag|Uncompressed Size| Compressed Size|
|-----|---|----| ----------------------------|
| eclipse-temurin|8u352-b08-jre-jammy|221MB|80M|
| ubuntu/chiselled-jre|8-22.04_edge| 123MB|46M |

The major points of difference are:
- `/bin` and `/usr/bin` are removed, which occupy 20MB (compressed) in Temurin
- `/var` is removed, which occupies 7.7MB due to `dpkg`
- only minimal set of libraries is present in /usr/lib/x86_64-linux-gnu, saving 39M
- contents of /usr/share are not present (31MB), assuming that for things like local time zone information, it is either mapped into the container, or containers run in GMT.

The JRE differences itself are minimal. Chiselled image removes libawt_xawt.so and libsplashscren.so along with accessibility support. Executables, except `java`, are removed from `jre/bin`.
Note: chiselled docker at the moment does not provides classes.jsa (Class Data Cache) in line with Temurin JRE and it has to be generated.

Below are image sizes of the deployed `acmeair` benchmark application
|Image|Base Image|Uncompressed Size| Compressed Size|
|-----|---|----| ----------------------------|
| acmeair deployed to WebSphere Liberty official image| websphere-liberty:23.0.0.1-full-java8-ibmjava| 772MB| 507MB|
| acmeair and WebSphere Liberty deployed to chiselled-jre| ubuntu/chiselled-jre:8_edge | 631MB | 407MB |
| acmeair deployed to Apache Tomcat | tomcat:9.0.71-jre8-temurin-jammy | 258MB | 108MB |
| acmeair and Apache Tomcat deployed to chiselled-jre | ubuntu/chiselled-jre:8_edge | 164MB | 76M |
| acmeair Stanalone Spring Boot on Temurin | eclipse-temurin:8u352-b08-jre-jammy | 244MB | 99MB |
| acmeair Stanalone Spring Boot | ubuntu/chiselled-jre:8_edge | 146MB | 65MB|

### Startup time

The startup times were evaluated by starting a Spring Boot standalone container repeatedly and measuring the total JVM time until the start of the application as per Spring Boot logs.
The table below shows average startup times (seconds):
|chiselled-jre| chiselled-jre with Class Data Caching| Temurin | Temurin with Class Data Caching|
|-----|---|----| -------------|
|1.03 |0.99328125| 1.04615625|0.989625|

Adding CDS (Class Data Sharing) to `acmeair` allows a 5% startup improvement at expense of a 6MB compressed (and 20MB uncompressed) image size increase.

### Throughput tests

The throughput tests were performed using Apache JMeter 5.5 on `acmeair` application using the following command: ``./apache-jmeter-5.5/bin/jmeter -n -t AcmeAir-v5.jmx -DusePureIDs=true -JHOST=localhost -JPORT=9080 -j performance.log -JTHREAD=1 -JUSER=9999 -JDURATION=120 -JRAMP=60 ;``

The table below shows average requests per second:

| WebSphere Liberty | WebSphere Liberty (chiselled) | Apache Tomcat | Apache Tomcat (chiselled) | Standalone (Temurin) | Standalone (Chiselled) |
|-------------------|-------------------------------|---------------|-------------|---------|--------|
| 1553.7 | 1704.5 | 1687.7 | 1733.2 | 1778 | 1773.6 |

This test shows no significant differences in performance for OpenJDK-based tests.

### Conclusion

Chiselled JRE image of OpenJDK 8 provides 42.5% reduction in the size of the compressed image and does not degrade throughput or startup performance.

## License

The source code in this project is licensed under the [Apache 2.0 LICENSE](./LICENSE).
**This is not the end-user license for the resulting container image.**
The software pulled at build time and shipped with the resulting image is licensed under a separate [LICENSE](./chiselled-jre/LICENSE).