#language: en
@tree
@Positive
@Purchase

Feature: create document an Internal supply request 

As a sales manager
I want to create an Internal supply request 
For ordering items to the planning department (purchasing or transfer from the store)


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _016500 preparation
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
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog Taxes objects	
		When Create catalog TaxRates objects
		When Create information register CurrencyRates records
		When Create catalog IntegrationSettings objects
		When update ItemKeys
		* Add plugin for taxes calculation
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			If "List" table does not contain lines Then
					| "Description" |
					| "TaxCalculateVAT_TR" |
				* Opening a form to add Plugin sessing
					Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				* Addition of Plugin sessing for calculating Tax types for Turkey (VAT)
					And I click the button named "FormCreate"
					And I select external file "#workingDir#/DataProcessor/TaxCalculateVAT_TR.epf"
					And I click the button named "FormAddExtDataProc"
					And I input "" text in "Path to plugin for test" field
					And I input "TaxCalculateVAT_TR" text in "Name" field
					And I click Open button of the field named "Description_en"
					And I input "TaxCalculateVAT_TR" text in the field named "Description_en"
					And I input "TaxCalculateVAT_TR" text in the field named "Description_tr"
					And I click "Ok" button
					And I click "Save and close" button
					And I wait "Plugins (create)" window closing in 10 seconds
				* Check added processing
					Then I check for the "ExternalDataProc" catalog element with the "Description_en" "TaxCalculateVAT_TR"
					Given I open hyperlink "e1cib/list/Catalog.Taxes"		
					And I go to line in "List" table
						| 'Description' |
						| 'VAT'         |
					And I select current line in "List" table
					And I click Select button of "Plugins" field
					And I go to line in "List" table
						| 'Description' |
						| 'TaxCalculateVAT_TR'         |
					And I select current line in "List" table
					And I click "Save and close" button
				And I close all client application windows
		
			
Scenario: _016501 create document Internal Supply Request
	* Opening the creation form Internal Supply Request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Trousers    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item     | Item key          |
			| Trousers | 36/Yellow |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Shirt       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "25,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Shirt       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key |
			| Shirt | 38/Black |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberInternalSupplyRequest016501$$" variable
		And I delete "$$InternalSupplyRequest016501$$" variable
		And I save the value of "Number" field as "$$NumberInternalSupplyRequest016501$$"
		And I save the window as "$$InternalSupplyRequest016501$$"
		And I click the button named "FormPostAndClose"
	* Check document creation
		And "List" table contains lines
			| 'Number'                                     | 'Company'      | 'Store'    |
			| '$$NumberInternalSupplyRequest016501$$'      | 'Main Company' | 'Store 01' |
		And I close all client application windows
	
	


Scenario: _016503 check the Company filter in the Internal Supply Request document.
	* Opening the creation form Internal Supply Request
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Check the visual filter by Company
		And I click Select button of "Company" field
		And "List" table became equal
			| Description  |
			| Main Company |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check filter by Company when inpute by string
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Store" field
		And Delay 2
		And "List" table does not contain lines
			| Description  |
			| Company Kalipso |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			|'Then the form attribute named "Company" became equal to "Company Kalipso"'|
		And I close all client application windows
	


Scenario: _016504 check display of the title of the collapsible group when creating the document Internal Supply Request
	* Opening the creation form Internal Supply Request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Filling in the document number
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "215" text in "Number" field
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description  |
			| Main Company | 
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
	* Check display of the title of the collapsible group
		Then the field named "DecorationGroupTitleUncollapsedLabel" value contains "Number: 215   Company: Main Company   Store: Store 01" text
		And I close all client application windows





Scenario: _300501 check connection to Internal Supply Request report "Related documents"
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberInternalSupplyRequest016501$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows




	



	






