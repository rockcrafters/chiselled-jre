# Chiselled JRE

The different releases of this chiselled Ubuntu image are maintained via
channel branches (e.g. `channels/8/edge`).

Read more about the repository structure and build automation [here](<https://github.com/ubuntu-rocks/.github/blob/main/profile/README.md#-joining-the-ubuntu-rocks-project>).


## Image Characteristics

According to JetBrains' 2022 [Java Developer Ecosystem](https://www.jetbrains.com/lp/devecosystem-2022/java/) survey, 60% of the developers still regularly used Java 8, 59% developed applications for Apache Tomcat and 67% used Spring Boot as an alternative to an application server. We will use those application platforms for the comparison of the image characteristics.

New Relic 2022 [Java Ecosystem report](https://newrelic.com/resources/report/2022-state-of-java-ecosystem) listed the following top JDK vendors:
 - Oracle Corporation 34.48%
 - Amazon 22.04%
 - Eclipse Adoptium 11.48%
 - Azul Zulu build of OpenJDK 16%

Snyk 2021 [JVM Ecosystem](https://snyk.io/jvm-ecosystem-report-2021/) had the following breakdown:
 - Eclipse Adoptium 44%
 - Oracle Corporation OpenJDK 28%
 - Oracle Corporation JDK 23%
 - Azul Zulu build of OpenJDK 16%
 - Amazon Coretto 8%

The differences in vendor distribution could be attributed to the audience providing survey responses.

The cloud vendors traditionally offered `amd64`-based virtual machines, though recently they have started to provide `arm64` offerings, such as [Amazon Graviton](https://aws.amazon.com/ec2/graviton/). This image evaluation will focus on `amd64` and `arm64` platforms.

The chiselled JRE container is built based on the Ubuntu 22.04 version of Java 8 runtime - `8u362-ga`.

This section provides a comparison with readily-available JRE 8 images for Ubuntu 22.04:
 - Eclipse Adoptium: `eclipse-temurin:8u362-b09-jre-jammy`
 - Amazon: `amazoncorretto:8u362-alpine3.14-jre`

Azul Zulu does not provide a JRE image: https://hub.docker.com/r/azul/zulu-openjdk and it was not evaluated.

Oracle does not provide an official image of the Java Runtime Environment 8 and it was not evaluated.

### Image size

### AMD64

|Image|Tag|Uncompressed Size| Compressed Size| % Compressed |
|-----|---|----| ----------------------------| -------------|
| eclipse-temurin|8u362-b09-jre-jammy|215MB|80M| 100% |
| amazoncorretto| 8u362-alpine3.14-jre| 109M | 43M| 53.8% |
| ubuntu/chiselled-jre|8-22.04_edge| 113MB |44M | 55% |

### ARM64

|Image|Tag|Uncompressed Size| Compressed Size| % Compressed |
|-----|---|----| ----------------------------| -------------|
| eclipse-temurin|8u362-b09-jre-jammy|205MB|77M| 100% |
| amazoncorretto| 8u362-alpine3.14-jre| n/a | n/a| n/a |
| ubuntu/chiselled-jre|8-22.04_edge| 109MB |42M | 55% |


The points of difference with the Temurin image are:
- `/bin` and `/usr/bin` are removed, which occupy 20MB (compressed) in Temurin
- `/var` is removed, which occupies 7.7MB due to `dpkg`
- only a minimal set of libraries is present in /usr/lib/x86_64-linux-gnu, saving 39M
- contents of /usr/share are not present (31MB), meaning that container always assumes GMT timezone.
- `glib` libraries imported by the URL proxy selector are absent. `java.net.ProxySelector.getDefault()` call will always return `Direct Proxy`.

The points of difference with the Amazon Corretto image are:
 - Corretto deploys busybox as a shell
 - Corretto does not have fontconfig/fonts libraries. This causes `java.awt.Font.createFont()` to fail with `java.lang.UnsatisfiedLinkError`.
 - No JRE is provided for ARM64, there is only JDK build

The JRE differences themselves are minimal. The chiselled image removes `libawt_xawt.so` and `libsplashscren.so` along with accessibility support. Only 'java' executable is left in `jre/bin`.
Note: chiselled images, at the moment, do not provide classes.jsa (Class Data Cache) in line with Temurin JRE.

Below are image sizes of the deployed `acmeair` benchmark application

#### `acmeair` as a standalone Spring Boot application

### AMD64
|Base Image|Uncompressed Size| Compressed Size| % Compressed |
|---|----| ----------------------------|----|
| eclipse-temurin:8u362-b08-jre-jammy | 237MB | 99MB |  100% |
| ubuntu/chiselled-jre:8_edge | 135MB | 63MB| 64% |
| amazoncorretto:8u362-alpine3.14-jre | 131MB | 62MB| 63% |

### ARM64
|Base Image|Uncompressed Size| Compressed Size| % Compressed |
|---|----| ----------------------------|----|
| eclipse-temurin:8u362-b08-jre-jammy | 227MB | 96MB |  100% |
| ubuntu/chiselled-jre:8_edge | 131MB | 62MB| 65% |


### Test Environment

The tests were performed using the following setup:
| Machine | Description |
|---------|-------------|
| mongodb | amd64 m1.small cloud instance (1 vCPU, 2048MB RAM, 10GB disk) |
| acmeair amd| amd64 m1.medium cloud instance (2 vCPUs, 4096MB RAM, 10GB disk) |
| acmeair arm| arm64 m1.small cloud instance (1 vCPU, 2048MB RAM, 10GB disk) |
| load machine| amd64 m1.medium cloud instance (2 vCPUs, 4096MB RAM, 10GB disk) |

[load machine] <-http-> [acmeair] <--> [mongodb]

<details>
<summary>
AMD64 vCPU details
</summary>

```
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel Core Processor (Haswell, no TSX, IBRS)
stepping        : 1
microcode       : 0x1
cpu MHz         : 2599.994
cache size      : 16384 KB
physical id     : 1
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology cpuid tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm cpuid_fault invpcid_single pti ssbd ibrs ibpb tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt arat md_clear
vmx flags       : vnmi preemption_timer posted_intr invvpid ept_x_only ept_ad ept_1gb flexpriority apicv tsc_offset vtpr mtf vapic ept vpid unrestricted_guest vapic_reg vid pml
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit srbds mmio_unknown
bogomips        : 5199.98
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:
```

</details>

<details>
  <summary>ARM64 vCPU details</summary>

```
processor       : 0
BogoMIPS        : 100.00
Features        : fp asimd evtstrm cpuid
CPU implementer : 0x50
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0x000
CPU revision    : 1
```

</details>




### Startup time

The startup times were evaluated by starting a Spring Boot standalone container and sampling 30 times the total JVM time until the start of the application as per Spring Boot logs.

### AMD64
|Image| Minimum (seconds) | Average (seconds) | Maximum (seconds) | Standard Error|
|-----|-------------------|-------------------|-------------------|-------------------|
| chiselled jre| 3.21   | 3.62  |4.40|  0.04 |
| temurin | 3.28    | 3.66  | 3.98 |    0.04 |
| corretto| 3.703   | 4.06 |    4.50    | 0.03 |

The chiselled jre and temurin images have no statistical differences in the startup time and Corretto image is significantly slower, which can be explained by a different runtime.

### ARM64
|Image| Minimum (seconds) | Average (seconds) | Maximum (seconds) | Standard Error|
|-----|-------------------|-------------------|-------------------|-------------------|
|chiselled jre  | 22.13 | 23.18 |   24.54   | 0.12 |
| temurin |  22.14  | 23.12 | 24.41 |   0.13 |

The chiselled jre and temurin images have no statistical differences in the startup time.

### Class Data Sharing

The image excludes class data sharing cache. The table below shows the difference in the startup time for the chiselled jre image:

| Platform| No Class Data Sharing Average (Seconds) | Class Data Sharing Average (Seconds) |  % Difference |
|---------|-----------------------------------------|--------------------------| ---|
| AMD64   | 3.62                                    | 3.51|                    | 3% |
| ARM64   | 23.18                                   | 23.14 |                  | 0% |


Adding Class Data Sharing to `acmeair` allows a 3% startup improvement at expense of a 6MB compressed (and 20MB uncompressed) image size increase.

### Throughput tests

The throughput tests were performed using Apache JMeter 5.5 on the `acmeair` application with the following command: ``jmeter -n -t AcmeAir-v5.jmx -DusePureIDs=true -JHOST=${HOST} -JPORT=9080 -j `pwd`/performance${i}.log -JTHREAD=1 -JUSER=10 -JDURATION=60 -JRAMP=0 ;``. The command was executed 33 times against running container and the database was cleared between commands. The result of the first three commands were ignored to account for the virtual machine warmup.

## `acmeair` Standalone Spring Application

### AMD64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
| chiselled-jre |348.2| 364.18 |376.3| 1.15 |
| temurin |345.9| 363.23 |384.8 | 1.55 |
| corretto |336.9| 361.05 | 380.9| 1.71 |

### ARM64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
| chiselled-jre |180.9| 213 |221.8| 1.15 |
| temurin | 170.1| 215 | 230.5| 2.24 |


The data shows no statistical difference for the standalone Spring Application.

## `acmeair` on Apache Tomcat

In this test the official tomcat images were used for temurin and corretto:
 - `tomcat:9.0.72-jre8-temurin-jammy`
 - `tomcat:9.0.72-jdk8-corretto-al2`

### AMD64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
| chiselled-jre |338.7| 362.18 | 377.7| 1.54 |
| temurin | 349.8| 365.77 | 377.8| 1.13 |
| corretto |336.2| 348.05 |373.9| 1.82 |

### ARM64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
| chiselled-jre |163| 206.17 | 225.8 | 2.09 |
| temurin | 150.2| 207.34 | 220.4| 2.54 |
| corretto |147.2 |191.60   |205 | 2.11  |

The data shows no statistical difference for the standalone Spring Application between chiselled jre and Temurin images, with a slightly lower performance of the Corretto image.

### Conclusion

The chiselled JRE image of OpenJDK 8 provides a 45% reduction in the size of the compressed image compared to Temurin and 1.2% larger than the Amazon Corretto image.
The chiselled JRE image does not degrade throughput or startup performance compared to the evaluated images.

## License

The source code in this project is licensed under the [Apache 2.0 LICENSE](./LICENSE).
**This is not the end-user license for the resulting container image.**
The software pulled at build time and shipped with the resulting image is licensed under a separate [LICENSE](./chiselled-jre/LICENSE).