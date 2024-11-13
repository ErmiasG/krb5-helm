package com.example.spnego.ldap.realm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;

@Stateless
@TransactionAttribute(TransactionAttributeType.NEVER)
public class RemoteUserGroupMapper {

  private static final String GROUP_SEPARATOR = ",";
  private static final String MAPPING_SEPARATOR = "->";
  private static final String GROUP_MAPPING_SEPARATOR = ";";

  /**
   * Creates a group mapping from remote user to local
   * @return group mapping 
   */
  public Map<String, List<String>> getGroupMappings(String mappingStr) {
    Map<String, List<String>> mappings = new HashMap<>();
    if (mappingStr == null || mappingStr.isEmpty()) {
      return mappings;
    }
    StringTokenizer tokenizer = new StringTokenizer(mappingStr, GROUP_MAPPING_SEPARATOR);
    while (tokenizer.hasMoreElements()) {
      String mapping = tokenizer.nextToken();
      String[] mappingGroups = mapping.split(MAPPING_SEPARATOR);
      String mappedGroup = null;
      String[] mappedToGroups = null;
      if (mappingGroups != null && mappingGroups.length == 2) {
        mappedGroup = mappingGroups[0].trim();
        mappedToGroups = mappingGroups[1].split(GROUP_SEPARATOR);
      }
      if (mappedGroup == null || mappedGroup.isEmpty() || mappedToGroups == null || mappedToGroups.length < 1) {
        continue;
      }
      List<String> mappedTOGroupList = new ArrayList<>();
      for (String grp : mappedToGroups) {
        mappedTOGroupList.add(grp.trim());
      }
      mappings.put(mappedGroup, mappedTOGroupList);
    }
    return mappings;
  }

  /**
   * Returns a list of local group names based on the group mapping in getMappingStr()
   * @param groups
   * @return 
   */
  public List<String> getMappedGroups(List<String> groups) {
    List<String> mappedGroups = new ArrayList<>();
    Map<String, List<String>> mappings = getGroupMappings(" Administrators->HOPS_USER,HOPS_ADMIN; IT People-> HOPS_USER ");
    if (mappings == null || mappings.isEmpty() || groups == null || groups.isEmpty()) {
      return mappedGroups;
    }
    for (String group : groups) {
      addUnique(mappings.get(group), mappedGroups);
    }
    return mappedGroups;
  }

  private void addUnique(List<String> src, List<String> dest) {
    if (src == null) {
      return;
    }
    for (String str : src) {
      if (!dest.contains(str)) {
        dest.add(str);
      }
    }
  }

}
