
package com.example.spnego.ldap.realm;

import java.util.List;
import jakarta.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class RemoteUserDTO {
  
  private String uuid;//Universally unique identifier
  private String uid;//username in remote
  private String givenName;
  private String surname;
  private List<String> email;
  private List<String> groups;
  private List<String> systemGroups;
  private boolean emailVerified;
  
  public RemoteUserDTO() {
  }
  
  public RemoteUserDTO(String uuid, String uid, String givenName, String surname, List<String> email,
    boolean emailVerified) {
    this.uuid = uuid;
    this.uid = uid;
    this.givenName = givenName;
    this.surname = surname;
    this.email = email;
    this.emailVerified = emailVerified;
  }

  public String getUuid() {
    return uuid;
  }
  
  public void setUuid(String uuid) {
    this.uuid = uuid;
  }
  
  public String getUid() {
    return uid;
  }
  
  public void setUid(String uid) {
    this.uid = uid;
  }
  
  public String getGivenName() {
    return givenName;
  }
  
  public void setGivenName(String givenName) {
    this.givenName = givenName;
  }
  
  public String getSurname() {
    return surname;
  }
  
  public void setSurname(String surname) {
    this.surname = surname;
  }
  
  public List<String> getEmail() {
    return email;
  }
  
  public void setEmail(List<String> email) {
    this.email = email;
  }
  
  public List<String> getSystemGroups() {
    return systemGroups;
  }
  
  public void setSystemGroups(List<String> systemGroups) {
    this.systemGroups = systemGroups;
  }

  public List<String> getGroups() {
    return groups;
  }
  
  public void setGroups(List<String> groups) {
    this.groups = groups;
  }

  public boolean isEmailVerified() {
    return emailVerified;
  }
  
  public void setEmailVerified(boolean emailVerified) {
    this.emailVerified = emailVerified;
  }
  
  @Override
  public String toString() {
    return "RemoteUserDTO{" + "uuid=" + uuid + ", uid=" + uid + ", givenName=" + givenName + ", surname=" + surname
      + ", email=" + email + ", groups=" + groups + ", systemGroups=" + systemGroups + ", emailVerified=" + emailVerified + '}';
  }
}
