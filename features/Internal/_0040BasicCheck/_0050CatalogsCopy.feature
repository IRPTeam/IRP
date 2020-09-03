#language: en
@tree
@Positive
@Test1
@Group1

Feature: filling in catalogs

              As an owner
              I want to fill out information on the company
To further use it when reflecting in the program of business processes

        Background:
            Given I open new TestClient session or connect the existing one
              And I set "True" value to the constant "ShowBetaTesting"
              And I set "True" value to the constant "ShowAlphaTestingSaas"
              And I set "True" value to the constant "UseItemKey"
              And I set "True" value to the constant "UseCompanies"



        Scenario: _005010 filling in the "Countries" catalog
	* Clearing the Countries catalog
              And I close all client application windows
	* Opening the Country creation form
            Given I open hyperlink "e1cib/list/Catalog.Countries"
              And Delay 2
              And I click the button named "FormCreate"
              And Delay 2
	* Data Filling - Turkey
              And I click Open button of the field named "Description_en"
              And I input "Turkey" text in the field named "Description_en"
              And I input "Turkey TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWriteAndClose"
              And Delay 5
	* Data Filling - Ukraine and Kazakhstan
              And I click the button named "FormCreate"
              And Delay 2
              And I click Open button of the field named "Description_en"
              And I input "Ukraine" text in the field named "Description_en"
              And I input "Ukraine TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWriteAndClose"
              And Delay 5
              And I click the button named "FormCreate"
              And Delay 2
              And I click Open button of the field named "Description_en"
              And I input "Kazakhstan" text in the field named "Description_en"
              And I input "Kazakhstan TR" text in the field named "Description_tr"
              And I click "Ok" button
              And I click the button named "FormWriteAndClose"
              And Delay 5
	* Check for added countries in the catalog
             Then I check for the "Countries" catalog element with the "Description_en" "Turkey"
             Then I check for the "Countries" catalog element with the "Description_tr" "Turkey TR"
             Then I check for the "Countries" catalog element with the "Description_en" "Kazakhstan"
             Then I check for the "Countries" catalog element with the "Description_en" "Ukraine"



        Scenario: _005011 filling in the "Currencies" catalog
	* Opening the Currency creation form
            Given I open hyperlink "e1cib/list/Catalog.Currencies"
              And Delay 2
              And I click the button named "FormCreate"
              And Delay 2
	* Creating currencies: Turkish lira, American dollar, Euro, Ukraine Hryvnia
              And I click Open button of the field named "Description_en"
              And I input "Turkish lira" text in the field named "Description_en"
              And I input "Turkish lira" text in the field named "Description_tr"
              And I click "Ok" button
              And I input "TL" text in "Symbol" field
              And I input "TRY" text in "Code" field
              And I click the button named "FormWriteAndClose"
              And Delay 5
              And I click the button named "FormCreate"
              And Delay 2
              And I click Open button of the field named "Description_en"
              And I input "American dollar" text in the field named "Description_en"
              And I input "American dollar" text in the field named "Description_tr"
              And I click "Ok" button
              And I input "$" text in "Symbol" field
              And I input "USD" text in "Code" field
              And I click the button named "FormWriteAndClose"
              And Delay 5
              And I click the button named "FormCreate"
              And Delay 2
              And I click Open button of the field named "Description_en"
              And I input "Euro" text in the field named "Description_en"
              And I input "Euro" text in the field named "Description_tr"
              And I click "Ok" button
              And I input "€" text in "Symbol" field
              And I input "EUR" text in "Code" field
              And I click the button named "FormWriteAndClose"
              And Delay 5
              And I click the button named "FormCreate"
              And Delay 2
              And I click Open button of the field named "Description_en"
              And I input "Ukraine Hryvnia" text in the field named "Description_en"
              And I input "Ukraine Hryvnia" text in the field named "Description_tr"
              And I click "Ok" button
              And I input "₴" text in "Symbol" field
              And I input "UAH" text in "Code" field
              And I click the button named "FormWriteAndClose"
              And Delay 5
	* Check for added currencies in the catalog
             Then I check for the "Currencies" catalog element with the "Description_en" "Turkish lira"
             Then I check for the "Currencies" catalog element with the "Description_tr" "Turkish lira"
             Then I check for the "Currencies" catalog element with the "Description_en" "American dollar"
             Then I check for the "Currencies" catalog element with the "Description_en" "Euro"
             Then I check for the "Currencies" catalog element with the "Description_en" "Ukraine Hryvnia"
