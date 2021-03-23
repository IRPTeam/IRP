#language: en
@tree
@Positive
@Sales

Feature: create document Sales return

As a procurement manager
I want to create a Sales return document
To track a product that returned from customer

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028500 preparation (create document Sales return)
	When set True value to the constant
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
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
		When Create document SalesInvoice objects (linked)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document SalesOrder and SalesInvoice objects (creation based on, SI >SO)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document SalesReturnOrder objects (creation based on)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturnOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		

Scenario: _028501 create document Sales return based on SI (without SRO)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner' |
		| '101'    | 'Crystal' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Crystal"
		Then the form attribute named "LegalName" became equal to "Company Adel"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "BusinessUnit" became equal to "Distribution department"
	* Check items tab
		| '#' | 'Business unit'           | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Use goods receipt' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Sales return order' | 'Sales invoice'                               | 'Expense type' |
		| '1' | 'Distribution department' | 'Shirt' | '38/Black' | 'No'                 | ''                   | '2,000' | 'pcs'            | '113,71'     | '350,00'   | '18%' | ''              | '586,29'     | 'No'                | '700,00'       | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''             |
		| '2' | 'Distribution department' | 'Boots' | '36/18SD'  | 'No'                 | ''                   | '2,000' | 'Boots (12 pcs)' | '2 729,05'   | '8 400,00' | '18%' | ''              | '14 070,95'  | 'No'                | '16 800,00'    | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''             |
		| '3' | 'Distribution department' | 'Boots' | '37/18SD'  | 'No'                 | ''                   | '2,000' | 'pcs'            | '227,42'     | '700,00'   | '18%' | ''              | '1 172,58'   | 'No'                | '1 400,00'     | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''             |
		| '4' | 'Distribution department' | 'Dress' | 'M/White'  | 'No'                 | ''                   | '4,000' | 'pcs'            | '337,88'     | '520,00'   | '18%' | ''              | '1 742,12'   | 'No'                | '2 080,00'     | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | ''             |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028501$$" variable
	And I delete "$$SalesReturn028501$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028501$$"
	And I save the window as "$$SalesReturn028501$$"
	And I click the button named "FormPostAndClose"
	And I close current window



// Scenario: _028502 check filling in Row Id info table in the SR (SI-SR)
// 	* Select SR
// 		Given I open hyperlink "e1cib/list/Document.SalesReturn"
// 		And I go to line in "List" table
// 			| 'Number'                     |
// 			| '$$NumberSalesReturn028501$$' |
// 		And I select current line in "List" table
// 		And I click "Show row key" button
// 		And I go to line in "ItemList" table
// 			| '#' |
// 			| '1' |
// 		And I activate "Key" field in "ItemList" table
// 		And I save the current field value as "$$Rov1SalesReturn028501$$"
// 		And I go to line in "ItemList" table
// 			| '#' |
// 			| '2' |
// 		And I activate "Key" field in "ItemList" table
// 		And I save the current field value as "$$Rov2SalesReturn028501$$"
// 		And I go to line in "ItemList" table
// 			| '#' |
// 			| '3' |
// 		And I activate "Key" field in "ItemList" table
// 		And I save the current field value as "$$Rov3SalesReturn028501$$"
// 	* Check Row Id info table
// 		And I move to "Row ID Info" tab
// 		And "RowIDInfo" table contains lines
// 			| 'Key'                       | 'Basis'                                       | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
// 			| '$$Rov1SalesReturn028501$$' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SC'        | '1,000'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SI&SC'        | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
// 			| '$$Rov2SalesReturn028501$$' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SC'        | '5,000'  | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SI&SC'        | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
// 			| '$$Rov3SalesReturn028501$$' | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SC'        | '60,000' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SI&SC'        | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' |
// 		Then the number of "RowIDInfo" table lines is "равно" "3"
// 	* Copy string and check Row ID Info tab
// 		And I move to "Item list" tab
// 		And I go to line in "ItemList" table
// 			| '#' | 'Item'  | 'Item key' | 'Q'     |
// 			| '1' | 'Dress' | 'XS/Blue'  | '1,000' |
// 		And in the table "ItemList" I click "Copy" button
// 		And I activate field named "ItemListQuantity" in "ItemList" table
// 		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
// 		And I finish line editing in "ItemList" table
// 		And I go to line in "ItemList" table
// 			| '#' |
// 			| '4' |
// 		And I activate "Key" field in "ItemList" table
// 		And I save the current field value as "$$Rov4SalesReturn028501$$"
// 		And I move to "Row ID Info" tab
// 		And I click the button named "FormPost"
// 		And "RowIDInfo" table contains lines
// 			| 'Key'                        | 'Basis'                                   | 'Row ID'                               | 'Next step'   | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
// 			| '$$Rov1SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SC'          | '1,000'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SI&SC'        | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
// 			| '$$Rov2SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SC'          | '5,000'  | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SI&SC'        | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
// 			| '$$Rov3SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SC'          | '60,000' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SI&SC'        | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' |
// 			| '$$Rov4SalesReturn028501$$' | ''                                        | '$$Rov4SalesReturn028501$$'           | 'SC'          | '8,000'  | ''                                     | ''             | '$$Rov4SalesReturn028501$$'           |
// 		Then the number of "RowIDInfo" table lines is "равно" "4"
// 		And "RowIDInfo" table does not contain lines
// 			| 'Key'                        | 'Q'     |
// 			| '$$Rov1SalesReturn028501$$' | '8,000' |
// 	* Delete string and check Row ID Info tab
// 		And I move to "Item list" tab
// 		And I go to line in "ItemList" table
// 			| '#' | 'Item'  | 'Item key' | 'Q'     |
// 			| '4' | 'Dress' | 'XS/Blue'  | '8,000' |
// 		And in the table "ItemList" I click "Delete" button
// 		And I move to "Row ID Info" tab
// 		And "RowIDInfo" table contains lines
// 			| 'Key'                        | 'Basis'                                   | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
// 			| '$$Rov1SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SC'        | '1,000'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SI&SC'        | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
// 			| '$$Rov2SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SC'        | '5,000'  | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SI&SC'        | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
// 			| '$$Rov3SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SC'        | '60,000' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SI&SC'        | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' |
// 		Then the number of "RowIDInfo" table lines is "равно" "3"
// 	* Change quantity and check  Row ID Info tab
// 		And I move to "Item list" tab
// 		And I go to line in "ItemList" table
// 			| '#' | 'Item'  | 'Item key' | 'Q'     |
// 			| '1' | 'Dress' | 'XS/Blue'  | '1,000' |
// 		And I activate "Q" field in "ItemList" table
// 		And I select current line in "ItemList" table
// 		And I input "7,000" text in "Q" field of "ItemList" table
// 		And I finish line editing in "ItemList" table
// 		And "RowIDInfo" table contains lines
// 			| 'Key'                        | 'Basis'                                   | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
// 			| '$$Rov1SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SC'        | '7,000'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SI&SC'        | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
// 			| '$$Rov2SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SC'        | '5,000'  | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SI&SC'        | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
// 			| '$$Rov3SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SC'        | '60,000' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SI&SC'        | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' |
// 		Then the number of "RowIDInfo" table lines is "равно" "3"
// 		And I move to "Item list" tab
// 		And I go to line in "ItemList" table
// 			| '#' | 'Item'  | 'Item key' | 'Q'     |
// 			| '1' | 'Dress' | 'XS/Blue'  | '7,000' |
// 		And I activate "Q" field in "ItemList" table
// 		And I select current line in "ItemList" table
// 		And I input "1,000" text in "Q" field of "ItemList" table
// 		And I finish line editing in "ItemList" table
// 	* Change checkbox Use Shipment confirmation and check RowIDInfo
// 		And I move to "Item list" tab
// 		And I go to line in "ItemList" table
// 			| 'Item'  | 'Item key' | 'Q'     | 'Unit'           |
// 			| 'Boots' | '36/18SD'  | '5,000' | 'Boots (12 pcs)' |
// 		And I remove "Use shipment confirmation" checkbox in "ItemList" table
// 		And I move to the tab named "GroupRowIDInfo"
// 		And I click "Post" button
// 		And "RowIDInfo" table contains lines
// 			| 'Key'                        | 'Basis'                                   | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
// 			| '$$Rov1SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SC'        | '1,000'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SI&SC'        | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
// 			| '$$Rov2SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SC'        | '5,000'  | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SI&SC'        | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
// 			| '$$Rov3SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | ''          | '60,000' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SI&SC'        | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' |
// 		Then the number of "RowIDInfo" table lines is "равно" "3"	
// 		And I click the button named "FormPostAndClose"





	
// Scenario: _024003 copy SI (based on SO) and check filling in Row Id info table (SI)
// 	* Copy SI
// 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
// 		And I go to line in "List" table
// 			| 'Number'                     |
// 			| '$$NumberSalesInvoice024008$$' |
// 		And in the table "List" I click the button named "ListContextMenuCopy"
// 	* Check copy info
// 		Then the form attribute named "Partner" became equal to "Ferron BP"
// 		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
// 		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
// 		Then the form attribute named "Description" became equal to "Click to enter description"
// 		Then the form attribute named "Company" became equal to "Main Company"
// 		Then the form attribute named "Store" became equal to "Store 02"
// 		And "ItemList" table became equal
// 			| '#' | 'Business unit'           | 'Price type'        | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Revenue type' |
// 			| '1' | 'Distribution department' | 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'No'                 | ''                   | '1,000' | 'pcs'            | '79,32'      | '520,00'   | '18%' | ''              | '440,68'     | '520,00'       | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | ''            | 'Revenue'      |
// 			| '2' | 'Distribution department' | 'Basic Price Types' | 'Shirt' | '36/Red'   | 'No'                 | ''                   | '5,000' | 'pcs'            | '240,25'     | '350,00'   | '18%' | '175,00'        | '1 334,75'   | '1 575,00'     | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | ''            | 'Revenue'      |
// 			| '3' | 'Front office'            | 'Basic Price Types' | 'Boots' | '36/18SD'  | 'No'                 | ''                   | '5,000' | 'Boots (12 pcs)' | '6 406,78'   | '8 400,00' | '18%' | ''              | '35 593,22'  | '42 000,00'    | ''                    | 'Store 02' | '27.01.2021'    | 'No'                        | ''       | ''            | 'Revenue'      |

// 		And "ObjectCurrencies" table became equal
// 			| 'Movement type'      | 'Type'         | 'Currency from' | 'Currency' | 'Rate presentation' | 'Multiplicity' | 'Amount'   |
// 			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1'            | '44 095'   |
// 			| 'Local currency'     | 'Legal'        | 'TRY'           | 'TRY'      | '1'                 | '1'            | '44 095'   |
// 			| 'Reporting currency' | 'Reporting'    | 'TRY'           | 'USD'      | '0,1712'            | '1'            | '7 549,06' |

// 		Then the form attribute named "BusinessUnit" became equal to ""
// 		Then the form attribute named "Author" became equal to "en description is empty"
// 		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
// 		Then the form attribute named "Currency" became equal to "TRY"
// 		Then the form attribute named "ItemListTotalNetAmount" became equal to "37 368,65"
// 		Then the form attribute named "ItemListTotalTaxAmount" became equal to "6 726,35"
// 		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "44 095,00"
// 		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
// 	* Post SI and check Row ID Info tab
// 		And I click the button named "FormPost"
// 		And I click the button named "FormShowRowKey"
// 		And I move to "Row ID Info" tab
// 		And "RowIDInfo" table does not contain lines
// 			| 'Key'                        | 'Basis'                                   | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
// 			| '$$Rov1SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SC'        | '7,000'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'SI&SC'        | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
// 			| '$$Rov2SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SC'        | '5,000'  | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'SI&SC'        | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
// 			| '$$Rov3SalesReturn028501$$' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | ''          | '60,000' | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' | 'SI&SC'        | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff' |
// 		Then the number of "RowIDInfo" table lines is "равно" "3"
// 		And I close all client application windows	


Scenario: _028515 create document Sales return based on SRO 
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '32'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I input "466,10" text in "Price" field of "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028515$$" variable
	And I delete "$$SalesReturn028515$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028515$$"
	And I save the window as "$$SalesReturn028515$$"
	And I click the button named "FormPostAndClose"
	And I close current window







Scenario: _028534 check totals in the document Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Select Sales Return
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturn028501$$'     |
		And I select current line in "List" table
	* Check totals in the document Sales return
		Then the form attribute named "ItemListTotalNetAmount" became equal to "466,10"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "83,90"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "550,00"



Scenario: _300511 check connection to SalesReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberSalesReturn028508$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session