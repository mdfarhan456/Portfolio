# Stage 1: Build
FROM eclipse-temurin:17-jdk-focal AS build
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src src

# Install Maven and build the project
RUN apt-get update && apt-get install -y maven
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:17-jre-focal
WORKDIR /app

# Copy JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Render will use this)
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
