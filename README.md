# Chiselled JRE

The different releases of this chiselled Ubuntu image are maintained via
channel branches (e.g. `channels/17/edge`).

Read more about the repository structure and build automation [here](<https://github.com/ubuntu-rocks/.github/blob/main/profile/README.md#-joining-the-ubuntu-rocks-project>).


## Image Characteristics

According to JetBrains' 2022 [Java Developer Ecosystem](https://www.jetbrains.com/lp/devecosystem-2022/java/) survey, 30% of the developers still regularly use Java 17, 59% developed applications for Apache Tomcat and 67% used Spring Boot as an alternative to an application server. We will use those application platforms for the comparison of the image characteristics.

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

The chiselled JRE container is built based on the Ubuntu 22.04 version of Java 17 runtime - `17.0.7+7`. In

This section provides a comparison with readily-available Java 17 runtime images from the most popular distributions:
 - Eclipse Adoptium publishes multiple [Java runtime images](https://github.com/adoptium/containers/tree/main/17/jre) for Java 17. We will evaluate Ubuntu Jammy [`eclipse-temurin:17.0.7_7-jre-jammy`](https://github.com/adoptium/containers/blob/main/17/jre/ubuntu/jammy/Dockerfile.releases.full) and Alpine-based [`eclipse-temurin:17.0.7_7-jre-alpine`](https://github.com/adoptium/containers/blob/main/17/jre/alpine/Dockerfile.releases.full) images.
 - Amazon Corretto publishes Java 17 image based on Amazon Linux 2023 [`amazoncorretto:17.0.7-al2023-headless`](https://github.com/corretto/corretto-docker/tree/main/17/headless/al2023)
 - Azul Zulu publishes multiple [Java runtime images](https://github.com/zulu-openjdk/zulu-openjdk) for Java 17. Will will evaluate distroless [`azul/zulu-openjdk-distroless:17.0.7-17.42.19`](https://github.com/zulu-openjdk/zulu-openjdk/tree/master/distroless/17.0.7-17.42.19).
 - [Oracle](https://github.com/oracle/docker-images/tree/main/OracleJava) only publishes JDK image.
 - Google provides distroless [`gcr.io/distroless/java17-debian11`](https://github.com/GoogleContainerTools/distroless/tree/main/java) Java 17 image.

### Image size

The evaluated images are built using the different processes and this affects the resulting image size.

Eclipse Temurin images use `ubuntu:22.04` or `alpine:3.18` base images and extract Adoptium's build of Java 17 Runtime built with OpenJDK `legacy-jre-image` target. It contains hotspot binaries and a base list of modules required for the runtime and is generated from the JDK image with the `jlink` tool. It includes a class data-sharing cache.

Azul Zulu packages a limited set of binaries and a full set of JDK modules. It includes a class data-sharing cache. It only installs base dependencies (`libc` and `libnss`) and none of the Abstract Window Toolkit (AWT) such as `fontconfig` despite having AWT binaries present in the Java runtime.

Amazon Corretto installs the Java JDK package in `amazonlinux:2023` with all package dependencies. It packages a limited set of binaries and a full set of JDK modules.

The Google distroless image is built by installing the Debian openjdk-17-jre-headless package and its dependencies and copying them into a scratch container. It contains a limited set of binaries and a full set of JDK modules.

Java 17 in chiselled Ubuntu is built by running `jlink` with a base list of modules required for the runtime in a normal Ubuntu 22.04 Jammy container. The dependencies are chiselled and copied into a scratch container along with the generated Java runtime.

As shown in the tables below the best space efficiency is achieved by Java 17 in chiselled Ubuntu with both approaches combined. `jlink` provides the best space saving and it is further augmented by having only Java library dependencies in the resulting image.

### AMD64

|Tag|Uncompressed Size(MB)| Compressed Size (MB)| % Compressed |
|---|----| ----------------------------| -------------|
|eclipse-temurin:17.0.7_7-jre-jammy	|259|	89	|100|
|eclipse-temurin:17.0.7_7-jre-alpine	|156	|55	|61.79|
|amazoncorretto:17.0.7-al2023-headless	|356|	127	|142.69|
|azul/zulu-openjdk-distroless:17.0.7-17.42.19| 	185|	63|	70.78|
|gcr.io/distroless/java17-debian11	|223|	82|	92.13|
|ubuntu/chiselled-jre:17_edge|	125|	44|	49.43|


### ARM64

|Tag|Uncompressed Size (MB)| Compressed Size(MB)| % Compressed |
|-----|----| ----------------------------| -------------|
|eclipse-temurin:17-jre-jammy|	254|	87	|100|
|gcr.io/distroless/java17-debian11|	218|	80	|91.9540229885057|
|ubuntu/chiselled-jre:17_edge|	121|	42	|48.2758620689655|


Below are image sizes of the deployed `acmeair` benchmark application

#### `acmeair` as a standalone Spring Boot application

### AMD64
|Tag|Uncompressed Size| Compressed Size| % Compressed |
|---|----| ----------------------------|----|
|standalone-eclipse-temurin:17.0.7_7-jre-jammy|	282|	109|	100|
|standalone-eclipse-temurin:17.0.7_7-jre-alpine|	179|	76|	69.72|
|standalone-amazoncorretto:17.0.7-al2023-headless|	379	|147	|134.86|
|standalone-azul/zulu-openjdk-distroless:17.0.7-17.42.19|	208|	83|	76.14|
|standalone-gcr.io/distroless/java17-debian11	|246|	102|	93.57|
|standalone-ubuntu/chiselled-jre:17_edge	|147|	65	|59.63|


### ARM64
|Tag|Uncompressed Size| Compressed Size| % Compressed |
|---|----| ----------------------------|----|
|standalone-eclipse-temurin:17.0.7_7-jre-jammy|	277	|108|	100|
|standalone-gcr.io/distroless/java17-debian11|	241	|101|	93.51|
|standalone-ubuntu/chiselled-jre:17_edge|143| 63|58.33|


### Test Environment

The tests were performed using the following setup:
| Machine | Description |
|---------|-------------|
| mongodb | amd64 m1.small cloud instance (1 vCPU, 2048MB RAM, 10GB disk) |
| acmeair amd| amd64 m1.medium cloud instance (2 vCPUs, 4096MB RAM, 10GB disk) |
| acmeair arm| arm64 m1.medium cloud instance (2 vCPU, 2048MB RAM, 10GB disk) |
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
|standalone-eclipse-temurin:17.0.7_7-jre-jammy|2.98|3.35|3.72|0.04|
|standalone-eclipse-temurin:17.0.7_7-jre-alpine|3.25|3.66|4.09|0.05|
|standalone-amazoncorretto:17.0.7-al2023-headless|2.97|3.35|3.82|0.04|
|standalone-azul/zulu-openjdk-distroless:17.0.7-17.42.19 |3.17|3.55|3.96|0.04|
|standalone-gcr.io/distroless/java17-debian11|2.80|3.37|3.68|0.04|
|standalone-ubuntu/chiselled-jre:17_edge|2.93|3.36|3.75|0.03|

The chiselled jre and temurin images have no statistical differences in the startup time.

### ARM64
|Image| Minimum (seconds) | Average (seconds) | Maximum (seconds) | Standard Error|
|-----|-------------------|-------------------|-------------------|-------------------|
|standalone-eclipse-temurin:17.0.7_7-jre-jammy|10.92|11.82|12.75|0.09|
|standalone-gcr.io/distroless/java17-debian11|10.85|11.68|13.37|0.13|
|standalone-ubuntu/chiselled-jre:17_edge|11.14|11.97|13.51|0.09|

The chiselled jre and temurin images have no statistical differences in the startup time.

### Throughput tests

The throughput tests were performed using Apache JMeter 5.5 on the `acmeair` application with the following command: ``jmeter -n -t AcmeAir-v5.jmx -DusePureIDs=true -JHOST=${HOST} -JPORT=9080 -j `pwd`/performance${i}.log -JTHREAD=1 -JUSER=10 -JDURATION=60 -JRAMP=0 ;``. The command was executed 33 times against the running container and the database was cleared between commands. The result of the first three commands was ignored to account for the virtual machine warmup.

## `acmeair` Standalone Spring Application

### AMD64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
|standalone-eclipse-temurin:17.0.7_7-jre-jammy|394.80|413.23|438.70|2.10|
|standalone-eclipse-temurin:17.0.7_7-jre-alpine|374.00|421.81|450.00|3.24|
|standalone-amazoncorretto:17.0.7-al2023-headless|413.20|422.91|434.30|1.03|
|standalone-azul/zulu-openjdk-distroless:17.0.7-17.42.19 |393.80|409.33|425.80|1.64|
|standalone-gcr.io/distroless/java17-debian11|413.90|424.52|438.40|1.29|
|standalone-ubuntu/chiselled-jre:17_edge|410.90|418.38|430.10|0.93|

### ARM64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
|standalone-eclipse-temurin:17.0.7_7-jre-jammy|138.10|163.10|170.70|1.48|
|standalone-gcr.io/distroless/java17-debian11|141.40|165.35|172.00|1.09|
|standalone-ubuntu/chiselled-jre:17_edge|136.10|163.68|172.50|1.24|


The data shows no statistical difference for the standalone Spring Application.

## `acmeair` on Apache Tomcat

In this test, the official tomcat images were used for temurin:
 - `tomcat:10.1.9-jre17-temurin-jammy`

Other images were built by compiling Apache Tomcat 10.1.9 with native extensions and copying it into the source container

### AMD64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
|tomcat:10.1.9-jre17-temurin-jammy|383.30|403.51|416.70|1.27|
|tomcat-eclipse-temurin:17.0.7_7-jre-alpine|387.50|395.27|405.70|0.91|
|tomcat-amazoncorretto:17.0.7-al2023-headless|368.00|401.13|410.80|1.54|
|tomcat-azul/zulu-openjdk-distroless:17.0.7-17.42.19 |375.50|401.53|412.80|1.44|
|tomcat-gcr.io/distroless/java17-debian11|397.30|408.76|421.60|1.10|
|tomcat-ubuntu/chiselled-jre:17_edge|384.10|402.82|415.90|1.53|

### ARM64

| Image | Min(requests/second)| Average (requests/seconds) | Max(requests/second)| Standard Error |
| ------|----------------------|------|----------------| --|
|tomcat:10.1.9-jre17-temurin-jammy|136.80|165.68|174.20|1.58|
|tomcat-gcr.io/distroless/java17-debian11|130.00|157.62|168.40|1.76|
|tomcat-ubuntu/chiselled-jre:17_edge|138.50|157.71|166.70|1.42|

The data shows no statistical difference for the standalone Spring Application between chiselled jre and Temurin images, with a slightly lower performance of the Corretto image.

### Conclusion

The chiselled JRE image of OpenJDK 8 provides a ~51% reduction in the size of the compressed image compared to Temurin Java 17 runtime image.
The chiselled JRE image does not degrade throughput or startup performance compared to the evaluated images.

## License

The source code in this project is licensed under the [Apache 2.0 LICENSE](./LICENSE).
**This is not the end-user license for the resulting container image.**
The software pulled at build time and shipped with the resulting image is licensed under a separate [LICENSE](./chiselled-jre/LICENSE).
