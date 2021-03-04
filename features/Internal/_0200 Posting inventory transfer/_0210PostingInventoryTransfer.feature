#language: en
@tree
@Positive
@Group4
@InventoryTransfer

Feature: create document Inventory transfer

As a procurement manager
I want to create a Inventory transfer order
To transfer items from one store to another

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _0201000 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog BusinessUnits objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
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
	* Load InventoryTransferOrder
		When Create document InventoryTransferOrder objects (creation based on)
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(17).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.InventoryTransferOrder.FindByNumber(18).GetObject().Write(DocumentWriteMode.Posting);" |


Scenario: _0201001 create IT based on ITO
	* Select ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' |
			| '17'     |
	* Create IT
		And I click the button named "FormDocumentInventoryTransferGenerate"
		Then "Add linked document rows" window is opened
		And "BasisesTree" table became equal
			| 'Row presentation'                                   | 'Use'                                                | 'Quantity' | 'Unit'           | 'Price' | 'Currency' |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34' | 'Inventory transfer order 17 dated 02.03.2021 13:34' | ''         | ''               | ''      | ''         |
			| 'Dress, L/Green'                                     | 'Yes'                                                | '20,000'   | 'pcs'            | ''      | ''         |
			| 'Trousers, 38/Yellow'                                | 'Yes'                                                | '20,000'   | 'pcs'            | ''      | ''         |
			| 'Boots, 36/18SD'                                     | 'Yes'                                                | '2,000'    | 'Boots (12 pcs)' | ''      | ''         |
		And I go to line in "BasisesTree" table
			| 'Row presentation'  |
			| 'Dress, L/Green' |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check filling in IT
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 02"
		Then the form attribute named "StoreReceiver" became equal to "Store 03"
		And "ItemList" table became equal
			| '#' | 'Item'     | 'Item key'  | 'Quantity' | 'Unit'           | 'Inventory transfer order'                              |
			| '1' | 'Trousers' | '38/Yellow' | '20,000'   | 'pcs'            | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' |
			| '2' | 'Boots'    | '36/18SD'   | '2,000'    | 'Boots (12 pcs)' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' |

		Then the form attribute named "BusinessUnit" became equal to "Logistics department"
		Then the form attribute named "Author" became equal to "en description is empty"
	* Change quantity (more than ITO) + new line
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'      |
			| 'Trousers' | '38/Yellow' | '20,000' |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "22,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| 'Basis'                                                 | 'Q'      |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '22,000' |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '24,000' |
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| 'Basis'                                                 | 'Q'      |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '22,000' |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '24,000' |
			| ''                                                      | '3,000' |
		And I move to "Other" tab
		And I set checkbox "Use goods receipt"
		And I set checkbox "Use shipment confirmation"		
		And I click the button named "FormPost"
		And I delete "$$InventoryTransfer0201001$$" variable
		And I delete "$$NumberInventoryTransfer0201001$$" variable
		And I save the window as "$$InventoryTransfer0201001$$"
		And I save the value of "Number" field as "$$NumberInventoryTransfer0201001$$"
		And I click the button named "FormPostAndClose"

	

Scenario: _0201002 check filling in Row Id info table in the IT (ITO-IT)
	* Select IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberInventoryTransfer0201001$$' |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1InventoryTransfer0201001$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2InventoryTransfer0201001$$"
		And I go to line in "ItemList" table
			| '#' |
			| '3' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3InventoryTransfer0201001$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                              | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'IT'           | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '2' | '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'IT'           | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '3' | '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'GR'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Copy string and check Row ID Info tab
		And I move to "Items" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key'  | 'Quantity' |
			| '1' | 'Trousers' | '38/Yellow' | '22,000'   |
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' |
			| '4' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov4InventoryTransfer0201001$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                              | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'IT'           | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '2' | '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'IT'           | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '3' | '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'GR'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '4' | '$$Rov4InventoryTransfer0201001$$' | ''                                                      | '$$Rov4InventoryTransfer0201001$$'     | 'GR'        | '10,000' | ''                                     | ''             | '$$Rov4InventoryTransfer0201001$$'     |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                              | 'Q'      |
			| '$$Rov1InventoryTransfer0201001$$' | '10,000' |
	* Delete string and check Row ID Info tab
		And I move to "Items" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key'  | 'Quantity' |
			| '4' | 'Trousers' | '38/Yellow' | '10,000'   |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                              | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'IT'           | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '2' | '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'IT'           | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '3' | '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'GR'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	// * Change checkbox Use Goods receipt and check RowIDInfo
		
	// 	And I click "Post" button
	// 	And "RowIDInfo" table contains lines
	// 		| '#' | 'Key'                           | 'Basis'                                        | 'Row ID'                               | 'Next step' | 'Q'     | 'Basis key'                            | 'Current step' | 'Row ref'                              |
	// 		| '1' | '$$Rov1InventoryTransfer0201001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '5,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'PI&GR'        | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
	// 		| '2' | '$$Rov2InventoryTransfer0201001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '5,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'PI&GR'        | '5165e259-51e5-4438-b7cb-ce848249e668' |
	// 		| '3' | '$$Rov3InventoryTransfer0201001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'GR'        | '8,000' | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' | 'PI&GR'        | '4e941c9a-e895-4eb2-87cd-09fe5b60fc57' |
	// 		| '4' | '$$Rov4InventoryTransfer0201001$$' | 'Purchase order 217 dated 12.02.2021 12:45:05' | '8d544e62-9a68-43c3-8399-b4ef451d9770' | ''          | '60,000'| '8d544e62-9a68-43c3-8399-b4ef451d9770' | 'PI&GR'        | '8d544e62-9a68-43c3-8399-b4ef451d9770' |
	// 	Then the number of "RowIDInfo" table lines is "равно" "4"	
		And I click the button named "FormPostAndClose"





	
Scenario: _0201003 copy IT (based on ITO) and check filling in Row Id info table (IT)
	* Copy IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberInventoryTransfer0201001$$' |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 02"
		Then the form attribute named "StoreReceiver" became equal to "Store 03"
		And "ItemList" table became equal
			| '#' | 'Item'     | 'Item key'  | 'Quantity' | 'Unit'           | 'Inventory transfer order' |
			| '1' | 'Trousers' | '38/Yellow' | '22,000'   | 'pcs'            | ''                         |
			| '2' | 'Boots'    | '36/18SD'   | '2,000'    | 'Boots (12 pcs)' | ''                         |
			| '3' | 'Shirt'    | '38/Black'  | '3,000'    | 'pcs'            | ''                         |
		Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
		Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
		Then the form attribute named "BusinessUnit" became equal to "Logistics department"
		Then the form attribute named "Author" became equal to "en description is empty"
	* Post IT and check Row ID Info tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| '#' | 'Key'                              | 'Basis'                                                 | 'Row ID'                           | 'Next step' | 'Q'      | 'Basis key' | 'Current step' | 'Row ref'                          |
			| '1' | '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '*'                                | 'GR'        | '22,000' | '*'         | 'IT'           | '*'                                |
			| '2' | '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '*'                                | 'GR'        | '24,000' | '*'         | 'IT'           | '*'                                |
			| '3' | '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$' | 'GR'        | '3,000'  | ''          | ''             | '$$Rov3InventoryTransfer0201001$$' |
		Then the number of "RowIDInfo" table lines is "равно" "9"
		And I close all client application windows		





	# 5
Scenario: _021024 create document Inventory Transfer (without ITO)
	
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Store sender" field
	And I go to line in "List" table
		| Description |
		| Store 01    |
	And I select current line in "List" table
	And I click Select button of "Store receiver" field
	And I go to line in "List" table
		| Description |
		| Store 02    |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I move to "Items" tab
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
		| 'S/Yellow' |
	And I select current line in "List" table
	And I activate "Unit" field in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "7,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransfer021024$$" variable
	And I delete "$$InventoryTransfer021024$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransfer021024$$"
	And I save the window as "$$InventoryTransfer021024$$"
	And I click the button named "FormPostAndClose"



Scenario: _02104808 check filling in fields Use GR and Use SC from Store in the Inventory transfer (prohibit Use SC = True, Use GR = False)
	* Opening a form to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Filling in Store sender (Use SC) and Store receiver (Use GR) and check filling fields Use GR and Use SC
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I move to "Other" tab
		Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
		Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
	* Filling in Store sender (not use SC) and Store receiver ( not use GR) and check filling fields Use GR and Use SC
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04'  |
		And I select current line in "List" table
		And I move to "Other" tab
		Then the form attribute named "UseShipmentConfirmation" became equal to "No"
		Then the form attribute named "UseGoodsReceipt" became equal to "No"
	* Filling in Store sender (not use SC) and Store receiver ( use GR) and check filling fields Use GR and Use SC
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I move to "Other" tab
		Then the form attribute named "UseShipmentConfirmation" became equal to "No"
		Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
	* Filling in Store sender (use SC) and Store receiver ( not use GR) and check filling fields Use GR and Use SC
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I move to "Other" tab
		Then I wait that in user messages the "Сan not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled." substring will appear in 20 seconds
		Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
		Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
		And I close all client application windows


Scenario: _999999 close TestClient session
	And I close TestClient session