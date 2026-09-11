FROM maven:3.9.16-eclipse-temurin-21-noble AS build
WORKDIR /workspace
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src src
RUN mvn -B verify

FROM eclipse-temurin:21-jre-noble
WORKDIR /app
RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl \
	&& rm -rf /var/lib/apt/lists/*
COPY --from=build /workspace/target/order-service-1.0.0.jar app.jar
EXPOSE 8080
HEALTHCHECK --interval=5s --timeout=3s --retries=12 \
	CMD ["curl", "--fail", "--silent", "http://localhost:8080/actuator/health"]
ENTRYPOINT ["java", "-jar", "/app/app.jar"]