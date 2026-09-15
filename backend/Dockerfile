# build ---------------------------------------------------------------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
RUN mvn -B -q package -DskipTests

# runtime -------------------------------------------------------------
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

COPY --from=build /build/target/visacampo.jar ./visacampo.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "visacampo.jar"]
