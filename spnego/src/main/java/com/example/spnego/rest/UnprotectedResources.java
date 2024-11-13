package com.example.spnego.rest;

import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.SecurityContext;

@Path("/unprotected")
public class UnprotectedResources {
  private final static Logger LOGGER = Logger.getLogger(UnprotectedResources.class.getName());
  
  @GET
  @Path("/resource")
  @Produces(MediaType.APPLICATION_JSON)
  public Response getUnprotectedResource(@Context SecurityContext sc, @Context HttpServletRequest req) {
    JsonResponse json = new JsonResponse();
    json.setStatus("SUCCESS");
    json.setMessage("Unprotected Resource");
    json.setSessionID(req.getSession().getId());
    json.setAuthType(req.getAuthType());
    String principalName = sc.getUserPrincipal() == null ? "" : sc.getUserPrincipal().getName();
    json.setPrincipal(principalName);
    Enumeration<String> names = req.getHeaderNames();
    while (names.hasMoreElements()) {
      String name = names.nextElement();
      LOGGER.log(Level.INFO, "{0} = {1}", new Object[]{name, req.getHeader(name)});
      if ("authorization".equals(name)) {
        json.setToken(req.getHeader(name));
      }
    }    
    LOGGER.log(Level.INFO, "Response: {0}", json);
    return Response.ok(json).build();
  }
}
