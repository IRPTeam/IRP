#language: en
@tree
@Positive
@Inventory

Feature: create document Goods receipt

As a storekeeper
I want to create a Goods receipt
To take products to the store


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028900 preparation (Goods receipt)
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
		When Create information register CurrencyRates records
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
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
	When Create document PurchaseOrder and Purchase invoice objects (creation based on, PI >PO)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseOrder.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.PurchaseInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
	

Scenario: _028901 create document Goods Receipt based on Purchase invoice (with PO, PI>PO)
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '102'      |
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                               | 'Use'                                            | 'Quantity' | 'Unit'           | 'Price'  | 'Currency' |
			| 'Purchase order 102 dated 03.03.2021 08:59:33'   | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''         | ''               | ''       | ''         |
			| 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | ''         | ''               | ''       | ''         |
			| 'Dress, XS/Blue'                                 | 'Yes'                                            | '1,000'    | 'pcs'            | '100,00' | 'TRY'      |
			| 'Shirt, 36/Red'                                  | 'Yes'                                            | '12,000'   | 'pcs'            | '200,00' | 'TRY'      |
			| 'Boots, 37/18SD'                                 | 'Yes'                                            | '2,000'    | 'Boots (12 pcs)' | '300,00' | 'TRY'      |
			| 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | ''         | ''               | ''       | ''         |
			| 'Shirt, 38/Black'                                | 'Yes'                                            | '2,000'    | 'pcs'            | '150,00' | 'TRY'      |
		Then the number of "BasisesTree" table lines is "равно" "7"
		And I click "Ok" button
	* Create GR and check creation
		And "ItemList" table contains lines
			| '#' | 'Item'  | 'Inventory transfer' | 'Item key' | 'Store'    | 'Internal supply request' | 'Quantity' | 'Sales invoice' | 'Unit'           | 'Receipt basis'                                  | 'Purchase invoice'                               | 'Currency' | 'Sales return order' | 'Sales order' | 'Purchase order'                               | 'Inventory transfer order' | 'Sales return' |
			| '1' | 'Dress' | ''                   | 'XS/Blue'  | 'Store 02' | ''                        | '1,000'    | ''              | 'pcs'            | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'TRY'      | ''                   | ''            | 'Purchase order 102 dated 03.03.2021 08:59:33' | ''                         | ''             |
			| '2' | 'Shirt' | ''                   | '36/Red'   | 'Store 02' | ''                        | '12,000'   | ''              | 'pcs'            | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'TRY'      | ''                   | ''            | 'Purchase order 102 dated 03.03.2021 08:59:33' | ''                         | ''             |
			| '3' | 'Boots' | ''                   | '37/18SD'  | 'Store 02' | ''                        | '2,000'    | ''              | 'Boots (12 pcs)' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'TRY'      | ''                   | ''            | 'Purchase order 102 dated 03.03.2021 08:59:33' | ''                         | ''             |
			| '4' | 'Shirt' | ''                   | '38/Black' | 'Store 02' | ''                        | '2,000'    | ''              | 'pcs'            | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'TRY'      | ''                   | ''            | ''                                             | ''                         | ''             |
		Then the number of "ItemList" table lines is "равно" "4"
		And I close all client application windows


Scenario: _028902 create document Goods Receipt based on Purchase order (with PI, PI>PO)
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102'      |
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                               | 'Use'                                            | 'Quantity' | 'Unit'           | 'Price'  | 'Currency' |
			| 'Purchase order 102 dated 03.03.2021 08:59:33'   | 'Purchase order 102 dated 03.03.2021 08:59:33'   | ''         | ''               | ''       | ''         |
			| 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | ''         | ''               | ''       | ''         |
			| 'Dress, XS/Blue'                                 | 'Yes'                                            | '1,000'    | 'pcs'            | '100,00' | 'TRY'      |
			| 'Shirt, 36/Red'                                  | 'Yes'                                            | '12,000'   | 'pcs'            | '200,00' | 'TRY'      |
			| 'Boots, 37/18SD'                                 | 'Yes'                                            | '2,000'    | 'Boots (12 pcs)' | '300,00' | 'TRY'      |
		Then the number of "BasisesTree" table lines is "равно" "5"
		And I click "Ok" button
	* Create GR and check creation
		And "ItemList" table contains lines
			| '#' | 'Item'  | 'Inventory transfer' | 'Item key' | 'Store'    | 'Internal supply request' | 'Quantity' | 'Sales invoice' | 'Unit'           | 'Receipt basis'                                  | 'Purchase invoice'                               | 'Currency' | 'Sales return order' | 'Sales order' | 'Purchase order'                               | 'Inventory transfer order' | 'Sales return' |
			| '1' | 'Dress' | ''                   | 'XS/Blue'  | 'Store 02' | ''                        | '1,000'    | ''              | 'pcs'            | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'TRY'      | ''                   | ''            | 'Purchase order 102 dated 03.03.2021 08:59:33' | ''                         | ''             |
			| '2' | 'Shirt' | ''                   | '36/Red'   | 'Store 02' | ''                        | '12,000'   | ''              | 'pcs'            | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'TRY'      | ''                   | ''            | 'Purchase order 102 dated 03.03.2021 08:59:33' | ''                         | ''             |
			| '3' | 'Boots' | ''                   | '37/18SD'  | 'Store 02' | ''                        | '2,000'    | ''              | 'Boots (12 pcs)' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'Purchase invoice 102 dated 03.03.2021 09:25:04' | 'TRY'      | ''                   | ''            | 'Purchase order 102 dated 03.03.2021 08:59:33' | ''                         | ''             |
		Then the number of "ItemList" table lines is "равно" "3"
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt028901$$" variable
		And I delete "$$GoodsReceipt028901$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt028901$$"
		And I save the window as "$$GoodsReceipt028901$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows



Scenario: _300507 check connection to GoodsReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt028901$$'      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows