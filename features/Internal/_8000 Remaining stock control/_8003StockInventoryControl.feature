#language: en
@tree
@Positive
@StockControl


Feature: check stock inventory control

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario:_800300 preparation (stock inventory control)
	When set True value to the constant
	* Load info
		When Create catalog CancelReturnReasons objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Units objects
		When Create catalog Items objects (serial lot numbers)
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects (with remaining stock control)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Countries objects
		When Create information register Barcodes records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When create items for work order
		When Create catalog BillOfMaterials objects
		When Create information register Taxes records (VAT)	
	* Load documents
		When Create document PurchaseInvoice, GoodsReceipt and SalesInvoice objects (stock inventory control)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1253).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1114).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2122).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Stock inventary settings
		When Create information register UserSettings records (stock inventory control)
	* Delete control for register R4014B_SerialLotNumber
		Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
		And I go to line in "List" table
			| "Attribute name"                     | "Kind of attribute" | "Metadata object"             | "Value" |
			| "CheckBalance_4014B_SerialLotNumber" | "Custom"            | "Document.RetailSalesReceipt" | "Yes"   |
		And in the table "List" I click "Delete" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| "Attribute name"                     | "Kind of attribute" | "Metadata object"             | "Value" |
			| "CheckBalance_4014B_SerialLotNumber" | "Custom"            | "Document.RetailSalesReceipt" | "Yes"   |
		And in the table "List" I click "Delete" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
	When create payment terminal
	When create PaymentTypes
	When create bank terms
	When create Workstation

Scenario:_8003001 check preparation
	When check preparation 


Scenario:_8003002 check stock inventory control for RetailSalesReceipt
	And I close all client application windows
	* Create RetailSalesReceipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 07" string
		* Payments
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I select "cas" from "Payment type" drop-down list by string in "Payments" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "260,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table	
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
		* Try post and check stock inventory control
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 6 . Lacking: 1 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 10 . Lacking: 2 .'|
		* Change quantity and check control
			And I go to line in "ItemList" table
				| "Item" | "Item key" |
				| "Bag"  | "ODS"      |
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "Item"                         | "Item key" | "Quantity" |
				| "Product 7 with SLN (new row)" | "PZU"      | "10,000"   |
			And I select current line in "ItemList" table
			And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009099"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009098"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I move to "Payments" tab
			And I select current line in "Payments" table
			And I input "210,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table
			And I move to "Item list" tab
			And I click "Post" button
			Then user message window does not contain messages
			And I delete "$$NumberRetailSalesReceipt2$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt2$$"
	* Create one more RSR (previous date) and check control
		* Create RetailSalesReceipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click "Create" button
			And I select from the drop-down list named "Store" by "Store 07" string
		* Payments
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I select "cas" from "Payment type" drop-down list by string in "Payments" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "10,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table	
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Other" tab
			And I move to "More" tab
			And I input "27.08.2024 16:00:00" text in the field named "Date"
			And I move to the next attribute
			Then "Update item list info" window is opened
			And I click "Uncheck all" button
			And I click "OK" button		
			And I click "Post" button
			And I click the button named "OK"			
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 0 . Required: 1 . Lacking: 1 .'|
			And I close current window
			Then "1C:Enterprise" window is opened
			And I click "No" button		
	* Cancel posting first RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| "Number"                        |
			| "$$NumberRetailSalesReceipt2$$" |
		And I click the button named "FormUndoPosting"		
		Then user message window does not contain messages
		And I close all client application windows
						

Scenario:_8003003 check stock inventory control for SI
	And I close all client application windows
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 07" string
		* Main attributes
			And I select from the drop-down list named "Partner" by "Lomaniti" string
			And I select from "Partner term" drop-down list by "Basic Partner terms, TRY" string
			And I select from the drop-down list named "Store" by "store 07" string			
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
		* Try post and check stock inventory control
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 6 . Lacking: 1 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 10 . Lacking: 2 .'|
		* Change quantity and check control
			And I go to line in "ItemList" table
				| "Item" | "Item key" |
				| "Bag"  | "ODS"      |
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "Item"                         | "Item key" | "Quantity" |
				| "Product 7 with SLN (new row)" | "PZU"      | "10,000"   |
			And I select current line in "ItemList" table
			And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009099"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009098"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I click "Post" button
			Then user message window does not contain messages
	* Cancel posting SI
		And I click the button named "FormUndoPosting"		
		Then user message window does not contain messages
		And I close all client application windows		
						
Scenario:_8003004 check stock inventory control for PR
	And I close all client application windows
	* Create Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 07" string
		* Main attributes
			And I select from the drop-down list named "Partner" by "DFC" string
			And I select from "Partner term" drop-down list by "Partner term vendor DFC" string
			And I select from the drop-down list named "Store" by "store 07" string			
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
		* Try post and check stock inventory control
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 6 . Lacking: 1 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 10 . Lacking: 2 .'|
		* Change quantity and check control
			And I go to line in "ItemList" table
				| "Item" | "Item key" |
				| "Bag"  | "ODS"      |
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "Item"                         | "Item key" | "Quantity" |
				| "Product 7 with SLN (new row)" | "PZU"      | "10,000"   |
			And I select current line in "ItemList" table
			And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009099"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009098"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I click "Post" button
			Then user message window does not contain messages
	* Cancel posting PR
		And I click the button named "FormUndoPosting"		
		Then user message window does not contain messages
		And I close all client application windows					
		
								
Scenario:_8003005 check stock inventory control for Stock adjustment as write off
	And I close all client application windows
	* Create Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 07" string
		* Main attributes
			And I select from the drop-down list named "Company" by "Main Company" string
			And I select from the drop-down list named "Store" by "store 07" string			
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I select "Logistics department" from "Profit loss center" drop-down list by string in "ItemList" table
			And I activate "Expense type" field in "ItemList" table
			And I select "Expense" from "Expense type" drop-down list by string in "ItemList" table			
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I select "Logistics department" from "Profit loss center" drop-down list by string in "ItemList" table
			And I activate "Expense type" field in "ItemList" table
			And I select "Expense" from "Expense type" drop-down list by string in "ItemList" table		
			And I finish line editing in "ItemList" table
		* Try post and check stock inventory control
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 6 . Lacking: 1 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 10 . Lacking: 2 .'|
		* Change quantity and check control
			And I go to line in "ItemList" table
				| "Item" | "Item key" |
				| "Bag"  | "ODS"      |
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "Item"                         | "Item key" | "Quantity" |
				| "Product 7 with SLN (new row)" | "PZU"      | "10,000"   |
			And I select current line in "ItemList" table
			And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009099"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009098"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I click "Post" button
			Then user message window does not contain messages
	* Cancel posting Stock adjustment as write off
		And I click the button named "FormUndoPosting"		
		Then user message window does not contain messages
		And I close all client application windows

Scenario:_8003006 check stock inventory control for IT
	And I close all client application windows
	* Create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click "Create" button
		* Main attributes
			And I select from the drop-down list named "Company" by "Main Company" string
			And I select from the drop-down list named "StoreSender" by "Store 07" string
			And I select from the drop-down list named "StoreReceiver" by "Store 06" string		
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table	
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "5,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
		* Try post and check stock inventory control
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 6 . Lacking: 1 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 10 . Lacking: 2 .'|
		* Change quantity and check control
			And I go to line in "ItemList" table
				| "Item" | "Item key" |
				| "Bag"  | "ODS"      |
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| "Item"                         | "Item key" | "Quantity" |
				| "Product 7 with SLN (new row)" | "PZU"      | "10,000"   |
			And I select current line in "ItemList" table
			And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009099"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I go to line in "SerialLotNumbers" table
				| "Quantity" | "Serial lot number" |
				| "5,000"    | "9009098"           |
			And I select current line in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I click "Post" button
			And I delete "$$NumberIT8003006$$" variable
			And I save the value of "Number" field as "$$NumberIT8003006$$"
			Then user message window does not contain messages
	* Cancel posting IT
		And I click the button named "FormUndoPosting"		
		Then user message window does not contain messages
		And I click "Post and close" button
	* Add SI and try unpost IT
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 07" string
		* Main attributes
			And I select from the drop-down list named "Partner" by "Lomaniti" string
			And I select from "Partner term" drop-down list by "Basic Partner terms, TRY" string
			And I select from the drop-down list named "Store" by "store 06" string			
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
		* Post and check stock inventory control
			And I click "Post" button
			Then user message window does not contain messages
		* Try unpost IT
			Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
			And I go to line in "List" table
				| "Number"              |
				| "$$NumberIT8003006$$" |
			And I click the button named "FormUndoPosting"
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then in the TestClient message log contains lines by template:
				|'* have negative stock balance'|
				|'Store [Store 06] [Bag ODS] Lacking: 4 pcs.'|									
		And I close all client application windows

Scenario:_8003010 try unpost PI that make a plus on the store
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 05" string
		* Main attributes
			And I select from the drop-down list named "Partner" by "Ferron BP" string
			And I select from the drop-down list named "LegalName" by "Company Ferron BP" string
			And I select from "Partner term" drop-down list by "Vendor Ferron, TRY" string
			And I select from the drop-down list named "Store" by "store 05" string			
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
			And I click "Post" button
			And I delete "$$NumberPurchaseInvoice8003010$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice8003010$$"
			Then user message window does not contain messages
		* Try unpost PI
			And I click the button named "FormUndoPosting"	
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 0 . Lacking: 5 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 0 . Lacking: 8 .'|
		And I close all client application windows

Scenario:_8003011 try unpost RetailReturnReceipt that make a plus on the store
	And I close all client application windows
	* Preparation
		* Remove control (store 05)
			When Remove stock control for store 05
		* Unpost PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"		
			If "List" table contains lines Then
				| "Number"                           |
				| "$$NumberPurchaseInvoice8003010$$" |
				Then I go to line in "List" table
					| "Number"                           |
					| "$$NumberPurchaseInvoice8003010$$" |
				And I click the button named "FormUndoPosting"	
		* Add control for store 05
			When Set stock control for store 05
	* Create RetailReturnReceipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 05" string
		* Payments
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I select "cas" from "Payment type" drop-down list by string in "Payments" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "210,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table	
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I input "10,00" text in "Landed cost" field of "ItemList" table	
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
			And I input "10,00" text in "Landed cost" field of "ItemList" table	
			And I click "Post" button
			And Delay 1
			And I delete "$$NumberRRR8003011$$" variable
			And I save the value of "Number" field as "$$NumberRRR8003011$$"
			Then user message window does not contain messages
		* Try unpost RRR
			And I click the button named "FormUndoPosting"	
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 0 . Lacking: 5 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 0 . Lacking: 8 .'|
		And I close all client application windows	
									

Scenario:_8003012 try unpost SalesReturn that make a plus on the store
	And I close all client application windows
	* Preparation
		* Remove control (store 05)
			When Remove stock control for store 05
		* Unpost RRR
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"		
			If "List" table contains lines Then
				| "Number"               |
				| "$$NumberRRR8003011$$" |
				Then I go to line in "List" table
					| "Number"               |
					| "$$NumberRRR8003011$$" |
				And I click the button named "FormUndoPosting"	
		* Add control for store 05
			When Set stock control for store 05
	* Create SalesReturn
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click "Create" button
		And I select from the drop-down list named "Store" by "Store 05" string
		* Main attributes
			And I select from the drop-down list named "Partner" by "Ferron BP" string
			And I select from the drop-down list named "LegalName" by "Company Ferron BP" string
			And I select from "Partner term" drop-down list by "Basic Partner terms, TRY" string
			And I select from the drop-down list named "Store" by "store 05" string		
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I input "10,00" text in "Landed cost" field of "ItemList" table	
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
			And I input "10,00" text in "Landed cost" field of "ItemList" table	
			And I click "Post" button
			And Delay 1
			And I delete "$$NumberSR8003012$$" variable
			And I save the value of the field named "Number" as "$$NumberSR8003012$$"
			Then user message window does not contain messages
		* Try unpost RSR
			And I click the button named "FormUndoPosting"	
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 0 . Lacking: 5 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 0 . Lacking: 8 .'|
		And I close all client application windows	

Scenario:_8003013 try unpost StockAdjustmentAsSurplus that make a plus on the store
	And I close all client application windows
	* Preparation
		* Remove control (store 05)
			When Remove stock control for store 05
		* Unpost RRR
			Given I open hyperlink "e1cib/list/Document.SalesReturn"		
			If "List" table contains lines Then
				| "Number"               |
				| "$$NumberSR8003012$$" |
				Then I go to line in "List" table
					| "Number"               |
					| "$$NumberSR8003012$$" |
				And I click the button named "FormUndoPosting"	
		* Add control for store 05
			When Set stock control for store 05
	* Create StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click "Create" button
		* Main attributes
			And I select from the drop-down list named "Company" by "Main Company" string
			And I select from the drop-down list named "Store" by "store 05" string			
		And in the table "ItemList" I click the button named "ItemListAdd"
		* Add first item
			And I select current line in "ItemList" table
			And I select "bag" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I select "Logistics department" from "Profit loss center" drop-down list by string in "ItemList" table
			And I activate "Revenue type" field in "ItemList" table
			And I select "Revenue" from "Revenue type" drop-down list by string in "ItemList" table			
			And I finish line editing in "ItemList" table
		* Add second item with SLN
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table			
			And in the table "SerialLotNumbers" I click "Add" button
			And I select "9009098" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I select "9009099" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I select "Logistics department" from "Profit loss center" drop-down list by string in "ItemList" table
			And I activate "Revenue type" field in "ItemList" table
			And I select "Revenue" from "Revenue type" drop-down list by string in "ItemList" table		
			And I finish line editing in "ItemList" table
			And I click "Post" button
			And Delay 1
			And I delete "$$NumberSAS8003013$$" variable
			And I save the value of the field named "Number" as "$$NumberSAS8003013$$"
			Then user message window does not contain messages
		* Try unpost SAS
			And I click the button named "FormUndoPosting"	
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 0 . Lacking: 5 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 0 . Lacking: 8 .'|
		And I close all client application windows	


Scenario:_8003014 try unpost OpeningEntry that make a plus on the store
	And I close all client application windows
	* Preparation
		* Remove control (store 05)
			When Remove stock control for store 05
		* Unpost RRR
			Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"		
			If "List" table contains lines Then
				| "Number"               |
				| "$$NumberSAS8003013$$" |
				Then I go to line in "List" table
					| "Number"               |
					| "$$NumberSAS8003013$$" |
				And I click the button named "FormUndoPosting"	
		* Add control for store 05
			When Set stock control for store 05
	* Create OpeningEntry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click "Create" button
		* Main attributes
			And I select from the drop-down list named "Company" by "Main Company" string
			And I move to "Inventory" tab
			And in the table "Inventory" I click "Add" button
		* Add first item
			And I select current line in "Inventory" table
			And I select "bag" from "Item" drop-down list by string in "Inventory" table
			And I activate field named "InventoryItemKey" in "Inventory" table
			And I select "ods" by string from the drop-down list named "InventoryItemKey" in "Inventory" table
			And I activate field named "InventoryQuantity" in "Inventory" table
			And I input "5,000" text in the field named "InventoryQuantity" of "Inventory" table
			And I input "10,00" text in the field named "InventoryPrice" of "Inventory" table		
			And I select "Store 05" from "Store" drop-down list by string in "Inventory" table		
			And I finish line editing in "Inventory" table
		* Add second item with SLN
			And in the table "Inventory" I click the button named "InventoryAdd"
			And I select current line in "Inventory" table
			And I select "Product 7 with SLN (new row)" from "Item" drop-down list by string in "Inventory" table
			And I activate field named "InventoryItemKey" in "Inventory" table
			And I select "pzu" by string from the drop-down list named "InventoryItemKey" in "Inventory" table
			And I select "Store 05" from "Store" drop-down list by string in "Inventory" table	
			And I input "9009098" text in the field named "InventorySerialLotNumber" of "Inventory" table
			And I input "10,00" text in the field named "InventoryPrice" of "Inventory" table
			And I input "8,000" text in the field named "InventoryQuantity" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I click "Post" button
			And I delete "$$NumberOE8003014$$" variable
			And I save the value of the field named "Number" as "$$NumberOE8003014$$"
			Then user message window does not contain messages
		* Try unpost OE
			And I click the button named "FormUndoPosting"	
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Line No. [1] [Bag ODS] R4050 Stock inventory remaining: 5 . Required: 0 . Lacking: 5 .'|
				|'Line No. [2] [Product 7 with SLN (new row) PZU] R4050 Stock inventory remaining: 8 . Required: 0 . Lacking: 8 .'|
		And I close all client application windows		