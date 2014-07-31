xml.instruct!
xml.Request do
  xml.requestID do
    xml.dateTimeOfRequest DateTime.now
    xml.requestorTransactionId "1234"
  end
  xml.identityInformation do
    xml.requestorIdentifierOfIdentity do
      xml.referenceURI "http://www.xxx.org/ourID/13365"
      xml.identifier "1234"
    end  
    xml.identity do
      xml.personOrFiction do
        xml.personalName do
          xml.nameUse
          xml.surname
          xml.forename
          xml.languageOfName
        end 
        xml.gender
        xml.birthDate
        xml.deathDate
        xml.nationality
        xml.resource do
          xml.creationClass
          xml.creationRole
          xml.fieldOfCreation do
            xml.fieldType
            xml.fieldOfCreationValue
          end
          xml.titleOfWork do
            xml.title
            xml.imprint do
              xml.publisher
              xml.date
            end
            xml.identifier do
              xml.identifierValue
              xml.identifierType
            end
          end
        end
        xml.contributedTo do
          xml.titleOfCollectiveWorkOrWorkPerformed
          xml.identifier do
            xml.identifierType
            xml.identifierValue
          end
        end 
        xml.personalNameVariant do
          xml.nameUse
          xml.surname
          xml.forename
        end     
      end  
    end  
    xml.languageOfIdentity
    xml.countriesAssociated do
      xml.countryCode
    end
    xml.externalInformation do
      xml.information
      xml.URI
    end
    xml.note 
  end

  
  
  
  
  
  
  

end
