#language: en
@tree
@Positive
@SalesOrderProcurement

Feature: create Purchase order based on a Sales order

As a sales manager
I want to create Purchase order based on a Sales order
To implement a sales-for-purchase scheme


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029200 preparation (create Purchase order based on a Sales order)
	When set True value to the constant
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
		When Create catalog Partners objects (Lomaniti)
		When Create catalog Partners objects (Ferron BP)
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
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
	When Create document SalesOrder objects (check SalesOrderProcurement)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(501).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(502).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(503).GetObject().Write(DocumentWriteMode.Posting);"   |

Scenario: _0292001 check preparation
	When check preparation

Scenario: _029201 create Purchase order based on Sales order
	* Create Purchase order based on Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '501'       |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseOrderGenerate"
		And "BasisesTree" table contains lines
			| 'Row presentation'                            | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 501 dated 30.03.2021 11:56:21'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Trousers (38/Yellow)'                        | 'Yes'   | '5,000'      | 'pcs'    | '338,98'   | 'TRY'         |
			| 'Shirt (38/Black)'                            | 'Yes'   | '2,000'      | 'pcs'    | '296,61'   | 'TRY'         |
			| 'Sales order 502 dated 30.03.2021 11:56:28'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Trousers (38/Yellow)'                        | 'Yes'   | '8,000'      | 'pcs'    | '400,00'   | 'TRY'         |
			| 'Shirt (38/Black)'                            | 'Yes'   | '11,000'     | 'pcs'    | '350,00'   | 'TRY'         |
			| 'Dress (M/White)'                             | 'Yes'   | '8,000'      | 'pcs'    | '520,00'   | 'TRY'         |
		Then the number of "BasisesTree" table lines is "равно" "7"
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Price type'   | 'Item'       | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'   | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '38/Yellow'   | ''             | 'Trousers'   | '5,000'      | 'pcs'    | ''             | ''        | '18%'   | ''             | ''               | 'Store 02'    |
			| '38/Yellow'   | ''             | 'Trousers'   | '8,000'      | 'pcs'    | ''             | ''        | '18%'   | ''             | ''               | 'Store 01'    |
			| '38/Black'    | ''             | 'Shirt'      | '2,000'      | 'pcs'    | ''             | ''        | '18%'   | ''             | ''               | 'Store 02'    |
			| '38/Black'    | ''             | 'Shirt'      | '11,000'     | 'pcs'    | ''             | ''        | '18%'   | ''             | ''               | 'Store 01'    |
			| 'M/White'     | ''             | 'Dress'      | '8,000'      | 'pcs'    | ''             | ''        | '18%'   | ''             | ''               | 'Store 01'    |
	* Filling in main info
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, USD'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I activate "Price" field in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Price type'          | 'Quantity'    |
			| 'Trousers'   | '38/Yellow'   | 'Vendor price, USD'   | '5,000'       |
		And I select current line in "ItemList" table
		And I input "10,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Price type'          | 'Quantity'    |
			| 'Trousers'   | '38/Yellow'   | 'Vendor price, USD'   | '8,000'       |
		And I select current line in "ItemList" table
		And I input "15,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price type'          | 'Quantity'    |
			| 'Shirt'   | '38/Black'   | 'Vendor price, USD'   | '2,000'       |
		And I select current line in "ItemList" table
		And I input "20,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price type'          | 'Quantity'    |
			| 'Shirt'   | '38/Black'   | 'Vendor price, USD'   | '11,000'      |
		And I select current line in "ItemList" table
		And I input "20,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price type'          | 'Quantity'    |
			| 'Dress'   | 'M/White'    | 'Vendor price, USD'   | '8,000'       |
		And I select current line in "ItemList" table
		And I input "21,00" text in "Price" field of "ItemList" table
		And I input "15,00" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I select "Approved" exact value from "Status" drop-down list
	* Add items from SO 503
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '10,000'     | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'       | 'Unit'   | 'Use'    |
			| 'TRY'        | '400,00'   | '5,000'      | 'Trousers (36/Yellow)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'       | 'Unit'   | 'Use'    |
			| 'TRY'        | '400,00'   | '10,000'     | 'Trousers (38/Yellow)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Dress'   | 'XS/Blue'    | '10,000'      |
		And I select current line in "ItemList" table
		And I input "17,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Quantity'    |
			| 'Trousers'   | '36/Yellow'   | '5,000'       |
		And I select current line in "ItemList" table
		And I input "18,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Quantity'    |
			| 'Trousers'   | '38/Yellow'   | '10,000'      |
		And I select current line in "ItemList" table
		And I input "20,00" text in "Price" field of "ItemList" table
		And I input "20,00" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add one more item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'High shoes'     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '37/19SD'     |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'High shoes box (8 pcs)'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "14,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov1PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov2PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov3PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '4'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov4PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov4PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '5'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov5PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov5PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '6'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov6PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov6PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '7'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov7PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov7PurchaseOrder029201$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '8'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov8PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov8PurchaseOrder029201$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '9'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov9PurchaseOrder029201$$" variable
		And I save the current field value as "$$Rov9PurchaseOrder029201$$"		
	* Check Row ID tab
		And I click the button named "FormPost"
		And "ItemList" table contains lines
			| 'Item'         | 'Item key'    | 'Quantity'   | 'Unit'                     | 'Tax amount'   | 'Price'   | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Sales order'                                 | 'Purchase basis'                               |
			| 'Trousers'     | '38/Yellow'   | '5,000'      | 'pcs'                      | '7,63'         | '10,00'   | '18%'   | '42,37'        | '50,00'          | 'Sales order 501 dated 30.03.2021 11:56:21'   | 'Sales order 501 dated 30.03.2021 11:56:21'    |
			| 'Trousers'     | '38/Yellow'   | '8,000'      | 'pcs'                      | '18,31'        | '15,00'   | '18%'   | '101,69'       | '120,00'         | 'Sales order 502 dated 30.03.2021 11:56:28'   | 'Sales order 502 dated 30.03.2021 11:56:28'    |
			| 'Shirt'        | '38/Black'    | '2,000'      | 'pcs'                      | '6,10'         | '20,00'   | '18%'   | '33,90'        | '40,00'          | 'Sales order 501 dated 30.03.2021 11:56:21'   | 'Sales order 501 dated 30.03.2021 11:56:21'    |
			| 'Shirt'        | '38/Black'    | '11,000'     | 'pcs'                      | '33,56'        | '20,00'   | '18%'   | '186,44'       | '220,00'         | 'Sales order 502 dated 30.03.2021 11:56:28'   | 'Sales order 502 dated 30.03.2021 11:56:28'    |
			| 'Dress'        | 'M/White'     | '15,000'     | 'pcs'                      | '48,05'        | '21,00'   | '18%'   | '266,95'       | '315,00'         | 'Sales order 502 dated 30.03.2021 11:56:28'   | 'Sales order 502 dated 30.03.2021 11:56:28'    |
			| 'Dress'        | 'XS/Blue'     | '10,000'     | 'pcs'                      | '25,93'        | '17,00'   | '18%'   | '144,07'       | '170,00'         | 'Sales order 503 dated 30.03.2021 11:57:06'   | 'Sales order 503 dated 30.03.2021 11:57:06'    |
			| 'Trousers'     | '36/Yellow'   | '5,000'      | 'pcs'                      | '13,73'        | '18,00'   | '18%'   | '76,27'        | '90,00'          | 'Sales order 503 dated 30.03.2021 11:57:06'   | 'Sales order 503 dated 30.03.2021 11:57:06'    |
			| 'Trousers'     | '38/Yellow'   | '20,000'     | 'pcs'                      | '61,02'        | '20,00'   | '18%'   | '338,98'       | '400,00'         | 'Sales order 503 dated 30.03.2021 11:57:06'   | 'Sales order 503 dated 30.03.2021 11:57:06'    |
			| 'High shoes'   | '37/19SD'     | '5,000'      | 'High shoes box (8 pcs)'   | '10,68'        | '14,00'   | '18%'   | '59,32'        | '70,00'          | ''                                            | ''                                             |
		And "RowIDInfo" table contains lines
			| 'Key'   | 'Basis'                                       | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '*'     | 'Sales order 501 dated 30.03.2021 11:56:21'   | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'   | 'PI&GR'       | '5,000'      | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'   | 'PO&PI'          | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'    |
			| '*'     | 'Sales order 502 dated 30.03.2021 11:56:28'   | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'   | 'PI&GR'       | '8,000'      | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'   | 'PO&PI'          | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'    |
			| '*'     | 'Sales order 501 dated 30.03.2021 11:56:21'   | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'   | 'PI&GR'       | '2,000'      | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'   | 'PO&PI'          | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'    |
			| '*'     | 'Sales order 502 dated 30.03.2021 11:56:28'   | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'   | 'PI&GR'       | '11,000'     | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'   | 'PO&PI'          | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'    |
			| '*'     | 'Sales order 502 dated 30.03.2021 11:56:28'   | '4a003d08-12af-4c34-98d5-5cdeb84616de'   | 'PI&GR'       | '15,000'     | '4a003d08-12af-4c34-98d5-5cdeb84616de'   | 'PO&PI'          | '4a003d08-12af-4c34-98d5-5cdeb84616de'    |
			| '*'     | 'Sales order 503 dated 30.03.2021 11:57:06'   | '323ed282-6c37-4443-b3b5-6abd5531e1b7'   | 'PI&GR'       | '10,000'     | '323ed282-6c37-4443-b3b5-6abd5531e1b7'   | 'PO&PI'          | '323ed282-6c37-4443-b3b5-6abd5531e1b7'    |
			| '*'     | 'Sales order 503 dated 30.03.2021 11:57:06'   | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'   | 'PI&GR'       | '5,000'      | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'   | 'PO&PI'          | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'    |
			| '*'     | 'Sales order 503 dated 30.03.2021 11:57:06'   | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'   | 'PI&GR'       | '20,000'     | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'   | 'PO&PI'          | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'    |
			| '*'     | ''                                            | '$$Rov9PurchaseOrder029201$$'            | 'PI&GR'       | '40,000'     | ''                                       | ''               | '$$Rov9PurchaseOrder029201$$'             |
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
			| 'Number'                           |
			| '$$NumberPurchaseOrder029201$$'    |
		* Create PI
			And I click the button named "FormDocumentPurchaseInvoiceGenerate"
			And I go to line in "BasisesTree" table
				| 'Currency'    | 'Price'     | 'Quantity'    | 'Row presentation'        | 'Unit'    | 'Use'     |
				| 'TRY'         | '400,00'    | '20,000'      | 'Trousers (38/Yellow)'    | 'pcs'     | 'Yes'     |
			And I change "Use" checkbox in "BasisesTree" table
			And Delay 2
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And "ItemList" table contains lines
				| '#'    | 'Profit loss center'    | 'Price type'                 | 'Item'          | 'Item key'     | 'Dont calculate row'    | 'Tax amount'    | 'Unit'                      | 'Serial lot numbers'    | 'Quantity'    | 'Price'    | 'VAT'    | 'Offers amount'    | 'Total amount'    | 'Additional analytic'    | 'Internal supply request'    | 'Store'       | 'Expense type'    | 'Purchase order'             | 'Detail'    | 'Sales order'                                  | 'Net amount'    | 'Use goods receipt'     |
				| '1'    | ''                      | 'en description is empty'    | 'Trousers'      | '38/Yellow'    | 'No'                    | '7,63'          | 'pcs'                       | ''                      | '5,000'       | '10,00'    | '18%'    | ''                 | '50,00'           | ''                       | ''                           | 'Store 02'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 501 dated 30.03.2021 11:56:21'    | '42,37'         | 'Yes'                   |
				| '2'    | ''                      | 'en description is empty'    | 'Trousers'      | '38/Yellow'    | 'No'                    | '18,31'         | 'pcs'                       | ''                      | '8,000'       | '15,00'    | '18%'    | ''                 | '120,00'          | ''                       | ''                           | 'Store 01'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 502 dated 30.03.2021 11:56:28'    | '101,69'        | 'No'                    |
				| '3'    | ''                      | 'en description is empty'    | 'Shirt'         | '38/Black'     | 'No'                    | '6,10'          | 'pcs'                       | ''                      | '2,000'       | '20,00'    | '18%'    | ''                 | '40,00'           | ''                       | ''                           | 'Store 02'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 501 dated 30.03.2021 11:56:21'    | '33,90'         | 'Yes'                   |
				| '4'    | ''                      | 'en description is empty'    | 'Shirt'         | '38/Black'     | 'No'                    | '33,56'         | 'pcs'                       | ''                      | '11,000'      | '20,00'    | '18%'    | ''                 | '220,00'          | ''                       | ''                           | 'Store 01'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 502 dated 30.03.2021 11:56:28'    | '186,44'        | 'No'                    |
				| '5'    | ''                      | 'en description is empty'    | 'Dress'         | 'M/White'      | 'No'                    | '48,05'         | 'pcs'                       | ''                      | '15,000'      | '21,00'    | '18%'    | ''                 | '315,00'          | ''                       | ''                           | 'Store 01'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 502 dated 30.03.2021 11:56:28'    | '266,95'        | 'No'                    |
				| '6'    | ''                      | 'en description is empty'    | 'Dress'         | 'XS/Blue'      | 'No'                    | '25,93'         | 'pcs'                       | ''                      | '10,000'      | '17,00'    | '18%'    | ''                 | '170,00'          | ''                       | ''                           | 'Store 02'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 503 dated 30.03.2021 11:57:06'    | '144,07'        | 'Yes'                   |
				| '7'    | ''                      | 'en description is empty'    | 'Trousers'      | '36/Yellow'    | 'No'                    | '13,73'         | 'pcs'                       | ''                      | '5,000'       | '18,00'    | '18%'    | ''                 | '90,00'           | ''                       | ''                           | 'Store 02'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 503 dated 30.03.2021 11:57:06'    | '76,27'         | 'Yes'                   |
				| '8'    | ''                      | 'en description is empty'    | 'High shoes'    | '37/19SD'      | 'No'                    | '10,68'         | 'High shoes box (8 pcs)'    | ''                      | '5,000'       | '14,00'    | '18%'    | ''                 | '70,00'           | ''                       | ''                           | 'Store 02'    | ''                | '$$PurchaseOrder029201$$'    | ''          | ''                                             | '59,32'         | 'Yes'                   |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Price'    | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '10,00'    | '5,000'        |
			And I select current line in "ItemList" table
			And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'    | 'Price'    | 'Quantity'     |
				| 'Dress'    | 'M/White'     | '21,00'    | '15,000'       |
			And I set "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table			
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'    | 'Price'    | 'Quantity'     |
				| 'Shirt'    | '38/Black'    | '20,00'    | '2,000'        |
			And I select current line in "ItemList" table
			And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I click "Post" button
			And I click "Show row key" button
			And "RowIDInfo" table contains lines
				| 'Key'    | 'Basis'                      | 'Row ID'                                  | 'Next step'    | 'Quantity'    | 'Basis key'                      | 'Current step'    | 'Row ref'                                  |
				| '*'      | '$$PurchaseOrder029201$$'    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'    | 'GR'           | '4,000'       | '$$Rov1PurchaseOrder029201$$'    | 'PI&GR'           | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'    | ''             | '8,000'       | '$$Rov2PurchaseOrder029201$$'    | 'PI&GR'           | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'    | 'GR'           | '3,000'       | '$$Rov3PurchaseOrder029201$$'    | 'PI&GR'           | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'    | ''             | '11,000'      | '$$Rov4PurchaseOrder029201$$'    | 'PI&GR'           | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '4a003d08-12af-4c34-98d5-5cdeb84616de'    | 'GR'           | '15,000'      | '$$Rov5PurchaseOrder029201$$'    | 'PI&GR'           | '4a003d08-12af-4c34-98d5-5cdeb84616de'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'    | 'GR'           | '10,000'      | '$$Rov6PurchaseOrder029201$$'    | 'PI&GR'           | '323ed282-6c37-4443-b3b5-6abd5531e1b7'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'    | 'GR'           | '5,000'       | '$$Rov7PurchaseOrder029201$$'    | 'PI&GR'           | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '$$Rov9PurchaseOrder029201$$'             | 'GR'           | '40,000'      | '$$Rov9PurchaseOrder029201$$'    | 'PI&GR'           | '$$Rov9PurchaseOrder029201$$'              |
				| '*'      | '$$PurchaseOrder029201$$'    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'    | 'SI&SC'        | '11,000'      | '$$Rov4PurchaseOrder029201$$'    | ''                | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'     |
				| '*'      | '$$PurchaseOrder029201$$'    | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'    | 'SI&SC'        | '8,000'       | '$$Rov2PurchaseOrder029201$$'    | ''                | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'     |
			Then the number of "RowIDInfo" table lines is "равно" "10"
			And I go to line in "ItemList" table
				| '#'     |
				| '1'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov1PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '2'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov2PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '3'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov3PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov3PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '4'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov4PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov4PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '5'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov5PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov5PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '6'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov6PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov6PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '7'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov7PurchaseInvoice0292021$$" variable
			And I save the current field value as "$$Rov7PurchaseInvoice0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '8'     |
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
				| '#'     |
				| '1'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov1GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '2'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov2GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '3'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov3GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov3GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '4'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov4GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov4GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '5'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov5GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov5GoodsReceipt0292021$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '6'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov6GoodsReceipt0292021$$" variable
			And I save the current field value as "$$Rov6GoodsReceipt0292021$$"	
			And "RowIDInfo" table contains lines
				| '#'    | 'Key'    | 'Basis'                         | 'Row ID'                                  | 'Next step'    | 'Quantity'    | 'Basis key'                         | 'Current step'    | 'Row ref'                                  |
				| '1'    | '*'      | '$$PurchaseInvoice0292021$$'    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'    | ''             | '4,000'       | '$$Rov1PurchaseInvoice0292021$$'    | 'GR'              | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'     |
				| '2'    | '*'      | '$$PurchaseInvoice0292021$$'    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'    | ''             | '3,000'       | '$$Rov3PurchaseInvoice0292021$$'    | 'GR'              | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'     |
				| '3'    | '*'      | '$$PurchaseInvoice0292021$$'    | '4a003d08-12af-4c34-98d5-5cdeb84616de'    | ''             | '15,000'      | '$$Rov5PurchaseInvoice0292021$$'    | 'GR'              | '4a003d08-12af-4c34-98d5-5cdeb84616de'     |
				| '4'    | '*'      | '$$PurchaseInvoice0292021$$'    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'    | ''             | '10,000'      | '$$Rov6PurchaseInvoice0292021$$'    | 'GR'              | '323ed282-6c37-4443-b3b5-6abd5531e1b7'     |
				| '5'    | '*'      | '$$PurchaseInvoice0292021$$'    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'    | ''             | '5,000'       | '$$Rov7PurchaseInvoice0292021$$'    | 'GR'              | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'     |
				| '6'    | '*'      | '$$PurchaseInvoice0292021$$'    | '$$Rov9PurchaseOrder029201$$'             | ''             | '40,000'      | '$$Rov8PurchaseInvoice0292021$$'    | 'GR'              | '$$Rov9PurchaseOrder029201$$'              |
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
			| 'Number'                           |
			| '$$NumberPurchaseOrder029201$$'    |
		* Create GR
			And I click the button named "FormDocumentGoodsReceiptGenerate"
			And "BasisesTree" table contains lines
				| 'Row presentation'                             | 'Use'    | 'Quantity'    | 'Unit'    | 'Price'     | 'Currency'     |
				| 'Sales order 501 dated 30.03.2021 11:56:21'    | 'Yes'    | ''            | ''        | ''          | ''             |
				| '$$PurchaseOrder029201$$'                      | 'Yes'    | ''            | ''        | ''          | ''             |
				| 'Trousers (38/Yellow)'                         | 'Yes'    | '1,000'       | 'pcs'     | '338,98'    | 'TRY'          |
				| 'Sales order 503 dated 30.03.2021 11:57:06'    | 'Yes'    | ''            | ''        | ''          | ''             |
				| '$$PurchaseOrder029201$$'                      | 'Yes'    | ''            | ''        | ''          | ''             |
				| 'Trousers (38/Yellow)'                         | 'Yes'    | '20,000'      | 'pcs'     | '400,00'    | 'TRY'          |
			Then the number of "BasisesTree" table lines is "равно" "6"
			And I click "Ok" button
			And "ItemList" table contains lines
				| '#'    | 'Item'        | 'Inventory transfer'    | 'Item key'     | 'Store'       | 'Internal supply request'    | 'Quantity'    | 'Sales invoice'    | 'Unit'    | 'Receipt basis'              | 'Purchase invoice'    | 'Currency'    | 'Sales return order'    | 'Sales order'                                  | 'Purchase order'             | 'Inventory transfer order'    | 'Sales return'     |
				| '1'    | 'Trousers'    | ''                      | '38/Yellow'    | 'Store 02'    | ''                           | '1,000'       | ''                 | 'pcs'     | '$$PurchaseOrder029201$$'    | ''                    | 'USD'         | ''                      | 'Sales order 501 dated 30.03.2021 11:56:21'    | '$$PurchaseOrder029201$$'    | ''                            | ''                 |
				| '2'    | 'Trousers'    | ''                      | '38/Yellow'    | 'Store 02'    | ''                           | '20,000'      | ''                 | 'pcs'     | '$$PurchaseOrder029201$$'    | ''                    | 'USD'         | ''                      | 'Sales order 503 dated 30.03.2021 11:57:06'    | '$$PurchaseOrder029201$$'    | ''                            | ''                 |
			And I click "Show row key" button
			And "RowIDInfo" table contains lines
				| '#'    | 'Key'    | 'Basis'                      | 'Row ID'                                  | 'Next step'    | 'Quantity'    | 'Basis key'                      | 'Current step'    | 'Row ref'                                  |
				| '1'    | '*'      | '$$PurchaseOrder029201$$'    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'    | ''             | '1,000'       | '$$Rov1PurchaseOrder029201$$'    | 'PI&GR'           | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'     |
				| '2'    | '*'      | '$$PurchaseOrder029201$$'    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'    | ''             | '20,000'      | '$$Rov8PurchaseOrder029201$$'    | 'PI&GR'           | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'     |
			And I go to line in "ItemList" table
				| '#'     |
				| '1'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1GoodsReceipt0292022$$" variable
			And I save the current field value as "$$Rov1GoodsReceipt0292022$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '2'     |
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
				| 'Row presentation'                             | 'Use'    | 'Quantity'    | 'Unit'    | 'Price'     | 'Currency'     |
				| 'Sales order 501 dated 30.03.2021 11:56:21'    | 'Yes'    | ''            | ''        | ''          | ''             |
				| '$$PurchaseOrder029201$$'                      | 'Yes'    | ''            | ''        | ''          | ''             |
				| '$$GoodsReceipt0292022$$'                      | 'Yes'    | ''            | ''        | ''          | ''             |
				| 'Trousers (38/Yellow)'                         | 'Yes'    | '1,000'       | 'pcs'     | '338,98'    | 'TRY'          |
				| 'Sales order 503 dated 30.03.2021 11:57:06'    | 'Yes'    | ''            | ''        | ''          | ''             |
				| '$$PurchaseOrder029201$$'                      | 'Yes'    | ''            | ''        | ''          | ''             |
				| '$$GoodsReceipt0292022$$'                      | 'Yes'    | ''            | ''        | ''          | ''             |
				| 'Trousers (38/Yellow)'                         | 'Yes'    | '20,000'      | 'pcs'     | '400,00'    | 'TRY'          |
			Then the number of "BasisesTree" table lines is "равно" "8"
			And I click "Ok" button
			And "ItemList" table contains lines
				| '#'    | 'Profit loss center'    | 'Price type'                 | 'Item'        | 'Item key'     | 'Dont calculate row'    | 'Tax amount'    | 'Unit'    | 'Serial lot numbers'    | 'Quantity'    | 'Price'    | 'VAT'    | 'Offers amount'    | 'Total amount'    | 'Additional analytic'    | 'Internal supply request'    | 'Store'       | 'Expense type'    | 'Purchase order'             | 'Detail'    | 'Sales order'                                  | 'Net amount'    | 'Use goods receipt'     |
				| '1'    | ''                      | 'en description is empty'    | 'Trousers'    | '38/Yellow'    | 'No'                    | '1,53'          | 'pcs'     | ''                      | '1,000'       | '10,00'    | '18%'    | ''                 | '10,00'           | ''                       | ''                           | 'Store 02'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 501 dated 30.03.2021 11:56:21'    | '8,47'          | 'Yes'                   |
				| '2'    | ''                      | 'en description is empty'    | 'Trousers'    | '38/Yellow'    | 'No'                    | '61,02'         | 'pcs'     | ''                      | '20,000'      | '20,00'    | '18%'    | ''                 | '400,00'          | ''                       | ''                           | 'Store 02'    | ''                | '$$PurchaseOrder029201$$'    | ''          | 'Sales order 503 dated 30.03.2021 11:57:06'    | '338,98'        | 'Yes'                   |
			And in the table "ItemList" I click "Goods receipts" button
			And "DocumentsTree" table became equal
				| 'Presentation'               | 'Invoice'    | 'QuantityInDocument'    | 'Quantity'     |
				| 'Trousers (38/Yellow)'       | '1,000'      | '1,000'                 | '1,000'        |
				| '$$GoodsReceipt0292022$$'    | ''           | '1,000'                 | '1,000'        |
				| 'Trousers (38/Yellow)'       | '20,000'     | '20,000'                | '20,000'       |
				| '$$GoodsReceipt0292022$$'    | ''           | '20,000'                | '20,000'       |
			And I close current window		
			And I click "Show row key" button
			And "RowIDInfo" table contains lines
				| '#'    | 'Key'    | 'Basis'                      | 'Row ID'                                  | 'Next step'    | 'Quantity'    | 'Basis key'                      | 'Current step'    | 'Row ref'                                  |
				| '1'    | '*'      | '$$GoodsReceipt0292022$$'    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'    | ''             | '1,000'       | '$$Rov1GoodsReceipt0292022$$'    | 'PI'              | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'     |
				| '2'    | '*'      | '$$GoodsReceipt0292022$$'    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'    | ''             | '20,000'      | '$$Rov2GoodsReceipt0292022$$'    | 'PI'              | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'     |
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
		| 'Number'   |
		| '502'      |
	* Create SI
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I delete a line in "ItemList" table
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesInvoice029203$$" variable
		And I save the current field value as "$$Rov1SalesInvoice029203$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2SalesInvoice029203$$" variable
		And I save the current field value as "$$Rov2SalesInvoice029203$$"	
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3SalesInvoice029203$$" variable
		And I save the current field value as "$$Rov3SalesInvoice029203$$"	
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I activate "Use shipment confirmation" field in "ItemList" table
		And I set "Use shipment confirmation" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And in the table "ItemList" I click "Edit quantity in base unit" button
		* Check ItemList tab
			And "ItemList" table contains lines
				| 'Key'                           | 'Store'       | 'Additional analytic'    | 'Stock quantity'    | '#'    | 'Profit loss center'    | 'Price type'                 | 'Item'        | 'Item key'     | 'Dont calculate row'    | 'Serial lot numbers'    | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Price'     | 'VAT'    | 'Offers amount'    | 'Net amount'    | 'Total amount'    | 'Use shipment confirmation'    | 'Detail'    | 'Sales order'                                  | 'Revenue type'     |
				| '$$Rov1SalesInvoice029203$$'    | ''            | ''                       | '2,000'             | '1'    | ''                      | 'en description is empty'    | 'Service'     | 'Internet'     | 'No'                    | ''                      | '2,000'       | 'pcs'     | '30,51'         | '100,00'    | '18%'    | ''                 | '169,49'        | '200,00'          | 'No'                           | ''          | 'Sales order 502 dated 30.03.2021 11:56:28'    | ''                 |
				| '$$Rov2SalesInvoice029203$$'    | 'Store 01'    | ''                       | '8,000'             | '2'    | ''                      | 'Basic Price Types'          | 'Trousers'    | '38/Yellow'    | 'No'                    | ''                      | '8,000'       | 'pcs'     | '488,14'        | '400,00'    | '18%'    | ''                 | '2 711,86'      | '3 200,00'        | 'No'                           | ''          | 'Sales order 502 dated 30.03.2021 11:56:28'    | ''                 |
				| '$$Rov3SalesInvoice029203$$'    | 'Store 01'    | ''                       | '11,000'            | '3'    | ''                      | 'Basic Price Types'          | 'Shirt'       | '38/Black'     | 'No'                    | ''                      | '11,000'      | 'pcs'     | '587,29'        | '350,00'    | '18%'    | ''                 | '3 262,71'      | '3 850,00'        | 'Yes'                          | ''          | 'Sales order 502 dated 30.03.2021 11:56:28'    | ''                 |
			Then the number of "ItemList" table lines is "равно" "3"
		* Check RowIDInfo tab
			And "RowIDInfo" table contains lines
				| '#'    | 'Key'                           | 'Basis'                                        | 'Row ID'                                  | 'Next step'    | 'Quantity'    | 'Basis key'                               | 'Current step'    | 'Row ref'                                  |
				| '1'    | '$$Rov1SalesInvoice029203$$'    | 'Sales order 502 dated 30.03.2021 11:56:28'    | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7'    | ''             | '2,000'       | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7'    | 'SI&WO&WS'        | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7'     |
				| '2'    | '$$Rov2SalesInvoice029203$$'    | '$$PurchaseInvoice0292021$$'                   | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'    | ''             | '8,000'       | '$$Rov2PurchaseInvoice0292021$$'          | 'SI&SC'           | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'     |
				| '3'    | '$$Rov3SalesInvoice029203$$'    | '$$PurchaseInvoice0292021$$'                   | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'    | 'SC'           | '11,000'      | '$$Rov4PurchaseInvoice0292021$$'          | 'SI&SC'           | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'     |
			Then the number of "RowIDInfo" table lines is "равно" "3"
		And I delete "$$NumberSalesInvoice029203$$" variable
		And I delete "$$SalesInvoice029203$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029203$$"
		And I save the window as "$$SalesInvoice029203$$"
	* Create SC
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1ShipmentConfirmation029203$$" variable
		And I save the current field value as "$$Rov1ShipmentConfirmation029203$$"
		And "ItemList" table contains lines
			| 'Key'                                  | 'Store'      | 'Shipment basis'           | '#'   | 'Stock quantity'   | 'Item'    | 'Inventory transfer'   | 'Item key'   | 'Quantity'   | 'Sales invoice'            | 'Unit'   | 'Sales order'                                 | 'Inventory transfer order'   | 'Purchase return order'   | 'Purchase return'    |
			| '$$Rov1ShipmentConfirmation029203$$'   | 'Store 01'   | '$$SalesInvoice029203$$'   | '1'   | '11,000'           | 'Shirt'   | ''                     | '38/Black'   | '11,000'     | '$$SalesInvoice029203$$'   | 'pcs'    | 'Sales order 502 dated 30.03.2021 11:56:28'   | ''                           | ''                        | ''                   |
		Then the number of "ItemList" table lines is "равно" "1"	
		And "RowIDInfo" table became equal
			| '#'   | 'Key'                                  | 'Basis'                    | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                    | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1ShipmentConfirmation029203$$'   | '$$SalesInvoice029203$$'   | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'   | ''            | '11,000'     | '$$Rov3SalesInvoice029203$$'   | 'SC'             | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'    |
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
		| 'Number'   |
		| '502'      |
	* Create SC
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button	
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1ShipmentConfirmation029204$$" variable
		And I save the current field value as "$$Rov1ShipmentConfirmation029204$$"	
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"	
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Key'                                  | 'Store'      | 'Shipment basis'                              | '#'   | 'Stock quantity'   | 'Item'    | 'Inventory transfer'   | 'Item key'   | 'Quantity'   | 'Sales invoice'   | 'Unit'   | 'Sales order'                                 | 'Inventory transfer order'   | 'Purchase return order'   | 'Purchase return'    |
			| '$$Rov1ShipmentConfirmation029204$$'   | 'Store 01'   | 'Sales order 502 dated 30.03.2021 11:56:28'   | '1'   | '5,000'            | 'Dress'   | ''                     | 'M/White'    | '5,000'      | ''                | 'pcs'    | 'Sales order 502 dated 30.03.2021 11:56:28'   | ''                           | ''                        | ''                   |
		Then the number of "ItemList" table lines is "равно" "1"
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                                  | 'Basis'                     | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                     | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1ShipmentConfirmation029204$$'   | '$$GoodsReceipt0292021$$'   | '4a003d08-12af-4c34-98d5-5cdeb84616de'   | 'SI'          | '5,000'      | '$$Rov3GoodsReceipt0292021$$'   | 'SI&SC'          | '4a003d08-12af-4c34-98d5-5cdeb84616de'    |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I delete "$$NumberShipmentConfirmation029204$$" variable
		And I delete "$$ShipmentConfirmation029204$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029204$$"
		And I save the window as "$$ShipmentConfirmation029204$$"
	* Create SI
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button	
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesInvoice029204$$" variable
		And I save the current field value as "$$Rov1SalesInvoice029204$$"	
		And I click the button named "FormPost"	
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Key'                          | 'Store'      | 'Additional analytic'   | 'Stock quantity'   | '#'   | 'Profit loss center'   | 'Price type'          | 'Item'    | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                 | 'Revenue type'    |
			| '$$Rov1SalesInvoice029204$$'   | 'Store 01'   | ''                      | '5,000'            | '1'   | ''                     | 'Basic Price Types'   | 'Dress'   | 'M/White'    | 'No'                   | ''                     | '5,000'      | 'pcs'    | '396,61'       | '520,00'   | '18%'   | ''                | '2 203,39'     | '2 600,00'       | 'Yes'                         | ''         | 'Sales order 502 dated 30.03.2021 11:56:28'   | ''                |
		Then the number of "ItemList" table lines is "равно" "1"
		And in the table "ItemList" I click "Shipment confirmations" button
		And "DocumentsTree" table became equal
			| 'Presentation'                     | 'Invoice'   | 'QuantityInDocument'   | 'Quantity'    |
			| 'Dress (M/White)'                  | '5,000'     | '5,000'                | '5,000'       |
			| '$$ShipmentConfirmation029204$$'   | ''          | '5,000'                | '5,000'       |
		And I close current window
		And "RowIDInfo" table became equal
			| '#'   | 'Key'                          | 'Basis'                            | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                            | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1SalesInvoice029204$$'   | '$$ShipmentConfirmation029204$$'   | '4a003d08-12af-4c34-98d5-5cdeb84616de'   | ''            | '5,000'      | '$$Rov1ShipmentConfirmation029204$$'   | 'SI'             | '4a003d08-12af-4c34-98d5-5cdeb84616de'    |
		And I close all client application windows

// rewrite when the scheme is worked out

Scenario: _029205 check movements in the register TM1010B_RowIDMovements
	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1010B_RowIDMovements"
	And "List" table contains lines
		| 'Recorder'                                   | 'Row ID'                                | 'Step'      | 'Basis'                                      | 'Row ref'                               | 'Quantity'   |
		| 'Sales order 501 dated 30.03.2021 11:56:21'  | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'PO&PI'     | 'Sales order 501 dated 30.03.2021 11:56:21'  | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '5,000'      |
		| 'Sales order 501 dated 30.03.2021 11:56:21'  | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | 'PO&PI'     | 'Sales order 501 dated 30.03.2021 11:56:21'  | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | '2,000'      |
		| 'Sales order 501 dated 30.03.2021 11:56:21'  | 'b5b69355-5373-4cd3-9ed7-d08af7501bc7'  | 'SI&WO&WS'  | 'Sales order 501 dated 30.03.2021 11:56:21'  | 'b5b69355-5373-4cd3-9ed7-d08af7501bc7'  | '1,000'      |
		| 'Sales order 501 dated 30.03.2021 11:56:21'  | '2e0968f4-d293-4faa-abe0-d25c849e9c32'  | 'SI&SC'     | 'Sales order 501 dated 30.03.2021 11:56:21'  | '2e0968f4-d293-4faa-abe0-d25c849e9c32'  | '5,000'      |
		| 'Sales order 501 dated 30.03.2021 11:56:21'  | '2659612d-158f-49a2-bbf4-46c70f05eb9d'  | 'SI&SC'     | 'Sales order 501 dated 30.03.2021 11:56:21'  | '2659612d-158f-49a2-bbf4-46c70f05eb9d'  | '10,000'     |
		| 'Sales order 502 dated 30.03.2021 11:56:28'  | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | 'PO&PI'     | 'Sales order 502 dated 30.03.2021 11:56:28'  | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | '8,000'      |
		| 'Sales order 502 dated 30.03.2021 11:56:28'  | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'PO&PI'     | 'Sales order 502 dated 30.03.2021 11:56:28'  | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| 'Sales order 502 dated 30.03.2021 11:56:28'  | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'PO&PI'     | 'Sales order 502 dated 30.03.2021 11:56:28'  | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '8,000'      |
		| 'Sales order 502 dated 30.03.2021 11:56:28'  | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7'  | 'SI&WO&WS'  | 'Sales order 502 dated 30.03.2021 11:56:28'  | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7'  | '2,000'      |
		| 'Sales order 503 dated 30.03.2021 11:57:06'  | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | 'PO&PI'     | 'Sales order 503 dated 30.03.2021 11:57:06'  | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | '10,000'     |
		| 'Sales order 503 dated 30.03.2021 11:57:06'  | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | 'PO&PI'     | 'Sales order 503 dated 30.03.2021 11:57:06'  | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | '5,000'      |
		| 'Sales order 503 dated 30.03.2021 11:57:06'  | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | 'PO&PI'     | 'Sales order 503 dated 30.03.2021 11:57:06'  | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | '10,000'     |
		| '$$PurchaseOrder029201$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'PO&PI'     | 'Sales order 501 dated 30.03.2021 11:56:21'  | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '5,000'      |
		| '$$PurchaseOrder029201$$'                    | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | 'PO&PI'     | 'Sales order 502 dated 30.03.2021 11:56:28'  | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | '8,000'      |
		| '$$PurchaseOrder029201$$'                    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | 'PO&PI'     | 'Sales order 501 dated 30.03.2021 11:56:21'  | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | '2,000'      |
		| '$$PurchaseOrder029201$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'PO&PI'     | 'Sales order 502 dated 30.03.2021 11:56:28'  | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| '$$PurchaseOrder029201$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'PO&PI'     | 'Sales order 502 dated 30.03.2021 11:56:28'  | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '8,000'      |
		| '$$PurchaseOrder029201$$'                    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | 'PO&PI'     | 'Sales order 503 dated 30.03.2021 11:57:06'  | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | '10,000'     |
		| '$$PurchaseOrder029201$$'                    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | 'PO&PI'     | 'Sales order 503 dated 30.03.2021 11:57:06'  | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | '5,000'      |
		| '$$PurchaseOrder029201$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | 'PO&PI'     | 'Sales order 503 dated 30.03.2021 11:57:06'  | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | '10,000'     |
		| '$$PurchaseOrder029201$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '5,000'      |
		| '$$PurchaseOrder029201$$'                    | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | '8,000'      |
		| '$$PurchaseOrder029201$$'                    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | '2,000'      |
		| '$$PurchaseOrder029201$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| '$$PurchaseOrder029201$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '15,000'     |
		| '$$PurchaseOrder029201$$'                    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | '10,000'     |
		| '$$PurchaseOrder029201$$'                    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | '5,000'      |
		| '$$PurchaseOrder029201$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | '20,000'     |
		| '$$PurchaseOrder029201$$'                    | '$$Rov9PurchaseOrder029201$$'           | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '$$Rov9PurchaseOrder029201$$'           | '40,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '4,000'      |
		| '$$PurchaseInvoice0292021$$'                 | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | '8,000'      |
		| '$$PurchaseInvoice0292021$$'                 | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | '2,000'      |
		| '$$PurchaseInvoice0292021$$'                 | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '15,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | '10,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | '5,000'      |
		| '$$PurchaseInvoice0292021$$'                 | '$$Rov9PurchaseOrder029201$$'           | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '$$Rov9PurchaseOrder029201$$'           | '40,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '4,000'      |
		| '$$PurchaseInvoice0292021$$'                 | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | '3,000'      |
		| '$$PurchaseInvoice0292021$$'                 | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '15,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | '10,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | '5,000'      |
		| '$$PurchaseInvoice0292021$$'                 | '$$Rov9PurchaseOrder029201$$'           | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '$$Rov9PurchaseOrder029201$$'           | '40,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'SI&SC'     | '$$PurchaseInvoice0292021$$'                 | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| '$$PurchaseInvoice0292021$$'                 | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | 'SI&SC'     | '$$PurchaseInvoice0292021$$'                 | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | '8,000'      |
		| '$$GoodsReceipt0292021$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '4,000'      |
		| '$$GoodsReceipt0292021$$'                    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | '3,000'      |
		| '$$GoodsReceipt0292021$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '15,000'     |
		| '$$GoodsReceipt0292021$$'                    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | '10,000'     |
		| '$$GoodsReceipt0292021$$'                    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | '5,000'      |
		| '$$GoodsReceipt0292021$$'                    | '$$Rov9PurchaseOrder029201$$'           | 'GR'        | '$$PurchaseInvoice0292021$$'                 | '$$Rov9PurchaseOrder029201$$'           | '40,000'     |
		| '$$GoodsReceipt0292021$$'                    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | 'SI&SC'     | '$$GoodsReceipt0292021$$'                    | '40d4db8e-5a7c-4d0f-878c-4f054b2a01cf'  | '5,000'      |
		| '$$GoodsReceipt0292021$$'                    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | 'SI&SC'     | '$$GoodsReceipt0292021$$'                    | '323ed282-6c37-4443-b3b5-6abd5531e1b7'  | '10,000'     |
		| '$$GoodsReceipt0292021$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'SI&SC'     | '$$GoodsReceipt0292021$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '15,000'     |
		| '$$GoodsReceipt0292021$$'                    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | 'SI&SC'     | '$$GoodsReceipt0292021$$'                    | '3cddf099-4bbf-4c9c-807a-bb2388f83e42'  | '3,000'      |
		| '$$GoodsReceipt0292021$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'SI&SC'     | '$$GoodsReceipt0292021$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '4,000'      |
		| '$$GoodsReceipt0292022$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '1,000'      |
		| '$$GoodsReceipt0292022$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | 'PI&GR'     | '$$PurchaseOrder029201$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | '20,000'     |
		| '$$GoodsReceipt0292022$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'PI'        | '$$GoodsReceipt0292022$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '1,000'      |
		| '$$GoodsReceipt0292022$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | 'PI'        | '$$GoodsReceipt0292022$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | '20,000'     |
		| '$$GoodsReceipt0292022$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | 'SI&SC'     | '$$GoodsReceipt0292022$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | '20,000'     |
		| '$$GoodsReceipt0292022$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'SI&SC'     | '$$GoodsReceipt0292022$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '1,000'      |
		| '$$PurchaseInvoice0292022$$'                 | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | 'PI'        | '$$GoodsReceipt0292022$$'                    | '6e8fe2b7-0bac-4b1e-92be-9a51ae0740b0'  | '1,000'      |
		| '$$PurchaseInvoice0292022$$'                 | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | 'PI'        | '$$GoodsReceipt0292022$$'                    | 'b07db6dd-4d01-469c-a8e8-ccfb69c27f28'  | '20,000'     |
		| '$$SalesInvoice029203$$'                     | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7'  | 'SI&WO&WS'  | 'Sales order 502 dated 30.03.2021 11:56:28'  | '1b08fb3c-845d-4912-9cc0-e07de99cb5c7'  | '2,000'      |
		| '$$SalesInvoice029203$$'                     | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | 'SI&SC'     | '$$PurchaseInvoice0292021$$'                 | '653068c5-a3a6-4d27-9e5e-1fc8102f7d91'  | '8,000'      |
		| '$$SalesInvoice029203$$'                     | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'SI&SC'     | '$$PurchaseInvoice0292021$$'                 | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| '$$SalesInvoice029203$$'                     | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'SC'        | '$$SalesInvoice029203$$'                     | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| '$$ShipmentConfirmation029203$$'             | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | 'SC'        | '$$SalesInvoice029203$$'                     | '647c0486-7e3c-49c1-aca2-7ffcc3246b18'  | '11,000'     |
		| '$$ShipmentConfirmation029204$$'             | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'SI&SC'     | '$$GoodsReceipt0292021$$'                    | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '5,000'      |
		| '$$ShipmentConfirmation029204$$'             | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | 'SI'        | '$$ShipmentConfirmation029204$$'             | '4a003d08-12af-4c34-98d5-5cdeb84616de'  | '5,000'      |
	Then the number of "List" table lines is "равно" "72"
	And I close all client application windows
	



Scenario: _029210 SO - PO - GR - SC - PI - SI
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029210$$" variable
		And I delete "$$SalesOrder029210$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029210$$"
		And I save the window as "$$SalesOrder029210$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029210$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029210$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029210$$'    |
	* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029210$$" variable
		And I delete "$$PurchaseOrder029210$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029210$$"
		And I save the window as "$$PurchaseOrder029210$$"
	* Create GR
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029210$$" variable
		And I delete "$$GoodsReceipt029210$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029210$$"
		And I save the window as "$$GoodsReceipt029210$$"
		And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029210$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029210$$'   | '$$SalesOrder029210$$'    |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029210$$" variable
		And I delete "$$ShipmentConfirmation029210$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029210$$"
		And I save the window as "$$ShipmentConfirmation29210$$"
		And I close current window
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberGoodsReceipt029210$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Source of origins'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Internal supply request'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Expense type'   | 'Purchase order'            | 'Detail'   | 'Sales order'            | 'Net amount'   | 'Use goods receipt'    |
			| 'Trousers'   | '38/Yellow'   | ''                     | 'No'                   | '122,03'       | 'pcs'    | ''                     | ''                    | '100,00'   | '18%'   | ''                | '800,00'         | ''                      | ''                          | 'Store 01'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029210$$'   | ''         | '$$SalesOrder029210$$'   | '677,97'       | 'Yes'                  |
			| 'Shirt'      | '38/Black'    | ''                     | 'No'                   | '335,59'       | 'pcs'    | ''                     | ''                    | '200,00'   | '18%'   | ''                | '2 200,00'       | ''                      | ''                          | 'Store 01'   | '11,000'     | ''                            | ''               | '$$PurchaseOrder029210$$'   | ''         | '$$SalesOrder029210$$'   | '1 864,41'     | 'Yes'                  |
			| 'Dress'      | 'M/White'     | ''                     | 'No'                   | '366,10'       | 'pcs'    | ''                     | ''                    | '300,00'   | '18%'   | ''                | '2 400,00'       | ''                      | ''                          | 'Store 01'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029210$$'   | ''         | '$$SalesOrder029210$$'   | '2 033,90'     | 'Yes'                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029210$$'   | '$$PurchaseOrder029210$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029210$$" variable
		And I delete "$$PurchaseInvoice029210$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029210$$"
		And I save the window as "$$PurchaseInvoice29210$$"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029210$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Use shipment confirmation'   | 'Sales order'             |
			| '1'   | 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029210$$'    |
			| '2'   | 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029210$$'    |
			| '3'   | 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029210$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029210$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029210$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029210$$'    |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029210$$" variable
		And I delete "$$SalesInvoice029210$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029210$$"
		And I save the window as "$$SalesInvoice29210$$"
		And I close all client application windows
		
				

Scenario: _029212 SO - PO - GR - PI - SC - SI
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029212$$" variable
		And I delete "$$SalesOrder029212$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029212$$"
		And I save the window as "$$SalesOrder029212$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029212$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029212$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029212$$'    |
	* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029212$$" variable
		And I delete "$$PurchaseOrder029212$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029212$$"
		And I save the window as "$$PurchaseOrder029212$$"
	* Create GR
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029212$$" variable
		And I delete "$$GoodsReceipt029212$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029212$$"
		And I save the window as "$$GoodsReceipt029212$$"
		And I close all client application windows
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberGoodsReceipt029212$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Source of origins'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Internal supply request'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Expense type'   | 'Purchase order'            | 'Detail'   | 'Sales order'            | 'Net amount'   | 'Use goods receipt'    |
			| 'Trousers'   | '38/Yellow'   | ''                     | 'No'                   | '122,03'       | 'pcs'    | ''                     | ''                    | '100,00'   | '18%'   | ''                | '800,00'         | ''                      | ''                          | 'Store 01'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029212$$'   | ''         | '$$SalesOrder029212$$'   | '677,97'       | 'Yes'                  |
			| 'Shirt'      | '38/Black'    | ''                     | 'No'                   | '335,59'       | 'pcs'    | ''                     | ''                    | '200,00'   | '18%'   | ''                | '2 200,00'       | ''                      | ''                          | 'Store 01'   | '11,000'     | ''                            | ''               | '$$PurchaseOrder029212$$'   | ''         | '$$SalesOrder029212$$'   | '1 864,41'     | 'Yes'                  |
			| 'Dress'      | 'M/White'     | ''                     | 'No'                   | '366,10'       | 'pcs'    | ''                     | ''                    | '300,00'   | '18%'   | ''                | '2 400,00'       | ''                      | ''                          | 'Store 01'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029212$$'   | ''         | '$$SalesOrder029212$$'   | '2 033,90'     | 'Yes'                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029212$$'   | '$$PurchaseOrder029212$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029212$$" variable
		And I delete "$$PurchaseInvoice029212$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029212$$"
		And I save the window as "$$PurchaseInvoice029212$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029212$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029212$$'   | '$$SalesOrder029212$$'    |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029212$$" variable
		And I delete "$$ShipmentConfirmation029212$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029212$$"
		And I save the window as "$$ShipmentConfirmation029212$$"
		And I close current window
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029212$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Use shipment confirmation'   | 'Sales order'             |
			| '1'   | 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029212$$'    |
			| '2'   | 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029212$$'    |
			| '3'   | 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029212$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029212$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029212$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029212$$'    |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029212$$" variable
		And I delete "$$SalesInvoice029212$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029212$$"
		And I save the window as "$$SalesInvoice29212$$"
		And I close all client application windows
		
				
			
				
Scenario: _029216 SO - PO - PI - SI
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029216$$" variable
		And I delete "$$SalesOrder029216$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029216$$"
		And I save the window as "$$SalesOrder029216$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029216$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029216$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029216$$'    |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029216$$'   | '$$SalesOrder029216$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029216$$'   | '$$SalesOrder029216$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029216$$'   | '$$SalesOrder029216$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029216$$" variable
		And I delete "$$PurchaseOrder029216$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029216$$"
		And I save the window as "$$PurchaseOrder029216$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029216$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029216$$'   | '$$SalesOrder029216$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 01'   | '11,000'     | ''                            | '$$PurchaseOrder029216$$'   | '$$SalesOrder029216$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029216$$'   | '$$SalesOrder029216$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029216$$'   | '$$PurchaseOrder029216$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029216$$'   | '$$PurchaseOrder029216$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029216$$'   | '$$PurchaseOrder029216$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029216$$" variable
		And I delete "$$PurchaseInvoice029216$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029216$$"
		And I save the window as "$$PurchaseInvoice029216$$"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029216$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029216$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029216$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029216$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029216$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029216$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029216$$'    |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029216$$" variable
		And I delete "$$SalesInvoice029216$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029216$$"
		And I save the window as "$$SalesInvoice029216$$"
		And I close all client application windows				

Scenario: _029218 SO - PO - PI - SI - SC
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029218$$" variable
		And I delete "$$SalesOrder029218$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029218$$"
		And I save the window as "$$SalesOrder029218$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029218$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029218$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029218$$'    |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029218$$'   | '$$SalesOrder029218$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029218$$'   | '$$SalesOrder029218$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029218$$'   | '$$SalesOrder029218$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029218$$" variable
		And I delete "$$PurchaseOrder029218$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029218$$"
		And I save the window as "$$PurchaseOrder029218$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029218$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029218$$'   | '$$SalesOrder029218$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 01'   | '11,000'     | ''                            | '$$PurchaseOrder029218$$'   | '$$SalesOrder029218$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029218$$'   | '$$SalesOrder029218$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029218$$'   | '$$PurchaseOrder029218$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029218$$'   | '$$PurchaseOrder029218$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029218$$'   | '$$PurchaseOrder029218$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029218$$" variable
		And I delete "$$PurchaseInvoice029218$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029218$$"
		And I save the window as "$$PurchaseInvoice029218$$"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029218$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029218$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029218$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029218$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029218$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029218$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029218$$'    |
		And for each line of "ItemList" table I do
			And I set "Use shipment confirmation" checkbox in "ItemList" table		
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029218$$" variable
		And I delete "$$SalesInvoice029218$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029218$$"
		And I save the window as "$$SalesInvoice029218$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice029218$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029218$$'   | '$$SalesInvoice029218$$'   | '$$SalesInvoice029218$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029218$$'   | '$$SalesInvoice029218$$'   | '$$SalesInvoice029218$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029218$$'   | '$$SalesInvoice029218$$'   | '$$SalesInvoice029218$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029218$$'   | '$$SalesInvoice029218$$'   | '$$SalesInvoice029218$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029218$$'   | '$$SalesInvoice029218$$'   | '$$SalesInvoice029218$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029218$$'   | '$$SalesInvoice029218$$'   | '$$SalesInvoice029218$$'    |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029218$$" variable
		And I delete "$$ShipmentConfirmation029218$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029218$$"
		And I save the window as "$$ShipmentConfirmation029218$$"
		And I close current window
		And I close all client application windows						

Scenario: _029220 SO - PO - PI - GR - SI
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029220$$" variable
		And I delete "$$SalesOrder029220$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029220$$"
		And I save the window as "$$SalesOrder029220$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029220$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029220$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029220$$'    |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029220$$'   | '$$SalesOrder029220$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029220$$'   | '$$SalesOrder029220$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029220$$'   | '$$SalesOrder029220$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029220$$" variable
		And I delete "$$PurchaseOrder029220$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029220$$"
		And I save the window as "$$PurchaseOrder029220$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029220$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029220$$'   | '$$SalesOrder029220$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 01'   | '11,000'     | ''                            | '$$PurchaseOrder029220$$'   | '$$SalesOrder029220$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029220$$'   | '$$SalesOrder029220$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'    |
		And for each line of "ItemList" table I do
			And I set "Use goods receipt" checkbox in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029220$$" variable
		And I delete "$$PurchaseInvoice029220$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029220$$"
		And I save the window as "$$PurchaseInvoice029220$$"
	* Create GR
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029220$$'    |
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'   | '$$PurchaseInvoice029220$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'   | '$$PurchaseInvoice029220$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'   | '$$PurchaseInvoice029220$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'   | 'Receipt basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                 | ''                 |
			| 'Shirt'      | '38/Black'    | ''              | ''                 | ''                 |
			| 'Dress'      | 'M/White'     | ''              | ''                 | ''                 |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'   | '$$PurchaseInvoice029220$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'   | '$$PurchaseInvoice029220$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029220$$'   | '$$PurchaseOrder029220$$'   | '$$PurchaseInvoice029220$$'    |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029220$$" variable
		And I delete "$$GoodsReceipt029220$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029220$$"
		And I save the window as "$$GoodsReceipt029220$$"
		And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029220$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029220$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029220$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029220$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029220$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029220$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029220$$'    |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029220$$" variable
		And I delete "$$SalesInvoice029220$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029220$$"
		And I save the window as "$$SalesInvoice029220$$"
		And I close all client application windows		
				
	
Scenario: _029222 SO - PO - PI - SC - SI
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029222$$" variable
		And I delete "$$SalesOrder029222$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029222$$"
		And I save the window as "$$SalesOrder029222$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029222$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029222$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029222$$'    |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029222$$" variable
		And I delete "$$PurchaseOrder029222$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029222$$"
		And I save the window as "$$PurchaseOrder029222$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029222$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029222$$'   | '$$SalesOrder029222$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 01'   | '11,000'     | ''                            | '$$PurchaseOrder029222$$'   | '$$SalesOrder029222$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029222$$'   | '$$SalesOrder029222$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029222$$'   | '$$PurchaseOrder029222$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029222$$'   | '$$PurchaseOrder029222$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029222$$'   | '$$PurchaseOrder029222$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029222$$" variable
		And I delete "$$PurchaseInvoice029222$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029222$$"
		And I save the window as "$$PurchaseInvoice029222$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029222$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'         | 'Sales invoice'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'   | ''                 |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'   | ''                 |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'   | ''                 |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'         | 'Sales invoice'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'   | ''                 |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'   | ''                 |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029222$$'   | '$$SalesOrder029222$$'   | ''                 |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029222$$" variable
		And I delete "$$ShipmentConfirmation029222$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029222$$"
		And I save the window as "$$ShipmentConfirmation029222$$"
		And I close current window
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029222$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029222$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029222$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029222$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029222$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029222$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029222$$'    |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029222$$" variable
		And I delete "$$SalesInvoice029222$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029222$$"
		And I save the window as "$$SalesInvoice029222$$"
		And I close all client application windows	

Scenario: _029224 SO - PO - PI  - GR - SI - SC
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029224$$" variable
		And I delete "$$SalesOrder029224$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029224$$"
		And I save the window as "$$SalesOrder029224$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029224$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029224$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029224$$'    |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029224$$'   | '$$SalesOrder029224$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029224$$'   | '$$SalesOrder029224$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029224$$'   | '$$SalesOrder029224$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029224$$" variable
		And I delete "$$PurchaseOrder029224$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029224$$"
		And I save the window as "$$PurchaseOrder029224$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029224$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029224$$'   | '$$SalesOrder029224$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 01'   | '11,000'     | ''                            | '$$PurchaseOrder029224$$'   | '$$SalesOrder029224$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029224$$'   | '$$SalesOrder029224$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'    |
		And for each line of "ItemList" table I do
			And I set "Use goods receipt" checkbox in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029224$$" variable
		And I delete "$$PurchaseInvoice029224$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029224$$"
		And I save the window as "$$PurchaseInvoice029224$$"
	* Create GR
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029224$$'    |
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'   | '$$PurchaseInvoice029224$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'   | '$$PurchaseInvoice029224$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'   | '$$PurchaseInvoice029224$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'   | 'Receipt basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                 | ''                 |
			| 'Shirt'      | '38/Black'    | ''              | ''                 | ''                 |
			| 'Dress'      | 'M/White'     | ''              | ''                 | ''                 |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'   | '$$PurchaseInvoice029224$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'   | '$$PurchaseInvoice029224$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029224$$'   | '$$PurchaseOrder029224$$'   | '$$PurchaseInvoice029224$$'    |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029224$$" variable
		And I delete "$$GoodsReceipt029224$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029224$$"
		And I save the window as "$$GoodsReceipt029224$$"
		And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029224$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029224$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029224$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029224$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029224$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029224$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029224$$'    |
		And for each line of "ItemList" table I do
			And I set "Use shipment confirmation" checkbox in "ItemList" table		
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029224$$" variable
		And I delete "$$SalesInvoice029224$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029224$$"
		And I save the window as "$$SalesInvoice029224$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice029224$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029224$$'   | '$$SalesInvoice029224$$'   | '$$SalesInvoice029224$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029224$$'   | '$$SalesInvoice029224$$'   | '$$SalesInvoice029224$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029224$$'   | '$$SalesInvoice029224$$'   | '$$SalesInvoice029224$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029224$$'   | '$$SalesInvoice029224$$'   | '$$SalesInvoice029224$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029224$$'   | '$$SalesInvoice029224$$'   | '$$SalesInvoice029224$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029224$$'   | '$$SalesInvoice029224$$'   | '$$SalesInvoice029224$$'    |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029224$$" variable
		And I delete "$$ShipmentConfirmation029224$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029224$$"
		And I save the window as "$$ShipmentConfirmation029224$$"
		And I close current window
		And I close all client application windows	
			
Scenario: _029226 SO - PO - PI  - GR - SC - SI
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029226$$" variable
		And I delete "$$SalesOrder029226$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029226$$"
		And I save the window as "$$SalesOrder029226$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029226$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029226$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029226$$'    |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029226$$" variable
		And I delete "$$PurchaseOrder029226$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029226$$"
		And I save the window as "$$PurchaseOrder029226$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029226$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029226$$'   | '$$SalesOrder029226$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 01'   | '11,000'     | ''                            | '$$PurchaseOrder029226$$'   | '$$SalesOrder029226$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029226$$'   | '$$SalesOrder029226$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'    |
		And for each line of "ItemList" table I do
			And I set "Use goods receipt" checkbox in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029226$$" variable
		And I delete "$$PurchaseInvoice029226$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029226$$"
		And I save the window as "$$PurchaseInvoice029226$$"
	* Create GR
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029226$$'    |
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'   | '$$PurchaseInvoice029226$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'   | '$$PurchaseInvoice029226$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'   | '$$PurchaseInvoice029226$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'   | 'Receipt basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                 | ''                 |
			| 'Shirt'      | '38/Black'    | ''              | ''                 | ''                 |
			| 'Dress'      | 'M/White'     | ''              | ''                 | ''                 |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'   | '$$PurchaseInvoice029226$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'   | '$$PurchaseInvoice029226$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029226$$'   | '$$PurchaseOrder029226$$'   | '$$PurchaseInvoice029226$$'    |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029226$$" variable
		And I delete "$$GoodsReceipt029226$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029226$$"
		And I save the window as "$$GoodsReceipt029226$$"
		And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029226$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029226$$'   | '$$SalesOrder029226$$'    |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029226$$" variable
		And I delete "$$ShipmentConfirmation029226$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029226$$"
		And I save the window as "$$ShipmentConfirmation029226$$"
		And I close current window
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029226$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Use shipment confirmation'   | 'Sales order'             |
			| '1'   | 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029226$$'    |
			| '2'   | 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029226$$'    |
			| '3'   | 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029226$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029226$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029226$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029226$$'    |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029226$$" variable
		And I delete "$$SalesInvoice029226$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029226$$"
		And I save the window as "$$SalesInvoice29212$$"
		And I close all client application windows						

# Scenario: _029214 SO - PO - PI - SI - GR - SC
# 	And I close all client application windows
# 	* Create SO
# 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
# 		And I go to line in "List" table
# 			| 'Number'    |
# 			| '502'       |
# 		And in the table "List" I click "Copy" button
# 		Then "Update item list info" window is opened
# 		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
# 		And I change checkbox "Do you want to update filled prices?"
# 		And I click "OK" button
# 		And I click "Post" button
# 		And I delete "$$NumberSalesOrder029214$$" variable
# 		And I delete "$$SalesOrder029214$$" variable
# 		And I save the value of "Number" field as "$$NumberSalesOrder029214$$"
# 		And I save the window as "$$SalesOrder029214$$"
# 	* Create PO
# 		And I click "Purchase order" button
# 		And I click "Ok" button
# 		And I click Choice button of the field named "Partner"
# 		And I go to line in "List" table
# 			| 'Description'    |
# 			| 'Ferron BP'      |
# 		And I select current line in "List" table
# 		And I click Select button of "Partner term" field
# 		And I go to line in "List" table
# 			| 'Description'           |
# 			| 'Vendor Ferron, TRY'    |
# 		And I select current line in "List" table
# 		Then "Update item list info" window is opened
# 		And I click "OK" button
# 		And I select "Approved" exact value from the drop-down list named "Status"
# 		And I activate field named "ItemListLineNumber" in "ItemList" table
# 		And "ItemList" table contains lines
# 			| 'Item key'    | 'Item'       | 'Sales order'             |
# 			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029214$$'    |
# 			| '38/Black'    | 'Shirt'      | '$$SalesOrder029214$$'    |
# 			| 'M/White'     | 'Dress'      | '$$SalesOrder029214$$'    |
# 		* Unlink and link
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I change checkbox "Linked documents"
# 		And in the table "ResultsTree" I click "Unlink all" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item key'    | 'Item'       | 'Sales order'    |
# 			| '38/Yellow'   | 'Trousers'   | ''               |
# 			| '38/Black'    | 'Shirt'      | ''               |
# 			| 'M/White'     | 'Dress'      | ''               |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I click "Auto link" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
# 			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029214$$'   | '$$SalesOrder029214$$'    |
# 			| '38/Black'    | 'Shirt'      | '$$SalesOrder029214$$'   | '$$SalesOrder029214$$'    |
# 			| 'M/White'     | 'Dress'      | '$$SalesOrder029214$$'   | '$$SalesOrder029214$$'    |
# 		And I go to line in "ItemList" table
# 			| 'Item'       | 'Item key'     |
# 			| 'Trousers'   | '38/Yellow'    |
# 		And I select current line in "ItemList" table
# 		And I input "100,00" text in "Price" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I go to line in "ItemList" table
# 			| 'Item'    | 'Item key'    |
# 			| 'Shirt'   | '38/Black'    |
# 		And I select current line in "ItemList" table
# 		And I input "200,00" text in "Price" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I go to line in "ItemList" table
# 			| 'Item'    | 'Item key'    |
# 			| 'Dress'   | 'M/White'     |
# 		And I select current line in "ItemList" table
# 		And I input "300,00" text in "Price" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I click "Post" button
# 		And I delete "$$NumberPurchaseOrder029214$$" variable
# 		And I delete "$$PurchaseOrder029214$$" variable
# 		And I save the value of "Number" field as "$$NumberPurchaseOrder029214$$"
# 		And I save the window as "$$PurchaseOrder029214$$"
# 	* Create PI	
# 		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
# 		And I go to line in "List" table
# 			| 'Number'                           |
# 			| '$$NumberPurchaseOrder029214$$'    |
# 		And I click "Purchase invoice" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
# 			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029214$$'   | '$$SalesOrder029214$$'   | '677,97'        |
# 			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 01'   | '11,000'     | ''                            | '$$PurchaseOrder029214$$'   | '$$SalesOrder029214$$'   | '1 864,41'      |
# 			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 01'   | '8,000'      | ''                            | '$$PurchaseOrder029214$$'   | '$$SalesOrder029214$$'   | '2 033,90'      |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I change checkbox "Linked documents"
# 		And in the table "ResultsTree" I click "Unlink all" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
# 			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
# 			| 'Shirt'      | '38/Black'    | ''              | ''                  |
# 			| 'Dress'      | 'M/White'     | ''              | ''                  |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I click "Auto link" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
# 			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'    |
# 			| 'Shirt'      | '38/Black'    | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'    |
# 			| 'Dress'      | 'M/White'     | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'    |
# 		And I go to line in "ItemList" table
# 			| 'Item'       | 'Item key'     |
# 			| 'Trousers'   | '38/Yellow'    |
# 		And I select current line in "ItemList" table
# 		And I input "100,00" text in "Price" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I go to line in "ItemList" table
# 			| 'Item'    | 'Item key'    |
# 			| 'Shirt'   | '38/Black'    |
# 		And I select current line in "ItemList" table
# 		And I input "200,00" text in "Price" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I go to line in "ItemList" table
# 			| 'Item'    | 'Item key'    |
# 			| 'Dress'   | 'M/White'     |
# 		And I select current line in "ItemList" table
# 		And I input "300,00" text in "Price" field of "ItemList" table
# 		And for each line of "ItemList" table I do
# 			And I set "Use goods receipt" checkbox in "ItemList" table
# 		And I click "Post" button
# 		And I delete "$$NumberPurchaseInvoice029214$$" variable
# 		And I delete "$$PurchaseInvoice029214$$" variable
# 		And I save the value of "Number" field as "$$NumberPurchaseInvoice029214$$"
# 		And I save the window as "$$PurchaseInvoice029214$$"
# 	* Create SI
# 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
# 		And I go to line in "List" table
# 			| 'Number'                        |
# 			| '$$NumberSalesOrder029214$$'    |
# 		And I click "Sales invoice" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
# 			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029214$$'    |
# 			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029214$$'    |
# 			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029214$$'    |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I change checkbox "Linked documents"
# 		And in the table "ResultsTree" I click "Unlink all" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'    |
# 			| 'Trousers'   | '38/Yellow'   | ''               |
# 			| 'Shirt'      | '38/Black'    | ''               |
# 			| 'Dress'      | 'M/White'     | ''               |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I click "Auto link" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'             |
# 			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029214$$'    |
# 			| 'Shirt'      | '38/Black'    | '$$SalesOrder029214$$'    |
# 			| 'Dress'      | 'M/White'     | '$$SalesOrder029214$$'    |
# 		And for each line of "ItemList" table I do
# 			And I set "Use shipment confirmation" checkbox in "ItemList" table		
# 		And I click "Post" button
# 		And I delete "$$NumberSalesInvoice029214$$" variable
# 		And I delete "$$SalesInvoice029214$$" variable
# 		And I save the value of "Number" field as "$$NumberSalesInvoice029214$$"
# 		And I save the window as "$$SalesInvoice029214$$"
# 	* Create GR
# 		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
# 		And I go to line in "List" table
# 			| 'Number'                             |
# 			| '$$NumberPurchaseInvoice029214$$'    |
# 		And I click "Goods receipt" button
# 		And I click "Ok" button
# 		And I activate field named "ItemListLineNumber" in "ItemList" table
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
# 			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'   | '$$PurchaseInvoice029214$$'    |
# 			| 'Shirt'      | '38/Black'    | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'   | '$$PurchaseInvoice029214$$'    |
# 			| 'Dress'      | 'M/White'     | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'   | '$$PurchaseInvoice029214$$'    |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I change checkbox "Linked documents"
# 		And in the table "ResultsTree" I click "Unlink all" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'   | 'Receipt basis'    |
# 			| 'Trousers'   | '38/Yellow'   | ''              | ''                 | ''                 |
# 			| 'Shirt'      | '38/Black'    | ''              | ''                 | ''                 |
# 			| 'Dress'      | 'M/White'     | ''              | ''                 | ''                 |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I click "Auto link" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |
# 			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'   | '$$PurchaseInvoice029214$$'    |
# 			| 'Shirt'      | '38/Black'    | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'   | '$$PurchaseInvoice029214$$'    |
# 			| 'Dress'      | 'M/White'     | '$$SalesOrder029214$$'   | '$$PurchaseOrder029214$$'   | '$$PurchaseInvoice029214$$'    |
# 		And I click "Post" button
# 		And I delete "$$NumberGoodsReceipt029214$$" variable
# 		And I delete "$$GoodsReceipt029214$$" variable
# 		And I save the value of "Number" field as "$$NumberGoodsReceipt029214$$"
# 		And I save the window as "$$GoodsReceipt029214$$"
# 		And I close all client application windows
# 	* Create SC
# 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
# 		And I go to line in "List" table
# 			| 'Number'                          |
# 			| '$$NumberSalesInvoice029214$$'    |
# 		And I click "Shipment confirmation" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |
# 			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029214$$'   | '$$SalesInvoice029214$$'   | '$$SalesInvoice029214$$'    |
# 			| 'Shirt'      | '38/Black'    | '$$SalesOrder029214$$'   | '$$SalesInvoice029214$$'   | '$$SalesInvoice029214$$'    |
# 			| 'Dress'      | 'M/White'     | '$$SalesOrder029214$$'   | '$$SalesInvoice029214$$'   | '$$SalesInvoice029214$$'    |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I change checkbox "Linked documents"
# 		And in the table "ResultsTree" I click "Unlink all" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
# 			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
# 			| 'Shirt'      | '38/Black'    | ''              | ''                  |
# 			| 'Dress'      | 'M/White'     | ''              | ''                  |
# 		And in the table "ItemList" I click "Link unlink basis documents" button
# 		And I click "Auto link" button
# 		And I click "Ok" button
# 		And "ItemList" table contains lines
# 			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |
# 			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029214$$'   | '$$SalesInvoice029214$$'   | '$$SalesInvoice029214$$'    |
# 			| 'Shirt'      | '38/Black'    | '$$SalesOrder029214$$'   | '$$SalesInvoice029214$$'   | '$$SalesInvoice029214$$'    |
# 			| 'Dress'      | 'M/White'     | '$$SalesOrder029214$$'   | '$$SalesInvoice029214$$'   | '$$SalesInvoice029214$$'    |
# 		And I click "Post" button
# 		And I delete "$$NumberShipmentConfirmation029214$$" variable
# 		And I delete "$$ShipmentConfirmation029214$$" variable
# 		And I save the value of "Number" field as "$$NumberShipmentConfirmation029214$$"
# 		And I save the window as "$$ShipmentConfirmation029214$$"
# 		And I close current window
# 		And I close all client application windows	

Scenario: _029228 SO - PO - GR - SC - PI - SI (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029228$$" variable
		And I delete "$$SalesOrder029228$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029228$$"
		And I save the window as "$$SalesOrder029228$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029228$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029228$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029228$$' | 'Store 02' |
	* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And Delay 2
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029228$$" variable
		And I delete "$$PurchaseOrder029228$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029228$$"
		And I save the window as "$$PurchaseOrder029228$$"
	* Create GR
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029228$$' | '$$PurchaseOrder029228$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029228$$' | '$$PurchaseOrder029228$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029228$$' | '$$PurchaseOrder029228$$' | 'Store 02' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029228$$'   | '$$PurchaseOrder029228$$'    | 'Store 02' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029228$$'   | '$$PurchaseOrder029228$$'    | 'Store 02' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029228$$'   | '$$PurchaseOrder029228$$'    | 'Store 02' |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029228$$" variable
		And I delete "$$GoodsReceipt029228$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029228$$"
		And I save the window as "$$GoodsReceipt029228$$"
		And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029228$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    | 'Store 01' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    | 'Store 01' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    | 'Store 01' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    | 'Store 01' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    | 'Store 01' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029228$$'   | '$$SalesOrder029228$$'    | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029228$$" variable
		And I delete "$$ShipmentConfirmation029228$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029228$$"
		And I save the window as "$$ShipmentConfirmation29228$$"
		And I close current window
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberGoodsReceipt029228$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Source of origins'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Internal supply request'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Expense type'   | 'Purchase order'            | 'Detail'   | 'Sales order'            | 'Net amount'   | 'Use goods receipt'    |
			| 'Trousers'   | '38/Yellow'   | ''                     | 'No'                   | '122,03'       | 'pcs'    | ''                     | ''                    | '100,00'   | '18%'   | ''                | '800,00'         | ''                      | ''                          | 'Store 02'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029228$$'   | ''         | '$$SalesOrder029228$$'   | '677,97'       | 'Yes'                  |
			| 'Shirt'      | '38/Black'    | ''                     | 'No'                   | '335,59'       | 'pcs'    | ''                     | ''                    | '200,00'   | '18%'   | ''                | '2 200,00'       | ''                      | ''                          | 'Store 02'   | '11,000'     | ''                            | ''               | '$$PurchaseOrder029228$$'   | ''         | '$$SalesOrder029228$$'   | '1 864,41'     | 'Yes'                  |
			| 'Dress'      | 'M/White'     | ''                     | 'No'                   | '366,10'       | 'pcs'    | ''                     | ''                    | '300,00'   | '18%'   | ''                | '2 400,00'       | ''                      | ''                          | 'Store 02'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029228$$'   | ''         | '$$SalesOrder029228$$'   | '2 033,90'     | 'Yes'                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029228$$' | '$$PurchaseOrder029228$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029228$$' | '$$PurchaseOrder029228$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029228$$' | '$$PurchaseOrder029228$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029228$$" variable
		And I delete "$$PurchaseInvoice029228$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029228$$"
		And I save the window as "$$PurchaseInvoice29228$$"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029228$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Use shipment confirmation'   | 'Sales order'             |
			| '1'   | 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029228$$'    |
			| '2'   | 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029228$$'    |
			| '3'   | 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029228$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029228$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029228$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029228$$'    |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029228$$" variable
		And I delete "$$SalesInvoice029228$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029228$$"
		And I save the window as "$$SalesInvoice29228$$"
		And I close all client application windows
		
				
Scenario: _029229 SO - PO - GR - PI - SC - SI (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029229$$" variable
		And I delete "$$SalesOrder029229$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029229$$"
		And I save the window as "$$SalesOrder029229$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             | 'Store'             |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029229$$'    | 'Store 02'          |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029229$$'    | 'Store 02'          |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029229$$'    | 'Store 02'          |
	* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And Delay 2
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029229$$'   | '$$SalesOrder029229$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029229$$'   | '$$SalesOrder029229$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029229$$'   | '$$SalesOrder029229$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029229$$" variable
		And I delete "$$PurchaseOrder029229$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029229$$"
		And I save the window as "$$PurchaseOrder029229$$"
	* Create GR
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             | 'Store'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029229$$'   | '$$PurchaseOrder029229$$'    | 'Store 02'          |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029229$$'   | '$$PurchaseOrder029229$$'    | 'Store 02'          |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029229$$'   | '$$PurchaseOrder029229$$'    | 'Store 02'          |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             | 'Store'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029229$$'   | '$$PurchaseOrder029229$$'    | 'Store 02'          |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029229$$'   | '$$PurchaseOrder029229$$'    | 'Store 02'          |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029229$$'   | '$$PurchaseOrder029229$$'    | 'Store 02'          |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029229$$" variable
		And I delete "$$GoodsReceipt029229$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029229$$"
		And I save the window as "$$GoodsReceipt029229$$"
		And I close all client application windows
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberGoodsReceipt029229$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Source of origins'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Internal supply request'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Expense type'   | 'Purchase order'            | 'Detail'   | 'Sales order'            | 'Net amount'   | 'Use goods receipt'    |
			| 'Trousers'   | '38/Yellow'   | ''                     | 'No'                   | '122,03'       | 'pcs'    | ''                     | ''                    | '100,00'   | '18%'   | ''                | '800,00'         | ''                      | ''                          | 'Store 02'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029229$$'   | ''         | '$$SalesOrder029229$$'   | '677,97'       | 'Yes'                  |
			| 'Shirt'      | '38/Black'    | ''                     | 'No'                   | '335,59'       | 'pcs'    | ''                     | ''                    | '200,00'   | '18%'   | ''                | '2 200,00'       | ''                      | ''                          | 'Store 02'   | '11,000'     | ''                            | ''               | '$$PurchaseOrder029229$$'   | ''         | '$$SalesOrder029229$$'   | '1 864,41'     | 'Yes'                  |
			| 'Dress'      | 'M/White'     | ''                     | 'No'                   | '366,10'       | 'pcs'    | ''                     | ''                    | '300,00'   | '18%'   | ''                | '2 400,00'       | ''                      | ''                          | 'Store 02'   | '8,000'      | ''                            | ''               | '$$PurchaseOrder029229$$'   | ''         | '$$SalesOrder029229$$'   | '2 033,90'     | 'Yes'                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029229$$' | '$$PurchaseOrder029229$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029229$$' | '$$PurchaseOrder029229$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029229$$' | '$$PurchaseOrder029229$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029229$$" variable
		And I delete "$$PurchaseInvoice029229$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029229$$"
		And I save the window as "$$PurchaseInvoice029229$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029229$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Shipment basis'       | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029229$$' | '$$SalesOrder029229$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029229$$' | '$$SalesOrder029229$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029229$$' | '$$SalesOrder029229$$' | 'Store 01' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029229$$'   | '$$SalesOrder029229$$'    | 'Store 01' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029229$$'   | '$$SalesOrder029229$$'    | 'Store 01' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029229$$'   | '$$SalesOrder029229$$'    | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029229$$" variable
		And I delete "$$ShipmentConfirmation029229$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029229$$"
		And I save the window as "$$ShipmentConfirmation029229$$"
		And I close current window
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029229$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Use shipment confirmation'   | 'Sales order'             |
			| '1'   | 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029229$$'    |
			| '2'   | 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029229$$'    |
			| '3'   | 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029229$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029229$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029229$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029229$$' | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029229$$" variable
		And I delete "$$SalesInvoice029229$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029229$$"
		And I save the window as "$$SalesInvoice29229$$"
		And I close all client application windows			
			
				

Scenario: _029230 SO - PO - PI - SI (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029230$$" variable
		And I delete "$$SalesOrder029230$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029230$$"
		And I save the window as "$$SalesOrder029230$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029230$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029230$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029230$$' | 'Store 02' |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And Delay 2
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029230$$'   | '$$SalesOrder029230$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029230$$'   | '$$SalesOrder029230$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029230$$'   | '$$SalesOrder029230$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029230$$" variable
		And I delete "$$PurchaseOrder029230$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029230$$"
		And I save the window as "$$PurchaseOrder029230$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029230$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And for each line of "ItemList" table I do
			And I remove "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table		
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Price'  | 'VAT' | 'Total amount' | 'Store'    | 'Quantity' | 'Use goods receipt' | 'Purchase order'          | 'Sales order'          | 'Net amount' |
			| 'Trousers' | '38/Yellow' | 'No'                 | '122,03'     | 'pcs'  | '100,00' | '18%' | '800,00'       | 'Store 02' | '8,000'    | 'No'                | '$$PurchaseOrder029230$$' | '$$SalesOrder029230$$' | '677,97'     |
			| 'Shirt'    | '38/Black'  | 'No'                 | '335,59'     | 'pcs'  | '200,00' | '18%' | '2 200,00'     | 'Store 02' | '11,000'   | 'No'                | '$$PurchaseOrder029230$$' | '$$SalesOrder029230$$' | '1 864,41'   |
			| 'Dress'    | 'M/White'   | 'No'                 | '366,10'     | 'pcs'  | '300,00' | '18%' | '2 400,00'     | 'Store 02' | '8,000'    | 'No'                | '$$PurchaseOrder029230$$' | '$$SalesOrder029230$$' | '2 033,90'   |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And Delay 2
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029230$$' | '$$PurchaseOrder029230$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029230$$' | '$$PurchaseOrder029230$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029230$$' | '$$PurchaseOrder029230$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029230$$" variable
		And I delete "$$PurchaseInvoice029230$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029230$$"
		And I save the window as "$$PurchaseInvoice029230$$"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029230$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029230$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029230$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029230$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029230$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029230$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029230$$' | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029230$$" variable
		And I delete "$$SalesInvoice029230$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029230$$"
		And I save the window as "$$SalesInvoice029230$$"
		And I close all client application windows

Scenario: _029231 SO - PO - PI - SI - SC (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029231$$" variable
		And I delete "$$SalesOrder029231$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029231$$"
		And I save the window as "$$SalesOrder029231$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button	
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029231$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029231$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029231$$' | 'Store 02' |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And Delay 2
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029231$$'   | '$$SalesOrder029231$$'    |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029231$$'   | '$$SalesOrder029231$$'    |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029231$$'   | '$$SalesOrder029231$$'    |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029231$$" variable
		And I delete "$$PurchaseOrder029231$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029231$$"
		And I save the window as "$$PurchaseOrder029231$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029231$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button	
		And for each line of "ItemList" table I do
			And I remove "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table	
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Price'  | 'VAT' | 'Total amount' | 'Store'    | 'Quantity' | 'Use goods receipt' | 'Purchase order'          | 'Sales order'          | 'Net amount' |
			| 'Trousers' | '38/Yellow' | 'No'                 | '122,03'     | 'pcs'  | '100,00' | '18%' | '800,00'       | 'Store 02' | '8,000'    | 'No'                | '$$PurchaseOrder029231$$' | '$$SalesOrder029231$$' | '677,97'     |
			| 'Shirt'    | '38/Black'  | 'No'                 | '335,59'     | 'pcs'  | '200,00' | '18%' | '2 200,00'     | 'Store 02' | '11,000'   | 'No'                | '$$PurchaseOrder029231$$' | '$$SalesOrder029231$$' | '1 864,41'   |
			| 'Dress'    | 'M/White'   | 'No'                 | '366,10'     | 'pcs'  | '300,00' | '18%' | '2 400,00'     | 'Store 02' | '8,000'    | 'No'                | '$$PurchaseOrder029231$$' | '$$SalesOrder029231$$' | '2 033,90'   |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029231$$' | '$$PurchaseOrder029231$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029231$$' | '$$PurchaseOrder029231$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029231$$' | '$$PurchaseOrder029231$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029231$$" variable
		And I delete "$$PurchaseInvoice029231$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029231$$"
		And I save the window as "$$PurchaseInvoice029231$$"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029231$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029231$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029231$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029231$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029231$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029231$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029231$$' | 'Store 01' |
		And for each line of "ItemList" table I do
			And I set "Use shipment confirmation" checkbox in "ItemList" table		
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029231$$" variable
		And I delete "$$SalesInvoice029231$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029231$$"
		And I save the window as "$$SalesInvoice029231$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice029231$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Shipment basis'         | 'Sales invoice'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029231$$' | '$$SalesInvoice029231$$' | '$$SalesInvoice029231$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029231$$' | '$$SalesInvoice029231$$' | '$$SalesInvoice029231$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029231$$' | '$$SalesInvoice029231$$' | '$$SalesInvoice029231$$' | 'Store 01' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Shipment basis'         | 'Sales invoice'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029231$$' | '$$SalesInvoice029231$$' | '$$SalesInvoice029231$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029231$$' | '$$SalesInvoice029231$$' | '$$SalesInvoice029231$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029231$$' | '$$SalesInvoice029231$$' | '$$SalesInvoice029231$$' | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029231$$" variable
		And I delete "$$ShipmentConfirmation029231$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029231$$"
		And I save the window as "$$ShipmentConfirmation029231$$"
		And I close current window
		And I close all client application windows						

Scenario: _029232 SO - PO - PI - GR - SI (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029232$$" variable
		And I delete "$$SalesOrder029232$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029232$$"
		And I save the window as "$$SalesOrder029232$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button	
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029232$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029232$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029232$$' | 'Store 02' |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          | 'Store'    |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029232$$'   | '$$SalesOrder029232$$'    | 'Store 02' |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029232$$'   | '$$SalesOrder029232$$'    | 'Store 02' |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029232$$'   | '$$SalesOrder029232$$'    | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029232$$" variable
		And I delete "$$PurchaseOrder029232$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029232$$"
		And I save the window as "$$PurchaseOrder029232$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029232$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029232$$'   | '$$SalesOrder029232$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 02'   | '11,000'     | ''                            | '$$PurchaseOrder029232$$'   | '$$SalesOrder029232$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029232$$'   | '$$SalesOrder029232$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029232$$' | '$$PurchaseOrder029232$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029232$$' | '$$PurchaseOrder029232$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029232$$' | '$$PurchaseOrder029232$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029232$$" variable
		And I delete "$$PurchaseInvoice029232$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029232$$"
		And I save the window as "$$PurchaseInvoice029232$$"
	* Create GR
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029232$$'    |
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Receipt basis'             | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029232$$' | '$$PurchaseOrder029232$$' | '$$PurchaseInvoice029232$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029232$$' | '$$PurchaseOrder029232$$' | '$$PurchaseInvoice029232$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029232$$' | '$$PurchaseOrder029232$$' | '$$PurchaseInvoice029232$$' | 'Store 02' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'   | 'Receipt basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                 | ''                 |
			| 'Shirt'      | '38/Black'    | ''              | ''                 | ''                 |
			| 'Dress'      | 'M/White'     | ''              | ''                 | ''                 |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029232$$'   | '$$PurchaseOrder029232$$'   | '$$PurchaseInvoice029232$$'    | 'Store 02' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029232$$'   | '$$PurchaseOrder029232$$'   | '$$PurchaseInvoice029232$$'    | 'Store 02' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029232$$'   | '$$PurchaseOrder029232$$'   | '$$PurchaseInvoice029232$$'    | 'Store 02' |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029232$$" variable
		And I delete "$$GoodsReceipt029232$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029232$$"
		And I save the window as "$$GoodsReceipt029232$$"
		And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029232$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029232$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029232$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029232$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029232$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029232$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029232$$' | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029232$$" variable
		And I delete "$$SalesInvoice029232$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029232$$"
		And I save the window as "$$SalesInvoice029232$$"
		And I close all client application windows		
				
	
Scenario: _029233 SO - PO - PI - SC - SI (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029233$$" variable
		And I delete "$$SalesOrder029233$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029233$$"
		And I save the window as "$$SalesOrder029233$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029233$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029233$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029233$$' | 'Store 02' |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Purchase basis'       | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029233$$" variable
		And I delete "$$PurchaseOrder029233$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029233$$"
		And I save the window as "$$PurchaseOrder029233$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029233$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And for each line of "ItemList" table I do
			And I remove "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table	
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029233$$'   | '$$SalesOrder029233$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 02'   | '11,000'     | ''                            | '$$PurchaseOrder029233$$'   | '$$SalesOrder029233$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029233$$'   | '$$SalesOrder029233$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029233$$' | '$$PurchaseOrder029233$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029233$$' | '$$PurchaseOrder029233$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029233$$' | '$$PurchaseOrder029233$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029233$$" variable
		And I delete "$$PurchaseInvoice029233$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029233$$"
		And I save the window as "$$PurchaseInvoice029233$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029233$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Shipment basis'       | 'Sales invoice' | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | ''              | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | ''              | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | ''              | 'Store 01' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Shipment basis'       | 'Sales invoice' | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | ''              | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | ''              | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029233$$' | '$$SalesOrder029233$$' | ''              | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029233$$" variable
		And I delete "$$ShipmentConfirmation029233$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029233$$"
		And I save the window as "$$ShipmentConfirmation029233$$"
		And I close current window
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029233$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029233$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029233$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029233$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029233$$' | 'Store 01' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029233$$' | 'Store 01' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029233$$' | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029233$$" variable
		And I delete "$$SalesInvoice029233$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029233$$"
		And I save the window as "$$SalesInvoice029233$$"
		And I close all client application windows	

Scenario: _029234 SO - PO - PI  - GR - SI - SC (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029234$$" variable
		And I delete "$$SalesOrder029234$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029234$$"
		And I save the window as "$$SalesOrder029234$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button	
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'             | 'Store'    |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029234$$'    | 'Store 02' |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029234$$'    | 'Store 02' |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029234$$'    | 'Store 02' |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Purchase basis'       | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029234$$' | '$$SalesOrder029234$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029234$$' | '$$SalesOrder029234$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029234$$' | '$$SalesOrder029234$$' | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029234$$" variable
		And I delete "$$PurchaseOrder029234$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029234$$"
		And I save the window as "$$PurchaseOrder029234$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029234$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029234$$'   | '$$SalesOrder029234$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 02'   | '11,000'     | ''                            | '$$PurchaseOrder029234$$'   | '$$SalesOrder029234$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029234$$'   | '$$SalesOrder029234$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'    |
		And for each line of "ItemList" table I do
			And I set "Use goods receipt" checkbox in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029234$$" variable
		And I delete "$$PurchaseInvoice029234$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029234$$"
		And I save the window as "$$PurchaseInvoice029234$$"
	* Create GR
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029234$$'    |
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |'Store'   |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'   | '$$PurchaseInvoice029234$$'    |'Store 02'|
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'   | '$$PurchaseInvoice029234$$'    |'Store 02'|
			| 'Dress'      | 'M/White'     | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'   | '$$PurchaseInvoice029234$$'    |'Store 02'|
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'   | 'Receipt basis'    |'Store'   |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                 | ''                 |'Store 02'|
			| 'Shirt'      | '38/Black'    | ''              | ''                 | ''                 |'Store 02'|
			| 'Dress'      | 'M/White'     | ''              | ''                 | ''                 |'Store 02'|
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                |'Store'   |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'   | '$$PurchaseInvoice029234$$'    |'Store 02'|
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'   | '$$PurchaseInvoice029234$$'    |'Store 02'|
			| 'Dress'      | 'M/White'     | '$$SalesOrder029234$$'   | '$$PurchaseOrder029234$$'   | '$$PurchaseInvoice029234$$'    |'Store 02'|
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029234$$" variable
		And I delete "$$GoodsReceipt029234$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029234$$"
		And I save the window as "$$GoodsReceipt029234$$"
		And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029234$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'             |
			| 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | '$$SalesOrder029234$$'    |
			| 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | '$$SalesOrder029234$$'    |
			| 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | '$$SalesOrder029234$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029234$$'    |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029234$$'    |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029234$$'    |
		And for each line of "ItemList" table I do
			And I set "Use shipment confirmation" checkbox in "ItemList" table		
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029234$$" variable
		And I delete "$$SalesInvoice029234$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029234$$"
		And I save the window as "$$SalesInvoice029234$$"
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice029234$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |'Store'   |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029234$$'   | '$$SalesInvoice029234$$'   | '$$SalesInvoice029234$$'    |'Store 01'|
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029234$$'   | '$$SalesInvoice029234$$'   | '$$SalesInvoice029234$$'    |'Store 01'|
			| 'Dress'      | 'M/White'     | '$$SalesOrder029234$$'   | '$$SalesInvoice029234$$'   | '$$SalesInvoice029234$$'    |'Store 01'|
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'           | 'Sales invoice'             |'Store'   |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029234$$'   | '$$SalesInvoice029234$$'   | '$$SalesInvoice029234$$'    |'Store 01'|
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029234$$'   | '$$SalesInvoice029234$$'   | '$$SalesInvoice029234$$'    |'Store 01'|
			| 'Dress'      | 'M/White'     | '$$SalesOrder029234$$'   | '$$SalesInvoice029234$$'   | '$$SalesInvoice029234$$'    |'Store 01'|
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029234$$" variable
		And I delete "$$ShipmentConfirmation029234$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029234$$"
		And I save the window as "$$ShipmentConfirmation029234$$"
		And I close current window
		And I close all client application windows	
			
Scenario: _029235 SO - PO - PI  - GR - SC - SI (selling from one store while purchasing for another)
	And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '502'       |
		And in the table "List" I click "Copy" button
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post" button
		And I delete "$$NumberSalesOrder029235$$" variable
		And I delete "$$SalesOrder029235$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029235$$"
		And I save the window as "$$SalesOrder029235$$"
	* Create PO
		And I click "Purchase order" button
		And I click "Ok" button
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button	
		And I select "Approved" exact value from the drop-down list named "Status"
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item key'  | 'Item'     | 'Sales order'          | 'Store'    |
			| '38/Yellow' | 'Trousers' | '$$SalesOrder029235$$' | 'Store 02' |
			| '38/Black'  | 'Shirt'    | '$$SalesOrder029235$$' | 'Store 02' |
			| 'M/White'   | 'Dress'    | '$$SalesOrder029235$$' | 'Store 02' |
		* Unlink and link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'    |
			| '38/Yellow'   | 'Trousers'   | ''               |
			| '38/Black'    | 'Shirt'      | ''               |
			| 'M/White'     | 'Dress'      | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		#temp
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "Update item list info" window is opened
		And I click "OK" button
		#temp
		And "ItemList" table contains lines
			| 'Item key'    | 'Item'       | 'Sales order'            | 'Purchase basis'          | 'Store'    |
			| '38/Yellow'   | 'Trousers'   | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 02' |
			| '38/Black'    | 'Shirt'      | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 02' |
			| 'M/White'     | 'Dress'      | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 02' |
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseOrder029235$$" variable
		And I delete "$$PurchaseOrder029235$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029235$$"
		And I save the window as "$$PurchaseOrder029235$$"
	* Create PI	
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder029235$$'    |
		And I click "Purchase invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Price'    | 'VAT'   | 'Total amount'   | 'Store'      | 'Quantity'   | 'Other period expense type'   | 'Purchase order'            | 'Sales order'            | 'Net amount'    |
			| 'Trousers'   | '38/Yellow'   | 'No'                   | '122,03'       | 'pcs'    | '100,00'   | '18%'   | '800,00'         | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029235$$'   | '$$SalesOrder029235$$'   | '677,97'        |
			| 'Shirt'      | '38/Black'    | 'No'                   | '335,59'       | 'pcs'    | '200,00'   | '18%'   | '2 200,00'       | 'Store 02'   | '11,000'     | ''                            | '$$PurchaseOrder029235$$'   | '$$SalesOrder029235$$'   | '1 864,41'      |
			| 'Dress'      | 'M/White'     | 'No'                   | '366,10'       | 'pcs'    | '300,00'   | '18%'   | '2 400,00'       | 'Store 02'   | '8,000'      | ''                            | '$$PurchaseOrder029235$$'   | '$$SalesOrder029235$$'   | '2 033,90'      |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Sales order'          | 'Purchase order'          | 'Store'    |
			| 'Trousers' | '38/Yellow' | '$$SalesOrder029235$$' | '$$PurchaseOrder029235$$' | 'Store 02' |
			| 'Shirt'    | '38/Black'  | '$$SalesOrder029235$$' | '$$PurchaseOrder029235$$' | 'Store 02' |
			| 'Dress'    | 'M/White'   | '$$SalesOrder029235$$' | '$$PurchaseOrder029235$$' | 'Store 02' |
		And for each line of "ItemList" table I do
			And I set "Use goods receipt" checkbox in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPurchaseInvoice029235$$" variable
		And I delete "$$PurchaseInvoice029235$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029235$$"
		And I save the window as "$$PurchaseInvoice029235$$"
	* Create GR
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029235$$'    |
		And I click "Goods receipt" button
		And I click "Ok" button
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029235$$'   | '$$PurchaseOrder029235$$'   | '$$PurchaseInvoice029235$$'    | 'Store 02' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029235$$'   | '$$PurchaseOrder029235$$'   | '$$PurchaseInvoice029235$$'    | 'Store 02' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029235$$'   | '$$PurchaseOrder029235$$'   | '$$PurchaseInvoice029235$$'    | 'Store 02' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Purchase order'   | 'Receipt basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                 | ''                 |
			| 'Shirt'      | '38/Black'    | ''              | ''                 | ''                 |
			| 'Dress'      | 'M/White'     | ''              | ''                 | ''                 |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Purchase order'            | 'Receipt basis'                | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029235$$'   | '$$PurchaseOrder029235$$'   | '$$PurchaseInvoice029235$$'    | 'Store 02' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029235$$'   | '$$PurchaseOrder029235$$'   | '$$PurchaseInvoice029235$$'    | 'Store 02' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029235$$'   | '$$PurchaseOrder029235$$'   | '$$PurchaseInvoice029235$$'    | 'Store 02' |
		And I click "Post" button
		And I delete "$$NumberGoodsReceipt029235$$" variable
		And I delete "$$GoodsReceipt029235$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029235$$"
		And I save the window as "$$GoodsReceipt029235$$"
		And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029235$$'    |
		And I click "Shipment confirmation" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 01' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 01' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 01' |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'   | 'Shipment basis'    |
			| 'Trousers'   | '38/Yellow'   | ''              | ''                  |
			| 'Shirt'      | '38/Black'    | ''              | ''                  |
			| 'Dress'      | 'M/White'     | ''              | ''                  |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'            | 'Shipment basis'          | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 01' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 01' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029235$$'   | '$$SalesOrder029235$$'    | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberShipmentConfirmation029235$$" variable
		And I delete "$$ShipmentConfirmation029235$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029235$$"
		And I save the window as "$$ShipmentConfirmation029235$$"
		And I close current window
	* Create SI
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberShipmentConfirmation029235$$'    |
		And I click "Sales invoice" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Use shipment confirmation'   | 'Sales order'             |
			| '1'   | 'Basic Price Types'   | 'Trousers'   | '38/Yellow'   | 'No'                   | '488,14'       | 'pcs'    | '8,000'      | '400,00'   | '18%'   | '2 711,86'     | '3 200,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029235$$'    |
			| '2'   | 'Basic Price Types'   | 'Shirt'      | '38/Black'    | 'No'                   | '587,29'       | 'pcs'    | '11,000'     | '350,00'   | '18%'   | '3 262,71'     | '3 850,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029235$$'    |
			| '3'   | 'Basic Price Types'   | 'Dress'      | 'M/White'     | 'No'                   | '634,58'       | 'pcs'    | '8,000'      | '520,00'   | '18%'   | '3 525,42'     | '4 160,00'       | 'Store 01'   | 'Yes'                         | '$$SalesOrder029235$$'    |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I change checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'    |
			| 'Trousers'   | '38/Yellow'   | ''               |
			| 'Shirt'      | '38/Black'    | ''               |
			| 'Dress'      | 'M/White'     | ''               |
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Sales order'             | 'Store'    |
			| 'Trousers'   | '38/Yellow'   | '$$SalesOrder029235$$'    | 'Store 01' |
			| 'Shirt'      | '38/Black'    | '$$SalesOrder029235$$'    | 'Store 01' |
			| 'Dress'      | 'M/White'     | '$$SalesOrder029235$$'    | 'Store 01' |
		And I click "Post" button
		And I delete "$$NumberSalesInvoice029235$$" variable
		And I delete "$$SalesInvoice029235$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029235$$"
		And I save the window as "$$SalesInvoice29212$$"
		And I close all client application windows						


						
						


		
				


		
				
	
		
				

