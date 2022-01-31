#language: en
@tree
@AdditionalCostAllocation

Feature: Additional cost allocation


Background:
	Given I open new TestClient session or connect the existing one


Scenario: _041 test data
	When set True value to the constant (LC)
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
		When Create catalog SerialLotNumbers objects (LC)
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
		When Create catalog TaxAnalytics objects (LC)
		When Create catalog TaxRates objects (LC)
		When Create catalog Taxes objects (LC)
		When Create catalog InterfaceGroups objects (LC)
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
		And Delay 10
		When update ItemKeys (LC)
	* Add plugin for taxes calculation
			When add Plugin for tax calculation (LC)
		When update tax settings (LC)

	* Landed cost currency movement type for company
		
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "External attributes" tab
		And I click Select button of "Landed cost currency movement type" field
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
			| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Main Company (Company) *" window closing in 20 seconds
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "External attributes" tab
		And I click Select button of "Landed cost currency movement type" field
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'        | 'Reference'          | 'Source'       | 'Type'      |
			| 'USD'      | 'No'                   | 'Reporting currency' | 'Reporting currency' | 'Forex Seling' | 'Reporting' |
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
			| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Second Company (Company) *" window closing in 20 seconds
	* Load documents
		When Create catalog RowIDs objects (LC)
		And Delay 10
		When Create document Bundling objects (LC)
		When Create document GoodsReceipt objects (LC)
		When Create document PurchaseInvoice objects (for AdditionalCostAllocation) (LC)
		When Create document InventoryTransfer objects (LC)
		When Create document OpeningEntry objects (LC)
		When Create document PriceList objects (LC)
		When Create document AdditionalCostAllocation objects (by documents, amount, quantity, weight) (LC)
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
		When Create document StockAdjustmentAsWriteOff objects (LC)
		When Create document Unbundling objects (LC)
		When Create document RetailSalesReceipt objects (LC)
		When Create document AdditionalCostAllocation objects (by rows, amount) (LC)
		When Create document RetailReturnReceipt objects (LC)
		When Create document CalculationMovementCosts objects (LC)
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
		And Delay "5"
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
	* Posting Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Posting Calculation movement costs
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	And I close all client application windows

Scenario: _042 check additional cost allocation (documents, by quantity)
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	And I click "Change option..." button
	And I move to "Fields" tab
	And I move to the tab named "FilterPage"
	And I go to line in "SettingsComposerSettingsFilter" table
		| 'Application'  | 'Comparison type' | 'Display mode' | 'Left value' | 'Use' |
		| 'No hierarchy' | 'Filled'          | 'Disabled'     | 'Recorder'   | 'Yes' |
	And I activate "Comparison type" field in "SettingsComposerSettingsFilter" table
	And I select current line in "SettingsComposerSettingsFilter" table
	And I select "Equal to" exact value from "Comparison type" drop-down list in "SettingsComposerSettingsFilter" table
	And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I click choice button of the attribute named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I go to line in "" table
		| ''                 |
		| 'Purchase invoice' |
	And I select current line in "" table
	And I go to line in "List" table
		| 'Amount'    | 'Company'      | 'Currency' | 'Date'                | 'Legal name'        | 'Number' | 'Partner'   | 'Reference'                                    |
		| '16 560,00' | 'Main Company' | 'TRY'      | '14.08.2021 12:00:00' | 'Company Ferron BP' | '2'      | 'Ferron BP' | 'Purchase invoice 2 dated 14.08.2021 12:00:00' |
	And I activate field named "Date" in "List" table
	And I select current line in "List" table
	And I finish line editing in "SettingsComposerSettingsFilter" table
	And I click "Finish editing" button
	And I click "Run report" button
	And "Result" spreadsheet document contains "BathBalance_042_1" template lines by template
	And I close all client application windows
	
	
Scenario: _043 check additional cost allocation (documents, by amount)
	And I close all client application windows
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	And I click "Change option..." button
	And I move to "Fields" tab
	And I move to the tab named "FilterPage"
	And I go to line in "SettingsComposerSettingsFilter" table
		| 'Application'  | 'Comparison type' | 'Display mode' | 'Left value' | 'Use' |
		| 'No hierarchy' | 'Filled'          | 'Disabled'     | 'Recorder'   | 'Yes' |
	And I activate "Comparison type" field in "SettingsComposerSettingsFilter" table
	And I select current line in "SettingsComposerSettingsFilter" table
	And I select "Equal to" exact value from "Comparison type" drop-down list in "SettingsComposerSettingsFilter" table
	And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I click choice button of the attribute named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I go to line in "" table
		| ''                 |
		| 'Purchase invoice' |
	And I select current line in "" table
	And I go to line in "List" table
		| 'Amount'     | 'Company'      | 'Currency' | 'Date'                | 'Legal name' | 'Number' | 'Partner' | 'Reference'                                    |
		| '104 241,20' | 'Main Company' | 'TRY'      | '13.08.2021 16:52:30' | 'DFC'        | '3'      | 'DFC'     | 'Purchase invoice 3 dated 13.08.2021 16:52:30' |
	And I activate field named "Date" in "List" table
	And I select current line in "List" table
	And I finish line editing in "SettingsComposerSettingsFilter" table
	And I click "Finish editing" button
	And I click "Run report" button
	And "Result" spreadsheet document contains "BathBalance_043_1" template lines by template
	And I close all client application windows

Scenario: _044 check additional cost allocation (documents, by weight)
	And I close all client application windows
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	And I click "Change option..." button
	And I move to "Fields" tab
	And I move to the tab named "FilterPage"
	And I go to line in "SettingsComposerSettingsFilter" table
		| 'Application'  | 'Comparison type' | 'Display mode' | 'Left value' | 'Use' |
		| 'No hierarchy' | 'Filled'          | 'Disabled'     | 'Recorder'   | 'Yes' |
	And I activate "Comparison type" field in "SettingsComposerSettingsFilter" table
	And I select current line in "SettingsComposerSettingsFilter" table
	And I select "Equal to" exact value from "Comparison type" drop-down list in "SettingsComposerSettingsFilter" table
	And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I click choice button of the attribute named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I go to line in "" table
		| ''                 |
		| 'Purchase invoice' |
	And I select current line in "" table
	And I go to line in "List" table
		| 'Number' |
		| '4'      |
	And I activate field named "Date" in "List" table
	And I select current line in "List" table
	And I finish line editing in "SettingsComposerSettingsFilter" table
	And I click "Finish editing" button
	And I click "Run report" button
	And "Result" spreadsheet document contains "BathBalance_044_1" template lines by template
	And I close all client application windows	
		
Scenario: _045 check additional cost allocation (rows, by amount)
	And I close all client application windows
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	And I click "Change option..." button
	And I move to "Fields" tab
	And I move to the tab named "FilterPage"
	And I go to line in "SettingsComposerSettingsFilter" table
		| 'Application'  | 'Comparison type' | 'Display mode' | 'Left value' | 'Use' |
		| 'No hierarchy' | 'Filled'          | 'Disabled'     | 'Recorder'   | 'Yes' |
	And I activate "Comparison type" field in "SettingsComposerSettingsFilter" table
	And I select current line in "SettingsComposerSettingsFilter" table
	And I select "In list" exact value from "Comparison type" drop-down list in "SettingsComposerSettingsFilter" table
	And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I click choice button of the attribute named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
	And I click the button named "Add"
	And I click choice button of the attribute named "Value" in "ValueList" table
	And I go to line in "" table
		| ''                 |
		| 'Purchase invoice' |
	And I select current line in "" table
	And I go to line in "List" table
		| 'Amount'    | 'Company'      | 'Currency' | 'Date'                | 'Legal name'        | 'Number' | 'Partner'   | 'Reference'                                    |
		| '19 700,00' | 'Main Company' | 'USD'      | '15.08.2021 16:56:10' | 'Company Ferron BP' | '5'      | 'Ferron BP' | 'Purchase invoice 5 dated 15.08.2021 16:56:10' |
	And I select current line in "List" table
	And I finish line editing in "ValueList" table
	And I click the button named "Add"
	And I click choice button of the attribute named "Value" in "ValueList" table
	And I go to line in "" table
		| ''                 |
		| 'Purchase invoice' |
	And I select current line in "" table
	And I go to line in "List" table
		| 'Amount'     | 'Company'      | 'Currency' | 'Date'                | 'Legal name' | 'Number' | 'Partner' | 'Reference'                                    |
		| '839 233,70' | 'Main Company' | 'TRY'      | '15.08.2021 16:56:11' | 'DFC'        | '6'      | 'DFC'     | 'Purchase invoice 6 dated 15.08.2021 16:56:11' |
	And I select current line in "List" table
	And I finish line editing in "ValueList" table
	And I click the button named "OK"
	And I finish line editing in "SettingsComposerSettingsFilter" table
	And I click "Finish editing" button
	And I click "Run report" button
	And "Result" spreadsheet document contains "BathBalance_045_1" template lines by template
	And I close all client application windows	