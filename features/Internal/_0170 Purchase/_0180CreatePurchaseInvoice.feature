#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase invoice

As a procurement manager
I want to create a Purchase invoice document
To track a product that has been received from a vendor

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _018000 preparation
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
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
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
	* Load documents
		When Create document PurchaseOrder objects (creation based on)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(217).GetObject().Write(DocumentWriteMode.Posting);" |
	



Scenario: _018001 create document Purchase Invoice based on order (partial quantity, PO-PI)
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'   | 'Partner'   | 'Date'                |
			| '217'      | 'Ferron BP' | '12.02.2021 12:45:05' |
	* Create PI
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And "BasisesTree" table became equal
			| 'Row presentation'                             | 'Use'                                          | 'Quantity' | 'Unit'           | 'Price'  | 'Currency' |
			| 'Purchase order 217 dated 12.02.2021 12:45:05' | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''         | ''               | ''       | ''         |
			| 'Dress, S/Yellow'                              | 'Yes'                                          | '10,000'   | 'pcs'            | '100,00' | 'TRY'      |
			| 'Service, Interner'                            | 'Yes'                                          | '2,000'    | 'pcs'            | '150,00' | 'TRY'      |
			| 'Trousers, 36/Yellow'                          | 'Yes'                                          | '5,000'    | 'pcs'            | '200,00' | 'TRY'      |
			| 'Trousers, 36/Yellow'                          | 'Yes'                                          | '8,000'    | 'pcs'            | '210,00' | 'TRY'      |
			| 'Boots, 36/18SD'                               | 'Yes'                                          | '5,000'    | 'Boots (12 pcs)' | '200,00' | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Row presentation'  |
			| 'Service, Interner' |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check filling in PI
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#' | 'Business unit' | 'Price type'              | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit'           | 'Serial lot numbers' | 'Q'      | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order'                               | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'Front office'  | 'en description is empty' | 'Dress'    | 'S/Yellow'  | 'No'                 | '137,29'     | 'pcs'            | ''                   | '10,000' | '100,00' | '18%' | '100,00'        | '900,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '762,71'     | 'Yes'               |
			| '2' | 'Front office'  | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '137,29'     | 'pcs'            | ''                   | '5,000'  | '200,00' | '18%' | '100,00'        | '900,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '762,71'     | 'Yes'               |
			| '3' | 'Front office'  | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '256,27'     | 'pcs'            | ''                   | '8,000'  | '210,00' | '18%' | ''              | '1 680,00'     | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '1 423,73'   | 'Yes'               |
			| '4' | ''              | 'en description is empty' | 'Boots'    | '36/18SD'   | 'No'                 | '1 830,51'   | 'Boots (12 pcs)' | ''                   | '5,000'  | '200,00' | '18%' | ''              | '12 000,00'    | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '10 169,49'  | 'Yes'               |
		And "SpecialOffers" table contains lines
			| '#' | 'Amount' |
			| '1' | '100,00' |
			| '2' | '100,00' |
		Then the form attribute named "BusinessUnit" became equal to ""
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "200,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "13 118,64"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "2 361,36"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "15 480,00"
	* Change quantity
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key'   | 'Q'      |
			| 'Dress' | 'S/Yellow'   | '10,000' |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$PurchaseInvoice018001$$" variable
		And I delete "$$NumberPurchaseInvoice018001$$" variable
		And I save the window as "$$PurchaseInvoice018001$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018001$$"
		And I click the button named "FormPostAndClose"

	

Scenario: _018002 check filling in Row Id info table in the PI (PO-PI)
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberPurchaseInvoice018001$$' |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1PurchaseInvoice018001$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2PurchaseInvoice018001$$"
		And I go to line in "ItemList" table
			| '#' |
			| '3' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3PurchaseInvoice018001$$"
		And I go to line in "ItemList" table
			| '#' |
			| '4' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov4PurchaseInvoice018001$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Q'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |

		Then the number of "RowIDInfo" table lines is "равно" "4"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Q'     |
			| '1' | 'Dress' | 'S/Yellow'  | '5,000' |		
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' |
			| '5' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov5PurchaseInvoice018001$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000'  | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000'  | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000'  | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
			| '5' | '$$Rov5PurchaseInvoice018001$$' | ''                                             | '$$Rov5PurchaseInvoice018001$$'        | 'GR'        | '10,000' | ''                                     | ''             | '$$Rov5PurchaseInvoice018001$$'        |
		Then the number of "RowIDInfo" table lines is "равно" "5"
		And "RowIDInfo" table does not contain lines
			| 'Key'                        | 'Q'     |
			| '$$Rov1PurchaseInvoice018001$$' | '10,000' |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Q'     |
			| '5' | 'Dress' | 'S/Yellow'  | '10,000' |	
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Q'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
		Then the number of "RowIDInfo" table lines is "равно" "4"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key'  | 'Q'     |
			| '3' | 'Trousers' | '36/Yellow' | '8,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Q'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '7,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key'  | 'Q'     |
			| '3' | 'Trousers' | '36/Yellow' | '7,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change checkbox Use Goods receipt and check RowIDInfo
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'     | 'Unit'           |
			| 'Boots' | '36/18SD'  | '5,000' | 'Boots (12 pcs)' |
		And I remove "Use goods receipt" checkbox in "ItemList" table			
		And I move to the tab named "GroupRowIDInfo"
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Q'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | ''          | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
		Then the number of "RowIDInfo" table lines is "равно" "4"	
		And I click the button named "FormPostAndClose"





	
Scenario: _018003 copy PI (based on PO) and check filling in Row Id info table (PI)
	* Copy PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberPurchaseInvoice018001$$' |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#' | 'Business unit' | 'Price type'              | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit'           | 'Serial lot numbers' | 'Q'     | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order' | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'Front office'  | 'en description is empty' | 'Dress'    | 'S/Yellow'  | 'No'                 | '61,02'      | 'pcs'            | ''                   | '5,000' | '100,00' | '18%' | '100,00'        | '400,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '338,98'     | 'Yes'               |
			| '2' | 'Front office'  | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '137,29'     | 'pcs'            | ''                   | '5,000' | '200,00' | '18%' | '100,00'        | '900,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '762,71'     | 'Yes'               |
			| '3' | 'Front office'  | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '256,27'     | 'pcs'            | ''                   | '8,000' | '210,00' | '18%' | ''              | '1 680,00'     | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '1 423,73'   | 'Yes'               |
			| '4' | ''              | 'en description is empty' | 'Boots'    | '36/18SD'   | 'No'                 | '1 830,51'   | 'Boots (12 pcs)' | ''                   | '5,000' | '200,00' | '18%' | ''              | '12 000,00'    | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '10 169,49'  | 'No'                |

		And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'         | 'Currency from' | 'Currency' | 'Rate presentation' | 'Multiplicity' | 'Amount'   |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1'            | '14 980'   |
			| 'Local currency'     | 'Legal'        | 'TRY'           | 'TRY'      | '1'                 | '1'            | '14 980'   |
			| 'Reporting currency' | 'Reporting'    | 'TRY'           | 'USD'      | '0,1712'            | '1'            | '2 564,58' |

		Then the form attribute named "BusinessUnit" became equal to ""
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "12 694,91"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "2 285,09"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "14 980,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post PI and check Row ID Info tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000'  | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000'  | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000'  | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | ''          | '60,000' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And I close all client application windows		


Scenario: _018012 Purchase invoice creation without PO
	* Creating Purchase Invoice without Purchase order	
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description        |
			| Vendor Ferron, EUR |
		And I select current line in "List" table
	* Filling in store
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'Dress/A-8'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Boots       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key  |
			| Boots | Boots/S-8 |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I input "250,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice018012$$" variable
		And I delete "$$PurchaseInvoice018012$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018012$$"
		And I save the window as "$$PurchaseInvoice018012$$"
		And I click the button named "FormPostAndClose"
	* Check movements by register
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key'  |
			| '10,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Dress/A-8' |
			| '20,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Boots/S-8' |
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key'  |
			| '10,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Dress/A-8' |
			| '20,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Boots/S-8' |
		Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                  | 'Item key'  |
			| '10,000'   | '$$PurchaseInvoice018012$$' | 'Dress/A-8' |
			| '20,000'   | '$$PurchaseInvoice018012$$' | 'Boots/S-8' |




// Scenario: _018020 check the form Pick up items in the document Purchase invoice
// 	And I close all client application windows
// 	* Opening a form for creating Purchase invoice
// 		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
// 		And I click the button named "FormCreate"
// 	* Filling in the main details of the document
// 		And I click Select button of "Company" field
// 		And I go to line in "List" table
// 			| Description  |
// 			| Main Company |
// 		And I select current line in "List" table
// 	* Filling in vendor information
// 		And I click Select button of "Partner" field
// 		And I go to line in "List" table
// 			| Description |
// 			| Ferron BP   |
// 		And I select current line in "List" table
// 		And I click Select button of "Legal name" field
// 		And I activate "Description" field in "List" table
// 		And I go to line in "List" table
// 			| Description       |
// 			| Company Ferron BP |
// 		And I select current line in "List" table
// 		And I click Select button of "Partner term" field
// 		And I go to line in "List" table
// 			| Description        |
// 			| Vendor Ferron, TRY |
// 		And I select current line in "List" table
// 		And I click Select button of "Store" field
// 		Then "Stores" window is opened
// 		And I select current line in "List" table
// 	When check the product selection form with price information in Purchase invoice
// 	And I close all client application windows



Scenario: _300503 check connection to Purchase invoice report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Form report Related documents
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018012$$'      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
