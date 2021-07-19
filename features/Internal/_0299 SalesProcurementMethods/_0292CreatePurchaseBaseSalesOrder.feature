#language: en
@tree
@Positive
@SalesOrderProcurement

Feature: create Purchase order based on a Sales order

As a sales manager
I want to create Purchase order based on a Sales order
To implement a sales-for-purchase scheme


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029200 preparation (create Purchase order based on a Sales order)
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
		When  Create catalog Partners objects (Lomaniti)
		When  Create catalog Partners objects (Ferron BP)
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
	When Create document SalesOrder objects (check SalesOrderProcurement)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(501).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.SalesOrder.FindByNumber(502).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.SalesOrder.FindByNumber(503).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _029201 create Purchase order based on Sales order
	* Create Purchase order based on Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                     |
			| '501' |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseOrderGenerate"
		And "BasisesTree" table contains lines
			| 'Row presentation'                          | 'Use'                                       | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 501 dated 30.03.2021 11:56:21' | 'Sales order 501 dated 30.03.2021 11:56:21' | ''         | ''     | ''       | ''         |
			| 'Trousers, 38/Yellow'                       | 'Yes'                                       | '5,000'    | 'pcs'  | '338,98' | 'TRY'      |
			| 'Shirt, 38/Black'                           | 'Yes'                                       | '2,000'    | 'pcs'  | '296,61' | 'TRY'      |
			| 'Sales order 502 dated 30.03.2021 11:56:28' | 'Sales order 502 dated 30.03.2021 11:56:28' | ''         | ''     | ''       | ''         |
			| 'Trousers, 38/Yellow'                       | 'Yes'                                       | '8,000'    | 'pcs'  | '400,00' | 'TRY'      |
			| 'Shirt, 38/Black'                           | 'Yes'                                       | '11,000'   | 'pcs'  | '350,00' | 'TRY'      |
			| 'Dress, M/White'                            | 'Yes'                                       | '8,000'    | 'pcs'  | '520,00' | 'TRY'      |
		Then the number of "BasisesTree" table lines is "равно" "7"
		And I click "Ok" button
	* Filling in main info
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'                     |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, USD' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "10,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Price type'        | 'Q'     |
			| 'Trousers' | '38/Yellow' | 'Vendor price, USD' | '8,000' |
		And I select current line in "ItemList" table
		And I input "15,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Shirt' | '38/Black' | 'Vendor price, USD' | '2,000' |
		And I select current line in "ItemList" table
		And I input "20,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price type'        | 'Q'      |
			| 'Shirt' | '38/Black' | 'Vendor price, USD' | '11,000' |
		And I select current line in "ItemList" table
		And I input "20,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | 'M/White'  | 'Vendor price, USD' | '8,000' |
		And I select current line in "ItemList" table
		And I input "21,00" text in "Price" field of "ItemList" table
		And I input "15,00" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I select "Approved" exact value from "Status" drop-down list
	* Add items from SO 503
		And I click "AddBasisDocuments" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '10,000'   | 'Dress, XS/Blue'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'    | 'Unit' | 'Use' |
			| 'TRY'      | '400,00' | '5,000'    | 'Trousers, 36/Yellow' | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'    | 'Unit' | 'Use' |
			| 'TRY'      | '400,00' | '10,000'   | 'Trousers, 38/Yellow' | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'XS/Blue'  | '10,000' |
		And I select current line in "ItemList" table
		And I input "17,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '36/Yellow' | '5,000' |
		And I select current line in "ItemList" table
		And I input "18,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'      |
			| 'Trousers' | '38/Yellow' | '10,000' |
		And I select current line in "ItemList" table
		And I input "20,00" text in "Price" field of "ItemList" table
		And I input "20,00" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add one more item
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'            |
			| 'High shoes box (8 pcs)' |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "14,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov1PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov2PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '3' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov3PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '4' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov4PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov4PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '5' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov5PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov5PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '6' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov6PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov6PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '7' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov7PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov7PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '8' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov8PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov8PurchaseOrder029201$$"
		And I go to line in "ItemList" table
			| '#' |
			| '9' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov9PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov9PurchaseOrder029201$$"		
	* Check Row ID tab
		And I click the button named "FormPost"
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'  | 'Q'      | 'Unit'                   | 'Tax amount' | 'Price' | 'VAT' | 'Net amount' | 'Total amount' | 'Sales order'                               | 'Purchase basis'                            |
			| 'Trousers'   | '38/Yellow' | '5,000'  | 'pcs'                    | '7,63'       | '10,00' | '18%' | '42,37'      | '50,00'        | 'Sales order 501 dated 30.03.2021 11:56:21' | 'Sales order 501 dated 30.03.2021 11:56:21' |
			| 'Trousers'   | '38/Yellow' | '8,000'  | 'pcs'                    | '18,31'      | '15,00' | '18%' | '101,69'     | '120,00'       | 'Sales order 502 dated 30.03.2021 11:56:28' | 'Sales order 502 dated 30.03.2021 11:56:28' |
			| 'Shirt'      | '38/Black'  | '2,000'  | 'pcs'                    | '6,10'       | '20,00' | '18%' | '33,90'      | '40,00'        | 'Sales order 501 dated 30.03.2021 11:56:21' | 'Sales order 501 dated 30.03.2021 11:56:21' |
			| 'Shirt'      | '38/Black'  | '11,000' | 'pcs'                    | '33,56'      | '20,00' | '18%' | '186,44'     | '220,00'       | 'Sales order 502 dated 30.03.2021 11:56:28' | 'Sales order 502 dated 30.03.2021 11:56:28' |
			| 'Dress'      | 'M/White'   | '15,000' | 'pcs'                    | '48,05'      | '21,00' | '18%' | '266,95'     | '315,00'       | 'Sales order 502 dated 30.03.2021 11:56:28' | 'Sales order 502 dated 30.03.2021 11:56:28' |
			| 'Dress'      | 'XS/Blue'   | '10,000' | 'pcs'                    | '25,93'      | '17,00' | '18%' | '144,07'     | '170,00'       | 'Sales order 503 dated 30.03.2021 11:57:06' | 'Sales order 503 dated 30.03.2021 11:57:06' |
			| 'Trousers'   | '36/Yellow' | '5,000'  | 'pcs'                    | '13,73'      | '18,00' | '18%' | '76,27'      | '90,00'        | 'Sales order 503 dated 30.03.2021 11:57:06' | 'Sales order 503 dated 30.03.2021 11:57:06' |
			| 'Trousers'   | '38/Yellow' | '20,000' | 'pcs'                    | '61,02'      | '20,00' | '18%' | '338,98'     | '400,00'       | 'Sales order 503 dated 30.03.2021 11:57:06' | 'Sales order 503 dated 30.03.2021 11:57:06' |
			| 'High shoes' | '37/19SD'   | '5,000'  | 'High shoes box (8 pcs)' | '85,42'      | '14,00' | '18%' | '474,58'     | '560,00'       | ''                                          | ''                                          |
		And "RowIDInfo" table contains lines
			| 'Key' | 'Basis'                                     | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '*'   | 'Sales order 501 dated 30.03.2021 11:56:21' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PI&GR'     | '5,000'  | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PO&PI'        | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' |
			| '*'   | 'Sales order 502 dated 30.03.2021 11:56:28' | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'PI&GR'     | '8,000'  | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'PO&PI'        | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' |
			| '*'   | 'Sales order 501 dated 30.03.2021 11:56:21' | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'PI&GR'     | '2,000'  | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'PO&PI'        | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' |
			| '*'   | 'Sales order 502 dated 30.03.2021 11:56:28' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'PI&GR'     | '11,000' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'PO&PI'        | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' |
			| '*'   | 'Sales order 502 dated 30.03.2021 11:56:28' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'PI&GR'     | '15,000' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'PO&PI'        | '4a003d08-12af-4c34-98d5-5cdeb84616de' |
			| '*'   | 'Sales order 503 dated 30.03.2021 11:57:06' | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'PI&GR'     | '10,000' | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'PO&PI'        | '323ed282-6c37-4443-b3b5-6abd5531e1b7' |
			| '*'   | 'Sales order 503 dated 30.03.2021 11:57:06' | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'PI&GR'     | '5,000'  | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'PO&PI'        | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' |
			| '*'   | 'Sales order 503 dated 30.03.2021 11:57:06' | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PI&GR'     | '20,000' | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PO&PI'        | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' |
			| '*'   | ''                                          | '$$Rov9PurchaseOrder029201$$'          | 'PI&GR'     | '40,000' | ''                                     | ''             | '$$Rov9PurchaseOrder029201$$'          |
		Then the number of "RowIDInfo" table lines is "равно" "9"

		And I delete "$$NumberPurchaseOrder029201$$" variable
		And I delete "$$PurchaseOrder029201$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029201$$"
		And I save the window as "$$PurchaseOrder029201$$"
		And I click the button named "FormPostAndClose"

Scenario: _029202 create PI and GR based on PO that based on SO
	* Create PI-GR
		* Select PO
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder029201$$'      |
		* Create PI
			And I click the button named "FormDocumentPurchaseInvoiceGenerate"
			And I go to line in "BasisesTree" table
				| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'    | 'Unit' | 'Use' |
				| 'TRY'      | '400,00' | '20,000'   | 'Trousers, 38/Yellow' | 'pcs'  | 'Yes' |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And "ItemList" table contains lines
				| '#' | 'Business unit' | 'Price type'              | 'Item'       | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit'                   | 'Serial lot numbers' | 'Q'      | 'Price' | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order'                             | 'Detail' | 'Sales order'                               | 'Net amount' | 'Use goods receipt' |
				| '1' | ''              | 'en description is empty' | 'Trousers'   | '38/Yellow' | 'No'                 | '7,63'       | 'pcs'                    | ''                   | '5,000'  | '10,00' | '18%' | ''              | '50,00'        | ''                    | ''                        | 'Store 02' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 501 dated 30.03.2021 11:56:21' | '42,37'      | 'Yes'               |
				| '2' | ''              | 'en description is empty' | 'Trousers'   | '38/Yellow' | 'No'                 | '18,31'      | 'pcs'                    | ''                   | '8,000'  | '15,00' | '18%' | ''              | '120,00'       | ''                    | ''                        | 'Store 01' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 502 dated 30.03.2021 11:56:28' | '101,69'     | 'No'                |
				| '3' | ''              | 'en description is empty' | 'Shirt'      | '38/Black'  | 'No'                 | '6,10'       | 'pcs'                    | ''                   | '2,000'  | '20,00' | '18%' | ''              | '40,00'        | ''                    | ''                        | 'Store 02' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 501 dated 30.03.2021 11:56:21' | '33,90'      | 'Yes'               |
				| '4' | ''              | 'en description is empty' | 'Shirt'      | '38/Black'  | 'No'                 | '33,56'      | 'pcs'                    | ''                   | '11,000' | '20,00' | '18%' | ''              | '220,00'       | ''                    | ''                        | 'Store 01' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 502 dated 30.03.2021 11:56:28' | '186,44'     | 'No'                |
				| '5' | ''              | 'en description is empty' | 'Dress'      | 'M/White'   | 'No'                 | '48,05'      | 'pcs'                    | ''                   | '15,000' | '21,00' | '18%' | ''              | '315,00'       | ''                    | ''                        | 'Store 01' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 502 dated 30.03.2021 11:56:28' | '266,95'     | 'No'                |
				| '6' | ''              | 'en description is empty' | 'Dress'      | 'XS/Blue'   | 'No'                 | '25,93'      | 'pcs'                    | ''                   | '10,000' | '17,00' | '18%' | ''              | '170,00'       | ''                    | ''                        | 'Store 02' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 503 dated 30.03.2021 11:57:06' | '144,07'     | 'Yes'               |
				| '7' | ''              | 'en description is empty' | 'Trousers'   | '36/Yellow' | 'No'                 | '13,73'      | 'pcs'                    | ''                   | '5,000'  | '18,00' | '18%' | ''              | '90,00'        | ''                    | ''                        | 'Store 02' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 503 dated 30.03.2021 11:57:06' | '76,27'      | 'Yes'               |
				| '8' | ''              | 'en description is empty' | 'High shoes' | '37/19SD'   | 'No'                 | '85,42'      | 'High shoes box (8 pcs)' | ''                   | '5,000'  | '14,00' | '18%' | ''              | '560,00'       | ''                    | ''                        | 'Store 02' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | ''                                          | '474,58'     | 'Yes'               |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Price' | 'Q'     |
				| 'Trousers' | '38/Yellow' | '10,00' | '5,000' |
			And I select current line in "ItemList" table
			And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key'  | 'Price' | 'Q'     |
				| 'Dress' | 'M/White' | '21,00' | '15,000' |
			And I set "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table			
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Price' | 'Q'     |
				| 'Shirt' | '38/Black' | '20,00' | '2,000' |
			And I select current line in "ItemList" table
			And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I click "Post" button
			And I click "Show row key" button
			And "RowIDInfo" table contains lines
				| 'Key' | 'Basis'                   | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                   | 'Current step' | 'Row ref'                              |
				| '*'   | '$$PurchaseOrder029201$$' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'GR'        | '4,000'  | '$$Rov1PurchaseOrder029201$$' | 'PI&GR'        | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' |
				| '*'   | '$$PurchaseOrder029201$$' | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | ''          | '8,000'  | '$$Rov2PurchaseOrder029201$$' | 'PI&GR'        | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' |
				| '*'   | '$$PurchaseOrder029201$$' | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'GR'        | '3,000'  | '$$Rov3PurchaseOrder029201$$' | 'PI&GR'        | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' |
				| '*'   | '$$PurchaseOrder029201$$' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | ''          | '11,000' | '$$Rov4PurchaseOrder029201$$' | 'PI&GR'        | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' |
				| '*'   | '$$PurchaseOrder029201$$' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'GR'        | '15,000' | '$$Rov5PurchaseOrder029201$$' | 'PI&GR'        | '4a003d08-12af-4c34-98d5-5cdeb84616de' |
				| '*'   | '$$PurchaseOrder029201$$' | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'GR'        | '10,000' | '$$Rov6PurchaseOrder029201$$' | 'PI&GR'        | '323ed282-6c37-4443-b3b5-6abd5531e1b7' |
				| '*'   | '$$PurchaseOrder029201$$' | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'GR'        | '5,000'  | '$$Rov7PurchaseOrder029201$$' | 'PI&GR'        | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' |
				| '*'   | '$$PurchaseOrder029201$$' | '$$Rov9PurchaseOrder029201$$'          | 'GR'        | '40,000' | '$$Rov9PurchaseOrder029201$$' | 'PI&GR'        | '$$Rov9PurchaseOrder029201$$'          |
				| '*'   | '$$PurchaseOrder029201$$' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'SI&SC'     | '11,000' | '$$Rov4PurchaseOrder029201$$' | ''             | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' |
				| '*'   | '$$PurchaseOrder029201$$' | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'SI&SC'     | '8,000'  | '$$Rov2PurchaseOrder029201$$' | ''             | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' |
			Then the number of "RowIDInfo" table lines is "равно" "10"
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov1PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '2' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov2PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '3' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov3PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov3PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '4' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov4PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov4PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '5' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov5PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov5PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '6' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov6PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov6PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '7' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov7PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov7PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '8' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov8PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov8PurchaseInvoice0292021$$"
			And I delete "$$NumberPurchaseInvoice0292021$$" variable
			And I delete "$$PurchaseInvoice0292021$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0292021$$"
			And I save the window as "$$PurchaseInvoice0292021$$"
		* Create GR
			And I click the button named "FormDocumentGoodsReceiptGenerate"
			And I click "Ok" button
			And I click "Show row key" button
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov1GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '2' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov2GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '3' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov3GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov3GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '4' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov4GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov4GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '5' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov5GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov5GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '6' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov6GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov6GoodsReceipt0292021$$"	
			And "RowIDInfo" table contains lines
				| '#' | 'Key' | 'Basis'                      | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                      | 'Current step' | 'Row ref'                              |
				| '1' | '*'   | '$$PurchaseInvoice0292021$$' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | ''          | '4,000'  | '$$Rov1PurchaseInvoice0292021$$' | 'GR'           | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' |
				| '2' | '*'   | '$$PurchaseInvoice0292021$$' | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | ''          | '3,000'  | '$$Rov3PurchaseInvoice0292021$$' | 'GR'           | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' |
				| '3' | '*'   | '$$PurchaseInvoice0292021$$' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | ''          | '15,000' | '$$Rov5PurchaseInvoice0292021$$' | 'GR'           | '4a003d08-12af-4c34-98d5-5cdeb84616de' |
				| '4' | '*'   | '$$PurchaseInvoice0292021$$' | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | ''          | '10,000' | '$$Rov6PurchaseInvoice0292021$$' | 'GR'           | '323ed282-6c37-4443-b3b5-6abd5531e1b7' |
				| '5' | '*'   | '$$PurchaseInvoice0292021$$' | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | ''          | '5,000'  | '$$Rov7PurchaseInvoice0292021$$' | 'GR'           | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' |
				| '6' | '*'   | '$$PurchaseInvoice0292021$$' | '$$Rov9PurchaseOrder029201$$'          | ''          | '40,000' | '$$Rov8PurchaseInvoice0292021$$' | 'GR'           | '$$Rov9PurchaseOrder029201$$'          |
			Then the number of "RowIDInfo" table lines is "равно" "6"
			And I click "Post" button
			And I delete "$$NumberGoodsReceipt0292021$$" variable
			And I delete "$$GoodsReceipt0292021$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0292021$$"
			And I save the window as "$$GoodsReceipt0292021$$"
			And I click the button named "FormPostAndClose"
	* Create GR-PI
		* Select PO
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder029201$$'      |
		* Create GR
			And I click the button named "FormDocumentGoodsReceiptGenerate"
			And "BasisesTree" table contains lines
				| 'Row presentation'                          | 'Use'                                       | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
				| 'Sales order 501 dated 30.03.2021 11:56:21' | 'Sales order 501 dated 30.03.2021 11:56:21' | ''         | ''     | ''       | ''         |
				| '$$PurchaseOrder029201$$'                   | '$$PurchaseOrder029201$$'                   | ''         | ''     | ''       | ''         |
				| 'Trousers, 38/Yellow'                       | 'Yes'                                       | '1,000'    | 'pcs'  | '338,98' | 'TRY'      |
				| 'Sales order 503 dated 30.03.2021 11:57:06' | 'Sales order 503 dated 30.03.2021 11:57:06' | ''         | ''     | ''       | ''         |
				| '$$PurchaseOrder029201$$'                   | '$$PurchaseOrder029201$$'                   | ''         | ''     | ''       | ''         |
				| 'Trousers, 38/Yellow'                       | 'Yes'                                       | '20,000'   | 'pcs'  | '400,00' | 'TRY'      |
			Then the number of "BasisesTree" table lines is "равно" "6"
			And I click "Ok" button
			And "ItemList" table contains lines
				| '#' | 'Item'     | 'Inventory transfer' | 'Item key'  | 'Store'    | 'Internal supply request' | 'Quantity' | 'Sales invoice' | 'Unit' | 'Receipt basis'           | 'Purchase invoice' | 'Currency' | 'Sales return order' | 'Sales order'                               | 'Purchase order'          | 'Inventory transfer order' | 'Sales return' |
				| '1' | 'Trousers' | ''                   | '38/Yellow' | 'Store 02' | ''                        | '1,000'    | ''              | 'pcs'  | '$$PurchaseOrder029201$$' | ''                 | 'USD'      | ''                   | 'Sales order 501 dated 30.03.2021 11:56:21' | '$$PurchaseOrder029201$$' | ''                         | ''             |
				| '2' | 'Trousers' | ''                   | '38/Yellow' | 'Store 02' | ''                        | '20,000'   | ''              | 'pcs'  | '$$PurchaseOrder029201$$' | ''                 | 'USD'      | ''                   | 'Sales order 503 dated 30.03.2021 11:57:06' | '$$PurchaseOrder029201$$' | ''                         | ''             |
			And I click "Show row key" button
			And "RowIDInfo" table contains lines
				| '#' | 'Key' | 'Basis'                   | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                   | 'Current step' | 'Row ref'                              |
				| '1' | '*'   | '$$PurchaseOrder029201$$' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | ''          | '1,000'  | '$$Rov1PurchaseOrder029201$$' | 'PI&GR'        | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' |
				| '2' | '*'   | '$$PurchaseOrder029201$$' | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | ''          | '20,000' | '$$Rov8PurchaseOrder029201$$' | 'PI&GR'        | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' |
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1GoodsReceipt0292022$$" variable
			And I save the current field value as "$$Rov1GoodsReceipt0292022$$"	
			And I go to line in "ItemList" table
				| '#' |
				| '2' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2GoodsReceipt0292022$$" variable
			And I save the current field value as "$$Rov2GoodsReceipt0292022$$"	
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0292022$$" variable
			And I delete "$$GoodsReceipt0292022$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0292022$$"
			And I save the window as "$$GoodsReceipt0292022$$"
		* Create PI
			And I click the button named "FormDocumentPurchaseInvoiceGenerate"
			And "BasisesTree" table contains lines
				| 'Row presentation'                          | 'Use'                                       | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
				| 'Sales order 501 dated 30.03.2021 11:56:21' | 'Sales order 501 dated 30.03.2021 11:56:21' | ''         | ''     | ''       | ''         |
				| '$$PurchaseOrder029201$$'                   | '$$PurchaseOrder029201$$'                   | ''         | ''     | ''       | ''         |
				| '$$GoodsReceipt0292022$$'                   | '$$GoodsReceipt0292022$$'                   | ''         | ''     | ''       | ''         |
				| 'Trousers, 38/Yellow'                       | 'Yes'                                       | '1,000'    | 'pcs'  | '338,98' | 'TRY'      |
				| 'Sales order 503 dated 30.03.2021 11:57:06' | 'Sales order 503 dated 30.03.2021 11:57:06' | ''         | ''     | ''       | ''         |
				| '$$PurchaseOrder029201$$'                   | '$$PurchaseOrder029201$$'                   | ''         | ''     | ''       | ''         |
				| '$$GoodsReceipt0292022$$'                   | '$$GoodsReceipt0292022$$'                   | ''         | ''     | ''       | ''         |
				| 'Trousers, 38/Yellow'                       | 'Yes'                                       | '20,000'   | 'pcs'  | '400,00' | 'TRY'      |
			Then the number of "BasisesTree" table lines is "равно" "8"
			And I click "Ok" button
			And "ItemList" table contains lines
				| '#' | 'Business unit' | 'Price type'              | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Q'      | 'Price' | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order'                             | 'Detail' | 'Sales order'                               | 'Net amount' | 'Use goods receipt' |
				| '1' | ''              | 'en description is empty' | 'Trousers' | '38/Yellow' | 'No'                 | '1,53'       | 'pcs'  | ''                   | '1,000'  | '10,00' | '18%' | ''              | '10,00'        | ''                    | ''                        | 'Store 02' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 501 dated 30.03.2021 11:56:21' | '8,47'       | 'Yes'               |
				| '2' | ''              | 'en description is empty' | 'Trousers' | '38/Yellow' | 'No'                 | '61,02'      | 'pcs'  | ''                   | '20,000' | '20,00' | '18%' | ''              | '400,00'       | ''                    | ''                        | 'Store 02' | ''              | ''             | '$$PurchaseOrder029201$$' | ''       | 'Sales order 503 dated 30.03.2021 11:57:06' | '338,98'     | 'Yes'               |
			And "GoodsReceiptsTree" table contains lines
				| 'Item'     | 'Item key'  | 'Goods receipt'           | 'Invoice' | 'GR'     | 'Q'      |
				| 'Trousers' | '38/Yellow' | ''                        | '1,000'   | '1,000'  | '1,000'  |
				| ''         | ''          | '$$GoodsReceipt0292022$$' | ''        | '1,000'  | '1,000'  |
				| 'Trousers' | '38/Yellow' | ''                        | '20,000'  | '20,000' | '20,000' |
				| ''         | ''          | '$$GoodsReceipt0292022$$' | ''        | '20,000' | '20,000' |
			And I click "Show row key" button
			And "RowIDInfo" table contains lines
				| '#' | 'Key' | 'Basis'                   | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                   | 'Current step' | 'Row ref'                              |
				| '1' | '*'   | '$$GoodsReceipt0292022$$' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | ''          | '1,000'  | '$$Rov1GoodsReceipt0292022$$' | 'PI'           | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' |
				| '2' | '*'   | '$$GoodsReceipt0292022$$' | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | ''          | '20,000' | '$$Rov2GoodsReceipt0292022$$' | 'PI'           | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0292022$$" variable
			And I delete "$$PurchaseInvoice0292022$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0292022$$"
			And I save the window as "$$PurchaseInvoice0292022$$"
			And I close all client application windows
			

Scenario: _029203 create SI-SC based on SO (with procurement method - purchase)
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' |
		| '502'      |
	* Create SI
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I delete a line in "ItemList" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesInvoice029203$$" variable
		And I save the current field value as "$$Rov1SalesInvoice029203$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2SalesInvoice029203$$" variable
		And I save the current field value as "$$Rov2SalesInvoice029203$$"	
		And I go to line in "ItemList" table
			| '#' |
			| '3' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3SalesInvoice029203$$" variable
		And I save the current field value as "$$Rov3SalesInvoice029203$$"	
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black'  |
		And I activate "Use shipment confirmation" field in "ItemList" table
		And I set "Use shipment confirmation" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		* Check ItemList tab
			And "ItemList" table contains lines
				| 'Key'                        | 'Store'    | 'Additional analytic' | 'Quantity in base unit' | '#' | 'Business unit' | 'Price type'              | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Serial lot numbers' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                               | 'Revenue type' |
				| '$$Rov1SalesInvoice029203$$' | 'Store 01' | ''                    | '2,000'                 | '1' | ''              | 'en description is empty' | 'Service'  | 'Interner'  | 'No'                 | ''                   | '2,000'  | 'pcs'  | '30,51'      | '100,00' | '18%' | ''              | '169,49'     | '200,00'       | '31.03.2021'    | 'No'                        | ''       | 'Sales order 502 dated 30.03.2021 11:56:28' | ''             |
				| '$$Rov2SalesInvoice029203$$' | 'Store 01' | ''                    | '8,000'                 | '2' | ''              | 'Basic Price Types'       | 'Trousers' | '38/Yellow' | 'No'                 | ''                   | '8,000'  | 'pcs'  | '488,14'     | '400,00' | '18%' | ''              | '2 711,86'   | '3 200,00'     | '31.03.2021'    | 'No'                        | ''       | 'Sales order 502 dated 30.03.2021 11:56:28' | ''             |
				| '$$Rov3SalesInvoice029203$$' | 'Store 01' | ''                    | '11,000'                | '3' | ''              | 'Basic Price Types'       | 'Shirt'    | '38/Black'  | 'No'                 | ''                   | '11,000' | 'pcs'  | '587,29'     | '350,00' | '18%' | ''              | '3 262,71'   | '3 850,00'     | '31.03.2021'    | 'Yes'                       | ''       | 'Sales order 502 dated 30.03.2021 11:56:28' | ''             |
			Then the number of "ItemList" table lines is "равно" "3"
		* Check RowIDInfo tab
			And "RowIDInfo" table contains lines
				| '#' | 'Key'                        | 'Basis'                                     | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
				| '1' | '$$Rov1SalesInvoice029203$$' | 'Sales order 502 dated 30.03.2021 11:56:28' | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7' | ''          | '2,000'  | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7' | 'SI'           | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7' |
				| '2' | '$$Rov2SalesInvoice029203$$' | '$$PurchaseInvoice0292021$$'                | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | ''          | '8,000'  | '$$Rov2PurchaseInvoice0292021$$'       | 'SI&SC'        | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' |
				| '3' | '$$Rov3SalesInvoice029203$$' | '$$PurchaseInvoice0292021$$'                | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'SC'        | '11,000' | '$$Rov4PurchaseInvoice0292021$$'       | 'SI&SC'        | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' |
			Then the number of "RowIDInfo" table lines is "равно" "3"
		And I delete "$$NumberSalesInvoice029203$$" variable
		And I delete "$$SalesInvoice029203$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029203$$"
		And I save the window as "$$SalesInvoice029203$$"
	* Create SC
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1ShipmentConfirmation029203$$" variable
		And I save the current field value as "$$Rov1ShipmentConfirmation029203$$"
		And "ItemList" table contains lines
			| 'Key'                                | 'Store'    | 'Shipment basis'         | '#' | 'Quantity in base unit' | 'Item'  | 'Inventory transfer' | 'Item key' | 'Quantity' | 'Sales invoice'          | 'Unit' | 'Sales order'                               | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '$$Rov1ShipmentConfirmation029203$$' | 'Store 01' | '$$SalesInvoice029203$$' | '1' | '11,000'                | 'Shirt' | ''                   | '38/Black' | '11,000'   | '$$SalesInvoice029203$$' | 'pcs'  | 'Sales order 502 dated 30.03.2021 11:56:28' | ''                         | ''                      | ''                |
		Then the number of "ItemList" table lines is "равно" "1"	
		And "RowIDInfo" table became equal
			| '#' | 'Key'                                | 'Basis'                  | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                  | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1ShipmentConfirmation029203$$' | '$$SalesInvoice029203$$' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | ''          | '11,000' | '$$Rov3SalesInvoice029203$$' | 'SC'           | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I click the button named "FormPost"	
		And I delete "$$NumberShipmentConfirmation029203$$" variable
		And I delete "$$ShipmentConfirmation0292033$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029203$$"
		And I save the window as "$$ShipmentConfirmation029203$$"
		And I close all client application windows
		
		

Scenario: _029204 create SC-SI based on SO (with procurement method - purchase)
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' |
		| '502'      |
	* Create SC
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button	
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1ShipmentConfirmation029204$$" variable
		And I save the current field value as "$$Rov1ShipmentConfirmation029204$$"	
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"	
		And "ItemList" table contains lines
			| 'Key'                                | 'Store'    | 'Shipment basis'                            | '#' | 'Quantity in base unit' | 'Item'  | 'Inventory transfer' | 'Item key' | 'Quantity' | 'Sales invoice' | 'Unit' | 'Sales order'                               | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '$$Rov1ShipmentConfirmation029204$$' | 'Store 01' | 'Sales order 502 dated 30.03.2021 11:56:28' | '1' | '5,000'                 | 'Dress' | ''                   | 'M/White'  | '5,000'    | ''              | 'pcs'  | 'Sales order 502 dated 30.03.2021 11:56:28' | ''                         | ''                      | ''                |
		Then the number of "ItemList" table lines is "равно" "1"
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                                | 'Basis'                   | 'Row ID'                               | 'Next step' | 'Q'     | 'Basis key'                   | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1ShipmentConfirmation029204$$' | '$$GoodsReceipt0292021$$' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'SI'        | '5,000' | '$$Rov3GoodsReceipt0292021$$' | 'SI&SC'        | '4a003d08-12af-4c34-98d5-5cdeb84616de' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I delete "$$NumberShipmentConfirmation029204$$" variable
		And I delete "$$ShipmentConfirmation029204$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029204$$"
		And I save the window as "$$ShipmentConfirmation029204$$"
	* Create SI
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button	
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesInvoice029204$$" variable
		And I save the current field value as "$$Rov1SalesInvoice029204$$"	
		And I click the button named "FormPost"	
		And "ItemList" table contains lines
			| 'Key'                                  | 'Store'    | 'Additional analytic' | 'Quantity in base unit' | '#' | 'Business unit' | 'Price type'        | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                               | 'Revenue type' |
			| '$$Rov1SalesInvoice029204$$' | 'Store 01' | ''                    | '5,000'                 | '1' | ''              | 'Basic Price Types' | 'Dress' | 'M/White'  | 'No'                 | ''                   | '5,000' | 'pcs'  | '396,61'     | '520,00' | '18%' | ''              | '2 203,39'   | '2 600,00'     | '31.03.2021'    | 'Yes'                       | ''       | 'Sales order 502 dated 30.03.2021 11:56:28' | ''             |
		Then the number of "ItemList" table lines is "равно" "1"
		And "ShipmentConfirmationsTree" table became equal
			| 'Key'                        | 'Basis key'                          | 'Item'  | 'Shipment confirmation'          | 'Item key' | 'Invoice' | 'SC'    | 'Q'     |
			| '$$Rov1SalesInvoice029204$$' | ''                                   | 'Dress' | ''                               | 'M/White'  | '5,000'   | '5,000' | '5,000' |
			| '$$Rov1SalesInvoice029204$$' | '$$Rov1ShipmentConfirmation029204$$' | ''      | '$$ShipmentConfirmation029204$$' | ''         | ''        | '5,000' | '5,000' |
		And "RowIDInfo" table became equal
			| '#' | 'Key'                        | 'Basis'                          | 'Row ID'                               | 'Next step' | 'Q'     | 'Basis key'                          | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1SalesInvoice029204$$' | '$$ShipmentConfirmation029204$$' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | ''          | '5,000' | '$$Rov1ShipmentConfirmation029204$$' | 'SI'           | '4a003d08-12af-4c34-98d5-5cdeb84616de' |
		And I close all client application windows

// rewrite when the scheme is worked out

Scenario: _029205 check movements in the register TM1010B_RowIDMovements
	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1010B_RowIDMovements"
	And "List" table contains lines
		| 'Recorder'                                  | 'Row ID'                               | 'Step'  | 'Basis'                                     | 'Row ref'                              | 'Quantity' |
		| 'Sales order 501 dated 30.03.2021 11:56:21' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PO&PI' | 'Sales order 501 dated 30.03.2021 11:56:21' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '5,000'    |
		| 'Sales order 501 dated 30.03.2021 11:56:21' | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'PO&PI' | 'Sales order 501 dated 30.03.2021 11:56:21' | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | '2,000'    |
		| 'Sales order 501 dated 30.03.2021 11:56:21' | 'b5b69355-5373-4cd3-9ed7-d08af7501bc7' | 'SI'    | 'Sales order 501 dated 30.03.2021 11:56:21' | 'b5b69355-5373-4cd3-9ed7-d08af7501bc7' | '1,000'    |
		| 'Sales order 501 dated 30.03.2021 11:56:21' | '2e0968f4-d293-4faa-abe0-d25c849e9c32' | 'SI&SC' | 'Sales order 501 dated 30.03.2021 11:56:21' | '2e0968f4-d293-4faa-abe0-d25c849e9c32' | '5,000'    |
		| 'Sales order 501 dated 30.03.2021 11:56:21' | '2659612d-158f-49a2-bbf4-46c70f05eb9d' | 'SI&SC' | 'Sales order 501 dated 30.03.2021 11:56:21' | '2659612d-158f-49a2-bbf4-46c70f05eb9d' | '10,000'   |
		| 'Sales order 502 dated 30.03.2021 11:56:28' | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'PO&PI' | 'Sales order 502 dated 30.03.2021 11:56:28' | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | '8,000'    |
		| 'Sales order 502 dated 30.03.2021 11:56:28' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'PO&PI' | 'Sales order 502 dated 30.03.2021 11:56:28' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| 'Sales order 502 dated 30.03.2021 11:56:28' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'PO&PI' | 'Sales order 502 dated 30.03.2021 11:56:28' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '8,000'    |
		| 'Sales order 502 dated 30.03.2021 11:56:28' | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7' | 'SI'    | 'Sales order 502 dated 30.03.2021 11:56:28' | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7' | '2,000'    |
		| 'Sales order 503 dated 30.03.2021 11:57:06' | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'PO&PI' | 'Sales order 503 dated 30.03.2021 11:57:06' | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | '10,000'   |
		| 'Sales order 503 dated 30.03.2021 11:57:06' | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'PO&PI' | 'Sales order 503 dated 30.03.2021 11:57:06' | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | '5,000'    |
		| 'Sales order 503 dated 30.03.2021 11:57:06' | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PO&PI' | 'Sales order 503 dated 30.03.2021 11:57:06' | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | '10,000'   |
		| '$$PurchaseOrder029201$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PO&PI' | 'Sales order 501 dated 30.03.2021 11:56:21' | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '5,000'    |
		| '$$PurchaseOrder029201$$'                   | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'PO&PI' | 'Sales order 502 dated 30.03.2021 11:56:28' | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | '8,000'    |
		| '$$PurchaseOrder029201$$'                   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'PO&PI' | 'Sales order 501 dated 30.03.2021 11:56:21' | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | '2,000'    |
		| '$$PurchaseOrder029201$$'                   | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'PO&PI' | 'Sales order 502 dated 30.03.2021 11:56:28' | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| '$$PurchaseOrder029201$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'PO&PI' | 'Sales order 502 dated 30.03.2021 11:56:28' | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '8,000'    |
		| '$$PurchaseOrder029201$$'                   | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'PO&PI' | 'Sales order 503 dated 30.03.2021 11:57:06' | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | '10,000'   |
		| '$$PurchaseOrder029201$$'                   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'PO&PI' | 'Sales order 503 dated 30.03.2021 11:57:06' | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | '5,000'    |
		| '$$PurchaseOrder029201$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PO&PI' | 'Sales order 503 dated 30.03.2021 11:57:06' | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | '10,000'   |
		| '$$PurchaseOrder029201$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '5,000'    |
		| '$$PurchaseOrder029201$$'                   | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | '8,000'    |
		| '$$PurchaseOrder029201$$'                   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | '2,000'    |
		| '$$PurchaseOrder029201$$'                   | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| '$$PurchaseOrder029201$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '15,000'   |
		| '$$PurchaseOrder029201$$'                   | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | '10,000'   |
		| '$$PurchaseOrder029201$$'                   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | '5,000'    |
		| '$$PurchaseOrder029201$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | '20,000'   |
		| '$$PurchaseOrder029201$$'                   | '$$Rov9PurchaseOrder029201$$'          | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '$$Rov9PurchaseOrder029201$$'          | '40,000'   |
		| '$$PurchaseInvoice0292021$$'                | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '4,000'    |
		| '$$PurchaseInvoice0292021$$'                | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | '8,000'    |
		| '$$PurchaseInvoice0292021$$'                | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | '2,000'    |
		| '$$PurchaseInvoice0292021$$'                | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| '$$PurchaseInvoice0292021$$'                | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '15,000'   |
		| '$$PurchaseInvoice0292021$$'                | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | '10,000'   |
		| '$$PurchaseInvoice0292021$$'                | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | '5,000'    |
		| '$$PurchaseInvoice0292021$$'                | '$$Rov9PurchaseOrder029201$$'          | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '$$Rov9PurchaseOrder029201$$'          | '40,000'   |
		| '$$PurchaseInvoice0292021$$'                | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '4,000'    |
		| '$$PurchaseInvoice0292021$$'                | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | '3,000'    |
		| '$$PurchaseInvoice0292021$$'                | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '15,000'   |
		| '$$PurchaseInvoice0292021$$'                | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | '10,000'   |
		| '$$PurchaseInvoice0292021$$'                | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | '5,000'    |
		| '$$PurchaseInvoice0292021$$'                | '$$Rov9PurchaseOrder029201$$'          | 'GR'    | '$$PurchaseInvoice0292021$$'                | '$$Rov9PurchaseOrder029201$$'          | '40,000'   |
		| '$$PurchaseInvoice0292021$$'                | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'SI&SC' | '$$PurchaseInvoice0292021$$'                | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| '$$PurchaseInvoice0292021$$'                | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'SI&SC' | '$$PurchaseInvoice0292021$$'                | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | '8,000'    |
		| '$$GoodsReceipt0292021$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '4,000'    |
		| '$$GoodsReceipt0292021$$'                   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | '3,000'    |
		| '$$GoodsReceipt0292021$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '15,000'   |
		| '$$GoodsReceipt0292021$$'                   | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | '10,000'   |
		| '$$GoodsReceipt0292021$$'                   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'GR'    | '$$PurchaseInvoice0292021$$'                | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | '5,000'    |
		| '$$GoodsReceipt0292021$$'                   | '$$Rov9PurchaseOrder029201$$'          | 'GR'    | '$$PurchaseInvoice0292021$$'                | '$$Rov9PurchaseOrder029201$$'          | '40,000'   |
		| '$$GoodsReceipt0292021$$'                   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | 'SI&SC' | '$$GoodsReceipt0292021$$'                   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf' | '5,000'    |
		| '$$GoodsReceipt0292021$$'                   | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | 'SI&SC' | '$$GoodsReceipt0292021$$'                   | '323ed282-6c37-4443-b3b5-6abd5531e1b7' | '10,000'   |
		| '$$GoodsReceipt0292021$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'SI&SC' | '$$GoodsReceipt0292021$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '15,000'   |
		| '$$GoodsReceipt0292021$$'                   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | 'SI&SC' | '$$GoodsReceipt0292021$$'                   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42' | '3,000'    |
		| '$$GoodsReceipt0292021$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'SI&SC' | '$$GoodsReceipt0292021$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '4,000'    |
		| '$$GoodsReceipt0292022$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '1,000'    |
		| '$$GoodsReceipt0292022$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PI&GR' | '$$PurchaseOrder029201$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | '20,000'   |
		| '$$GoodsReceipt0292022$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PI'    | '$$GoodsReceipt0292022$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '1,000'    |
		| '$$GoodsReceipt0292022$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PI'    | '$$GoodsReceipt0292022$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | '20,000'   |
		| '$$GoodsReceipt0292022$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'SI&SC' | '$$GoodsReceipt0292022$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | '20,000'   |
		| '$$GoodsReceipt0292022$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'SI&SC' | '$$GoodsReceipt0292022$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '1,000'    |
		| '$$PurchaseInvoice0292022$$'                | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | 'PI'    | '$$GoodsReceipt0292022$$'                   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0' | '1,000'    |
		| '$$PurchaseInvoice0292022$$'                | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | 'PI'    | '$$GoodsReceipt0292022$$'                   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28' | '20,000'   |
		| '$$SalesInvoice029203$$'                    | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7' | 'SI'    | 'Sales order 502 dated 30.03.2021 11:56:28' | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7' | '2,000'    |
		| '$$SalesInvoice029203$$'                    | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | 'SI&SC' | '$$PurchaseInvoice0292021$$'                | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91' | '8,000'    |
		| '$$SalesInvoice029203$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'SI&SC' | '$$PurchaseInvoice0292021$$'                | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| '$$SalesInvoice029203$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'SC'    | '$$SalesInvoice029203$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| '$$ShipmentConfirmation029203$$'            | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | 'SC'    | '$$SalesInvoice029203$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18' | '11,000'   |
		| '$$ShipmentConfirmation029204$$'            | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'SI&SC' | '$$GoodsReceipt0292021$$'                   | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '5,000'    |
		| '$$ShipmentConfirmation029204$$'            | '4a003d08-12af-4c34-98d5-5cdeb84616de' | 'SI'    | '$$ShipmentConfirmation029204$$'            | '4a003d08-12af-4c34-98d5-5cdeb84616de' | '5,000'    |
	Then the number of "List" table lines is "равно" "72"
	And I close all client application windows
	



		
					

		
				
	



			
						

			
						
						


		
				


		
				
	
		
				

