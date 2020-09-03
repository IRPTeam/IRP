#language: en
@tree
@Positive
@Test13
@Group1


Feature: basic check documents and catalogs

              As an QA
              I want to check opening and closing of documents and catalogs forms

        Background:
            Given I launch TestClient opening script or connect the existing one
              And I set "True" value to the constant "ShowBetaTesting"
              And I set "True" value to the constant "ShowAlphaTestingSaas"
              And I set "True" value to the constant "UseItemKey"
              And I set "True" value to the constant "UseCompanies"



	
        Scenario: Open list form "AddAttributeAndPropertyValues"
              And I close all client application windows
            Given I open "AddAttributeAndPropertyValues" catalog default form
              If the warning is displayed then
             Then I raise "Failed to open catalog form AddAttributeAndPropertyValues" exception
              And I close current window

        Scenario: Open object form "AddAttributeAndPropertyValues"
              And I close all client application windows
            Given I open "AddAttributeAndPropertyValues" reference main form
              If the warning is displayed then
             Then I raise "Failed to open catalog form AddAttributeAndPropertyValues" exception
              And I close current window


        Scenario: Open list form "Partner terms"
              And I close all client application windows
            Given I open "Agreements" catalog default form
              If the warning is displayed then
             Then I raise "Failed to open catalog form Partner terms" exception
              And I close current window