module LabelPrinterService
  module SparqlQueries

    def select_contacts
      query = %q(
SELECT ?prefix ?firstName ?lastName ?organizationName ?street ?poBox ?postCode ?city WHERE {
  ?s a <http://mu.semte.ch/vocabularies/ext/bravoer/Sympathizer> ;
     <http://mu.semte.ch/vocabularies/ext/bravoer/communicationsMedium> "paper" .

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasFamilyName> ?lastName .
  }

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasHonorificPrefix> ?prefix .
  }

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasGivenName> ?firstName .
  }

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasOrganizationName> ?organizationName .
  }

  OPTIONAL { 
    ?s <http://www.w3.org/ns/locn#address> ?address .
    ?address <http://www.w3.org/ns/locn#thoroughfare> ?street .
    ?address <http://www.w3.org/ns/locn#poBox> ?poBox .
    ?address <http://www.w3.org/ns/locn#postCode> ?postCode .
    ?address <http://www.w3.org/ns/locn#postName> ?city .
  }
} ORDER BY ?lastName ?firstName
      )
      query(query)
    end
  end
end
