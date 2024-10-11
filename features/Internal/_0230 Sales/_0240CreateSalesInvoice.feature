#language: en
@tree
@Positive
@Sales

Feature: create document Sales invoice

As a sales manager
I want to create a Sales invoice document
To sell a product to a customer

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _024000 preparation (Sales invoice)
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
		When Create catalog CashAccounts objects
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
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog CancelReturnReasons objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Partners objects
		When Create Document discount
		When Create information register Taxes records (VAT)
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount	
	When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
	When Create document SalesOrder objects (SC before SI, creation based on)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document ShipmentConfirmation objects (creation based on, for SI 15)
	When Create document ShipmentConfirmation objects (creation based on, without SO and SI)
	And I execute 1C:Enterprise script at server
		| "Documents.ShipmentConfirmation.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.ShipmentConfirmation.FindByNumber(16).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.ShipmentConfirmation.FindByNumber(17).GetObject().Write(DocumentWriteMode.Posting);"   |
	When create SO, SC with two same items
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(1111).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server	
		| "Documents.ShipmentConfirmation.FindByNumber(1111).GetObject().Write(DocumentWriteMode.Posting);"   |

	
Scenario: _0240001 check preparation
	When check preparation



Scenario: _024001 create document Sales Invoice based on sales order (partial quantity, SO-SI)
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'   | 'Partner'     | 'Date'                   |
			| '3'        | 'Ferron BP'   | '27.01.2021 19:50:45'    |
	* Create SI
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table became equal
			| 'Row presentation'                          | 'Use'   | 'Quantity'   | 'Unit'             | 'Price'      | 'Currency'    |
			| 'Sales order 3 dated 27.01.2021 19:50:45'   | 'Yes'   | ''           | ''                 | ''           | ''            |
			| 'Dress (XS/Blue)'                           | 'Yes'   | '1,000'      | 'pcs'              | '520,00'     | 'TRY'         |
			| 'Shirt (36/Red)'                            | 'Yes'   | '10,000'     | 'pcs'              | '350,00'     | 'TRY'         |
			| 'Service (Internet)'                        | 'Yes'   | '1,000'      | 'pcs'              | '100,00'     | 'TRY'         |
			| 'Boots (36/18SD)'                           | 'Yes'   | '5,000'      | 'Boots (12 pcs)'   | '8 400,00'   | 'TRY'         |
		And I go to line in "BasisesTree" table
			| 'Row presentation'      |
			| 'Service (Internet)'    |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check filling in SI
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#'   | 'Profit loss center'        | 'Price type'          | 'Item'    | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'             | 'Tax amount'   | 'Price'      | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                               | 'Revenue type'    |
			| '1'   | 'Distribution department'   | 'Basic Price Types'   | 'Dress'   | 'XS/Blue'    | 'No'                   | ''                     | '1,000'      | 'pcs'              | '75,36'        | '520,00'     | '18%'   | '26,00'           | '418,64'       | '494,00'         | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'Revenue'         |
			| '2'   | 'Distribution department'   | 'Basic Price Types'   | 'Shirt'   | '36/Red'     | 'No'                   | ''                     | '10,000'     | 'pcs'              | '507,20'       | '350,00'     | '18%'   | '175,00'          | '2 817,80'     | '3 325,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'Revenue'         |
			| '3'   | 'Front office'              | 'Basic Price Types'   | 'Boots'   | '36/18SD'    | 'No'                   | ''                     | '5,000'      | 'Boots (12 pcs)'   | '6 406,78'     | '8 400,00'   | '18%'   | ''                | '35 593,22'    | '42 000,00'      | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'Revenue'         |

		And "SpecialOffers" table contains lines
			| '#'   | 'Amount'    |
			| '1'   | '26,00'     |
			| '2'   | '175,00'    |

		Then the number of "PaymentTerms" table lines is "равно" 0
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'      |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200' | '7 844,21'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '45 819'      |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '45 819'      |
		And I close current window
		Then the form attribute named "ManagerSegment" became equal to "Region 1"
		Then the form attribute named "Branch" became equal to "Distribution department"
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "Manager" became equal to ""
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		And the editing text of form attribute named "DeliveryDate" became equal to "27.01.2021"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "201,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "38 829,66"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "6 989,34"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "45 819,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Change quantity
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Shirt'   | '36/Red'     | '10,000'      |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$SalesInvoice024008$$" variable
		And I delete "$$NumberSalesInvoice024008$$" variable
		And I save the window as "$$SalesInvoice024008$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice024008$$"
		And I click the button named "FormPostAndClose"
	* Check auto filling inventory origin (FO Use commission trading switched off)
		When set True value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024008$$'    |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center'      | 'Dont calculate row' | 'Tax amount' | 'Unit'           | 'Serial lot numbers' | 'Quantity' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other period revenue type' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                             | 'Work order' | 'Revenue type' |
			| '1' | 'Own stocks'       | ''             | 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'Distribution department' | 'No'                 | '75,36'      | 'pcs'            | ''                   | '1,000'    | '520,00'   | '18%' | '26,00'         | '418,64'     | '494,00'       | 'No'             | ''                   | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' | ''           | 'Revenue'      |
			| '2' | 'Own stocks'       | ''             | 'Basic Price Types' | 'Shirt' | '36/Red'   | 'Distribution department' | 'No'                 | '253,60'     | 'pcs'            | ''                   | '5,000'    | '350,00'   | '18%' | '87,50'         | '1 408,90'   | '1 662,50'     | 'No'             | ''                   | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' | ''           | 'Revenue'      |
			| '3' | 'Own stocks'       | ''             | 'Basic Price Types' | 'Boots' | '36/18SD'  | 'Front office'            | 'No'                 | '6 406,78'   | 'Boots (12 pcs)' | ''                   | '5,000'    | '8 400,00' | '18%' | ''              | '35 593,22'  | '42 000,00'    | 'No'             | ''                   | ''                    | 'Store 02' | '27.01.2021'    | 'Yes'                       | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' | ''           | 'Revenue'      |
		And I close all client application windows	
		When set False value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024008$$'    |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I activate "Inventory origin" field in "ItemList" table'    |
		And I close all client application windows		
		
		

Scenario: _024002 check filling in Row Id info table in the SI (SO-SI)
		And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024008$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1SalesInvoice023002$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2SalesInvoice023002$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3SalesInvoice023002$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                          | 'Basis'                                     | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SC'          | '1,000'      | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SI&SC'          | '0cb89084-5857-45fc-b333-4fbec2c2e90a'    |
			| '$$Rov2SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SC'          | '5,000'      | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SI&SC'          | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'    |
			| '$$Rov3SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SC'          | '60,000'     | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SI&SC'          | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'XS/Blue'    | '1,000'       |
		And in the table "ItemList" I click "Copy" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '4'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov4SalesInvoice023002$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                          | 'Basis'                                     | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SC'          | '1,000'      | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SI&SC'          | '0cb89084-5857-45fc-b333-4fbec2c2e90a'    |
			| '$$Rov2SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SC'          | '5,000'      | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SI&SC'          | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'    |
			| '$$Rov3SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SC'          | '60,000'     | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SI&SC'          | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'    |
			| '$$Rov4SalesInvoice023002$$'   | ''                                          | '$$Rov4SalesInvoice023002$$'             | 'SC'          | '8,000'      | ''                                       | ''               | '$$Rov4SalesInvoice023002$$'              |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                          | 'Quantity'    |
			| '$$Rov1SalesInvoice023002$$'   | '8,000'       |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '4'   | 'Dress'   | 'XS/Blue'    | '8,000'       |
		And in the table "ItemList" I click "Delete" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                          | 'Basis'                                     | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SC'          | '1,000'      | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SI&SC'          | '0cb89084-5857-45fc-b333-4fbec2c2e90a'    |
			| '$$Rov2SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SC'          | '5,000'      | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SI&SC'          | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'    |
			| '$$Rov3SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SC'          | '60,000'     | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SI&SC'          | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'XS/Blue'    | '1,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "RowIDInfo" table contains lines
			| 'Key'                          | 'Basis'                                     | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SC'          | '7,000'      | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SI&SC'          | '0cb89084-5857-45fc-b333-4fbec2c2e90a'    |
			| '$$Rov2SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SC'          | '5,000'      | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SI&SC'          | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'    |
			| '$$Rov3SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SC'          | '60,000'     | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SI&SC'          | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'XS/Blue'    | '7,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change checkbox Use Shipment confirmation and check RowIDInfo
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'              |
			| 'Boots'   | '36/18SD'    | '5,000'      | 'Boots (12 pcs)'    |
		And I remove "Use shipment confirmation" checkbox in "ItemList" table
		And I move to the tab named "GroupRowIDInfo"
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| 'Key'                          | 'Basis'                                     | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SC'          | '1,000'      | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SI&SC'          | '0cb89084-5857-45fc-b333-4fbec2c2e90a'    |
			| '$$Rov2SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SC'          | '5,000'      | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SI&SC'          | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'    |
			| '$$Rov3SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | ''            | '60,000'     | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SI&SC'          | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"	
		And I click the button named "FormPostAndClose"





	
Scenario: _024003 copy SI (based on SO) and check filling in Row Id info table (SI)
	* Copy SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024008$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#'   | 'Profit loss center'        | 'Price type'          | 'Item'    | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'             | 'Tax amount'   | 'Price'      | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'   | 'Revenue type'    |
			| '1'   | 'Distribution department'   | 'Basic Price Types'   | 'Dress'   | 'XS/Blue'    | 'No'                   | ''                     | '1,000'      | 'pcs'              | '*'            | '520,00'     | '18%'   | '*'            | '*'              | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | ''              | 'Revenue'         |
			| '2'   | 'Distribution department'   | 'Basic Price Types'   | 'Shirt'   | '36/Red'     | 'No'                   | ''                     | '5,000'      | 'pcs'              | '*'            | '350,00'     | '18%'   | '*'            | '*'              | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | ''              | 'Revenue'         |
			| '3'   | 'Front office'              | 'Basic Price Types'   | 'Boots'   | '36/18SD'    | 'No'                   | ''                     | '5,000'      | 'Boots (12 pcs)'   | '6 406,78'     | '8 400,00'   | '18%'   | '35 593,22'    | '42 000,00'      | ''                      | 'Store 02'   | '27.01.2021'      | 'No'                          | ''         | ''              | 'Revenue'         |
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'    |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '*'         |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '*'         |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '*'         |
		And I close current window
		Then the form attribute named "Branch" became equal to "Distribution department"
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post SI and check Row ID Info tab
		And I click the button named "FormPost"
		And I click the button named "FormShowRowKey"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                          | 'Basis'                                     | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SC'          | '7,000'      | '0cb89084-5857-45fc-b333-4fbec2c2e90a'   | 'SI&SC'          | '0cb89084-5857-45fc-b333-4fbec2c2e90a'    |
			| '$$Rov2SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SC'          | '5,000'      | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'   | 'SI&SC'          | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'    |
			| '$$Rov3SalesInvoice023002$$'   | 'Sales order 3 dated 27.01.2021 19:50:45'   | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | ''            | '60,000'     | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'   | 'SI&SC'          | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows			
		

Scenario: _024004 create SI using form link/unlink
	* Open SI form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table	
	* Select items from basis documents
		And I move to "Item list" tab		
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '10,000'     | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '350,00'   | '7,000'      | 'Shirt (36/Red)'     | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'   | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| ''           | ''        | '10,000'     | 'Dress (S/Yellow)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#'  | 'Basis'                                               | 'Next step'  | 'Quantity'  | 'Current step'   |
		| '1'  | 'Sales order 15 dated 01.02.2021 19:50:45'            | ''           | '10,000'    | 'SI&SC'          |
		| '2'  | 'Shipment confirmation 17 dated 25.02.2021 16:28:54'  | ''           | '10,000'    | 'SI'             |
		| '3'  | 'Shipment confirmation 15 dated 25.02.2021 14:13:30'  | ''           | '7,000'     | 'SI'             |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"
		Then "Link / unlink document row" window is opened
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'    |
			| '3'   | '7,000'      | 'Shirt (36/Red)'     | 'Store 02'   | 'pcs'     |
		And I set checkbox "Linked documents"	
		And I go to line in "ResultsTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '350,00'   | '7,000'      | 'Shirt (36/Red)'     | 'pcs'     |
		And I click "Unlink" button
		And I click "Ok" button
		And I click "Post" button	
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                                                | 'Next step'   | 'Quantity'   | 'Current step'    |
			| '1'   | 'Sales order 15 dated 01.02.2021 19:50:45'             | 'SC'          | '10,000'     | 'SI&SC'           |
			| '2'   | 'Shipment confirmation 17 dated 25.02.2021 16:28:54'   | ''            | '10,000'     | 'SI'              |
			| '3'   | ''                                                     | 'SC'          | '7,000'      | ''                |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Sales order'                                 |
			| 'Dress'   | 'XS/Blue'    | 'Sales order 15 dated 01.02.2021 19:50:45'    |
			| 'Dress'   | 'S/Yellow'   | ''                                            |
			| 'Shirt'   | '36/Red'     | ''                                            |
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'    |
			| '3'   | '7,000'      | 'Shirt (36/Red)'     | 'Store 02'   | 'pcs'     |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '350,00'   | '7,000'      | 'Shirt (36/Red)'     | 'pcs'     |
		And I click "Link" button
		And I click "Ok" button
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                                                | 'Next step'   | 'Quantity'   | 'Current step'    |
			| '1'   | 'Sales order 15 dated 01.02.2021 19:50:45'             | ''            | '10,000'     | 'SI&SC'           |
			| '2'   | 'Shipment confirmation 17 dated 25.02.2021 16:28:54'   | ''            | '10,000'     | 'SI'              |
			| '3'   | 'Shipment confirmation 15 dated 25.02.2021 14:13:30'   | ''            | '7,000'      | 'SI'              |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Sales order'                                 |
			| 'Dress'   | 'XS/Blue'    | 'Sales order 15 dated 01.02.2021 19:50:45'    |
			| 'Dress'   | 'S/Yellow'   | ''                                            |
			| 'Shirt'   | '36/Red'     | 'Sales order 15 dated 01.02.2021 19:50:45'    |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '10,000'     | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Sales order'                                 |
			| 'Dress'   | 'XS/Blue'    | 'Sales order 15 dated 01.02.2021 19:50:45'    |
			| 'Dress'   | 'S/Yellow'   | ''                                            |
			| 'Shirt'   | '36/Red'     | 'Sales order 15 dated 01.02.2021 19:50:45'    |
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Store'       |
			| 'Dress'   | 'XS/Blue'    | '10,000'     | 'Store 02'    |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And "RowIDInfo" table contains lines
			| 'Basis'                                                | 'Next step'   | 'Quantity'   | 'Current step'    |
			| 'Sales order 15 dated 01.02.2021 19:50:45'             | ''            | '80,000'     | 'SI&SC'           |
			| 'Shipment confirmation 17 dated 25.02.2021 16:28:54'   | ''            | '10,000'     | 'SI'              |
			| 'Shipment confirmation 15 dated 25.02.2021 14:13:30'   | ''            | '7,000'      | 'SI'              |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I click "Save" button
		And I click the button named "FormUndoPosting"		
		And I close all client application windows


		
Scenario: _024005 create SI based on SO with 2 SC (SC>SO + new string + string from SO without SC)
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And "BasisesTree" table contains lines
			| 'Row presentation'                                     | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 15 dated 01.02.2021 19:50:45'             | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Service (Internet)'                                   | 'Yes'   | '1,000'      | 'pcs'    | '100,00'   | 'TRY'         |
			| 'Dress (XS/Blue)'                                      | 'Yes'   | '10,000'     | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Shipment confirmation 15 dated 25.02.2021 14:13:30'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Dress (XS/Blue)'                                      | 'Yes'   | '1,000'      | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Shirt (36/Red)'                                       | 'Yes'   | '7,000'      | 'pcs'    | '350,00'   | 'TRY'         |
			| 'Dress (XS/Blue)'                                      | 'Yes'   | '2,000'      | 'pcs'    | '500,00'   | 'TRY'         |
			| 'Shipment confirmation 16 dated 25.02.2021 14:14:14'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Shirt (36/Red)'                                       | 'Yes'   | '3,000'      | 'pcs'    | '350,00'   | 'TRY'         |
	* Select items for SI
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '10,000'     | 'Dress (XS/Blue)'    | 'pcs'    | 'Yes'    |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		And Delay 5
		And "ItemList" table contains lines
			| '#'   | 'Profit loss center'        | 'Price type'                | 'Item'      | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                | 'Revenue type'   | 'Sales person'       |
			| '1'   | 'Front office'              | 'en description is empty'   | 'Service'   | 'Internet'   | 'No'                   | ''                     | '1,000'      | 'pcs'    | '14,49'        | '100,00'   | '18%'   | '5,00'            | '80,51'        | '95,00'          | ''                      | ''           | '27.01.2021'      | 'No'                          | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Alexander Orlov'    |
			| '2'   | 'Distribution department'   | 'Basic Price Types'         | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '1,000'      | 'pcs'    | '75,36'        | '520,00'   | '18%'   | '26,00'           | '418,64'       | '494,00'         | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Anna Petrova'       |
			| '3'   | 'Distribution department'   | 'Basic Price Types'         | 'Shirt'     | '36/Red'     | 'No'                   | ''                     | '10,000'     | 'pcs'    | '507,20'       | '350,00'   | '18%'   | '175,00'          | '2 817,80'     | '3 325,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Alexander Orlov'    |
			| '4'   | 'Distribution department'   | 'en description is empty'   | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '2,000'      | 'pcs'    | '152,54'       | '500,00'   | '18%'   | ''                | '847,46'       | '1 000,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Alexander Orlov'    |		
		Then the number of "ItemList" table lines is "равно" "4"
		And I close current window
	* Create SI for all items from SO
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And "ItemList" table contains lines
			| '#'   | 'Profit loss center'        | 'Price type'                | 'Item'      | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                | 'Revenue type'   | 'Sales person'       |
			| '1'   | 'Front office'              | 'en description is empty'   | 'Service'   | 'Internet'   | 'No'                   | ''                     | '1,000'      | 'pcs'    | '14,49'        | '100,00'   | '18%'   | '5,00'            | '80,51'        | '95,00'          | ''                      | ''           | '27.01.2021'      | 'No'                          | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Alexander Orlov'    |
			| '2'   | ''                          | 'Basic Price Types'         | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '10,000'     | 'pcs'    | '793,22'       | '520,00'   | '18%'   | ''                | '4 406,78'     | '5 200,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | ''               | ''                   |
			| '3'   | 'Distribution department'   | 'Basic Price Types'         | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '1,000'      | 'pcs'    | '75,36'        | '520,00'   | '18%'   | '26,00'           | '418,64'       | '494,00'         | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Anna Petrova'       |
			| '4'   | 'Distribution department'   | 'Basic Price Types'         | 'Shirt'     | '36/Red'     | 'No'                   | ''                     | '10,000'     | 'pcs'    | '507,20'       | '350,00'   | '18%'   | '175,00'          | '2 817,80'     | '3 325,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Alexander Orlov'    |
			| '5'   | 'Distribution department'   | 'en description is empty'   | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '2,000'      | 'pcs'    | '152,54'       | '500,00'   | '18%'   | ''                | '847,46'       | '1 000,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'        | 'Alexander Orlov'    |
		Then the number of "ItemList" table lines is "равно" "5"
		And I close current window



Scenario: _024006 create SI based on 2 SO with SC
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '3'        | '27.01.2021 19:50:45'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentSalesInvoiceGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                                     | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 3 dated 27.01.2021 19:50:45'              | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Shirt (36/Red)'                                       | 'Yes'   | '5,000'      | 'pcs'    | '350,00'   | 'TRY'         |
			| 'Service (Internet)'                                   | 'Yes'   | '1,000'      | 'pcs'    | '100,00'   | 'TRY'         |
			| 'Sales order 15 dated 01.02.2021 19:50:45'             | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Service (Internet)'                                   | 'Yes'   | '1,000'      | 'pcs'    | '100,00'   | 'TRY'         |
			| 'Dress (XS/Blue)'                                      | 'Yes'   | '10,000'     | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Shipment confirmation 15 dated 25.02.2021 14:13:30'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Dress (XS/Blue)'                                      | 'Yes'   | '1,000'      | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Shirt (36/Red)'                                       | 'Yes'   | '7,000'      | 'pcs'    | '350,00'   | 'TRY'         |
			| 'Dress (XS/Blue)'                                      | 'Yes'   | '2,000'      | 'pcs'    | '500,00'   | 'TRY'         |
			| 'Shipment confirmation 16 dated 25.02.2021 14:14:14'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Shirt (36/Red)'                                       | 'Yes'   | '3,000'      | 'pcs'    | '350,00'   | 'TRY'         |
		Then the number of "BasisesTree" table lines is "равно" "12"
		And I click "Ok" button
	* Create SI
		And "ItemList" table contains lines
			| '#'   | 'Profit loss center'        | 'Price type'                | 'Item'      | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                | 'Revenue type'    |
			| '1'   | 'Distribution department'   | 'Basic Price Types'         | 'Shirt'     | '36/Red'     | 'No'                   | ''                     | '5,000'      | 'pcs'    | '253,60'       | '350,00'   | '18%'   | '87,50'           | '1 408,90'     | '1 662,50'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 3 dated 27.01.2021 19:50:45'    | 'Revenue'         |
			| '2'   | 'Front office'              | 'en description is empty'   | 'Service'   | 'Internet'   | 'No'                   | ''                     | '1,000'      | 'pcs'    | '14,49'        | '100,00'   | '18%'   | '5,00'            | '80,51'        | '95,00'          | ''                      | ''           | '27.01.2021'      | 'No'                          | ''         | 'Sales order 3 dated 27.01.2021 19:50:45'    | 'Revenue'         |
			| '3'   | 'Front office'              | 'en description is empty'   | 'Service'   | 'Internet'   | 'No'                   | ''                     | '1,000'      | 'pcs'    | '14,49'        | '100,00'   | '18%'   | '5,00'            | '80,51'        | '95,00'          | ''                      | ''           | '27.01.2021'      | 'No'                          | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'         |
			| '4'   | ''                          | 'Basic Price Types'         | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '10,000'     | 'pcs'    | '793,22'       | '520,00'   | '18%'   | ''                | '4 406,78'     | '5 200,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | ''                |
			| '5'   | 'Distribution department'   | 'Basic Price Types'         | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '1,000'      | 'pcs'    | '75,36'        | '520,00'   | '18%'   | '26,00'           | '418,64'       | '494,00'         | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'         |
			| '6'   | 'Distribution department'   | 'Basic Price Types'         | 'Shirt'     | '36/Red'     | 'No'                   | ''                     | '10,000'     | 'pcs'    | '507,20'       | '350,00'   | '18%'   | '175,00'          | '2 817,80'     | '3 325,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'         |
			| '7'   | 'Distribution department'   | 'en description is empty'   | 'Dress'     | 'XS/Blue'    | 'No'                   | ''                     | '2,000'      | 'pcs'    | '152,54'       | '500,00'   | '18%'   | ''                | '847,46'       | '1 000,00'       | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 15 dated 01.02.2021 19:50:45'   | 'Revenue'         |
		Then the number of "ItemList" table lines is "равно" "7"
	* Change quantity and check Row ID
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'   | 'Unit'    |
			| 'Dress'   | 'XS/Blue'    | '500,00'   | '2,000'      | 'pcs'     |
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And "RowIDInfo" table became equal
			| 'Basis'                                                | 'Next step'   | 'Quantity'   | 'Current step'    |
			| 'Sales order 3 dated 27.01.2021 19:50:45'              | ''            | '5,000'      | 'SI&SC'           |
			| 'Sales order 3 dated 27.01.2021 19:50:45'              | ''            | '1,000'      | 'SI&WO&WS'        |
			| 'Sales order 15 dated 01.02.2021 19:50:45'             | ''            | '1,000'      | 'SI&WO&WS'        |
			| 'Sales order 15 dated 01.02.2021 19:50:45'             | ''            | '10,000'     | 'SI&SC'           |
			| 'Shipment confirmation 15 dated 25.02.2021 14:13:30'   | ''            | '1,000'      | 'SI'              |
			| 'Shipment confirmation 15 dated 25.02.2021 14:13:30'   | ''            | '7,000'      | 'SI'              |
			| 'Shipment confirmation 16 dated 25.02.2021 14:14:14'   | ''            | '3,000'      | 'SI'              |
			| 'Shipment confirmation 15 dated 25.02.2021 14:13:30'   | ''            | '16,000'     | 'SI'              |
		And I close all client application windows

Scenario: _024007 create SI based on SC	without SO
	* Select SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '17'        |
		And I click the button named "FormDocumentSalesInvoiceGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                                     | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'   | 'Currency'    |
			| 'Shipment confirmation 17 dated 25.02.2021 16:28:54'   | 'Yes'   | ''           | ''       | ''        | ''            |
			| 'Dress (S/Yellow)'                                     | 'Yes'   | '10,000'     | 'pcs'    | ''        | ''            |
			| 'Dress (S/Yellow)'                                     | 'Yes'   | '5,000'      | 'pcs'    | ''        | ''            |
			| 'Dress (L/Green)'                                      | 'Yes'   | '8,000'      | 'pcs'    | ''        | ''            |
		Then the number of "BasisesTree" table lines is "равно" "4"
		And I click "Ok" button
	* Create SI
		And "ItemList" table contains lines
			| '#'   | 'Profit loss center'   | 'Price type'   | 'Item'    | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'   | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'   | 'Revenue type'    |
			| '1'   | ''                     | ''             | 'Dress'   | 'S/Yellow'   | 'No'                   | ''                     | '15,000'     | 'pcs'    | ''             | ''        | '18%'   | ''                | ''             | ''               | ''                      | 'Store 01'   | ''                | 'Yes'                         | ''         | ''              | ''                |
			| '2'   | ''                     | ''             | 'Dress'   | 'L/Green'    | 'No'                   | ''                     | '8,000'      | 'pcs'    | ''             | ''        | '18%'   | ''                | ''             | ''               | ''                      | 'Store 01'   | ''                | 'Yes'                         | ''         | ''              | ''                |
		Then the number of "ItemList" table lines is "равно" "2"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And in the table "ItemList" I click "Shipment confirmations" button
		And "DocumentsTree" table became equal
			| 'Presentation'                                         | 'Invoice'   | 'QuantityInDocument'   | 'Quantity'    |
			| 'Dress (S/Yellow)'                                     | '15,000'    | '15,000'               | '15,000'      |
			| 'Shipment confirmation 17 dated 25.02.2021 16:28:54'   | ''          | '10,000'               | '10,000'      |
			| 'Shipment confirmation 17 dated 25.02.2021 16:28:54'   | ''          | '5,000'                | '5,000'       |
			| 'Dress (L/Green)'                                      | '8,000'     | '8,000'                | '8,000'       |
			| 'Shipment confirmation 17 dated 25.02.2021 16:28:54'   | ''          | '8,000'                | '8,000'       |
		And I close all client application windows
	* Select items in SI from SC and check filling inventory origin
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I select from "Partner term" drop-down list by "Basic Partner terms, TRY" string
		And I select from "Branch" drop-down list by "Distribution department" string
		And I move to "Item list" tab
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Row presentation'                                   |
			| 'Shipment confirmation 17 dated 25.02.2021 16:28:54' |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Post" button
		And I delete "$$SalesInvoice024007$$" variable
		And I save the window as "$$SalesInvoice024007$$"
		When set True value to the constant Use commission trading
		And "ItemList" table became equal
			| 'Inventory origin' |
			| 'Own stocks'       |
			| 'Own stocks'       |
		When set False value to the constant Use commission trading
		And I close all client application windows
		
			


Scenario: _024025 create document Sales Invoice without Sales order and check Row ID (SI-SC)
	When set False value to the constant Use commission trading
	When create SalesInvoice024025
	* Check Row Id
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024025$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesInvoice024025$$" variable
		And I save the current field value as "$$Rov1SalesInvoice024025$$"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                          | 'Basis'   | 'Row ID'                       | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                       |
			| '1'   | '$$Rov1SalesInvoice024025$$'   | ''        | '$$Rov1SalesInvoice024025$$'   | 'SC'          | '20,000'     | ''            | ''               | '$$Rov1SalesInvoice024025$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I close all client application windows
	* Check auto filling inventory origin (FO Use commission trading switched off)
		When set True value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024025$$'    |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Inventory origin'   | 'Item'    | 'Item key'    |
			| 'Own stocks'         | 'Dress'   | 'L/Green'     |
		And I close all client application windows	
		When set False value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024025$$'    |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I activate "Inventory origin" field in "ItemList" table'    |
		And I close all client application windows		
		
		
Scenario: _024027 cancel line in the SO and create SI
	* Cancel line in the SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '7'   | 'Dress'   | 'XS/Blue'    | '10,000'      |
		And I activate "Cancel" field in "ItemList" table
		And I set "Cancel" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Cancel reason" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'      |
			| 'not available'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table	
		And I click "Post" button	
	* Create SI
		And I click "Sales invoice" button
		Then "Add linked document rows" window is opened
		And "BasisesTree" table does not contain lines
			| 'Row presentation'   | 'Quantity'   | 'Unit'    |
			| 'Dress (XS/Blue)'    | '10,000'     | 'pcs'     |
		And I close all client application windows
		
Scenario: _024028 create SI based on SC with two same items (creation based on)
	* Select SC
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1 111'     |
		And I click the button named "FormDocumentSalesInvoiceGenerate"	
	* Create SI
		And "BasisesTree" table became equal
			| 'Row presentation'                                        | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 1 111 dated 15.02.2022 11:03:38'             | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Shipment confirmation 1 111 dated 15.02.2022 11:04:31'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Dress (XS/Blue)'                                         | 'Yes'   | '10,000'     | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Dress (M/White)'                                         | 'Yes'   | '5,000'      | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Dress (XS/Blue)'                                         | 'Yes'   | '9,000'      | 'pcs'    | '520,00'   | 'TRY'         |
			| 'Dress (M/White)'                                         | 'Yes'   | '5,000'      | 'pcs'    | '520,00'   | 'TRY'         |
		And I click "Ok" button
	* Check
		And "ItemList" table contains lines
			| '#'   | 'Price type'          | 'Item'    | 'Item key'   | 'Profit loss center'        | 'Dont calculate row'   | 'Tax amount'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Other period revenue type'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                   | 'Revenue type'    |
			| '1'   | 'Basic Price Types'   | 'Dress'   | 'XS/Blue'    | 'Distribution department'   | 'No'                   | '1 507,12'     | ''                     | '19,000'     | 'pcs'    | '520,00'   | '18%'   | ''                | '8 372,88'     | '9 880,00'       | ''                     | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 1 111 dated 15.02.2022 11:03:38'   | 'Revenue'         |
			| '2'   | 'Basic Price Types'   | 'Dress'   | 'M/White'    | 'Distribution department'   | 'No'                   | '793,22'       | ''                     | '10,000'     | 'pcs'    | '520,00'   | '18%'   | ''                | '4 406,78'     | '5 200,00'       | ''                     | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 1 111 dated 15.02.2022 11:03:38'   | 'Revenue'         |
		
		And I close all client application windows
		
Scenario: _024029 create SI based on SC with two same items (link items)
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table		
	* Select items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "19,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '520,00'   | '10,000'     | 'Dress (XS/Blue)'    | 'pcs'     |
		And I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '520,00'   | '9,000'      | 'Dress (XS/Blue)'    | 'pcs'     |
		And I click the button named "Link"	
		And I click "Ok" button				
	* Check
		And "ItemList" table contains lines
			| 'Price type'          | 'Item'    | 'Item key'   | 'Profit loss center'        | 'Dont calculate row'   | 'Tax amount'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Other period revenue type'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                   | 'Revenue type'    |
			| 'Basic Price Types'   | 'Dress'   | 'XS/Blue'    | 'Distribution department'   | 'No'                   | '1 507,12'     | ''                     | '19,000'     | 'pcs'    | '520,00'   | '18%'   | ''                | '8 372,88'     | '9 880,00'       | ''                     | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 1 111 dated 15.02.2022 11:03:38'   | 'Revenue'         |
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| 'Key'   | 'Basis'                                                   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '*'     | 'Shipment confirmation 1 111 dated 15.02.2022 11:04:31'   | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'   | ''            | '10,000'     | '6c91e0f0-6936-4c02-8827-a74810daf826'   | 'SI'             | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'    |
			| '*'     | 'Shipment confirmation 1 111 dated 15.02.2022 11:04:31'   | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'   | ''            | '9,000'      | '367a8f1e-f5f8-4b1b-8181-f5579c9a8010'   | 'SI'             | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'    |
		And I close all client application windows

Scenario: _024030 create SI based on SC with two same items (add linked document rows)
	And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
	* Select items
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                                        | 'Use'    |
			| 'Shipment confirmation 1 111 dated 15.02.2022 11:04:31'   | 'No'     |
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '10,000'     | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '9,000'      | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '5,000'      | 'Dress (M/White)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| 'Price type'          | 'Item'    | 'Item key'   | 'Profit loss center'        | 'Dont calculate row'   | 'Tax amount'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Other period revenue type'         | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                   | 'Revenue type'    |
			| 'Basic Price Types'   | 'Dress'   | 'XS/Blue'    | 'Distribution department'   | 'No'                   | '1 507,12'     | ''                     | '19,000'     | 'pcs'    | '520,00'   | '18%'   | ''                | '8 372,88'     | '9 880,00'       | ''                           | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 1 111 dated 15.02.2022 11:03:38'   | 'Revenue'         |
			| 'Basic Price Types'   | 'Dress'   | 'M/White'    | 'Distribution department'   | 'No'                   | '396,61'       | ''                     | '5,000'      | 'pcs'    | '520,00'   | '18%'   | ''                | '2 203,39'     | '2 600,00'       | ''                           | ''                      | 'Store 02'   | '27.01.2021'      | 'Yes'                         | ''         | 'Sales order 1 111 dated 15.02.2022 11:03:38'   | 'Revenue'         |
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| '#'   | 'Key'   | 'Basis'                                                   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '*'     | 'Shipment confirmation 1 111 dated 15.02.2022 11:04:31'   | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'   | ''            | '10,000'     | '6c91e0f0-6936-4c02-8827-a74810daf826'   | 'SI'             | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'    |
			| '2'   | '*'     | 'Shipment confirmation 1 111 dated 15.02.2022 11:04:31'   | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'   | ''            | '9,000'      | '367a8f1e-f5f8-4b1b-8181-f5579c9a8010'   | 'SI'             | '5c5bf772-9ed5-470c-889a-79c10b8c1fef'    |
			| '3'   | '*'     | 'Shipment confirmation 1 111 dated 15.02.2022 11:04:31'   | '2d14e136-93bc-4968-b1a9-89e56be271cf'   | ''            | '5,000'      | 'c2843939-e765-4207-81cf-1143a5137357'   | 'SI'             | '2d14e136-93bc-4968-b1a9-89e56be271cf'    |
		And I click the button named "FormPost"
		And I delete "$$SalesInvoice024030$$" variable
		And I delete "$$NumberSalesInvoice024030$$" variable
		And I save the window as "$$SalesInvoice024030$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice024030$$"
		And I click the button named "FormPostAndClose"
	* Check auto filling inventory origin (FO Use commission trading switched off)
		When set True value to the constant Use commission trading
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024030$$'    |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Inventory origin'   | 'Item'    | 'Item key'    |
			| 'Own stocks'         | 'Dress'   | 'XS/Blue'     |
			| 'Own stocks'         | 'Dress'   | 'M/White'     |
		And I close all client application windows	
		When set False value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024030$$'    |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I activate "Inventory origin" field in "ItemList" table'    |
		And I close all client application windows
		
Scenario: _024030 filling in Account field in the SI
	And I close all client application windows
	* Open SI and fill main details
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                        |
			| 'Basic Partner terms, without VAT'   |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select current line in "ItemList" table
		And I select "scarf" from "Item" drop-down list by string in "ItemList" table
		And I input "10,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Fill Account for payment
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| "Currency" | "Description"       |
			| "TRY"      | "Bank account, TRY" |
		And I select current line in "List" table
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		And I select from the drop-down list named "Account" by "Bank account, TRY" string
		Then the form attribute named "Account" became equal to "Bank account, TRY"
	And I close all client application windows					

Scenario: _300505 check connection to Sales invoice report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Form report Related documents
		And I go to line in "List" table
		| 'Number'                         |
		| '$$NumberSalesInvoice024008$$'   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows

