#language: en
@tree
@LandedCost

Feature: Landed cost

Variables:
import "Variables.feature"

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _001 test data
	When set True value to the constant
	* Checking the availability of catalogs and batches registers
		Given I open hyperlink "e1cib/list/Catalog.BatchKeys"
		Given I open hyperlink "e1cib/list/Catalog.Batches"
		Given I open hyperlink "e1cib/list/InformationRegister.T6020S_BatchKeysInfo"
		Given I open hyperlink "e1cib/list/InformationRegister.T6010S_BatchesInfo"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6010B_BatchWiseBalance"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6040T_BatchShortageIncoming"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6030T_BatchShortageOutgoing"
		And I close all client application windows
	* Load data
		When Create catalog AddAttributeAndPropertySets objects (LC)
		When Create catalog CancelReturnReasons objects (LC)
		When Create catalog AddAttributeAndPropertyValues objects (LC)
		When Create catalog IDInfoAddresses objects (LC)
		When Create catalog BusinessUnits objects (LC)
		When Create catalog Companies objects (LC)
		When Create catalog ConfigurationMetadata objects (LC)
		When Create catalog Countries objects (LC)
		When Create catalog Currencies objects (LC)
		When Create catalog ExpenseAndRevenueTypes objects (LC)
		When Create catalog IntegrationSettings objects (LC)
		When Create catalog ItemKeys objects (LC)
		When Create catalog ItemSegments objects (LC)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ReportOptions objects
		When Create catalog SerialLotNumbers objects (LC)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog ItemTypes objects (LC)
		When Create catalog Units objects (LC)
		When Create catalog Items objects (LC)
		When Create catalog CurrencyMovementSets objects (LC)
		When Create catalog ObjectStatuses objects (LC)
		When Create catalog PartnerSegments objects (LC)
		When Create catalog Agreements objects (LC)
		When Create catalog Partners objects (LC)
		When Create catalog ExternalDataProc objects (LC)
		When Create catalog PriceKeys objects (LC)
		When Create catalog PriceTypes objects (LC)
		When Create catalog Specifications objects (LC)
		When Create catalog Stores objects (LC)
		When Create catalog TaxRates objects (LC)
		When Create catalog Taxes objects (LC)
		When Create catalog InterfaceGroups objects (LC)
		When Create information register Barcodes records
		When Create catalog AccessGroups objects (LC)
		When Create catalog AccessProfiles objects (LC)
		When Create catalog UserGroups objects (LC)
		When Create catalog Users objects (LC)
		When Create document PriceList objects (LC)
		When Create chart of characteristic types AddAttributeAndProperty objects (LC)
		When Create chart of characteristic types CustomUserSettings objects (LC)
		When Create chart of characteristic types CurrencyMovementType objects (LC)
		When Create information register Taxes records (LC)
		When Create information register CurrencyRates records (LC)
		When Create information register Barcodes records (LC)
		When Create information register PricesByItemKeys records (LC)
		When Create information register PricesByItems records (LC)
		When Create information register PricesByProperties records (LC)
		When Create information register TaxSettings records (LC)
		When Create information register UserSettings records (LC)
		When create items for work order (LC)
		When Create catalog BillOfMaterials objects (LC)
		And Delay 5
	* Landed cost currency movement type for company
		
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Deferred calculation'   | 'Description'      | 'Source'         | 'Type'     |
			| 'TRY'        | 'No'                     | 'Local currency'   | 'Forex Seling'   | 'Legal'    |
		And I select current line in "List" table
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
		And I click "Save and close" button
		And I wait "Main Company (Company) *" window closing in 20 seconds
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Deferred calculation'   | 'Description'      | 'Source'         | 'Type'     |
			| 'TRY'        | 'No'                     | 'Local currency'   | 'Forex Seling'   | 'Legal'    |
		And I select current line in "List" table
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
		And I click "Save and close" button
		And I wait "Second Company (Company) *" window closing in 20 seconds
	* Load documents
		When Create catalog RowIDs objects (LC)
		And Delay 10
		When Create document Bundling objects (LC)
		When Create document SO-WO-WS-SI (LC)
		When Create document GoodsReceipt objects (LC)
		When Create document InventoryTransfer objects (LC)
		When Create document OpeningEntry objects (LC)
		When Create document PriceList objects (LC)
		When Create document PurchaseInvoice objects (LC)
		When Create document PurchaseOrder objects (LC)
		When Create document PurchaseReturn objects (LC)
		When Create document PurchaseReturnOrder objects (LC)
		When Create document SalesInvoice objects (LC)
		When Create document SalesReturn objects (LC)
		When Create document SalesReturnOrder objects (LC)
		When Create document ShipmentConfirmation objects (LC)
		When Create document StockAdjustmentAsSurplus objects (LC)
		When Create document StockAdjustmentAsWriteOff objects (LC)
		When Create document Unbundling objects (LC)
		When Create document RetailSalesReceipt objects (LC)
		When Create document RetailReturnReceipt objects (LC)
		When Create document ItemStockAdjustment objects (LC)
		When Create document PurchaseInvoice objects (for materials LC)
	* Posting Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		Then "Purchase orders" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "10"
	* Posting Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		Then "Purchase invoices" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "10"
	* Posting Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		Then "Sales invoices" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "10"
	* Posting Price list
		Given I open hyperlink "e1cib/list/Document.PriceList"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "10"
	* Posting Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		Then "Sales return orders" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "10"
		And I close all client application windows
	* Posting Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		Then "Sales returns" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		Then "Purchase return orders" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
		And I close all client application windows
	* Posting Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		Then "Purchase returns" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		Then "Goods receipts" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "10"
	* Posting Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		Then "Shipment confirmations" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "10"
	* Posting Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		Then "Stock adjustments as surplus" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		Then "Stock adjustments as write-off" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		Then "Bundling list" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		Then "Unbundling list" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		Then "Opening entries" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		Then "Inventory transfers" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		Then "Retail sales receipts" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		Then "Retail return receipts" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		Then "Work orders" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		Then "Work sheets" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting AdditionalCostAllocation
		Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
		Then "Additional cost allocations" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	And I close all client application windows
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window

Scenario: _0011 check preparation
	When check preparation

Scenario: _002 creating Calculation movement costs
	Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
	* Calculation movement costs for Main company (01/08-15/08)
		Then "Calculations movement costs" window is opened
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I input "01.08.2021" text in "Begin date" field
		And I input "17.08.2021" text in "End date" field
		And I input "01.08.2021 01:00:00" text in "Date" field
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list		
		And I click "Post and close" button
		And Delay 10
	* Calculation movement costs for Second company
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I input "01.08.2021" text in "Begin date" field
		And I input "20.08.2021" text in "End date" field
		And I input "01.08.2021 01:00:02" text in "Date" field
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list	
		And I click "Post and close" button
		And Delay 10
	* Сhecking creation Batches and Batches keys
		Given I open hyperlink "e1cib/list/Catalog.Batches"
		And "List" table contains "Batches" template lines by template
		Given I open hyperlink "e1cib/list/Catalog.BatchKeys"
		And "List" table contains "BatchKeys" template lines by template
	* Сhecking movements (BatchWiseBalance, BatchShortageIncoming and BatchShortageOutgoing)
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6010B_BatchWiseBalance"
		And "List" table contains "BatchWiseBalance" template lines by template
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6040T_BatchShortageIncoming"
		And "List" table contains "BatchShortageIncoming" template lines by template
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6030T_BatchShortageOutgoing"
		And "List" table contains "BatchShortageOutgoing" template lines by template
	And I close all client application windows
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window
	

Scenario: _003 creating Purchase invoice and checking close Batch wise over balance
	* Creating Purchase invoice for Store 10
		* Filling main infotmation
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I remove checkbox named "FilterCompanyUse"
			And I go to line in "List" table
				| 'Description'                  |
				| 'DFC Vendor by agreements'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Second Company'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 10'        |
			And I select current line in "List" table
			Then the form attribute named "Store" became equal to "Store 10"
		* Filling item list		
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'High shoes'      |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item'          | 'Item key'     |
				| 'High shoes'    | '39/19SD'      |
			And I select current line in "List" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I input "50,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Posting Purchase invoice 9 009
			And I move to "Other" tab
			And I input "9 009" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "9 009" text in "Number" field
			And I input "01.08.2021 08:00:00" text in "Date" field
			And I move to the next attribute
			Then "Update item list info" window is opened
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'End date'     | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '20.08.2021'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Checking close Batch wise over balance (High shoes, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '39/19SD'     |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_003_2" template lines by template
		And I close all client application windows
	And I close all client application windows

Scenario: _004 creating Sales invoice by last date and checking the mechanism for aligning the sequence of batches
	* Creating Sales invoice from Store 02
		* Filling main infotmation
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I select from "Partner" drop-down list by "Ka" string
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Company Kalipso'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Boots'    | 'Boots/S-8'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "600,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Other" tab
			And I input "13.08.2021 16:53:01" text in "Date" field
			#And I move to the next attribute
			#Then "Update item list info" window is opened
			#And I click "OK" button
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "9 100" text in "Number" field
			And I click "Post and close" button
	* Checking that the invoice is displayed as not relevance in the register BatchRelevance 
		Given I open hyperlink "e1cib/list/InformationRegister.T6030S_BatchRelevance"
		And "List" table contains lines
			| 'Date'                  | 'Company'        | 'Store'      | 'Item key'    | 'Document'                                         |
			| '13.08.2021 16:53:01'   | 'Main Company'   | 'Store 02'   | 'Boots/S-8'   | 'Sales invoice 9 100 dated 13.08.2021 16:53:01'    |
	* Сhecking that the report shows unclosed batches by the created invoice (Boots/S-8, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_004_1" template lines by template
	* Repeated posting document CalculationMovementCosts №1
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking that the report shows unclosed batches by the created invoice (Boots/S-8, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_004_2" template lines by template
		And I close all client application windows

Scenario: _005 add Purchase invoice and checking the mechanism for aligning the sequence of batches
	* Creating Purchase invoice from Store 02 by last date
		* Filling main infotmation
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'     |
				| 'DFC'             |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'DFC Vendor by agreements'     |
			And I select current line in "List" table
			Then the form attribute named "Store" became equal to "Store 02"
		* Filling item list
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item'     | 'Item key'      |
				| 'Boots'    | 'Boots/S-8'     |
			And I select current line in "List" table
			And I input "500,000" text in "Quantity" field of "ItemList" table
			And I input "50,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Posting Purchase invoice 9 009
			And I move to "Other" tab
			And I input "9 010" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "9 010" text in "Number" field
			And I input "13.08.2021 16:49:00" text in "Date" field
			And I move to the next attribute
			Then "Update item list info" window is opened
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click "Post and close" button
	* Сhecking that the report shows unclosed batches by the created invoice (Boots/S-8, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_005_1" template lines by template
	* Repeated posting document CalculationMovementCosts №1
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking that the report shows closed batches by the created invoice (Boots/S-8, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_005_2" template lines by template
		And I close all client application windows
	* Changing Store and Company on Second company
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 010'     |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 04'       |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second company'    |
		And I select current line in "List" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_005_3" template lines by template
		And I close all client application windows
	* Changing item key and changing Store and Company back 
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 010'     |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main company'    |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '39/18SD'     |
		And I select current line in "List" table
		And I input "50,00" text in "Price" field of "ItemList" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '39/18SD'     |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_005_4" template lines by template
		And I close all client application windows
	* Clear posting and changing item key back
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 010'     |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I input "50,00" text in "Price" field of "ItemList" table
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number'   | 'Partner'    |
			| '9 010'    | 'DFC'        |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_005_5" template lines by template
		And I close all client application windows
	* Posting back
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 010'     |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_005_2" template lines by template
		And I close all client application windows



Scenario: _006 changing Sales invoice and checking the mechanism for aligning the sequence of batches
	* Changing Quantity in the Sales invoice 9100 from Store 02
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 100'     |
		And I activate "Date" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "400,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Checking that the invoice is displayed as not relevance in the register BatchRelevance 
		Given I open hyperlink "e1cib/list/InformationRegister.T6030S_BatchRelevance"
		And "List" table contains lines
			| 'Date'                  | 'Company'        | 'Store'      | 'Is relevance'   | 'Item key'    | 'Document'                                         |
			| '13.08.2021 16:53:01'   | 'Main Company'   | 'Store 02'   | 'No'             | 'Boots/S-8'   | 'Sales invoice 9 100 dated 13.08.2021 16:53:01'    |
	* Сhecking that the report shows unclosed batches by the created invoice (Boots/S-8, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_1" template lines by template
	* Repeated posting document CalculationMovementCosts №1
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking that the report shows unclosed batches by the created invoice (Boots/S-8, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_2" template lines by template
		And I close all client application windows
	* Changing Date (19/08) in the Sales invoice 9100 from Store 02
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 100'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input "19.08.2021 12:00:00" text in "Date" field
		And I move to the next attribute
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Calculation movement costs for Main company (19/08-20/08)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		Then "Calculations movement costs" window is opened
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I input "18.08.2021" text in "Begin date" field
		And I input "20.08.2021" text in "End date" field
		And I input "18.08.2021 11:56:51" text in "Date" field
		And I input "3" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "3" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list	
		And I click "Post and close" button
	* Сhecking the report (Boots/S-8, Store 02)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_3" template lines by template
	* Changing Store and Company on Second company
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 100'     |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 04'       |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second company'    |
		And I select current line in "List" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_4" template lines by template
		And I close all client application windows
	* Changing item key and changing Store and Company back
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 100'     |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main company'    |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    | 'Unit'    |
			| 'Boots'   | 'Boots/S-8'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '39/18SD'     |
		And I select current line in "List" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Boots (12 pcs)'    |
		And I select current line in "List" table		
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_5" template lines by template
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '39/18SD'     |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_51" template lines by template
		And I close all client application windows
	* Clear posting and changing item key back
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 100'     |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '39/18SD'     |
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number'   | 'Partner'    |
			| '9 100'    | 'Kalipso'    |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_6" template lines by template
		And I close all client application windows
	* Posting back
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '9 100'     |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Repeated posting document CalculationMovementCosts №1 and checking report
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'         |
			| '01.08.2021'   | 'Main Company'    |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'     |
			| 'Boots'   | 'Boots/S-8'    |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_006_7" template lines by template
		And I close all client application windows


Scenario: _007 changing Inventory transfer and checking the mechanism for aligning the sequence of batches
	* Сhecking calculation movements post by Inventory transfers (Shirt 36/Red)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_1" template lines by template
	* Changing Quantity in the Inventory transfer 1 dated 05.08.2021 12:00:00	
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Date'                  | 'Number'    |
			| '05.08.2021 12:00:00'   | '1'         |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Shirt'   | '36/Red'     | '21,000'     | 'pcs'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "48,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Checking that the batch calculation is no longer relevant
		Given I open hyperlink "e1cib/list/InformationRegister.T6030S_BatchRelevance"
		And "List" table contains lines
			| 'Date'                  | 'Company'        | 'Store'      | 'Is relevance'   | 'Item key'   | 'Document'                                          |
			| '05.08.2021 12:00:00'   | 'Main Company'   | 'Store 02'   | 'No'             | '36/Red'     | 'Inventory transfer 1 dated 05.08.2021 12:00:00'    |
			| '05.08.2021 12:00:00'   | 'Main Company'   | 'Store 03'   | 'No'             | '36/Red'     | 'Inventory transfer 1 dated 05.08.2021 12:00:00'    |
	* Repeated posting document CalculationMovementCosts №1 and creating CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Shirt/36/Red)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_2" template lines by template
	* Changing Store Sender on Store 05 (no balance)
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Date'                  | 'Number'    |
			| '05.08.2021 12:00:00'   | '1'         |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 05'       |
		And I select current line in "List" table
		And I click "Post and close" button
	* Checking that the batch calculation is no longer relevant
		Given I open hyperlink "e1cib/list/InformationRegister.T6030S_BatchRelevance"
		And "List" table contains lines
			| 'Date'                  | 'Company'        | 'Document'                                         | 'Item key'   | 'Is relevance'    |
			| '05.08.2021 12:00:00'   | 'Main Company'   | 'Inventory transfer 1 dated 05.08.2021 12:00:00'   | '36/Red'     | 'No'              |
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Shirt/36/Red)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_3" template lines by template
	* Changing Store Sender on Store 01 and changing date
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Date'                  | 'Number'    |
			| '05.08.2021 12:00:00'   | '1'         |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input "18.08.2021  03:01:34" text in "Date" field
		And I click "Post and close" button 
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Shirt/36/Red)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_4" template lines by template
	* Changing Store Receiver on Store 06 and company on Second company
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second company'    |
		And I select current line in "List" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №3 and Сhecking the report (Shirt/36/Red)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'End date'      |
			| '01.08.2021'   | 'Second Company'   | '20.08.2021'    |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_6" template lines by template
	* Changing item key and changing Store Receiver and Company back
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main company'    |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I activate "Item key" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №3 and Сhecking the report (Shirt/38/Black)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'End date'      |
			| '01.08.2021'   | 'Second Company'   | '20.08.2021'    |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_7" template lines by template
	* Clear posting
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main company'    |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'     |
			| 'Shirt'    |
		And I activate "Item key" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Repeated posting document CalculationMovementCosts №3 and Сhecking the report (Shirt/36/Red)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_8" template lines by template
	* Posting back
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Repeated posting document CalculationMovementCosts №3 and Сhecking the report (Shirt/36/Red)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_007_5" template lines by template
		And I close all client application windows




Scenario: _008 creating Sales return on a wholly sold batches and checking the mechanism for aligning the sequence of batches
	* Creating Sales return for Sales invoice 461 (Trousers 38/Yellow)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'   | 'Partner'      |
			| '4'        | 'Ferron BP'    |
		And I click the button named "FormDocumentSalesReturnGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Uncheck all" button
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'   | 'Quantity'   | 'Row presentation'       | 'Unit'   | 'Use'    |
			| 'USD'        | '80,00'   | '7,000'      | 'Trousers (38/Yellow)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I input "16.08.2021 11:13:00" text in "Date" field
		And I move to the next attribute
		If window with "Update item list info" header has appeared Then
			And I change checkbox "Do you want to replace filled price types with price type Price USD?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "10" text in "Number" field
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Trousers 38/Yellow)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table		
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_008_1" template lines by template
	* Changing date (Sales return 10 -18/08)
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
		And I activate "Date" field in "List" table
		And I select current line in "List" table
		And I move to "Other" tab
		And I input "18.08.2021 21:05:01" text in "Date" field
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Trousers 38/Yellow)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table	
		And I click "Generate" button
	* Clear posting Sales return №10 and checking the sequence of batches
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Trousers 38/Yellow)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_008_3" template lines by template
	* Posting Sales return №10 and checking the sequence of batches
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Trousers 38/Yellow)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem2Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_008_4" template lines by template
	

Scenario: _009 creating Purchase return and checking the mechanism for aligning the sequence of batches
	* Сhecking the report (37/18SD)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '37/18SD'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_009_1" template lines by template
	* Changing date (Purchase return 15 -18/08)
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I activate "Date" field in "List" table
		And I select current line in "List" table
		And I move to "Other" tab
		And I input "18.08.2021 21:05:01" text in "Date" field
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (37/18SD)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '37/18SD'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_009_2" template lines by template
	* Clear posting Purchase return №15 and checking the sequence of batches
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report ((37/18SD)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '37/18SD'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_009_3" template lines by template
	* Posting Purchase return №15 and checking the sequence of batches
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Repeated posting document CalculationMovementCosts №1 and CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (37/18SD)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '37/18SD'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_009_4" template lines by template
	


Scenario: _010 change Stock adjustment as surplus, Stock adjustment as write-off, Opening entry and checking the mechanism for aligning the sequence of batches
	#  Store 05 Dress XS/Blue
	* Changing quantity (Stock adjustment as write-off 2 - 6pcs) 
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Company'        | 'Number'   | 'Store'       |
			| 'Main Company'   | '2'        | 'Store 03'    |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | 'XS/Blue'    | '5,000'      | 'pcs'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "6,000" text in "Quantity" field of "ItemList" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Dress XS/Blue)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_010_2" template lines by template
	* Changing company (Stock adjustment as surplus 2) 
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Company'        | 'Number'   | 'Store'       |
			| 'Main Company'   | '3'        | 'Store 03'    |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Dress XS/Blue)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_010_3" template lines by template
	* Clear posting Opening entry 1 and checking the sequence of batches
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Dress XS/Blue)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_010_5" template lines by template
	* Posting opening entry №1, Changing company (Stock adjustment as surplus 3)
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Company'          | 'Number'   | 'Store'       |
			| 'Second Company'   | '3'        | 'Store 03'    |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'          | 'Number'    |
			| '01.08.2021'   | 'Second Company'   | '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Dress XS/Blue)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_010_6" template lines by template
		And I close all client application windows
		


Scenario: _011 change Bundling and UnBundling and checking the mechanism for aligning the sequence of batches
	* Creating Bundle (Set)
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Сhewing gum'    |
		And I select current line in "List" table
		And I input "5,000" text in the field named "Quantity"
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Сhewing gum'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'          | 'Item key'      |
			| 'Сhewing gum'   | 'Mint/Mango'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Сhewing gum'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'          | 'Item key'       |
			| 'Сhewing gum'   | 'Mint/Cherry'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "05.08.2021 0:00:00" text in "Date" field
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "11" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "11" text in "Number" field
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem1Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_011_1" template lines by template
	* Creating UnBundle (Set)
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Сhewing gum'    |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| 'Item key'                   |
			| 'Сhewing gum/Сhewing gum'    |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And in the table "ItemList" I click "By bundle content" button
		And "ItemList" table became equal
			| 'Item'          | 'Quantity'   | 'Item key'      | 'Unit'    |
			| 'Сhewing gum'   | '1,000'      | 'Mint/Mango'    | 'pcs'     |
			| 'Сhewing gum'   | '1,000'      | 'Mint/Cherry'   | 'pcs'     |
		And I move to "Other" tab
		And I input "10.08.2021  0:00:00" text in "Date" field
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "15" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "15" text in "Number" field
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem1Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_011_2" template lines by template
	* Creating one more Bundle (Set)
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Сhewing gum'    |
		And I select current line in "List" table
		And I input "10,000" text in the field named "Quantity"
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Сhewing gum'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'          | 'Item key'      |
			| 'Сhewing gum'   | 'Mint/Mango'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Сhewing gum'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'          | 'Item key'       |
			| 'Сhewing gum'   | 'Mint/Cherry'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "11.08.2021  0:00:00" text in "Date" field
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "15" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "15" text in "Number" field
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem1Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_011_3" template lines by template
	* Clear posting (Bundling 11, Unbundling 15)
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem1Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_011_5" template lines by template
	* Posting back (Bundling 11, Unbundling 15)
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
				| 'Number'     |
				| '15'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Repeated posting document CalculationMovementCosts №1, №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '01.08.2021'   | 'Main Company'   | '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'        | 'Number'    |
			| '18.08.2021'   | 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem1Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_011_4" template lines by template
	* Creating Unbandling of purchased Bundle
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'               |
			| 'Skittles + Сhewing gum'    |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| 'Item key'                                         |
			| 'Skittles + Сhewing gum/Skittles + Сhewing gum'    |
		And I select current line in "List" table
		And I input "12,000" text in the field named "Quantity"
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And in the table "ItemList" I click "By specification" button		
		And I go to line in "ItemList" table
			| 'Item'          | 'Item key'      | 'Quantity'   | 'Unit'    |
			| 'Сhewing gum'   | 'Mint/Cherry'   | '1,000'      | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "1,00000" text in "Amount value" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Skittles'   | 'fruit'      | '1,000'      | 'pcs'     |
		And I input "3,00000" text in "Amount value" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "19.08.2021 21:26:29" text in "Date" field
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "20" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "20" text in "Number" field
		And I click "Post and close" button
	* Repeated posting document CalculationMovementCosts №3
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Company'        | 'Number'    |
			| 'Main Company'   | '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem1Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_011_6" template lines by template
	And I close all client application windows




Scenario: _012 checking batches calculation for Retail sales receipt/ Retail return receipt
	And I close all client application windows
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And Delay 10
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item key'    |
			| '39/19SD'     |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_012_1" template lines by template
	* Unpost First Retail sales receipt and check batches calculation
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'         |
			| '01.08.2021'   | 'Main Company'    |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item key'    |
			| '39/19SD'     |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_012_2" template lines by template
	* Change first sales receipt date and check batches calculation
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input "10.08.2021 16:00:00" text in "Date" field
		And I move to the next attribute
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'         |
			| '01.08.2021'   | 'Main Company'    |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item key'    |
			| '39/19SD'     |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_012_4" template lines by template
	* Change quantity in the first Retail sales receipt and Retail return receipt and check batches calculation
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'   | 'Quantity'    |
			| 'High shoes'   | '39/19SD'    | '2,000'       |
		And I input "9,000" text in "Quantity" field of "ItemList" table
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "10 000,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table	
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "800,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table	
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'         |
			| '01.08.2021'   | 'Main Company'    |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'           |
			| '01.08.2021'   | 'Second Company'    |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Сhecking the report (Store 10)
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item key'    |
			| '39/19SD'     |
		And I select current line in "List" table
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_012_5" template lines by template
		And I close all client application windows
	* Check batches calculation for Retail return without base document
		* Create retail sales return
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
			And I click the button named "FormCreate"
			And I select from "Partner" drop-down list by "Retail customer" string
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'                 |
				| 'Retail customer company'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 10'        |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'             |
				| 'Retail partner term'     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'M/Brown'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I input "20,000" text in "Landed cost" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			And I click the button named "FormCreate"
			Then "Payment type (create)" window is opened
			And I input "Cash" text in "ENG" field
			And I select "Cash" exact value from "Type" drop-down list
			And I click "Save and close" button
			And I click the button named "FormChoose"
			And I activate "Amount" field in "Payments" table
			And I input "2 360,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I move to "Other" tab
			And I input "15.08.2021 19:32:00" text in "Date" field
			And I click Select button of "Branch" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Shop 01'         |
			And I select current line in "List" table
			And I move to the next attribute
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "5" text in "Number" field
			And I move to "Item list" tab
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "1 000,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And I remove checkbox "Price includes tax"				
			When in opened panel I select "Retail return receipt (create) *"
			Then "Retail return receipt (create) *" window is opened
			And I move to "Other" tab			
			And I click "Post and close" button
		* Batches calculation
			Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
			And I go to line in "List" table
				| 'Begin date'    | 'Company'          |
				| '01.08.2021'    | 'Main Company'     |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Сhecking the report (Store 10)
			Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
			And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 10'        |
			And I select current line in "List" table
			And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
			And I go to line in "List" table
				| 'Item key'     |
				| 'M/Brown'      |
			And I select current line in "List" table
			And I click "Generate" button
			And "Result" spreadsheet document contains "BathBalance_012_7" template lines by template
			And I close all client application windows
		
Scenario: _023 check Stock adjustment as write off movements by register R5022 Expenses
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	* Select Stock adjustment as write off
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
	* Check movements
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 1 dated 10.08.2021 16:47:25'   | ''                      | ''            | ''                    | ''              | ''               | ''         | ''                     | ''               | ''           | ''           | ''              | ''           | ''                      | ''                               | ''                      | ''                                                          |
			| 'Document registrations records'                              | ''                      | ''            | ''                    | ''              | ''               | ''         | ''                     | ''               | ''           | ''           | ''              | ''           | ''                      | ''                               | ''                      | ''                                                          |
			| 'Register  "R5022 Expenses"'                                  | ''                      | ''            | ''                    | ''              | ''               | ''         | ''                     | ''               | ''           | ''           | ''              | ''           | ''                      | ''                               | ''                      | ''                                                          |
			| ''                                                            | 'Period'                | 'Resources'   | ''                    | ''              | 'Dimensions'     | ''         | ''                     | ''               | ''           | ''           | ''              | ''           | ''                      | ''                               | ''                      | 'Attributes'                                                |
			| ''                                                            | ''                      | 'Amount'      | 'Amount with taxes'   | 'Amount cost'   | 'Company'        | 'Branch'   | 'Profit loss center'   | 'Expense type'   | 'Item key'   | 'Fixed asset'| 'Ledger type'   | 'Currency'   | 'Additional analytic'   | 'Multi currency movement type'   | 'Project'               | 'Calculation movement cost'                                 |
			| ''                                                            | '10.08.2021 16:47:25'   | '17,12'       | '17,29'               | ''              | 'Main Company'   | ''         | 'Front office'         | 'Expense'        | ''           | ''           | ''              | 'USD'        | ''                      | 'Reporting currency'             | ''                      | 'Calculation movement costs 1 dated 01.08.2021 01:00:00'    |
			| ''                                                            | '10.08.2021 16:47:25'   | '100'         | '101'                 | ''              | 'Main Company'   | ''         | 'Front office'         | 'Expense'        | ''           | ''           | ''              | 'TRY'        | ''                      | 'Local currency'                 | ''                      | 'Calculation movement costs 1 dated 01.08.2021 01:00:00'    |
			| ''                                                            | '10.08.2021 16:47:25'   | '100'         | '101'                 | ''              | 'Main Company'   | ''         | 'Front office'         | 'Expense'        | ''           | ''           | ''              | 'TRY'        | ''                      | 'en description is empty'        | ''                      | 'Calculation movement costs 1 dated 01.08.2021 01:00:00'    |
			| ''                                                            | '10.08.2021 16:47:25'   | '171,2'       | '174,62'              | ''              | 'Main Company'   | ''         | 'Front office'         | 'Expense'        | ''           | ''           | ''              | 'USD'        | ''                      | 'Reporting currency'             | ''                      | 'Calculation movement costs 1 dated 01.08.2021 01:00:00'    |
			| ''                                                            | '10.08.2021 16:47:25'   | '1 000'       | '1 020'               | ''              | 'Main Company'   | ''         | 'Front office'         | 'Expense'        | ''           | ''           | ''              | 'TRY'        | ''                      | 'Local currency'                 | ''                      | 'Calculation movement costs 1 dated 01.08.2021 01:00:00'    |
			| ''                                                            | '10.08.2021 16:47:25'   | '1 000'       | '1 020'               | ''              | 'Main Company'   | ''         | 'Front office'         | 'Expense'        | ''           | ''           | ''              | 'TRY'        | ''                      | 'en description is empty'        | ''                      | 'Calculation movement costs 1 dated 01.08.2021 01:00:00'    |
		And I close all client application windows
		
Scenario: _024 check Stock adjustment as surplus movements by register R5021 Revenues		
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	* Select Stock adjustment as surplus
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
	* Check movements
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as surplus 1 dated 01.08.2021 09:42:37'   | ''                      | ''            | ''                    | ''               | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| 'Document registrations records'                            | ''                      | ''            | ''                    | ''               | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| 'Register  "R5021 Revenues"'                                | ''                      | ''            | ''                    | ''               | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| ''                                                          | 'Period'                | 'Resources'   | ''                    | 'Dimensions'     | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| ''                                                          | ''                      | 'Amount'      | 'Amount with taxes'   | 'Company'        | 'Branch'   | 'Profit loss center'   | 'Revenue type'   | 'Item key'   | 'Currency'   | 'Additional analytic'   | 'Multi currency movement type'    | 'Project'               |
			| ''                                                          | '01.08.2021 09:42:37'   | '130,58'      | '154,08'              | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | '39/18SD'    | 'USD'        | ''                      | 'Reporting currency'              | ''                      |
			| ''                                                          | '01.08.2021 09:42:37'   | '762,71'      | '900,00'              | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | '39/18SD'    | 'TRY'        | ''                      | 'Local currency'                  | ''                      |
			| ''                                                          | '01.08.2021 09:42:37'   | '762,71'      | '900,00'              | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | '39/18SD'    | 'TRY'        | ''                      | 'en description is empty'         | ''                      |
		And I close all client application windows
		
						
		
				
Scenario: _027 check calculation movements cost for ItemStockAdjustment
	* Post 	ItemStockAdjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Create Calculation movement cost
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I input "18.09.2022 00:00:00" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Landed cost" exact value from "Calculation mode" drop-down list
		And I input "18.09.2022" text in "Begin date" field
		And I input "18.09.2022" text in "End date" field
		And I click "Post and close" button
		And I wait "Calculation movement costs (create) *" window closing in 20 seconds
	* Check report
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And Delay 10
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem0Use"
		And I remove checkbox named "SettingsComposerUserSettingsItem1Use"	
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_024_1" template lines by template
		And I close all client application windows
	* Clear posting 
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Batches calculation
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'         |
			| '18.09.2022'   | 'Main Company'    |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Check report
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem0Use"
		And I remove checkbox named "SettingsComposerUserSettingsItem0Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_024_2" template lines by template	
	* Post ItemStockAdjustment back	
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
	* Batches calculation
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Begin date'   | 'Company'         |
			| '18.09.2022'   | 'Main Company'    |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Check report
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 10'       |
		And I select current line in "List" table
		And I remove checkbox named "SettingsComposerUserSettingsItem0Use"
		And I remove checkbox named "SettingsComposerUserSettingsItem0Use"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_024_1" template lines by template
		And I close all client application windows		
							

Scenario: _028 check landed cost by materials
	And I close all client application windows
	* Create CalculationMovementCosts
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Landed cost (batch reallocate)" exact value from "Calculation mode" drop-down list
		And I input "22.09.2022" text in "Begin date" field
		And I input "26.09.2022" text in "End date" field
		And I click "Post and close" button
	* Check calculation
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I move to "Standard" tab
		And I click "Load setting" button
		And I click "Generate" button	
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "22.09.2022" text in the field named "DateBegin"
		And I input "22.09.2022" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_025_1" template lines by template
		And I close all client application windows

				
Scenario: _030 check landed cost (double return)
	And I close all client application windows
	* Load documents for double return
		When Data preparation (double return, landed cost)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(9012).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(185).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(186).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseReturn.FindByNumber(16).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check movement cost calculation
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I go to line in "OptionsList" table
			| 'Report option'    |
			| 'Test'             |
		And I click "Load setting" button
		And I click "Generate" button	
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "05.12.2022" text in the field named "DateBegin"
		And I input "07.12.2022" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_070_2" template lines by template
		And I close all client application windows
				
	
Scenario: _032 check landed cost SR and RRR with the same items in different lines
	And I close all client application windows
	* Load documents for double return
		When Data preparation for landed cost SR and RRR with the same items in different lines
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(9013).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(9013).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(9013).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(9013).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(9013).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check movement cost calculation
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I go to line in "OptionsList" table
			| 'Report option'    |
			| 'Test'             |
		And I click "Load setting" button
		And I click "Generate" button	
		And I click Choice button of the field named "SettingsComposerUserSettingsItem2Value"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "18.08.2021" text in the field named "DateBegin"
		And I input "19.08.2021" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click "Generate" button
		And "Result" spreadsheet document contains "BathBalance_073_2" template lines by template
		And I close all client application windows				