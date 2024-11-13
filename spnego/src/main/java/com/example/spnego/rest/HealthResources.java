package com.example.spnego.rest;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/health")
public class HealthResources {
  
  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public Response getUnprotectedResource() {
    return Response.ok().build();
  }
}
