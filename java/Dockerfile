# Stage 1: Build the JAR using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
# Copying source code to the correct Maven path
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Final lightweight runtime image
# We use 'jre' instead of 'jdk' for the final image to reduce size and attack surface
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080

# Production-ready JVM flags for container awareness
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]