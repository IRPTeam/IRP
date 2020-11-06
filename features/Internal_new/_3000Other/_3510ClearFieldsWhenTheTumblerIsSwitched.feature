#language: en
@tree
@Positive
@Other

Feature: check the cleaning of fields in forms of directories with switches (the drawing of the form depends on the switch)



Background:
        Given I launch TestClient opening script or connect the existing one
        


Scenario: _3510000 preparation (check the cleaning of fields in forms)
        When set True value to the constant
        And I close TestClient session
        Given I open new TestClient session or connect the existing one
        * Load info
                When Create catalog ObjectStatuses objects
                When Create catalog ItemKeys objects
                When Create catalog ItemTypes objects
                When Create catalog Units objects
                When Create catalog Items objects
                When Create catalog PriceTypes objects
                When Create catalog Specifications objects
                When Create catalog CashAccounts objects 
                When Create chart of characteristic types AddAttributeAndProperty objects
                When Create catalog AddAttributeAndPropertySets objects
                When Create catalog AddAttributeAndPropertyValues objects
                When Create catalog Currencies objects
                When Create catalog Companies objects (Main company)
                When Create catalog Stores objects
                When Create catalog Partners objects (Ferron BP)
                When Create catalog Partners objects (Kalipso)
                When Create catalog Companies objects (partners company)
                When Create information register PartnerSegments records
                When Create catalog PartnerSegments objects
                When Create catalog Agreements objects
                When Create chart of characteristic types CurrencyMovementType objects
                When Create information register PricesByItemKeys records
                When Create catalog IntegrationSettings objects
                When Create information register CurrencyRates records
        * Add plugin for taxes calculation
                Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
                If "List" table does not contain lines Then
                                | "Description" |
                                | "TaxCalculateVAT_TR" |
                        When add Plugin for tax calculation
                When Create information register Taxes records (VAT)
        * Tax settings
                When filling in Tax settings for company

Scenario: _3510001 check the clearing of values ​​when changing the type of account in the Cash / Bank accounts catalog
* Open Cash account form
        Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
        And I click the button named "FormCreate"
* Filling in the details of the document for Bank account
        And I change "Type" radio button value to "Bank"
        And I input "Test Bank" text in the field named "Description_en"
        And I click Select button of "Company" field
        And I go to line in "List" table
        | 'Description'  |
        | 'Main Company' |
        And I select current line in "List" table
        And I input "12345" text in "Number" field
        And I input "1234" text in "Bank name" field
        And I click Select button of "Transit account" field
        And I go to line in "List" table
        | 'Description'    |
        | 'Transit Second' |
        And I select current line in "List" table
        And I click Choice button of the field named "Currency"
        And I go to line in "List" table
        | 'Code' | 'Description'     |
        | 'USD'  | 'American dollar' |
        And I activate "Description" field in "List" table
        And I select current line in "List" table
        * Check filling in
        Then the form attribute named "Type" became equal to "Bank"
        Then the form attribute named "Company" became equal to "Main Company"
        Then the form attribute named "Number" became equal to "12345"
        Then the form attribute named "BankName" became equal to "1234"
        Then the form attribute named "TransitAccount" became equal to "Transit Second"
        Then the form attribute named "Description_en" became equal to "Test Bank"
        Then the form attribute named "CurrencyType" became equal to "Fixed"
        Then the form attribute named "Currency" became equal to "USD"
* Switching the type to Cash and then back to the Bank and checking the cleaning of the filled in details
        And I change "Type" radio button value to "Cash"
        And I change "Type" radio button value to "Bank"
        Then the form attribute named "Type" became equal to "Bank"
        Then the form attribute named "Company" became equal to "Main Company"
        Then the form attribute named "Number" became equal to ""
        Then the form attribute named "BankName" became equal to ""
        Then the form attribute named "TransitAccount" became equal to ""
        Then the form attribute named "CurrencyType" became equal to "Fixed"
* Filling in the details for Cash account
        And I change "Type" radio button value to "Cash"
        And I change the radio button named "CurrencyType" value to "Fixed"
        And I click Choice button of the field named "Currency"
        And I go to line in "List" table
        | 'Code' | 'Description' |
        | 'EUR'  | 'Euro'        |
        And I activate "Description" field in "List" table
        And I select current line in "List" table
* Check reset when switching transit and back to Cash
        And I change "Type" radio button value to "Transit"
        And I change "Type" radio button value to "Cash"
        Then the form attribute named "CurrencyType" became equal to "Multi"
        And I close all client application windows


Scenario: _3510002 check clearing values ​​when changing the Ap-ar posting / Standard switch to Partner term
* Open Partner term form
        Given I open hyperlink "e1cib/list/Catalog.Agreements"
        And I click the button named "FormCreate"
* Filling in the details of the document for partner term with AP/AR posting detail - By standard partner term
        And I change "Kind" radio button value to "Regular"
        And I click Select button of "Multi currency movement type" field
        And I go to line in "List" table
        | 'Description' |
        | 'EUR'         |
        And I select current line in "List" table
        And I change "AP/AR posting detail" radio button value to "By standard partner term"
        And I click Select button of "Standard Partner term" field
        * Create standart agreement in EUR
        And I click the button named "FormCreate"
        And I input "Standard, EUR" text in the field named "Description_en"
        And I click "Save and close" button
        And I click the button named "FormChoose"
        And I click Select button of "Price type" field
        And I go to line in "List" table
        | 'Description'       |
        | 'Basic Price Types' |
        And I select current line in "List" table
* Check filling in
        Then the form attribute named "CurrencyMovementType" became equal to "EUR"
        Then the form attribute named "StandardAgreement" became equal to "Standard, EUR"
        Then the form attribute named "PriceType" became equal to "Basic Price Types"
* Switching the Ap-ar posting switch to By Partner terms and checking to clear the StandardPartner term field
        And I change "AP/AR posting detail" radio button value to "By partner terms"
        Then the form attribute named "StandardAgreement" became equal to ""
* Check clearing fields when changing the switch to Standard
        And I change "Kind" radio button value to "Standard"
        Then the form attribute named "CurrencyMovementType" became equal to "EUR"
        Then the form attribute named "PriceType" became equal to ""
        And I close all client application windows


Scenario: _3510003 check clearing the values ​​of Tax types and Multi currency movement type when changing the OurCompany checkmark in Company
* Open Compant form
        Given I open hyperlink "e1cib/list/Catalog.Companies"
        And I click the button named "FormCreate"
* Tick the box OurCompany and fill in Tax types and Multi currency movement types
        And I input "Test" text in the field named "Description_en"
        And I set checkbox "Our Company"
        * Filling in Multi currency movement type
                And in the table "Currencies" I click the button named "CurrenciesAdd"
                And I click choice button of "Movement type" attribute in "Currencies" table
                And I go to line in "List" table
                        | 'Currency' | 'Deferred calculation' | 'Description'        | 'Reference'          | 'Source'       | 'Type'      |
                        | 'USD'      | 'No'                   | 'Reporting currency' | 'Reporting currency' | 'Forex Seling' | 'Reporting' |
                And I activate "Description" field in "List" table
                And I select current line in "List" table
                And I finish line editing in "Currencies" table
                And "Currencies" table contains lines
                        | 'Movement type'      | 'Type'      | 'Currency' | 'Source'       |
                        | 'Reporting currency' | 'Reporting' | 'USD'      | 'Forex Seling' |
        * Filling in Tax types
                And I move to "Tax types" tab
                And in the table "CompanyTaxes" I click the button named "CompanyTaxesAdd"
                And I input "01.10.2019" text in "Period" field
                And I activate "Tax" field in "CompanyTaxes" table
                And I click choice button of "Tax" attribute in "CompanyTaxes" table
                And I go to line in "List" table
                        | 'Description' | 'Reference' |
                        | 'VAT'         | 'VAT'       |
                And I select current line in "List" table
                And I activate "Priority" field in "CompanyTaxes" table
                And I input "2" text in "Priority" field of "CompanyTaxes" table
                And I finish line editing in "CompanyTaxes" table
                And "CompanyTaxes" table contains lines
                        | 'Use' | 'Tax' | 'Priority' |
                        | 'Yes' | 'VAT' | '2'        |
        * Check to clear completed data when uncheck OurCompany
				And I move to "Info" tab
				And I remove checkbox "Our Company"
				And I select "Company" exact value from the drop-down list named "Type"
				And I click "Save" button
                And I set checkbox "Our Company"
                And "Currencies" table does not contain lines
                        | 'Movement type'      | 'Type'      | 'Currency' | 'Source'       |
                        | 'Reporting currency' | 'Reporting' | 'USD'      | 'Forex Seling' |
                And "CompanyTaxes" table does not contain lines
                        | 'Use' | 'Tax' | 'Priority' |
                        | 'Yes' | 'VAT' | '2'        |
                And I close all client application windows