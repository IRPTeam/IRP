#language: en
@tree
@Positive
@Purchase

Functionality: Purchase invoice - Inventory transfer


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _022600 preparation (PI-IT)
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create catalog BusinessUnits objects
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create document PurchaseInvoice objects
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		
		
Scenario: _0226001 check preparation
	When check preparation

Scenario: _0226002 create IT based in PI Store distributed purchase = False
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '12'      |
	* Try create IT
		And I click the button named "FormDocumentInventoryTransferGenerate""
		Then the number of "ItemList" table lines is "равно" 0
	And I close all client application windows
	

Scenario: _0226003 create PI (Store distributed purchase)
	And I close all client application windows
	* Create PI 
		* Open form for create PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'            |
				| 'Vendor Ferron, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I move to "More" tab
			And I change checkbox "Store distributed purchase"
		* Filling items
			* Dress
				And I move to "Item list" tab
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I activate "Item" field in "ItemList" table
				And I select current line in "ItemList" table
				And I select "dress" from "Item" drop-down list by string in "ItemList" table
				And I activate "Item key" field in "ItemList" table
				And I select "XS/Blue" from "Item key" drop-down list by string in "ItemList" table
				And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
				And I input "100,00" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Scarf
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I activate "Item" field in "ItemList" table
				And I select "Scarf" from "Item" drop-down list by string in "ItemList" table
				And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
				And I input "20,00" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Product 1 with SLN
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I activate "Item" field in "ItemList" table
				And I select "Product 1 with SLN" from "Item" drop-down list by string in "ItemList" table
				And I activate "Item key" field in "ItemList" table
				And I select "ODS" from "Item key" drop-down list by string in "ItemList" table
				And I activate "Serial lot numbers" field in "ItemList" table
				And I click choice button of "Serial lot numbers" attribute in "ItemList" table
				And in the table "SerialLotNumbers" I click "Add" button
				And I select "9090098908" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
				And I activate "Quantity" field in "SerialLotNumbers" table
				And I input "10,000" text in "Quantity" field of "SerialLotNumbers" table
				And I finish line editing in "SerialLotNumbers" table
				And I click "Ok" button
				And I input "100,00" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Product 3 with SLN
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I activate "Item" field in "ItemList" table
				And I select current line in "ItemList" table
				And I select "Product 3 with SLN" from "Item" drop-down list by string in "ItemList" table
				And I select "UNIQ" from "Item key" drop-down list by string in "ItemList" table
				And I activate "Serial lot numbers" field in "ItemList" table
				And I click choice button of "Serial lot numbers" attribute in "ItemList" table
				And in the table "SerialLotNumbers" I click "Add" button
				And I select "09987897977889" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
				And I activate "Quantity" field in "SerialLotNumbers" table
				And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
				And I finish line editing in "SerialLotNumbers" table
				And in the table "SerialLotNumbers" I click "Add" button
				And I select "09987897977890" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
				And I activate "Quantity" field in "SerialLotNumbers" table
				And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
				And I finish line editing in "SerialLotNumbers" table
				And I click "Ok" button
				And I input "100,00" text in "Price" field of "ItemList" table
				And I finish line editing in "ItemList" table
		* Post document
			And I click the button named "FormWrite"
			And I delete "$$NumberPurchaseInvoice0226002$$" variable
			And I delete "$$PurchaseInvoice0226002$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0226002$$"
			And I save the window as "$$PurchaseInvoice0226002$$"
			And I click the button named "FormPostAndClose"		
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And "List" table contains lines
				| 'Number'                              |
				| '$$NumberPurchaseInvoice0226002$$'    |
			And I close all client application windows

			
Scenario: _0226004 create IT based on PI, Store distributed purchase = True
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseInvoice0226002$$'    |
	* Create first IT
		And I click the button named "FormDocumentInventoryTransferGenerate"
		And I select from the drop-down list named "StoreReceiver" by "Store 03" string
		* Check tab
			And "ItemList" table became equal
				| "#" | "Item"               | "Item key" | "Serial lot numbers"             | "Unit" | "Source of origins" | "Quantity" | "Inventory transfer order" | "Production planning" |
				| "1" | "Dress"              | "XS/Blue"  | ""                               | "pcs"  | ""                  | "10,000"   | ""                         | ""                    |
				| "2" | "Scarf"              | "XS/Red"   | ""                               | "pcs"  | ""                  | "5,000"    | ""                         | ""                    |
				| "3" | "Product 1 with SLN" | "ODS"      | "9090098908"                     | "pcs"  | ""                  | "10,000"   | ""                         | ""                    |
				| "4" | "Product 3 with SLN" | "UNIQ"     | "09987897977889; 09987897977890" | "pcs"  | ""                  | "10,000"   | ""                         | ""                    |
		Then the form attribute named "DistributedPurchaseInvıoice" became equal to "$$PurchaseInvoice0226002$$"
		And checkbox "Use shipment confirmation" is equal to "Yes"
		And checkbox named "UseGoodsReceipt" is equal to "Yes"
		* Change quantity
			And I go to line in "ItemList" table
				| "#" | "Item"  | "Item key" | "Quantity" | "Unit" |
				| "2" | "Scarf" | "XS/Red"   | "5,000"    | "pcs"  |
			And I select current line in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "#" | "Item"  | "Item key" | "Quantity" | "Unit" |
				| "1" | "Dress" | "XS/Blue"  | "10,000"   | "pcs"  |
			And I select current line in "ItemList" table
			And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "#" | "Item"               | "Item key" | "Quantity" | "Serial lot numbers" | "Unit" |
				| "3" | "Product 1 with SLN" | "ODS"      | "10,000"   | "9090098908"         | "pcs"  |
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I activate field named "SerialLotNumbersQuantity" in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "8,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click the button named "FormOk"
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "#" | "Item"               | "Item key" | "Quantity" | "Serial lot numbers"             | "Unit" |
				| "4" | "Product 3 with SLN" | "UNIQ"     | "10,000"   | "09987897977889; 09987897977890" | "pcs"  |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I activate field named "SerialLotNumbersQuantity" in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "1,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I go to line in "SerialLotNumbers" table
				| "Code is approved" | "Quantity" | "Serial lot number" |
				| "No"               | "5,000"    | "09987897977890"    |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click the button named "FormOk"
			And I finish line editing in "ItemList" table
		* Post document
			And I click the button named "FormWrite"
			And I delete "$$NumberIT0226003$$" variable
			And I delete "$$IT0226003$$" variable
			And I save the value of "Number" field as "$$NumberIT0226003$$"
			And I save the window as "$$IT0226003$$"
			And I click the button named "FormPostAndClose"		
			Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
			And "List" table contains lines
				| 'Number'                 |
				| '$$NumberIT0226003$$'    |
	* Create second IT
		* Select PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
				| 'Number'                              |
				| '$$NumberPurchaseInvoice0226002$$'    |
			And I select current line in "TableName" table
			And I click the button named "FormDocumentInventoryTransferGenerate"			
	* Create second IT
		And I select from the drop-down list named "StoreReceiver" by "Store 07" string
		* Check tab
			And "ItemList" table became equal
			And "ItemList" table became equal
				| "#" | "Item"               | "Item key" | "Serial lot numbers"             | "Unit" | "Source of origins" | "Quantity" | "Inventory transfer order" | "Production planning" |
				| "1" | "Dress"              | "XS/Blue"  | ""                               | "pcs"  | ""                  | "7,000"    | ""                         | ""                    |
				| "2" | "Scarf"              | "XS/Red"   | ""                               | "pcs"  | ""                  | "3,000"    | ""                         | ""                    |
				| "3" | "Product 1 with SLN" | "ODS"      | "9090098908"                     | "pcs"  | ""                  | "2,000"    | ""                         | ""                    |
				| "4" | "Product 3 with SLN" | "UNIQ"     | "09987897977889; 09987897977890" | "pcs"  | ""                  | "5,000"    | ""                         | ""                    |	
		Then the form attribute named "DistributedPurchaseInvıoice" became equal to "$$PurchaseInvoice0226002$$"
		And checkbox "Use shipment confirmation" is equal to "Yes"
		And checkbox named "UseGoodsReceipt" is equal to "Yes"
		* Post document
			And I click the button named "FormWrite"
			And I delete "$$NumberIT02260032$$" variable
			And I delete "$$IT02260032$$" variable
			And I save the value of "Number" field as "$$NumberIT02260032$$"
			And I save the window as "$$IT02260032$$"
			And I click the button named "FormPostAndClose"		
			Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
			And "List" table contains lines
				| 'Number'                  |
				| '$$NumberIT02260032$$'    |
		And I close all client application windows

