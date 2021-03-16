#language: en
@tree
@Positive
@Purchase

Functionality: purchase order closing



Scenario: _0224000 preparation (Purchase order closing)
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
		When Create catalog BusinessUnits objects
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
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog CancelReturnReasons objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company
	* Create test PO
		When Create document PurchaseOrder objects (for check closing)
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseOrder.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _0224001 create and check filling Purchase order closing (PO not shipped)
	* Create Purchase order closing 
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  | 'Date'                |
			| '37'      | '09.03.2021 14:29:00'	|	
		And I click the button named "FormDocumentPurchaseOrderClosingGeneratePurchaseOrderClosing"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 03"
		Then the form attribute named "PurchaseOrder" became equal to "Purchase order 37 dated 09.03.2021 14:29:00"
		And "ItemList" table contains lines
			| 'Business unit' | 'Price type'              | 'Item'    | 'Item key' | 'Dont calculate row' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' | 'Internal supply request' | 'Store'    | 'Expense type' | 'Detail' | 'Sales order' | 'Cancel' | 'Purchase basis' | 'Delivery date' | 'Cancel reason' |
			| 'Front office'  | 'en description is empty' | 'Shirt'   | '38/Black' | 'No'                 | '2,000'  | 'pcs'  | '45,76'      | '150,00' | ''              | '254,24'     | '300,00'       | ''                        | 'Store 03' | ''             | ''       | ''            | 'Yes'    | ''               | '11.03.2021'    | ''              |
			| 'Front office'  | 'en description is empty' | 'Dress'   | 'XS/Blue'  | 'No'                 | '96,000' | 'pcs'  | '1 757,29'   | '120,00' | ''              | '9 762,71'   | '11 520,00'    | ''                        | 'Store 03' | ''             | ''       | ''            | 'Yes'    | ''               | '11.03.2021'    | ''              |
			| 'Front office'  | 'en description is empty' | 'Service' | 'Rent'     | 'No'                 | '1,000'  | 'pcs'  | '15,25'      | '100,00' | ''              | '84,75'      | '100,00'       | ''                        | 'Store 03' | ''             | ''       | ''            | 'Yes'    | ''               | '11.03.2021'    | ''              |
		Then the number of "ItemList" table lines is "equal" "3"
		Then the form attribute named "Currency" became equal to "TRY"
	// * Try to post document without filling in cancel reason
	// 	And I click the button named "FormPost"
	// 	Then I wait that in user messages the "Cancel reason has to be filled if string was canceled" substring will appear in "10" seconds
	* Filling in cancel reason and post Sales order closing
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'   |
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'not available' |
		And I select current line in "List" table	
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black'   |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key' |
			| 'Service' | 'Rent'  |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrderClosing0224001$$" variable
		And I delete "$$PurchaseOrderClosing0224001$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrderClosing0224001$$"
		And I save the window as "$$PurchaseOrderClosing0224001$$"
	* Check PO lock
		And I click Open button of "Purchase order" field
		Then the form attribute named "ClosingOrder" became equal to "$$PurchaseOrderClosing0224001$$"
		And I close all client application windows
	

Scenario: _0230002 create and check filling Purchase order closing (PO partially shipped)
	* Preparation
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		If "List" table contains lines Then
				| "Number" |
				| "$$NumberPurchaseOrderClosing0224001$$" |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrderClosing.FindByNumber($$NumberPurchaseOrderClosing0224001$$).GetObject().Write(DocumentWriteMode.UndoPosting);" |
	* Load PI and GR for PO 37
		When Create document GoodsReceipt objects (for check closing)
		When Create document PurchaseInvoice objects (for check closing)
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);" |	
		And I execute 1C:Enterprise script at server
 			| "Documents.GoodsReceipt.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);" |
	* Create Purchase order closing 
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  | 'Date'                |
			| '37'      | '09.03.2021 14:29:00'	|
		And I click the button named "FormDocumentPurchaseOrderClosingGeneratePurchaseOrderClosing"	
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 03"
		Then the form attribute named "PurchaseOrder" became equal to "Purchase order 37 dated 09.03.2021 14:29:00"
		And "ItemList" table contains lines
			| 'Business unit' | 'Price type'              | 'Item'    | 'Item key' | 'Dont calculate row' | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' | 'Internal supply request' | 'Store'    | 'Expense type' | 'Detail' | 'Sales order' | 'Cancel' | 'Purchase basis' | 'Delivery date' | 'Cancel reason' |
			| 'Front office'  | 'en description is empty' | 'Shirt'   | '38/Black' | 'No'                 | '1,000' | 'pcs'  | ''           | '150,00' | ''              | '150,00'     | '150,00'       | ''                        | 'Store 03' | ''             | ''       | ''            | 'No'     | ''               | '11.03.2021'    | ''              |
			| 'Front office'  | 'en description is empty' | 'Dress'   | 'XS/Blue'  | 'No'                 | '8,000' | 'pcs'  | ''           | '120,00' | ''              | '960,00'     | '960,00'       | ''                        | 'Store 03' | ''             | ''       | ''            | 'Yes'    | ''               | '11.03.2021'    | ''              |
			| 'Front office'  | 'en description is empty' | 'Service' | 'Rent'     | 'No'                 | '1,000' | 'pcs'  | '15,25'      | '100,00' | ''              | '84,75'      | '100,00'       | ''                        | 'Store 03' | ''             | ''       | ''            | 'Yes'    | ''               | '11.03.2021'    | ''              |
		Then the number of "ItemList" table lines is "equal" "3"
		And I close all client application windows