# Chiselled JRE

The different releases of this chiselled Ubuntu image are maintained via
channel branches (e.g. `channels/8/edge`).

Read more about the repository structure and build automation in [here](<https://github.com/ubuntu-rocks/.github/blob/main/profile/README.md#-joining-the-ubuntu-rocks-project>).


## Image characteristics

According to JetBrains' 2022 [Java Developer Ecosystem](https://www.jetbrains.com/lp/devecosystem-2022/java/) survey, 60% of the developers still regularly used Java 8, 59% developed applications for Apache Tomcat and 67% used Spring Boot as an alternative to an application server.

New Relic 2022 [Java Ecosystem report](https://newrelic.com/resources/report/2022-state-of-java-ecosystem) listed following top JDK vendors:
 - Oracle Corporation 34.48%
 - Amazon 22.04%
 - Eclipse Adoptimum 11.48%
 - Azul Zulu build of OpenJDK 16%

Snyk 2021 [JVM Ecosystem](https://snyk.io/jvm-ecosystem-report-2021/) had the following breakdown:
 - Eclipse Adoptimum 44%
 - Oracle Corporation OpenJDK 28%
 - Oracle Corporation JDK 23%
 - Azul Zulu build of OpenJDK 16%
 - Amazon Coretto 8%

The differences in the vendor distribution could be attributed to the audience providing survey responses.

The chiselled JRE container is built based on Ubuntu 22.04 version of Java 8 runtime - `8u352-b08`.

This section provides a comparison with readily-available JRE 8 images for Ubuntu 22.04:
 - Eclipse Adoptium: `eclipse-temurin:8u352-b08-jre-jammy`
 - Amazon: `amazoncorretto:8u352-alpine3.14-jre`

Azul Zulu does not provide a JRE image: https://hub.docker.com/r/azul/zulu-openjdk and it was not evaluated.
Oracle does not provide official image of the Java Runtime Environment 8 and it was not evaluated.

### Image size

|Image|Tag|Uncompressed Size| Compressed Size|
|-----|---|----| ----------------------------|
| eclipse-temurin|8u352-b08-jre-jammy|221MB|80M|
| amazoncorretto| 8u352-alpine3.14-jre| 110MB | 41M|
| ubuntu/chiselled-jre|8-22.04_edge| 123MB|46M |


The major points of difference with Temurin image are:
- `/bin` and `/usr/bin` are removed, which occupy 20MB (compressed) in Temurin
- `/var` is removed, which occupies 7.7MB due to `dpkg`
- only minimal set of libraries is present in /usr/lib/x86_64-linux-gnu, saving 39M
- contents of /usr/share are not present (31MB), assuming that for things like local time zone information, it is either mapped into the container, or containers run in GMT.

The major points of difference with Corretto image are:
 - Corretto deploys busybox as a shell
 - Corretto does not have fontconfig/fonts libraries. This causes `java.awt.Font.createFont()` to fail with `java.lang.UnsatisfiedLinkError`.
 - Corretto does not provide `glib` libraries imported by the URL proxy selector. `java.net.ProxySelector.getDefault()` call will always return `Direct Proxy`.

The JRE differences itself are minimal. Th chiselled image removes libawt_xawt.so and libsplashscren.so along with accessibility support. Executables, except `java`, are removed from `jre/bin`.
Note: chiselled docker at the moment does not provide classes.jsa (Class Data Cache) in line with Temurin JRE and it has to be generated.

Below are image sizes of the deployed `acmeair` benchmark application
|Image|Base Image|Uncompressed Size| Compressed Size|
|-----|---|----| ----------------------------|
| acmeair deployed to WebSphere Liberty official image| websphere-liberty:23.0.0.1-full-java8-ibmjava| 772MB| 507MB|
| acmeair and WebSphere Liberty deployed to chiselled-jre| ubuntu/chiselled-jre:8_edge | 631MB | 407MB |
| acmeair and WebSphere Liberty deployed to Corretto| 8u352-alpine3.14-jre | 618MB | 402MB |
| acmeair deployed to Apache Tomcat | tomcat:9.0.71-jre8-temurin-jammy | 258MB | 108MB |
| acmeair and Apache Tomcat deployed to chiselled-jre | ubuntu/chiselled-jre:8_edge | 164MB | 76M |
| acmeair and Apache Tomcat deployed to Corretto| 8u352-alpine3.14-jre | 151MB | 71M |
| acmeair Stanalone Spring Boot on Temurin | eclipse-temurin:8u352-b08-jre-jammy | 244MB | 99MB |
| acmeair Stanalone Spring Boot | ubuntu/chiselled-jre:8_edge | 146MB | 65MB|
| acmeair Stanalone Spring Boot on Corretto | 8u352-alpine3.14-jre | 133MB | 61MB|

### Startup time

The startup times were evaluated by starting a Spring Boot standalone container repeatedly and measuring the total JVM time until the start of the application as per Spring Boot logs.
The table below shows average startup times (seconds):
|chiselled-jre| chiselled-jre with Class Data Caching| Temurin | Temurin with Class Data Caching| Corretto | Corretto with Class Data Caching |
|-----|---|----| -------------|---| ---|
|1.03 |0.99328125| 1.04615625|0.989625| 1.1124375 |  1.06978125 |

Adding CDS (Class Data Sharing) to `acmeair` allows a 5% startup improvement at expense of a 6MB compressed (and 20MB uncompressed) image size increase.

### Throughput tests

The throughput tests were performed using Apache JMeter 5.5 on `acmeair` application with the following command: ``./apache-jmeter-5.5/bin/jmeter -n -t AcmeAir-v5.jmx -DusePureIDs=true -JHOST=localhost -JPORT=9080 -j performance.log -JTHREAD=1 -JUSER=9999 -JDURATION=120 -JRAMP=60 ;``

The table below shows average requests per second:

| WebSphere Liberty | WebSphere Liberty (chiselled) | Apache Tomcat | Apache Tomcat (chiselled) | Standalone (Temurin) | Standalone (chiselled) |  Standalone (corretto) |
|-------------------|-------------------------------|---------------|-------------|---------|--------| ---|
| 1553.7 | 1704.5 | 1687.7 | 1733.2 | 1778 | 1773.6 | 1798 |

This test shows no significant differences in performance for OpenJDK-based tests.

### Conclusion

The chiselled JRE image of OpenJDK 8 provides a 42.5% reduction in the size of the compressed image compared to Temurin and 11% larger than Amazon Corretto image.
The chiselled JRE image does not degrade throughput or startup performance.

## License

The source code in this project is licensed under the [Apache 2.0 LICENSE](./LICENSE).
**This is not the end-user license for the resulting container image.**
The software pulled at build time and shipped with the resulting image is licensed under a separate [LICENSE](./chiselled-jre/LICENSE).