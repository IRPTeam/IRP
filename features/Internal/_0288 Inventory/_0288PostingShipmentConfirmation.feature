#language: en
@tree
@Positive
@Inventory



Feature: create Shipment confirmation


As a storekeeper
I want to create a Shipment confirmation
For shipment of products from store


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _028800 preparation (Shipment confirmation)
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023005$$" |
			When create SalesOrder023005
	* Check or create SalesInvoice024008 based on SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024008$$" |
			When create SalesInvoice024008
	* Check or create SalesInvoice024025
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024025$$" |					
			When create SalesInvoice024025
	* Check or create PurchaseOrder017003
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017003$$" |
			When create PurchaseOrder017003
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018006$$" |
			When create PurchaseInvoice018006 based on PurchaseOrder017003
	
	* Check or create PurchaseReturn022314
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseReturn022314$$" |
			When create PurchaseReturn022314
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			And I go to line in "List" table
					| 'Number'                          |
					| "$$NumberPurchaseReturn022314$$"|
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPostAndClose"
	* Check or create InventoryTransfer021030
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberInventoryTransfer021030$$" |	
			When create InventoryTransfer021030
		And Delay 5
	* Create SO
		When Create document SalesOrder objects (SC before SI, creation based on)
		And I close all client application windows
		And Delay 5
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);" |
		And Delay 5
	* Copy created SO 
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                       |
			| '15' |
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I move to "Other" tab
		And I input "16" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "16" text in "Number" field		
		And I click "Post and close" button
	* Create SI>SO
		When Create document SalesOrder and SalesInvoice objects (creation based on, SI >SO)	
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
				
		




Scenario: _028801 create document Shipment confirmation based on SI (with SO)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'                       | 'Partner'   |
		| '$$NumberSalesInvoice024008$$' | 'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerate"
	And I click "Ok" button	
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check if the product is filled in
		And "ItemList" table contains lines
		| 'Item'     | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| 'Dress'    | '10,000'   | 'L/Green'  | 'pcs' | '$$SalesInvoice024008$$' |
		| 'Trousers' | '14,000'   | '36/Yellow'| 'pcs' | '$$SalesInvoice024008$$' |
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	And I click the button named "FormPost"
	And I delete "$$NumberShipmentConfirmation028801$$" variable
	And I delete "$$ShipmentConfirmation0028801$$" variable
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028801$$"
	And I save the window as "$$ShipmentConfirmation0028801$$"
	And I click the button named "FormPostAndClose"
	And I close current window
	

Scenario: _028804 create document Shipment confirmation based on SI (without SO)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'    |
		| '$$NumberSalesInvoice024025$$'      | 'Kalipso' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerate"
	And I click "Ok" button	
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check if the product is filled in
		And "ItemList" table contains lines
		| '#' | 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| '1' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | '$$SalesInvoice024025$$' |
	And I click the button named "FormPost"
	And I delete "$$NumberShipmentConfirmation028804$$" variable
	And I delete "$$ShipmentConfirmation0028804$$" variable
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028804$$"
	And I save the window as "$$ShipmentConfirmation0028804$$"
	And I click the button named "FormPostAndClose"
	And I close current window

Scenario: _028805 create document Shipment confirmation based on 2 SO
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		* List Options (ordering by number)
			And I click "Configure list..." button
			And I move to "Order" tab
			And I go to line in "SettingsComposerUserSettingsItem1AvailableFieldsTable" table
				| 'Available fields' |
				| 'Number'           |
			And I select current line in "SettingsComposerUserSettingsItem1AvailableFieldsTable" table
			And I go to line in "SettingsComposerUserSettingsItem1Order" table
				| 'Field' | 'Sort direction' | 'Use' |
				| 'Date'  | 'Ascending'      | 'Yes' |
			And I activate field named "SettingsComposerUserSettingsItem1OrderField" in "SettingsComposerUserSettingsItem1Order" table
			And I delete a line in "SettingsComposerUserSettingsItem1Order" table
			And I click "Finish editing" button
		And I go to line in "List" table
			| 'Number'  |
			| '15'      |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentShipmentConfirmationGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                         | 'Use'                                      | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 15 dated 01.02.2021 19:50:45' | 'Sales order 15 dated 01.02.2021 19:50:45' | ''         | ''     | ''       | ''         |
			| 'Dress, XS/Blue'                           | 'Yes'                                      | '1,000'    | 'pcs'  | '520,00' | 'TRY'      |
			| 'Shirt, 36/Red'                            | 'Yes'                                      | '10,000'   | 'pcs'  | '350,00' | 'TRY'      |
			| 'Dress, XS/Blue'                           | 'Yes'                                      | '2,000'    | 'pcs'  | '500,00' | 'TRY'      |
			| 'Dress, XS/Blue'                           | 'Yes'                                      | '10,000'   | 'pcs'  | '520,00' | 'TRY'      |
			| 'Sales order 16*'                          | 'Sales order 16*'                          | ''         | ''     | ''       | ''         |
			| 'Dress, XS/Blue'                           | 'Yes'                                      | '1,000'    | 'pcs'  | '520,00' | 'TRY'      |
			| 'Shirt, 36/Red'                            | 'Yes'                                      | '10,000'   | 'pcs'  | '350,00' | 'TRY'      |
			| 'Dress, XS/Blue'                           | 'Yes'                                      | '2,000'    | 'pcs'  | '500,00' | 'TRY'      |
			| 'Dress, XS/Blue'                           | 'Yes'                                      | '10,000'   | 'pcs'  | '520,00' | 'TRY'      |
		Then the number of "BasisesTree" table lines is "равно" "10"
		And I click "Ok" button
	* Create SC and check filling in
		And "ItemList" table contains lines
			| '#' | 'Item'  | 'Inventory transfer' | 'Item key' | 'Quantity' | 'Sales invoice' | 'Unit' | 'Store'    | 'Shipment basis'                           | 'Sales order'                              | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Dress' | ''                   | 'XS/Blue'  | '1,000'    | ''              | 'pcs'  | 'Store 02' | 'Sales order 15 dated 01.02.2021 19:50:45' | 'Sales order 15 dated 01.02.2021 19:50:45' | ''                         | ''                      | ''                |
			| '2' | 'Dress' | ''                   | 'XS/Blue'  | '1,000'    | ''              | 'pcs'  | 'Store 02' | 'Sales order 16*'                          | 'Sales order 16*'                          | ''                         | ''                      | ''                |
			| '3' | 'Shirt' | ''                   | '36/Red'   | '10,000'   | ''              | 'pcs'  | 'Store 02' | 'Sales order 15 dated 01.02.2021 19:50:45' | 'Sales order 15 dated 01.02.2021 19:50:45' | ''                         | ''                      | ''                |
			| '4' | 'Shirt' | ''                   | '36/Red'   | '10,000'   | ''              | 'pcs'  | 'Store 02' | 'Sales order 16*'                          | 'Sales order 16*'                          | ''                         | ''                      | ''                |
			| '5' | 'Dress' | ''                   | 'XS/Blue'  | '2,000'    | ''              | 'pcs'  | 'Store 02' | 'Sales order 15 dated 01.02.2021 19:50:45' | 'Sales order 15 dated 01.02.2021 19:50:45' | ''                         | ''                      | ''                |
			| '6' | 'Dress' | ''                   | 'XS/Blue'  | '2,000'    | ''              | 'pcs'  | 'Store 02' | 'Sales order 16*'                          | 'Sales order 16*'                          | ''                         | ''                      | ''                |
			| '7' | 'Dress' | ''                   | 'XS/Blue'  | '10,000'   | ''              | 'pcs'  | 'Store 02' | 'Sales order 15 dated 01.02.2021 19:50:45' | 'Sales order 15 dated 01.02.2021 19:50:45' | ''                         | ''                      | ''                |
			| '8' | 'Dress' | ''                   | 'XS/Blue'  | '10,000'   | ''              | 'pcs'  | 'Store 02' | 'Sales order 16*'                          | 'Sales order 16*'                          | ''                         | ''                      | ''                |
		Then the number of "ItemList" table lines is "равно" "8"
	// * Check RowId info
	// 	And I click "Show row key" button		
	// 	And "RowIDInfo" table contains lines
	// 		| '#' | 'Key' | 'Basis'                                    | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
	// 		| '1' | '*'   | 'Sales order 15 dated 01.02.2021 19:50:45' | '63008c12-b682-4aff-b29f-e6927036b09a' | ''          | '1,000'  | '63008c12-b682-4aff-b29f-e6927036b09a' | 'SI&SC'        | '63008c12-b682-4aff-b29f-e6927036b09a' |
	// 		| '2' | '*'   | 'Sales order 16 dated 10.03.2021 16:43:13' | '*'                                    | ''          | '1,000'  | '*'                                    | 'SI&SC'        | '*'                                    |
	// 		| '3' | '*'   | 'Sales order 15 dated 01.02.2021 19:50:45' | 'e34f52ea-1fe2-47b2-9b37-63c093896682' | ''          | '10,000' | 'e34f52ea-1fe2-47b2-9b37-63c093896682' | 'SI&SC'        | 'e34f52ea-1fe2-47b2-9b37-63c093896682' |
	// 		| '4' | '*'   | 'Sales order 16 dated 10.03.2021 16:43:13' | '*'                                    | ''          | '10,000' | '*'                                    | 'SI&SC'        | '*'                                    |
	// 		| '5' | '*'   | 'Sales order 15 dated 01.02.2021 19:50:45' | '6f6dfb41-d0f8-450e-a482-8ec73611481c' | ''          | '2,000'  | '6f6dfb41-d0f8-450e-a482-8ec73611481c' | 'SI&SC'        | '6f6dfb41-d0f8-450e-a482-8ec73611481c' |
	// 		| '6' | '*'   | 'Sales order 16 dated 10.03.2021 16:43:13' | '*'                                    | ''          | '2,000'  | '*'                                    | 'SI&SC'        | '*'                                    |
	// 		| '7' | '*'   | 'Sales order 15 dated 01.02.2021 19:50:45' | '1d6247c2-19e2-4aa8-93a2-58e0867cc2be' | ''          | '10,000' | '1d6247c2-19e2-4aa8-93a2-58e0867cc2be' | 'SI&SC'        | '1d6247c2-19e2-4aa8-93a2-58e0867cc2be' |
	// 		| '8' | '*'   | 'Sales order 16 dated 10.03.2021 16:43:13' | '*'                                    | ''          | '10,000' | '*'                                    | 'SI&SC'        | '*'                                    |
	// 	Then the number of "RowIDInfo" table lines is "равно" "8"	
		And I close all client application windows


Scenario: _028806 create document Shipment confirmation based on SI (with SO, SI>SO)
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '32'      |
		And I click the button named "FormDocumentShipmentConfirmationGenerate"	
		And "BasisesTree" table contains lines
			| 'Row presentation'                           | 'Use'                                        | 'Quantity' | 'Unit'           | 'Price'    | 'Currency' |
			| 'Sales order 32 dated 26.02.2021 13:30:49'   | 'Sales order 32 dated 26.02.2021 13:30:49'   | ''         | ''               | ''         | ''         |
			| 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''         | ''               | ''         | ''         |
			| 'Dress, XS/Blue'                             | 'Yes'                                        | '1,000'    | 'pcs'            | '520,00'   | 'TRY'      |
			| 'Shirt, 36/Red'                              | 'Yes'                                        | '12,000'   | 'pcs'            | '350,00'   | 'TRY'      |
			| 'Boots, 37/18SD'                             | 'Yes'                                        | '2,000'    | 'Boots (12 pcs)' | '8 400,00' | 'TRY'      |
			| 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''         | ''               | ''         | ''         |
			| 'Shirt, 38/Black'                            | 'Yes'                                        | '2,000'    | 'pcs'            | '350,00'   | 'TRY'      |
		Then the number of "BasisesTree" table lines is "равно" "7"
		And I click "Ok" button
	* Create SC and check filling in
		And "ItemList" table contains lines
			| '#' | 'Item'  | 'Inventory transfer' | 'Item key' | 'Quantity' | 'Sales invoice'                              | 'Unit'           | 'Store'    | 'Shipment basis'                             | 'Sales order'                              | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Dress' | ''                   | 'XS/Blue'  | '1,000'    | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'pcs'            | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'Sales order 32 dated 26.02.2021 13:30:49' | ''                         | ''                      | ''                |
			| '2' | 'Shirt' | ''                   | '36/Red'   | '12,000'   | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'pcs'            | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'Sales order 32 dated 26.02.2021 13:30:49' | ''                         | ''                      | ''                |
			| '3' | 'Boots' | ''                   | '37/18SD'  | '2,000'    | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'Boots (12 pcs)' | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'Sales order 32 dated 26.02.2021 13:30:49' | ''                         | ''                      | ''                |
			| '4' | 'Shirt' | ''                   | '38/Black' | '2,000'    | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'pcs'            | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''                                         | ''                         | ''                      | ''                |
		Then the number of "ItemList" table lines is "равно" "4"
	* Check RowId info
		And I click "Show row key" button	
		And "RowIDInfo" table contains lines
			| '#' | 'Key' | 'Basis'                                      | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '*'   | 'Sales invoice 32 dated 04.03.2021 16:32:23' | '498b47ae-dd97-473e-b00d-4b9d611f7413' | ''          | '1,000'  | '4f22f6a9-2f81-47bb-a8b8-f6089fb7ba21' | 'SC'           | '498b47ae-dd97-473e-b00d-4b9d611f7413' |
			| '2' | '*'   | 'Sales invoice 32 dated 04.03.2021 16:32:23' | '706b55fe-a4a3-4d44-b648-2dc75c16b0db' | ''          | '12,000' | '3f40a72c-599e-4778-bfe8-56e6f33d5d8d' | 'SC'           | '706b55fe-a4a3-4d44-b648-2dc75c16b0db' |
			| '3' | '*'   | 'Sales invoice 32 dated 04.03.2021 16:32:23' | 'c32fd20d-7e19-4d30-9cf6-2cef506c9bc5' | ''          | '24,000' | 'edddfff5-6850-4f96-a93a-abed1c5e6c84' | 'SC'           | 'c32fd20d-7e19-4d30-9cf6-2cef506c9bc5' |
			| '4' | '*'   | 'Sales invoice 32 dated 04.03.2021 16:32:23' | '5fca1039-4b80-4493-bbd6-44e8d01b9a59' | ''          | '2,000'  | '5fca1039-4b80-4493-bbd6-44e8d01b9a59' | 'SC'           | '5fca1039-4b80-4493-bbd6-44e8d01b9a59' |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And I close all client application windows


Scenario: _028807 create document Shipment confirmation based on Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022314$$'      |
	And I select current line in "List" table
	And I click "Shipment confirmation" button
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'                              |
		| 'Dress' | '10,000'    | 'L/Green'  | 'pcs'  | '$$PurchaseReturn022314$$' |
	And I click the button named "FormPost"
	And I delete "$$NumberShipmentConfirmation028807$$" variable
	And I delete "$$ShipmentConfirmation0028807$$" variable
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028807$$"
	And I save the window as "$$ShipmentConfirmation0028807$$"
	And I click the button named "FormPostAndClose"
	And I close current window



Scenario: _028809 check Shipment confirmation posting (based on Purchase return) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | '$$ShipmentConfirmation0028807$$' | '$$PurchaseReturn022314$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028810 create document Shipment confirmation  based on Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'                           |
		| '$$NumberInventoryTransfer021030$$' |
	And I click the button named "FormDocumentShipmentConfirmationGenerate"
	And I click "Ok" button	
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "TransactionType" became equal to "Inventory transfer"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
		| '#' | 'Item'  | 'Inventory transfer'          | 'Item key' | 'Quantity' | 'Sales invoice' | 'Unit' | 'Store'    | 'Shipment basis'              | 'Sales order' | 'Inventory transfer order' | 'Purchase return order' | 'Purchase return' |
		| '1' | 'Dress' | '$$InventoryTransfer021030$$' | 'L/Green'  | '3,000'    | ''              | 'pcs'  | 'Store 02' | '$$InventoryTransfer021030$$' | ''            | ''                         | ''                      | ''                |
	And I click "Show row key" button
	And I go to line in "ItemList" table
		| '#' |
		| '1' |
	And I activate "Key" field in "ItemList" table
	And I save the current field value as "$$Rov1ShipmentConfirmation028810$$"	
	And I move to "Row ID Info" tab
	And "RowIDInfo" table contains lines
		| '#' | 'Key'                                | 'Basis'                       | 'Row ID' | 'Next step' | 'Q'     | 'Basis key' | 'Current step' | 'Row ref' |
		| '1' | '$$Rov1ShipmentConfirmation028810$$' | '$$InventoryTransfer021030$$' | '*'      | ''          | '3,000' | '*'         | 'SC'           | '*'       |	
	Then the number of "RowIDInfo" table lines is "равно" "1"
	And I click the button named "FormPost"
	And I delete "$$NumberShipmentConfirmation028810$$" variable
	And I delete "$$ShipmentConfirmation0028810$$" variable
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028810$$"
	And I save the window as "$$ShipmentConfirmation0028810$$"
	And I click the button named "FormPostAndClose"
	




Scenario: _300506 check connection to Shipment Confirmation report "Related documents"
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberShipmentConfirmation028801$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
