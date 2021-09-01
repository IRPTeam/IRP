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
			| 'Row presentation'                                   | 'Use' | 'Quantity' | 'Unit'           | 'Price' | 'Currency' |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34' | 'Yes' | ''         | ''               | ''      | ''         |
			| 'Dress (L/Green)'                                     | 'Yes' | '20,000'   | 'pcs'            | ''      | ''         |
			| 'Trousers (38/Yellow)'                                | 'Yes' | '20,000'   | 'pcs'            | ''      | ''         |
			| 'Boots (36/18SD)'                                     | 'Yes' | '2,000'    | 'Boots (12 pcs)' | ''      | ''         |
		And I go to line in "BasisesTree" table
			| 'Row presentation'  |
			| 'Dress (L/Green)' |
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

		Then the form attribute named "Branch" became equal to "Logistics department"
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
		And I click "Show row key" button
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
			| 'Key'                              | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''          | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'IT'           | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''          | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'IT'           | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'SC'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'SC'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''             | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'SC'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''             | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'GR'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''             | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''             | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
		Then the number of "RowIDInfo" table lines is "равно" "8"
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
			| 'Key'                              | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''          | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'IT'           | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''          | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'IT'           | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov4InventoryTransfer0201001$$' | ''                                                      | '$$Rov4InventoryTransfer0201001$$'     | 'SC'        | '10,000' | ''                                     | ''             | '$$Rov4InventoryTransfer0201001$$'     |
			| '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'SC'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'SC'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''             | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'SC'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''             | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '$$Rov4InventoryTransfer0201001$$' | ''                                                      | '$$Rov4InventoryTransfer0201001$$'     | 'GR'        | '10,000' | ''                                     | ''             | '$$Rov4InventoryTransfer0201001$$'     |
			| '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'GR'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''             | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''             | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
		Then the number of "RowIDInfo" table lines is "равно" "10"
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
			| 'Key'                              | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''          | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'IT'           | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''          | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'IT'           | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'SC'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'SC'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''             | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'SC'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''             | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'GR'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''             | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''             | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
		Then the number of "RowIDInfo" table lines is "равно" "8"
	* Change checkbox Use SC and check RowIDInfo
		And I remove checkbox "Use shipment confirmation"
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| 'Key'                              | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''          | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'IT'           | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''          | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'IT'           | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov3InventoryTransfer0201001$$' | ''                                                      | '$$Rov3InventoryTransfer0201001$$'     | 'GR'        | '3,000'  | ''                                     | ''             | '$$Rov3InventoryTransfer0201001$$'     |
			| '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '5165e259-51e5-4438-b7cb-ce848249e668' | 'GR'        | '24,000' | '5165e259-51e5-4438-b7cb-ce848249e668' | ''             | '5165e259-51e5-4438-b7cb-ce848249e668' |
			| '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | 'GR'        | '22,000' | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' | ''             | 'a6fd4d98-157c-4fa4-946b-295c45d1c017' |
		Then the number of "RowIDInfo" table lines is "равно" "5"	
		And I click the button named "FormPostAndClose"





	
Scenario: _0201003 copy IT (based on ITO) and check filling in Row Id info table (IT)
	* Copy IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberInventoryTransfer0201001$$' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I set checkbox "Use shipment confirmation"
		And I click the button named "FormPostAndClose"
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
		Then the form attribute named "Branch" became equal to "Logistics department"
		Then the form attribute named "Author" became equal to "en description is empty"
	* Post IT and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| '#' | 'Key'                              | 'Basis'                                                 | 'Row ID'                           | 'Next step' | 'Q'      | 'Basis key' | 'Current step' | 'Row ref'                          |
			| '1' | '$$Rov1InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '*'                                | 'GR'        | '22,000' | '*'         | 'IT'           | '*'                                |
			| '2' | '$$Rov2InventoryTransfer0201001$$' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | '*'                                | 'GR'        | '24,000' | '*'         | 'IT'           | '*'                                |
		Then the number of "RowIDInfo" table lines is "равно" "6"
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


Scenario: _02104809 create IT using form link/unlink
	* Open IT form
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Store 02' |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Store 03' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table		
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price' | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| ''         | ''      | '20,000'   | 'Dress (L/Green)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price' | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| ''         | ''      | '5,000'    | 'Shirt (38/Black)'  | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price' | 'Quantity' | 'Row presentation' | 'Unit'           | 'Use' |
			| ''         | ''      | '3,000'    | 'Boots (36/18SD)'   | 'Boots (12 pcs)' | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#' | 'Basis'                                                 | 'Next step' | 'Q'      | 'Current step' |
		| '1' | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | ''          | '20,000' | 'IT'        |
		| '2' | 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | ''          | '36,000' | 'IT'           |
		| '3' | 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | ''          | '5,000'  | 'IT'           |
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"
		Then "Link / unlink document row" window is opened
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store' | 'Unit' |
			| '3' | '5,000'    | 'Shirt (38/Black)'  | ''      | 'pcs'  |
		And I set checkbox "Linked documents"
		And I go to line in "ResultsTree" table
			| 'Currency' | 'Price' | 'Quantity' | 'Row presentation' | 'Unit' |
			| ''         | ''      | '5,000'    | 'Shirt (38/Black)'  | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		And I click "Save" button	
		And "RowIDInfo" table became equal
			| 'Basis'                                                 | 'Next step' | 'Q'      | 'Current step' |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | ''          | '20,000' | 'IT'           |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | ''          | '36,000' | 'IT'           |
			| ''                                                      | 'SC'        | '5,000'  | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'SC'        | '36,000' | ''             |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'SC'        | '20,000' | ''             |
			| ''                                                      | 'GR'        | '5,000'  | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'GR'        | '36,000' | ''             |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'GR'        | '20,000' | ''             |
		Then the number of "RowIDInfo" table lines is "равно" "8"		
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Inventory transfer order'                              |
			| 'Dress' | 'L/Green'  | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' |
			| 'Boots' | '36/18SD'  | 'Inventory transfer order 18 dated 02.03.2021 13:54:52' |
			| 'Shirt' | '38/Black' | ''                                                      |
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store' | 'Unit' |
			| '3' | '5,000'    | 'Shirt (38/Black)'  | ''      | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' |
			| '5,000'    | 'Shirt (38/Black)'  | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| 'Basis'                                                 | 'Next step' | 'Q'      | 'Current step' |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | ''          | '20,000' | 'IT'           |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | ''          | '36,000' | 'IT'           |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | ''          | '5,000'  | 'IT'           |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'SC'        | '5,000'  | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'SC'        | '36,000' | ''             |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'SC'        | '20,000' | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'GR'        | '5,000'  | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'GR'        | '36,000' | ''             |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'GR'        | '20,000' | ''             |
		Then the number of "RowIDInfo" table lines is "равно" "9"		
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Inventory transfer order'                                           |
			| 'Dress' | 'L/Green'  | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' |
			| 'Boots' | '36/18SD'  | 'Inventory transfer order 18 dated 02.03.2021 13:54:52' |
			| 'Shirt' | '38/Black' | 'Inventory transfer order 18 dated 02.03.2021 13:54:52' |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price' | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| ''         | ''      | '20,000'   | 'Dress (L/Green)'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Inventory transfer order'                                           |
			| 'Dress' | 'L/Green'  | 'Inventory transfer order 17 dated 02.03.2021 13:34:27' |
			| 'Boots' | '36/18SD'  | 'Inventory transfer order 18 dated 02.03.2021 13:54:52' |
			| 'Shirt' | '38/Black' | 'Inventory transfer order 18 dated 02.03.2021 13:54:52' |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'box Dress (8 pcs)' |
		And I select current line in "List" table
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| 'Basis'                                                 | 'Next step' | 'Q'       | 'Current step' |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | ''          | '160,000' | 'IT'           |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | ''          | '36,000'  | 'IT'           |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | ''          | '5,000'   | 'IT'           |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'SC'        | '5,000'   | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'SC'        | '36,000'  | ''             |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'SC'        | '160,000' | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'GR'        | '5,000'   | ''             |
			| 'Inventory transfer order 18 dated 02.03.2021 13:54:52' | 'GR'        | '36,000'  | ''             |
			| 'Inventory transfer order 17 dated 02.03.2021 13:34:27' | 'GR'        | '160,000' | ''             |
		Then the number of "RowIDInfo" table lines is "равно" "9"
		And I close all client application windows


Scenario: _999999 close TestClient session
	And I close TestClient session