package com.example.spnego.rest.application.config;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@ApplicationPath("api")
public class ApplicationConfig extends Application {
  @Override
  public Set<Class<?>> getClasses() {
    return Stream.of(
      com.example.spnego.rest.ProtectedResources.class,
      com.example.spnego.rest.UnprotectedResources.class,
      com.example.spnego.rest.HealthResources.class
    ).collect(Collectors.toSet());
  }
}
