#language: en
@tree
@Positive
@Sales

Feature: create documents Shipmentnd receipt planing orders


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028600 preparation (Shipment receipt planing orders)
	When set True value to the constant
	When set True value to the constant Use shipment and receipt planing orders
	When set True value to the constant DisableLinkedRowsIntegrity
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog Partners objects
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create catalog ExpenseAndRevenueTypes objects 
		When Create information register CurrencyRates records
		When Create catalog Companies objects (own Second company)
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
	* Add plugin for discount
		When Create Document discount (for row)
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	* Load documents
		When Create SO for shipment planning order (use variable item key)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2113).GetObject().Write(DocumentWriteMode.Posting);"    |
	
Scenario: _0286001 check preparation
	When check preparation

Scenario: _0286002 create Shipment receipt planing order - Shipment confirmation (based on SO)
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'   |
			| '2 112'    |	
	* Generate Shipment planning order
		And I click the button named "FormDocumentShipmentPlaningOrderGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		And I click Select button of "Shipment period" field
		Then "Select period" window is opened
		And I input "01.03.2025" text in the field named "DateBegin"
		And I input "10.03.2025" text in the field named "DateEnd"
		And I click the button named "Select"			
	* Check
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "Branch" became equal to "Logistics department"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ExternalLinkedDocs" became equal to ""
		And "ItemList" table became equal
			| '#' | 'Item'       | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Store'    | 'Shipment basis'                              | 'Sales order'                                 |
			| '1' | 'Shirt'      | '38/Black' | ''                   | 'pcs'  | ''                  | '5,000'    | 'Store 01' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | 'Sales order 2 112 dated 03.03.2025 10:36:15' |
			| '2' | 'Boots'      | '38/18SD'  | ''                   | 'pcs'  | ''                  | '15,000'   | 'Store 01' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | 'Sales order 2 112 dated 03.03.2025 10:36:15' |
			| '3' | 'High shoes' | '37/19SD'  | ''                   | 'pcs'  | ''                  | '2,000'    | 'Store 01' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | 'Sales order 2 112 dated 03.03.2025 10:36:15' |
		
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "ShipmentPeriod" became equal to "01.03.2025 - 10.03.2025"		
	* Change item key
		And I go to line in "ItemList" table
			| "Item"  | "Item key" |
			| "Boots" | "38/18SD"  |	
		And I select "37" from "Item key" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberShipmentPlaningOrder1$$" variable
		And I delete "$$ShipmentPlaningOrder1$$" variable
		And I save the value of "Number" field as "$$NumberShipmentPlaningOrder1$$"
		And I save the window as "$$ShipmentPlaningOrder1$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ShipmentPlaningOrder"
		And "List" table contains lines
			| 'Number'                         |
			| '$$NumberShipmentPlaningOrder1$$'|
	* Create Shipment confirmation
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberShipmentPlaningOrder1$$' |
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
	* Check
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "Branch" became equal to "Logistics department"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "isPackage" became equal to "No"
		And "ItemList" table became equal
			| '#' | 'Item'       | 'Inventory transfer' | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' | 'Sales invoice' | 'Store'    | 'Shipment basis'                              | 'Sales order'                                 | 'Shipment planing order'    | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Shirt'      | ''                   | '38/Black' | ''                   | 'pcs'  | '5,000'    | ''              | 'Store 01' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | '$$ShipmentPlaningOrder1$$' | ''                         | ''                      | ''                |
			| '2' | 'Boots'      | ''                   | '37/18SD'  | ''                   | 'pcs'  | '15,000'   | ''              | 'Store 01' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | '$$ShipmentPlaningOrder1$$' | ''                         | ''                      | ''                |
			| '3' | 'High shoes' | ''                   | '37/19SD'  | ''                   | 'pcs'  | '2,000'    | ''              | 'Store 01' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | 'Sales order 2 112 dated 03.03.2025 10:36:15' | '$$ShipmentPlaningOrder1$$' | ''                         | ''                      | ''                |
		
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "TransactionType" became equal to "Sales"
		And I click the button named "FormPost"
		And I delete "$$NumberShipmentConfirmation1$$" variable
		And I delete "$$ShipmentConfirmation1$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation1$$"
		And I save the window as "$$ShipmentConfirmation1$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And "List" table contains lines
			| 'Number'                         |
			| '$$NumberShipmentConfirmation1$$'|
		And I close all client application windows
		

				
				
				

		

				

					
				