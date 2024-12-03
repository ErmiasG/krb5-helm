package com.example.spnego.rest;

import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/auth")
public class AuthResource {
  
  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public Response checkSession() {
    return Response.ok().build();
  }
  
  @POST
  @Path("krb/login")
  @Produces(MediaType.APPLICATION_JSON)
  public Response krbLogin(@FormParam("chosenEmail") String chosenEmail, @FormParam("consent") boolean consent) {
    return Response.ok().build();
  }
  
  @POST
  @Path("ldap/login")
  @Produces(MediaType.APPLICATION_JSON)
  public Response ldapLogin(@FormParam("chosenEmail") String chosenEmail, @FormParam("consent") boolean consent) {
    return Response.ok().build();
  }
  
  @POST
  @Path("oauth/login")
  @Produces(MediaType.APPLICATION_JSON)
  public Response oauthLogin(@FormParam("chosenEmail") String chosenEmail, @FormParam("consent") boolean consent) {
    return Response.ok().build();
  }
}
