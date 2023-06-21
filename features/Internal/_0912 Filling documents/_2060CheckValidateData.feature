#language: en
@tree
@Positive
@FillingDocuments

Feature: check the validate of data in documents

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _0206000 preparation (checks data)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog PaymentTypes objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create catalog Taxes objects (for work order)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog PlanningPeriods objects
		When create items for work order
		When Create catalog BillOfMaterials objects
		When update ItemKeys
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create catalog PartnerItems objects
		When Create information register Taxes records (VAT)
	* Add plugin for discount
		When Create Document discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	* Tax settings
		When filling in Tax settings for company
		When Create catalog CancelReturnReasons objects
		When Create catalog Users objects
		When Create document RetailSalesReceipt objects (wrong data)
		When Create document GoodsReceipt objects (wrong data)
		When Create document InventoryTransfer (wrong data)
		When Create document InventoryTransferOrder objects (wrong data)
		When Create document InternalSupplyRequest objects (wrong data)
		When Create document SalesOrder objects (wrong data)
		And I close all client application windows

Scenario: _0260601 check preparation
	When check preparation	

Scenario: _0206002 сheck data verification in Retail sales receipt
	And I close all client application windows
	* Open report
		Given I open hyperlink "e1cib/app/Report.AdditionalDocumentTablesCheck"
		And I click "Change option..." button
		And I move to the tab named "FilterPage"
		And I go to line in "SettingsComposerSettingsFilterFilterAvailableFields" table
			| 'Available fields'    |
			| 'Document type'       |
		And I select current line in "SettingsComposerSettingsFilterFilterAvailableFields" table
		And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I select current line in "SettingsComposerSettingsFilter" table
		And I select "Retail sales receipt" exact value from the drop-down list named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I finish line editing in "SettingsComposerSettingsFilter" table
		And I click "Finish editing" button
		And I click "Generate" button
	* Check report
		Then "Result" spreadsheet document is equal
			| 'Data parameters:'                                       | 'Error list: '                                                                                                                                                                                                                                                                                                                                                                                                                                         |
			| 'Filter:'                                                | 'Reference.Posted Equal to "Yes" AND\nStatus Filled AND\nDocument type Equal to "Retail sales receipt"'                                                                                                                                                                                                                                                                                                                                                |
			| ''                                                       | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
			| 'Document type'                                          | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
			| 'Reference'                                              | 'Status'                                                                                                                                                                                                                                                                                                                                                                                                                                               |
			| 'Retail sales receipt'                                   | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
			| 'Retail sales receipt 8 811 dated 07.03.2023 16:47:01'   | 'Row: 1. Total amount minus net amount is not equal to tax amount\nRow: 1. Offers amount in item list is not equal to offers amount in offers list\nRow: 1. Not filled quantity in source of origins\nRow: 2. Tax amount in item list is not equal to tax amount in tax list\nRow: 2. Total amount minus net amount is not equal to tax amount\nRow: 2. Not filled quantity in source of origins\nRow: 3. Not filled quantity in source of origins'    |
		And I close all client application windows

Scenario: _0206003 сheck data verification in Goods receipt
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button	
	* Check report
		Then "Fix document problems" window is opened
		And I expand a line in "CheckList" table
			| 'Date'                  | 'Fixed'   | 'Line number'   | 'Ref'                                              |
			| '10.03.2023 15:43:56'   | 'No'      | '1'             | 'Goods receipt 8 811 dated 10.03.2023 15:43:56'    |
		And I go to line in "CheckList" table
			| 'Date'                  | 'Error ID'                                  | 'Fixed'   | 'Line number'   | 'Ref'                                              |
			| '10.03.2023 15:43:56'   | 'ErrorQuantityNotEqualQuantityInBaseUnit'   | 'No'      | '1'             | 'Goods receipt 8 811 dated 10.03.2023 15:43:56'    |
		And I activate "Error ID" field in "CheckList" table	
	And I close all client application windows	

Scenario: _0206004 сheck data verification in Inventory transfer
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		Then "Fix document problems" window is opened
		And I expand a line in "CheckList" table
			| 'Ref'                                                   |
			| 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'    |
		And "CheckList" table contains lines
			| 'Fixed'   | 'Date'                  | 'Ref'                                                  | 'Error ID'                                                | 'Line number'   | 'Problem while quick fix'    |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | ''                                                        | '8'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorQuantityIsZero'                                     | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorQuantityNotEqualQuantityInBaseUnit'                 | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorItemNotEqualItemInItemKey'                          | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorNotFilledQuantityInSourceOfOrigins'                 | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorUseSerialButSerialNotSet'                           | '2'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorNotTheSameQuantityInSerialListTableAndInItemList'   | '2'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorNotFilledQuantityInSourceOfOrigins'                 | '2'             | ''                           |
			| 'No'      | '10.03.2023 17:06:48'   | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'   | 'ErrorNotFilledQuantityInSourceOfOrigins'                 | '3'             | ''                           |
	And I close all client application windows	
				
Scenario: _0206005 сheck data verification in Inventory transfer order
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		Then "Fix document problems" window is opened
		And I expand a line in "CheckList" table
			| 'Ref'                                                         |
			| 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12'    |
	* Check report
		And "CheckList" table contains lines
			| 'Fixed'   | 'Date'                  | 'Ref'                                                        | 'Error ID'                                  | 'Line number'   | 'Problem while quick fix'    |
			| 'No'      | '10.03.2023 17:20:12'   | 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12'   | ''                                          | '4'             | ''                           |
			| 'No'      | '10.03.2023 17:20:12'   | 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12'   | 'ErrorQuantityInBaseUnitIsZero'             | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:20:12'   | 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12'   | 'ErrorQuantityNotEqualQuantityInBaseUnit'   | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:20:12'   | 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12'   | 'ErrorQuantityInBaseUnitIsZero'             | '2'             | ''                           |
			| 'No'      | '10.03.2023 17:20:12'   | 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12'   | 'ErrorQuantityNotEqualQuantityInBaseUnit'   | '2'             | ''                           |
	And I close all client application windows	

Scenario: _0206006 сheck data verification in Internal supply request
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		Then "Fix document problems" window is opened
		And I expand a line in "CheckList" table
			| 'Ref'                                                        |
			| 'Internal supply request 8 811 dated 10.03.2023 17:24:29'    |
	* Check report
		And "CheckList" table contains lines
			| 'Fixed'   | 'Date'                  | 'Ref'                                                       | 'Error ID'                        | 'Line number'   | 'Problem while quick fix'    |
			| 'No'      | '10.03.2023 17:24:29'   | 'Internal supply request 8 811 dated 10.03.2023 17:24:29'   | ''                                | '2'             | ''                           |
			| 'No'      | '10.03.2023 17:24:29'   | 'Internal supply request 8 811 dated 10.03.2023 17:24:29'   | 'ErrorQuantityIsZero'             | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:24:29'   | 'Internal supply request 8 811 dated 10.03.2023 17:24:29'   | 'ErrorQuantityInBaseUnitIsZero'   | '1'             | ''                           |
	And I close all client application windows


Scenario: _0206007 сheck data verification in Sales order
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		Then "Fix document problems" window is opened
		And I expand a line in "CheckList" table
			| 'Ref'                                            |
			| 'Sales order 8 811 dated 10.03.2023 17:32:00'    |
	* Check report
		And "CheckList" table contains lines
			| 'Fixed'   | 'Date'                  | 'Ref'                                           | 'Error ID'                                          | 'Line number'   | 'Problem while quick fix'    |
			| 'No'      | '10.03.2023 17:32:00'   | 'Sales order 8 811 dated 10.03.2023 17:32:00'   | ''                                                  | '4'             | ''                           |
			| 'No'      | '10.03.2023 17:32:00'   | 'Sales order 8 811 dated 10.03.2023 17:32:00'   | 'ErrorQuantityInItemListNotEqualQuantityInRowID'    | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:32:00'   | 'Sales order 8 811 dated 10.03.2023 17:32:00'   | 'ErrorNetAmountGreaterTotalAmount'                  | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:32:00'   | 'Sales order 8 811 dated 10.03.2023 17:32:00'   | 'ErrorTotalAmountMinusNetAmountNotEqualTaxAmount'   | '1'             | ''                           |
			| 'No'      | '10.03.2023 17:32:00'   | 'Sales order 8 811 dated 10.03.2023 17:32:00'   | 'ErrorQuantityInItemListNotEqualQuantityInRowID'    | '2'             | ''                           |
	And I close all client application windows	

