﻿#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase invoice

As a procurement manager
I want to create a Purchase invoice document
To track a product that has been received from a vendor

Variables:
import "Variables.feature"

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
		When Create catalog BusinessUnits objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog CancelReturnReasons objects
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
		When Create document GoodsReceipt objects (creation based on, without PO and PI)
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document SalesOrder objects (SC before SI, creation based on)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |
		When create PO, GR with two same items
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1111).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1111).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _0180001 check preparation
	When check preparation

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
			| 'Row presentation'                             | 'Use' | 'Quantity' | 'Unit'           | 'Price'  | 'Currency' |
			| 'Purchase order 217 dated 12.02.2021 12:45:05' | 'Yes' | ''         | ''               | ''       | ''         |
			| 'Dress (S/Yellow)'                             | 'Yes' | '10,000'   | 'pcs'            | '100,00' | 'TRY'      |
			| 'Service (Internet)'                           | 'Yes' | '2,000'    | 'pcs'            | '150,00' | 'TRY'      |
			| 'Trousers (36/Yellow)'                         | 'Yes' | '5,000'    | 'pcs'            | '200,00' | 'TRY'      |
			| 'Trousers (36/Yellow)'                         | 'Yes' | '8,000'    | 'pcs'            | '210,00' | 'TRY'      |
			| 'Boots (36/18SD)'                              | 'Yes' | '5,000'    | 'Boots (12 pcs)' | '200,00' | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Row presentation'  |
			| 'Service (Internet)' |
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
			| '#' | 'Profit loss center' | 'Price type'              | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit'           | 'Serial lot numbers' | 'Quantity'      | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order'                               | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'Front office'       | 'en description is empty' | 'Dress'    | 'S/Yellow'  | 'No'                 | '137,29'     | 'pcs'            | ''                   | '10,000' | '100,00' | '18%' | '100,00'        | '900,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '762,71'     | 'Yes'               |
			| '2' | 'Front office'       | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '137,29'     | 'pcs'            | ''                   | '5,000'  | '200,00' | '18%' | '100,00'        | '900,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '762,71'     | 'Yes'               |
			| '3' | 'Front office'       | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '256,27'     | 'pcs'            | ''                   | '8,000'  | '210,00' | '18%' | ''              | '1 680,00'     | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '1 423,73'   | 'Yes'               |
			| '4' | ''                   | 'en description is empty' | 'Boots'    | '36/18SD'   | 'No'                 | '1 830,51'   | 'Boots (12 pcs)' | ''                   | '5,000'  | '200,00' | '18%' | ''              | '12 000,00'    | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''       | ''            | '10 169,49'  | 'Yes'               |
		And "SpecialOffers" table contains lines
			| '#' | 'Amount' |
			| '1' | '100,00' |
			| '2' | '100,00' |
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "200,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "13 118,64"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "2 361,36"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "15 480,00"
	* Change quantity
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key'   | 'Quantity'      |
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
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'  |
			| '$$NumberPurchaseInvoice018001$$' |
		And I close all client application windows

	

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
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Quantity'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |

		Then the number of "RowIDInfo" table lines is "равно" "4"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Quantity'     |
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
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Quantity'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000'  | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000'  | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000'  | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
			| '5' | '$$Rov5PurchaseInvoice018001$$' | ''                                             | '$$Rov5PurchaseInvoice018001$$'        | 'GR'        | '10,000' | ''                                     | ''             | '$$Rov5PurchaseInvoice018001$$'        |
		Then the number of "RowIDInfo" table lines is "равно" "5"
		And "RowIDInfo" table does not contain lines
			| 'Key'                        | 'Quantity'     |
			| '$$Rov1PurchaseInvoice018001$$' | '10,000' |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Quantity'     |
			| '5' | 'Dress' | 'S/Yellow'  | '10,000' |	
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Quantity'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
		Then the number of "RowIDInfo" table lines is "равно" "4"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key'  | 'Quantity'     |
			| '3' | 'Trousers' | '36/Yellow' | '8,000' |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Quantity'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '2' | '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '3' | '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '7,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '4' | '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'GR'        | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key'  | 'Quantity'     |
			| '3' | 'Trousers' | '36/Yellow' | '7,000' |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change checkbox Use Goods receipt and check RowIDInfo
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'     | 'Unit'           |
			| 'Boots' | '36/18SD'  | '5,000' | 'Boots (12 pcs)' |
		And I remove "Use goods receipt" checkbox in "ItemList" table			
		And I move to the tab named "GroupRowIDInfo"
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Quantity'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
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
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button	
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#' | 'Profit loss center' | 'Price type'              | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit'           | 'Serial lot numbers' | 'Quantity'     | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order' | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'Front office'  | 'en description is empty' | 'Dress'    | 'S/Yellow'  | 'No'                 | '61,02'      | 'pcs'            | ''                   | '5,000' | '100,00' | '18%' | '100,00'        | '400,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '338,98'     | 'Yes'               |
			| '2' | 'Front office'  | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '137,29'     | 'pcs'            | ''                   | '5,000' | '200,00' | '18%' | '100,00'        | '900,00'       | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '762,71'     | 'Yes'               |
			| '3' | 'Front office'  | 'en description is empty' | 'Trousers' | '36/Yellow' | 'No'                 | '256,27'     | 'pcs'            | ''                   | '8,000' | '210,00' | '18%' | ''              | '1 680,00'     | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '1 423,73'   | 'Yes'               |
			| '4' | ''              | 'en description is empty' | 'Boots'    | '36/18SD'   | 'No'                 | '1 830,51'   | 'Boots (12 pcs)' | ''                   | '5,000' | '200,00' | '18%' | ''              | '12 000,00'    | ''                    | ''                        | 'Store 02' | '12.02.2021'    | ''             | ''               | ''       | ''            | '10 169,49'  | 'No'                |
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'   |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '2 564,58' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '14 980'   |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '14 980'   |
		And I close current window
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "12 694,91"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "2 285,09"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "14 980,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post PI and check Row ID Info tab
		And I click "Show row key" button
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Quantity'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '$$Rov1PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'GR'        | '5,000'  | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' | 'PI&GR'        | '4fcbb4cf-3824-47fb-89b5-50d151215d4d' |
			| '$$Rov2PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'GR'        | '5,000'  | '923e7825-c20f-4a3e-a983-3b85d80e475a' | 'PI&GR'        | '923e7825-c20f-4a3e-a983-3b85d80e475a' |
			| '$$Rov3PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000'  | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
			| '$$Rov4PurchaseInvoice018001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | ''          | '60,000' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And I close all client application windows		

Scenario: _018004 create PI based on GR without PO
	* Select GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '12'      |
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                           | 'Use' | 'Quantity' | 'Unit'           | 'Price' | 'Currency' |
			| 'Goods receipt 12 dated 02.03.2021 12:16:02' | 'Yes' | ''         | ''               | ''      | ''         |
			| 'Dress (XS/Blue)'                            | 'Yes' | '10,000'   | 'pcs'            | ''      | ''         |
			| 'Trousers (38/Yellow)'                       | 'Yes' | '20,000'   | 'pcs'            | ''      | ''         |
			| 'Boots (39/18SD)'                            | 'Yes' | '2,000'    | 'Boots (12 pcs)' | ''      | ''         |
			| 'Dress (XS/Blue)'                            | 'Yes' | '2,000'    | 'pcs'            | ''      | ''         |
		Then the number of "BasisesTree" table lines is "равно" "5"
		And I click "Ok" button
	* Create PI and check creation
		And "ItemList" table contains lines
			| '#' | 'Profit loss center' | 'Price type' | 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit'           | 'Serial lot numbers' | 'Quantity' | 'Price' | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Expense type' | 'Purchase order' | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | ''                   | ''           | 'Dress'    | 'XS/Blue'   | 'No'                 | ''           | 'pcs'            | ''                   | '12,000'   | ''      | '18%' | ''              | ''             | ''                    | ''                        | 'Store 02' | ''              | ''             | ''               | ''       | ''            | ''           | 'Yes'               |
			| '2' | ''                   | ''           | 'Trousers' | '38/Yellow' | 'No'                 | ''           | 'pcs'            | ''                   | '20,000'   | ''      | '18%' | ''              | ''             | ''                    | ''                        | 'Store 02' | ''              | ''             | ''               | ''       | ''            | ''           | 'Yes'               |
			| '3' | ''                   | ''           | 'Boots'    | '39/18SD'   | 'No'                 | ''           | 'Boots (12 pcs)' | ''                   | '2,000'    | ''      | '18%' | ''              | ''             | ''                    | ''                        | 'Store 02' | ''              | ''             | ''               | ''       | ''            | ''           | 'Yes'               |
		Then the number of "ItemList" table lines is "равно" "3"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And in the table "ItemList" I click "Goods receipts" button
		And "DocumentsTree" table became equal
			| 'Presentation'                               | 'Invoice' | 'QuantityInDocument' | 'Quantity' |
			| 'Dress (XS/Blue)'                            | '12,000'  | '12,000'             | '12,000'   |
			| 'Goods receipt 12 dated 02.03.2021 12:16:02' | ''        | '10,000'             | '10,000'   |
			| 'Goods receipt 12 dated 02.03.2021 12:16:02' | ''        | '2,000'              | '2,000'    |
			| 'Trousers (38/Yellow)'                       | '20,000'  | '20,000'             | '20,000'   |
			| 'Goods receipt 12 dated 02.03.2021 12:16:02' | ''        | '20,000'             | '20,000'   |
			| 'Boots (39/18SD)'                            | '24,000'  | '24,000'             | '24,000'   |
			| 'Goods receipt 12 dated 02.03.2021 12:16:02' | ''        | '24,000'             | '24,000'   |	
		And I close all client application windows

Scenario: _018005 create Purchase invoice based on Internal supply request
	And I close all client application windows
	* Add items from basis documents
		* Open form for create PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' | 
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Ferron BP' | 
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Vendor Ferron, TRY' | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
				| '50,000'    | 'Dress (XS/Blue)'   | 'pcs'  | 'No'  |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
				| '10,000'    | 'Dress (S/Yellow)'   | 'pcs'  | 'No'  |
			And I change "Use" checkbox in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button
			* Set Use GR checkbox
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' |
					| 'Dress' | 'S/Yellow' |
				And I set "Use goods receipt" checkbox in "ItemList" table
				And I finish line editing in "ItemList" table
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' |
					| 'Dress' | 'XS/Blue'  |
				And I set "Use goods receipt" checkbox in "ItemList" table
				And I finish line editing in "ItemList" table					
			And I click "Save" button							
		* Check Item tab and RowID tab
			And "ItemList" table contains lines
				| 'Store'    | 'Internal supply request'                               | 'Quantity in base unit' | 'Profit loss center' | 'Price type'        | 'Item'  | 'Item key' | 'Dont calculate row' | 'Quantity'      | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Expense type' | 'Detail' | 'Sales order' | 'Purchase order' | 'Delivery date' |
				| 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '10,000'                | ''                   | 'Vendor price, TRY' | 'Dress' | 'S/Yellow' | 'No'                 | '10,000' | 'pcs'  | ''           | ''      | '18%' | ''              | ''           | ''             | ''             | ''       | ''            | ''               | ''              |
				| 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '50,000'                | ''                   | 'Vendor price, TRY' | 'Dress' | 'XS/Blue'  | 'No'                 | '50,000' | 'pcs'  | ''           | ''      | '18%' | ''              | ''           | ''             | ''             | ''       | ''            | ''               | ''              |
			And "RowIDInfo" table contains lines
				| 'Basis'                                                 | 'Next step' | 'Quantity'      | 'Current step' |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38' | 'GR'          | '10,000' | 'ITO&PO&PI'    |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38' | 'GR'          | '50,000' | 'ITO&PO&PI'    |
			Then the number of "RowIDInfo" table lines is "равно" "2"	
		And I close all client application windows
	* Create PI based on ISR (Create button)
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'                           |
			| '117' |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1InternalSupplyRequestr017006$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2InternalSupplyRequestr017006$$"
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And I click "Show row key" button	
		And "ItemList" table contains lines
			| 'Store'    | 'Internal supply request'                               | 'Quantity in base unit' | 'Profit loss center' | 'Price type' | 'Item'  | 'Item key' | 'Dont calculate row' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Expense type' | 'Detail' | 'Sales order' | 'Purchase order' | 'Delivery date' |
			| 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '10,000'                | ''                   | ''           | 'Dress' | 'S/Yellow' | 'No'                 | '10,000'   | 'pcs'  | ''           | ''      | '18%' | ''              | ''           | ''             | ''             | ''       | ''            | ''               | ''              |
			| 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '50,000'                | ''                   | ''           | 'Dress' | 'XS/Blue'  | 'No'                 | '50,000'   | 'pcs'  | ''           | ''      | '18%' | ''              | ''           | ''             | ''             | ''       | ''            | ''               | ''              |
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseInvoice018005$$" variable
		And I save the current field value as "$$Rov1PurchaseInvoice018005$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2PurchaseInvoice018005$$" variable
		And I save the current field value as "$$Rov2PurchaseInvoice018005$$"
		* Set Use GR checkbox
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			And I set "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I set "Use goods receipt" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table	
		And I click "Save" button	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                         | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Quantity'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseInvoice018005$$' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '$$Rov1InternalSupplyRequestr017006$$' | 'GR'     | '10,000' | '$$Rov1InternalSupplyRequestr017006$$' | 'ITO&PO&PI'    | '$$Rov1InternalSupplyRequestr017006$$' |
			| '2' | '$$Rov2PurchaseInvoice018005$$' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '$$Rov2InternalSupplyRequestr017006$$' | 'GR'     | '50,000' | '$$Rov2InternalSupplyRequestr017006$$' | 'ITO&PO&PI'    | '$$Rov2InternalSupplyRequestr017006$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		* Filling in the main details of the document
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Ferron BP' | 
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Vendor Ferron, TRY' | 
			And I select current line in "List" table
			And I click "OK" button					
		And I delete "$$NumberPurchaseInvoice018005$$" variable
		And I delete "$$PurchaseInvoice018005$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018005$$"
		And I save the window as "$$PurchaseInvoice018005$$"
		And I click the button named "FormWrite"
		And I close current window		
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberPurchaseInvoice018005$$' |
		And I close all client application windows
		


Scenario: _018012 Purchase invoice creation without PO
	And I close all client application windows
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
		And in the table "ItemList" I click the button named "ItemListAdd"
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
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
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
		And I activate "Quantity" field in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I input "250,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice018012$$" variable
		And I delete "$$PurchaseInvoice018012$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018012$$"
		And I save the window as "$$PurchaseInvoice018012$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'  |
			| '$$NumberPurchaseInvoice018012$$' |
		And I close all client application windows
	

Scenario: _018013 create PI using form link/unlink
	* Open PI form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Store 02' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Front office' |
		And I select current line in "List" table	
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"		
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '100,00' | '5,000'    | 'Dress (S/Yellow)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'  | 'Unit' | 'Use' |
			| 'TRY'      | '150,00' | '2,000'    | 'Service (Internet)' | 'pcs'  | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#' | 'Basis'                                        | 'Next step' | 'Quantity'      | 'Current step' |
		| '1' | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''          | '5,000'  | 'PI&GR'        |
		| '2' | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''          | '2,000'  | 'PI'           |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"
		Then "Link / unlink document row" window is opened
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Service (Internet)'   | 'Store 02' | 'pcs'  |
		And I set checkbox "Linked documents"
		And I click "Unlink" button
		And I click "Ok" button
		And I click "Save" button	
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                        | 'Next step' | 'Quantity'     | 'Current step' |
			| '1' | 'Purchase order 217 dated 12.02.2021 12:45:05' | 'GR'        | '5,000' | 'PI&GR'        |
			| '2' | ''                                             | ''          | '2,000' | ''             |	
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key' | 'Sales order'                              | 'Purchase order'                               |
			| 'Dress'   | 'S/Yellow' | ''                                         | 'Purchase order 217 dated 12.02.2021 12:45:05' |
			| 'Service' | 'Internet' | ''                                         | ''                                             |
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation'  | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Service (Internet)' | 'Store 02' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'  | 'Unit' |
			| 'TRY'      | '150,00' | '2,000'    | 'Service (Internet)' | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                        | 'Next step' | 'Quantity'      | 'Current step' |
			| '1' | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''          | '5,000'  | 'PI&GR'        |
			| '2' | 'Purchase order 217 dated 12.02.2021 12:45:05' | ''          | '2,000'  | 'PI'           |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key' | 'Sales order'                              | 'Purchase order'                               |
			| 'Dress'   | 'S/Yellow' | ''                                         | 'Purchase order 217 dated 12.02.2021 12:45:05' |
			| 'Service' | 'Internet' | ''                                         | 'Purchase order 217 dated 12.02.2021 12:45:05' |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key' | 'Sales order'                              | 'Purchase order'                               |
			| 'Dress'   | 'S/Yellow' | ''                                         | 'Purchase order 217 dated 12.02.2021 12:45:05' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '100,00' | '5,000'    | 'Dress (S/Yellow)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key' | 'Sales order'                              | 'Purchase order'                               |
			| 'Dress'   | 'S/Yellow' | ''                                         | 'Purchase order 217 dated 12.02.2021 12:45:05' |
			| 'Service' | 'Internet' | ''                                         | 'Purchase order 217 dated 12.02.2021 12:45:05' |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Quantity'      | 'Store'    |
			| 'Dress' | 'S/Yellow'  | '5,000' | 'Store 02' |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'box Dress (8 pcs)' |
		And I select current line in "List" table
		And "RowIDInfo" table contains lines
			| 'Basis'                                        | 'Next step' | 'Quantity'      | 'Current step' |
			| 'Purchase order 217 dated 12.02.2021 12:45:05' | ''          | '40,000' | 'PI&GR'        |
			| 'Purchase order 217 dated 12.02.2021 12:45:05' | ''          | '2,000'  | 'PI'           |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I click "Save" button
		And I close all client application windows

Scenario: _018015 cancel line in the PO and create PI
	* Cancel line in the PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                     |
			| '217' |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| '#' | 'Item'    | 'Item key' | 'Quantity'     |
			| '2' | 'Service' | 'Internet' | '2,000' |
		And I activate "Cancel" field in "ItemList" table
		And I set "Cancel" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Cancel reason" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'not available' |	
		And I select current line in "List" table
		And I finish line editing in "ItemList" table	
		And I click "Post" button	
	* Create PI
		And I click "Purchase invoice" button
		Then "Add linked document rows" window is opened
		And "BasisesTree" table does not contain lines
			| 'Row presentation'   | 'Quantity' | 'Unit' |
			| 'Service (Internet)' | '2,000'    | 'pcs'  |
		And I close all client application windows

Scenario: _018016 create PI based on GR with two same items (creation based on)
	* Select GR
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 111'      |
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"	
	* Create PI
		And "BasisesTree" table became equal
			| 'Row presentation'                               | 'Use' | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Purchase order 1 111 dated 15.02.2022 12:31:27' | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Goods receipt 1 111 dated 15.02.2022 14:34:54'  | 'Yes' | ''         | ''     | ''       | ''         |
			| 'Dress (XS/Blue)'                                | 'Yes' | '10,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (M/White)'                                | 'Yes' | '5,000'    | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (XS/Blue)'                                | 'Yes' | '9,000'    | 'pcs'  | '520,00' | 'TRY'      |
			| 'Dress (M/White)'                                | 'Yes' | '5,000'    | 'pcs'  | '520,00' | 'TRY'      |
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Quantity'      | 'Serial lot numbers' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Is additional item cost' | 'Expense type' | 'Purchase order'                                 | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'en description is empty' | 'Dress' | 'XS/Blue'  | ''                   | 'No'                 | '1 507,12'   | 'pcs'  | '19,000' | ''                   | '520,00' | '18%' | ''              | '9 880,00'     | ''                    | ''                        | 'Store 02' | ''              | 'No'                      | ''             | 'Purchase order 1 111 dated 15.02.2022 12:31:27' | ''       | ''            | '8 372,88'   | 'Yes'               |
			| '2' | 'en description is empty' | 'Dress' | 'M/White'  | ''                   | 'No'                 | '793,22'     | 'pcs'  | '10,000' | ''                   | '520,00' | '18%' | ''              | '5 200,00'     | ''                    | ''                        | 'Store 02' | ''              | 'No'                      | ''             | 'Purchase order 1 111 dated 15.02.2022 12:31:27' | ''       | ''            | '4 406,78'   | 'Yes'               |
		And I close all client application windows
		
Scenario: _018017 create PI based on GR with two same items (link items)
	* Create PI
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'              |
				| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
				| Description |
				| Store 02    |
		And I select current line in "List" table
	* Select items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "19,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '520,00' | '10,000'   | 'Dress (XS/Blue)'  | 'pcs'  |
		And in the table "BasisesTree" I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '520,00' | '9,000'    | 'Dress (XS/Blue)'  | 'pcs'  |
		And in the table "BasisesTree" I click the button named "Link"
		And I click "Ok" button	
	* Check
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Quantity'      | 'Serial lot numbers' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Is additional item cost' | 'Expense type' | 'Purchase order'                                 | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| '1' | 'en description is empty' | 'Dress' | 'XS/Blue'  | ''                   | 'No'                 | '1 507,12'   | 'pcs'  | '19,000' | ''                   | '520,00' | '18%' | ''              | '9 880,00'     | ''                    | ''                        | 'Store 02' | ''              | 'No'                      | ''             | 'Purchase order 1 111 dated 15.02.2022 12:31:27' | ''       | ''            | '8 372,88'   | 'Yes'               |
		And I click "Show row key" button
		And I move to "Row ID Info" tab	
		And "RowIDInfo" table became equal
			| 'Key' | 'Basis'                                         | 'Row ID'                               | 'Next step' | 'Quantity'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '*'   | 'Goods receipt 1 111 dated 15.02.2022 14:34:54' | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' | ''          | '10,000' | '17c1c453-6971-467e-96a5-baadd8496c38' | 'PI'           | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' |
			| '*'   | 'Goods receipt 1 111 dated 15.02.2022 14:34:54' | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' | ''          | '9,000'  | '5848e9dc-c303-4dfe-afef-4b2853214cac' | 'PI'           | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' |
		And I close all client application windows
		
		
Scenario: _018018 create PI based on GR with two same items (add linked document rows)
	* Create PI
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'              |
				| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
				| Description |
				| Store 02    |
		And I select current line in "List" table
	* Add linked document rows	
		And in the table "ItemList" I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                           | 'Use' |
			| 'Goods receipt 12 dated 02.03.2021 12:16:02' | 'No'  |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                               | 'Use' |
			| 'Purchase order 1 111 dated 15.02.2022 12:31:27' | 'No'  |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                              | 'Use' |
			| 'Goods receipt 1 111 dated 15.02.2022 14:34:54' | 'No'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '10,000'   | 'Dress (XS/Blue)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '5,000'    | 'Dress (M/White)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '9,000'    | 'Dress (XS/Blue)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '5,000'    | 'Dress (M/White)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| 'Price type'              | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Quantity'      | 'Serial lot numbers' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Is additional item cost' | 'Expense type' | 'Purchase order'                                 | 'Detail' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| 'en description is empty' | 'Dress' | 'XS/Blue'  | ''                   | 'No'                 | '1 507,12'   | 'pcs'  | '19,000' | ''                   | '520,00' | '18%' | ''              | '9 880,00'     | ''                    | ''                        | 'Store 02' | ''              | 'No'                      | ''             | 'Purchase order 1 111 dated 15.02.2022 12:31:27' | ''       | ''            | '8 372,88'   | 'Yes'               |
			| 'en description is empty' | 'Dress' | 'M/White'  | ''                   | 'No'                 | '793,22'     | 'pcs'  | '10,000' | ''                   | '520,00' | '18%' | ''              | '5 200,00'     | ''                    | ''                        | 'Store 02' | ''              | 'No'                      | ''             | 'Purchase order 1 111 dated 15.02.2022 12:31:27' | ''       | ''            | '4 406,78'   | 'Yes'               |	
		And I click "Show row key" button
		And I move to "Row ID Info" tab	
		And "RowIDInfo" table became equal
			| 'Key' | 'Basis'                                         | 'Row ID'                               | 'Next step' | 'Quantity'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '*'   | 'Goods receipt 1 111 dated 15.02.2022 14:34:54' | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' | ''          | '10,000' | '17c1c453-6971-467e-96a5-baadd8496c38' | 'PI'           | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' |
			| '*'   | 'Goods receipt 1 111 dated 15.02.2022 14:34:54' | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' | ''          | '9,000'  | '5848e9dc-c303-4dfe-afef-4b2853214cac' | 'PI'           | '290b1eb2-e2ac-4f3f-9d12-0cd144474054' |
			| '*'   | 'Goods receipt 1 111 dated 15.02.2022 14:34:54' | 'f5b7bbaf-7525-4d01-a472-687190c70d35' | ''          | '5,000'  | '6ff368ba-803b-4c49-a03a-9d0f4a05e5bf' | 'PI'           | 'f5b7bbaf-7525-4d01-a472-687190c70d35' |
			| '*'   | 'Goods receipt 1 111 dated 15.02.2022 14:34:54' | 'f5b7bbaf-7525-4d01-a472-687190c70d35' | ''          | '5,000'  | '5dff43f5-e537-4fae-a925-7fd7a77a4aae' | 'PI'           | 'f5b7bbaf-7525-4d01-a472-687190c70d35' |
		And I close all client application windows
		
									
				
		
				



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