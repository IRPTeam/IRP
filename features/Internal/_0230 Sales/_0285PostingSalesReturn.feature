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
		When Create catalog ExpenseAndRevenueTypes objects 
		When Create information register CurrencyRates records
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
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
		When Create document SalesReturnOrder objects (creation based on, without SI)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturnOrder.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturnOrder.FindByNumber(106).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturnOrder.FindByNumber(107).GetObject().Write(DocumentWriteMode.Posting);" |


Scenario: _028501 create document Sales return based on SI (without SRO)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner' |
		| '101'    | 'Crystal' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerate"
	And I click "Ok" button
	* Check the details
		Then the form attribute named "Partner" became equal to "Crystal"
		Then the form attribute named "LegalName" became equal to "Company Adel"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Store" became equal to "Store 01"
		// Then the form attribute named "Branch" became equal to "Distribution department"
	* Check items tab
		And "ItemList" table contains lines
		| '#' | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Use goods receipt' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Sales return order' | 'Sales invoice'                               | 'Revenue type' |
		| '1' | 'Shirt' | '38/Black' | 'No'                 | ''                   | '2,000' | 'pcs'            | '113,71'     | '350,00'   | '18%' | ''              | '586,29'     | 'No'                | '700,00'       | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'Revenue'      |
		| '2' | 'Boots' | '36/18SD'  | 'No'                 | ''                   | '2,000' | 'Boots (12 pcs)' | '2 729,05'   | '8 400,00' | '18%' | ''              | '14 070,95'  | 'No'                | '16 800,00'    | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'Revenue'      |
		| '3' | 'Boots' | '37/18SD'  | 'No'                 | ''                   | '2,000' | 'pcs'            | '227,42'     | '700,00'   | '18%' | ''              | '1 172,58'   | 'No'                | '1 400,00'     | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'Revenue'      |
		| '4' | 'Dress' | 'M/White'  | 'No'                 | ''                   | '4,000' | 'pcs'            | '337,88'     | '520,00'   | '18%' | ''              | '1 742,12'   | 'No'                | '2 080,00'     | ''                    | 'Store 01' | ''                   | 'Sales invoice 101 dated 05.03.2021 12:56:38' | 'Revenue'      |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028501$$" variable
	And I delete "$$SalesReturn028501$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028501$$"
	And I save the window as "$$SalesReturn028501$$"
	And I click the button named "FormPostAndClose"
	And I close current window
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberSalesReturn028501$$' |
		And I close all client application windows



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
// 			| '#' | 'Profit loss center'           | 'Price type'        | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Revenue type' |
// 			| '1' | 'Distribution department' | 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'No'                 | ''                   | '1,000' | 'pcs'            | '79,32'      | '520,00'   | '18%' | ''              | '440,68'     | '520,00'       | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | ''            | 'Revenue'      |
// 			| '2' | 'Distribution department' | 'Basic Price Types' | 'Shirt' | '36/Red'   | 'No'                 | ''                   | '5,000' | 'pcs'            | '240,25'     | '350,00'   | '18%' | '175,00'        | '1 334,75'   | '1 575,00'     | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | ''            | 'Revenue'      |
// 			| '3' | 'Front office'            | 'Basic Price Types' | 'Boots' | '36/18SD'  | 'No'                 | ''                   | '5,000' | 'Boots (12 pcs)' | '6 406,78'   | '8 400,00' | '18%' | ''              | '35 593,22'  | '42 000,00'    | ''                    | 'Store 02' | '27.01.2021'    | 'No'                        | ''       | ''            | 'Revenue'      |

// 		And "ObjectCurrencies" table became equal
// 			| 'Movement type'      | 'Type'         | 'Currency from' | 'Currency' | 'Rate presentation' | 'Multiplicity' | 'Amount'   |
// 			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1'            | '44 095'   |
// 			| 'Local currency'     | 'Legal'        | 'TRY'           | 'TRY'      | '1'                 | '1'            | '44 095'   |
// 			| 'Reporting currency' | 'Reporting'    | 'TRY'           | 'USD'      | '0,1712'            | '1'            | '7 549,06' |

// 		Then the form attribute named "Branch" became equal to ""
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


Scenario: _028509 create Sales return without bases document
	* Opening a form to create Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100" text in "Q" field of "ItemList" table
		And I input "200" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200" text in "Q" field of "ItemList" table
		And I input "210" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		And I select current line in "ItemList" table
		And I input "300" text in "Q" field of "ItemList" table
		And I input "250" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Q'       | 'Item key'  | 'Store'    | 'Unit' |
			| 'Dress'    | '100,000' | 'M/White'   | 'Store 01' | 'pcs'  |
			| 'Dress'    | '200,000' | 'L/Green'   | 'Store 01' | 'pcs'  |
			| 'Trousers' | '300,000' | '36/Yellow' | 'Store 01' | 'pcs'  |
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn028509$$" variable
		And I delete "$$SalesReturn028509$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn028509$$"
		And I save the window as "$$SalesReturn028509$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberSalesReturn028509$$' |
		And I close all client application windows

Scenario: _028510 check filling in Row Id info table in the SR
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberSalesReturn028509$$' |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1SalesReturn028509$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2SalesReturn028509$$"
		And I go to line in "ItemList" table
			| '#' |
			| '3' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3SalesReturn028509$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                       | 'Basis' | 'Row ID'                    | 'Next step' | 'Q'       | 'Basis key' | 'Current step' | 'Row ref'                   |
			| '$$Rov1SalesReturn028509$$' | ''      | '$$Rov1SalesReturn028509$$' | ''          | '100,000' | ''          | ''             | '$$Rov1SalesReturn028509$$' |
			| '$$Rov2SalesReturn028509$$' | ''      | '$$Rov2SalesReturn028509$$' | ''          | '200,000' | ''          | ''             | '$$Rov2SalesReturn028509$$' |
			| '$$Rov3SalesReturn028509$$' | ''      | '$$Rov3SalesReturn028509$$' | ''          | '300,000' | ''          | ''             | '$$Rov3SalesReturn028509$$' |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Q'     |
			| '2' | 'Dress' | 'L/Green'  | '200,000' |
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "208,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' |
			| '4' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov4SalesReturn028509$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                       | 'Basis' | 'Row ID'                    | 'Next step' | 'Q'       | 'Basis key' | 'Current step' | 'Row ref'                   |
			| '$$Rov1SalesReturn028509$$' | ''      | '$$Rov1SalesReturn028509$$' | ''          | '100,000' | ''          | ''             | '$$Rov1SalesReturn028509$$' |
			| '$$Rov2SalesReturn028509$$' | ''      | '$$Rov2SalesReturn028509$$' | ''          | '200,000' | ''          | ''             | '$$Rov2SalesReturn028509$$' |
			| '$$Rov3SalesReturn028509$$' | ''      | '$$Rov3SalesReturn028509$$' | ''          | '300,000' | ''          | ''             | '$$Rov3SalesReturn028509$$' |
			| '$$Rov4SalesReturn028509$$' | ''      | '$$Rov4SalesReturn028509$$' | ''          | '208,000' | ''          | ''             | '$$Rov4SalesReturn028509$$' |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                       | 'Basis' | 'Row ID'                    | 'Next step' | 'Q'       | 'Basis key' | 'Current step' | 'Row ref'                   |
			| '$$Rov2SalesReturn028509$$' | ''      | '$$Rov2SalesReturn028509$$' | ''          | '208,000' | ''          | ''             | '$$Rov2SalesReturn028509$$' |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Q'       |
			| '4' | 'Dress' | 'L/Green'  | '208,000' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                       | 'Basis' | 'Row ID'                    | 'Next step' | 'Q'       | 'Basis key' | 'Current step' | 'Row ref'                   |
			| '$$Rov1SalesReturn028509$$' | ''      | '$$Rov1SalesReturn028509$$' | ''          | '100,000' | ''          | ''             | '$$Rov1SalesReturn028509$$' |
			| '$$Rov2SalesReturn028509$$' | ''      | '$$Rov2SalesReturn028509$$' | ''          | '200,000' | ''          | ''             | '$$Rov2SalesReturn028509$$' |
			| '$$Rov3SalesReturn028509$$' | ''      | '$$Rov3SalesReturn028509$$' | ''          | '300,000' | ''          | ''             | '$$Rov3SalesReturn028509$$' |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Q'     |
			| '2' | 'Dress' | 'L/Green'  | '200,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                       | 'Basis' | 'Row ID'                    | 'Next step' | 'Q'       | 'Basis key' | 'Current step' | 'Row ref'                   |
			| '$$Rov1SalesReturn028509$$' | ''      | '$$Rov1SalesReturn028509$$' | ''          | '100,000' | ''          | ''             | '$$Rov1SalesReturn028509$$' |
			| '$$Rov2SalesReturn028509$$' | ''      | '$$Rov2SalesReturn028509$$' | ''          | '7,000'   | ''          | ''             | '$$Rov2SalesReturn028509$$' |
			| '$$Rov3SalesReturn028509$$' | ''      | '$$Rov3SalesReturn028509$$' | ''          | '300,000' | ''          | ''             | '$$Rov3SalesReturn028509$$' |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Q'     |
			| '2' | 'Dress' | 'L/Green'  | '7,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
		
	
Scenario: _028511 copy SR and check filling in Row Id info table
	* Copy SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberSalesReturn028509$$' |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#' | 'Profit loss center' | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Q'       | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Net amount' |
			| '1' | ''              | 'Dress'    | 'M/White'   | 'No'                 | '100,000' | 'pcs'  | '3 050,85'   | '200,00' | '18%' | ''              | '20 000,00'    | ''                    | 'Store 01' | ''             | '16 949,15'  |
			| '2' | ''              | 'Dress'    | 'L/Green'   | 'No'                 | '200,000' | 'pcs'  | '6 406,78'   | '210,00' | '18%' | ''              | '42 000,00'    | ''                    | 'Store 01' | ''             | '35 593,22'  |
			| '3' | ''              | 'Trousers' | '36/Yellow' | 'No'                 | '300,000' | 'pcs'  | '11 440,68'  | '250,00' | '18%' | ''              | '75 000,00'    | ''                    | 'Store 01' | ''             | '63 559,32'  |
		And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'         | 'Currency from' | 'Currency' | 'Rate presentation' | 'Multiplicity' | 'Amount'    |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1'            | '137 000'   |
			| 'Local currency'     | 'Legal'        | 'TRY'           | 'TRY'      | '1'                 | '1'            | '137 000'   |
			| 'Reporting currency' | 'Reporting'    | 'TRY'           | 'USD'      | '0,1712'            | '1'            | '23 454,40' |
		Then the form attribute named "Branch" became equal to ""
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post SR and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                       | 'Basis' | 'Row ID'                    | 'Next step' | 'Q'       | 'Basis key' | 'Current step' | 'Row ref'                   |
			| '$$Rov1SalesReturn028509$$' | ''      | '$$Rov1SalesReturn028509$$' | ''        | '100,000' | ''          | ''             | '$$Rov1SalesReturn028509$$' |
			| '$$Rov2SalesReturn028509$$' | ''      | '$$Rov2SalesReturn028509$$' | ''        | '200,000' | ''          | ''             | '$$Rov2SalesReturn028509$$' |
			| '$$Rov3SalesReturn028509$$' | ''      | '$$Rov3SalesReturn028509$$' | ''        | '300,000' | ''          | ''             | '$$Rov3SalesReturn028509$$' |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows

Scenario: _028515 create document Sales return based on SRO 
	* Save Sales return order Row id
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '105' | 
		And I select current line in "List" table
		And I click "Show row key" button	
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov1SalesReturnOrder028515$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov2SalesReturnOrder028515$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '106' | 
		And I select current line in "List" table
		And I click "Show row key" button	
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov3SalesReturnOrder028515$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov4SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov4SalesReturnOrder028515$$"
		And I close all client application windows
	* Add items from basis documents
		* Open form for create Sales return
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Kalipso' | 
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Company Kalipso' | 
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Basic Partner terms, TRY' | 
			And I select current line in "List" table
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And "BasisesTree" table contains lines
				| 'Row presentation'                                 | 'Use'                                              | 'Quantity' | 'Unit'           | 'Price'    | 'Currency' |
				| 'Sales return order 105 dated 25.03.2021 12:09:40' | 'No'                                               | ''         | ''               | ''         | ''         |
				| 'Dress, XS/Blue'                                   | 'No'                                               | '1,000'    | 'pcs'            | '520,00'   | 'TRY'      |
				| 'Boots, 37/18SD'                                   | 'No'                                               | '3,000'    | 'Boots (12 pcs)' | '8 400,00' | 'TRY'      |
				| 'Sales return order 106 dated 25.03.2021 12:10:03' | 'No'                                               | ''         | ''               | ''         | ''         |
				| 'Dress, XS/Blue'                                   | 'No'                                               | '12,000'   | 'pcs'            | '520,00'   | 'TRY'      |
				| 'Boots, 37/18SD'                                   | 'No'                                               | '11,000'   | 'Boots (12 pcs)' | '8 400,00' | 'TRY'      |
			// Then the number of "BasisesTree" table lines is "равно" "6"
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
				| '12,000'    | 'Dress, XS/Blue'   | 'pcs'  | 'No'  |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
				| '1,000'    | 'Dress, XS/Blue'   | 'pcs'  | 'No'  |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1SalesReturn028515$$" variable	
			And I save the current field value as "$$Rov1SalesReturn028515$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '2' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2SalesReturn028515$$" variable	
			And I save the current field value as "$$Rov2SalesReturn028515$$"			
		* Check Item tab and RowID tab
			And "ItemList" table contains lines
				| 'Key'                       | 'Store'    | 'Additional analytic' | 'Quantity in base unit' | '#' | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Use goods receipt' | 'Total amount' | 'Sales return order'                               | 'Sales invoice' | 'Revenue type' |
				| '$$Rov1SalesReturn028515$$' | 'Store 02' | ''                    | '1,000'                 | '1' | 'Dress' | 'XS/Blue'  | 'No'                 | ''                   | '1,000'  | 'pcs'  | '79,32'      | '520,00' | '18%' | ''              | '440,68'     | 'No'                | '520,00'       | 'Sales return order 105 dated 25.03.2021 12:09:40' | ''              | 'Expense'      |
				| '$$Rov2SalesReturn028515$$' | 'Store 02' | ''                    | '12,000'                | '2' | 'Dress' | 'XS/Blue'  | 'No'                 | ''                   | '12,000' | 'pcs'  | '951,86'     | '520,00' | '18%' | ''              | '5 288,14'   | 'No'                | '6 240,00'     | 'Sales return order 106 dated 25.03.2021 12:10:03' | ''              | ''             |
			And "RowIDInfo" table contains lines
				| '#' | 'Key'                       | 'Basis'                                            | 'Row ID'                         | 'Next step' | 'Q'      | 'Basis key'                      | 'Current step' | 'Row ref'                        |
				| '1' | '$$Rov1SalesReturn028515$$' | 'Sales return order 105 dated 25.03.2021 12:09:40' | '$$Rov1SalesReturnOrder028515$$' | ''          | '1,000'  | '$$Rov1SalesReturnOrder028515$$' | 'SR'           | '$$Rov1SalesReturnOrder028515$$' |
				| '2' | '$$Rov2SalesReturn028515$$' | 'Sales return order 106 dated 25.03.2021 12:10:03' | '$$Rov3SalesReturnOrder028515$$' | ''          | '12,000' | '$$Rov3SalesReturnOrder028515$$' | 'SR'           | '$$Rov3SalesReturnOrder028515$$' |
			Then the number of "RowIDInfo" table lines is "равно" "2"
			* Set checkbox Use GR and check RowID tab
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| '#' |
					| '1' |
				And I activate "Use goods receipt" field in "ItemList" table
				And I set "Use goods receipt" checkbox in "ItemList" table
				And I finish line editing in "ItemList" table
				And I click "Save" button
				And "RowIDInfo" table contains lines
					| '#' | 'Key'                       | 'Basis'                                            | 'Row ID'                         | 'Next step' | 'Q'      | 'Basis key'                      | 'Current step' | 'Row ref'                        |
					| '1' | '$$Rov1SalesReturn028515$$' | 'Sales return order 105 dated 25.03.2021 12:09:40' | '$$Rov1SalesReturnOrder028515$$' | 'GR'        | '1,000'  | '$$Rov1SalesReturnOrder028515$$' | 'SR'           | '$$Rov1SalesReturnOrder028515$$' |
					| '2' | '$$Rov2SalesReturn028515$$' | 'Sales return order 106 dated 25.03.2021 12:10:03' | '$$Rov3SalesReturnOrder028515$$' | ''          | '12,000' | '$$Rov3SalesReturnOrder028515$$' | 'SR'           | '$$Rov3SalesReturnOrder028515$$' |
				Then the number of "RowIDInfo" table lines is "равно" "2"
		And I close all client application windows
	* Create Sales return based on Sales return order(Create button)
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '105' |
		And I click the button named "FormDocumentSalesReturnGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"		
		And I click "Show row key" button	
		And "ItemList" table contains lines
			| 'Store'    | 'Additional analytic' | 'Quantity in base unit' | '#' | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Use goods receipt' | 'Total amount' | 'Sales return order'                               | 'Sales invoice' | 'Revenue type' |
			| 'Store 02' | ''                    | '1,000'                 | '1' | 'Dress' | 'XS/Blue'  | 'No'                 | ''                   | '1,000' | 'pcs'            | '79,32'      | '520,00'   | '18%' | ''              | '440,68'     | 'No'                | '520,00'       | 'Sales return order 105 dated 25.03.2021 12:09:40' | ''              | 'Expense'      |
			| 'Store 02' | ''                    | '36,000'                | '2' | 'Boots' | '37/18SD'  | 'No'                 | ''                   | '3,000' | 'Boots (12 pcs)' | '3 844,07'   | '8 400,00' | '18%' | ''              | '21 355,93'  | 'No'                | '25 200,00'    | 'Sales return order 105 dated 25.03.2021 12:09:40' | ''              | 'Expense'      |
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesReturn028515$$" variable
		And I save the current field value as "$$Rov1SalesReturn028515$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2SalesReturn028515$$" variable
		And I save the current field value as "$$Rov2SalesReturn028515$$"	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                       | 'Basis'                                            | 'Row ID'                         | 'Next step' | 'Q'      | 'Basis key'                      | 'Current step' | 'Row ref'                        |
			| '1' | '$$Rov1SalesReturn028515$$' | 'Sales return order 105 dated 25.03.2021 12:09:40' | '$$Rov1SalesReturnOrder028515$$' | ''          | '1,000'  | '$$Rov1SalesReturnOrder028515$$' | 'SR'           | '$$Rov1SalesReturnOrder028515$$' |
			| '2' | '$$Rov2SalesReturn028515$$' | 'Sales return order 105 dated 25.03.2021 12:09:40' | '$$Rov2SalesReturnOrder028515$$' | ''          | '36,000' | '$$Rov2SalesReturnOrder028515$$' | 'SR'           | '$$Rov2SalesReturnOrder028515$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn028515$$" variable
		And I delete "$$SalesReturn028515$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn028515$$"
		And I save the window as "$$SalesReturn028515$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberSalesReturn028515$$' |
		And I close all client application windows







Scenario: _028534 check totals in the document Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Select Sales Return
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturn028509$$'     |
		And I select current line in "List" table
	* Check totals in the document Sales return
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"



Scenario: _300511 check connection to SalesReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Form report Related documents
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturn028509$$'      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session