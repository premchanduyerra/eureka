# Use the official Maven image to build the application
FROM maven:3.8.4 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project's POM file
COPY pom.xml .

# Download the Maven dependencies
RUN mvn dependency:go-offline

# Copy the application source code
COPY src ./src

# Build the application
RUN mvn clean package -Pprod

# Use the official OpenJDK base image for running the application
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the Maven build stage to the current stage
COPY --from=build /app/target/eureka.jar ./eureka.jar

# Expose the default port
EXPOSE 8761

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "eureka.jar", "--spring.profiles.active=prod"]
