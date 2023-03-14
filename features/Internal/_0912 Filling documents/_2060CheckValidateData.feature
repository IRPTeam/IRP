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
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create catalog PartnerItems objects
		When Create information register Taxes records (VAT)
	* Add plugin for discount
		When Create Document discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
	* Tax settings
		When filling in Tax settings for company
		When Create catalog CancelReturnReasons objects
		When Create catalog Users objects
		When Create document RetailSalesReceipt objects (wrong data)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(8811).GetObject().Write(DocumentWriteMode.Posting);" |
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
			| 'Available fields' |
			| 'Document type'    |
		And I select current line in "SettingsComposerSettingsFilterFilterAvailableFields" table
		And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I select current line in "SettingsComposerSettingsFilter" table
		And I select "Retail sales receipt" exact value from the drop-down list named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I finish line editing in "SettingsComposerSettingsFilter" table
		And I click "Finish editing" button
		And I click "Generate" button
	* Check report
		Then "Result" spreadsheet document is equal
			| 'Filter:'                                              | 'Reference.Posted Equal to "Yes" AND\nStatus Filled AND\nDocument type Equal to "Retail sales receipt"'                                                                                                                                                                                       |
			| ''                                                     | ''                                                                                                                                                                                                                                                                                            |
			| 'Document type'                                        | ''                                                                                                                                                                                                                                                                                            |
			| 'Reference'                                            | 'Status'                                                                                                                                                                                                                                                                                      |
			| 'Retail sales receipt'                                 | ''                                                                                                                                                                                                                                                                                            |
			| 'Retail sales receipt 8 811 dated 07.03.2023 16:47:01' | 'Row: 1. Total amount minus net amount is not equal to tax amount\nRow: 1. Offers amount in item list is not equal to offers amount in offers list\nRow: 2. Tax amount in item list is not equal to tax amount in tax list\nRow: 2. Total amount minus net amount is not equal to tax amount' |	
		And I close all client application windows

Scenario: _0206003 сheck data verification in Goods receipt
	And I close all client application windows
	* Open report
		Given I open hyperlink "e1cib/app/Report.AdditionalDocumentTablesCheck"
		And I click "Change option..." button
		And I move to the tab named "FilterPage"
		And I go to line in "SettingsComposerSettingsFilterFilterAvailableFields" table
			| 'Available fields' |
			| 'Document type'    |
		And I select current line in "SettingsComposerSettingsFilterFilterAvailableFields" table
		And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I select current line in "SettingsComposerSettingsFilter" table
		And I select "Goods receipt" exact value from the drop-down list named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I finish line editing in "SettingsComposerSettingsFilter" table
		And I click "Finish editing" button
		And I click "Generate" button
	* Check report
		Then "Result" spreadsheet document is equal
			| 'Filter:'                                       | 'Reference.Posted Equal to "Yes" AND\nStatus Filled AND\nDocument type Equal to "Goods receipt"'                                                |
			| ''                                              | ''                                                                                                                                              |
			| 'Document type'                                 | ''                                                                                                                                              |
			| 'Reference'                                     | 'Status'                                                                                                                                        |
			| 'Goods receipt'                                 | ''                                                                                                                                              |
			| 'Goods receipt 8 811 dated 10.03.2023 15:43:56' | 'Row: 1. Quantity not equal quantity in base unit when unit quantity equal 1\nRow: 1. Quantity in item list is not equal to quantity in row ID' |
	And I close all client application windows	

Scenario: _0206004 сheck data verification in Inventory transfer
	And I close all client application windows
	* Open report
		Given I open hyperlink "e1cib/app/Report.AdditionalDocumentTablesCheck"
		And I click "Change option..." button
		And I move to the tab named "FilterPage"
		And I go to line in "SettingsComposerSettingsFilterFilterAvailableFields" table
			| 'Available fields' |
			| 'Document type'    |
		And I select current line in "SettingsComposerSettingsFilterFilterAvailableFields" table
		And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I select current line in "SettingsComposerSettingsFilter" table
		And I select "Inventory transfer" exact value from the drop-down list named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I finish line editing in "SettingsComposerSettingsFilter" table
		And I click "Finish editing" button
		And I click "Generate" button
	* Check report
		Then "Result" spreadsheet document is equal
			| 'Filter:'                                            | 'Reference.Posted Equal to "Yes" AND\nStatus Filled AND\nDocument type Equal to "Inventory transfer"'                                                                                                                                                                                                                                                                                                                 |
			| ''                                                   | ''                                                                                                                                                                                                                                                                                                                                                                                                                    |
			| 'Document type'                                      | ''                                                                                                                                                                                                                                                                                                                                                                                                                    |
			| 'Reference'                                          | 'Status'                                                                                                                                                                                                                                                                                                                                                                                                              |
			| 'Inventory transfer'                                 | ''                                                                                                                                                                                                                                                                                                                                                                                                                    |
			| 'Inventory transfer 8 811 dated 10.03.2023 17:06:48' | 'Row: 1. Quantity is zero\nRow: 1. Quantity not equal quantity in base unit when unit quantity equal 1\nRow: 1. Item is not equal to item in item key\nRow: 2. Quantity in item list is not equal to quantity in row ID\nRow: 2. Serial is not set but is required\nRow: 2. Quantity in serial list table is not the same as quantity in item list\nRow: 3. Quantity in item list is not equal to quantity in row ID' |		
	And I close all client application windows	
				
Scenario: _0206005 сheck data verification in Inventory transfer order
	And I close all client application windows
	* Open report
		Given I open hyperlink "e1cib/app/Report.AdditionalDocumentTablesCheck"
		And I click "Change option..." button
		And I move to the tab named "FilterPage"
		And I go to line in "SettingsComposerSettingsFilterFilterAvailableFields" table
			| 'Available fields' |
			| 'Document type'    |
		And I select current line in "SettingsComposerSettingsFilterFilterAvailableFields" table
		And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I select current line in "SettingsComposerSettingsFilter" table
		And I select "Inventory transfer order" exact value from the drop-down list named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I finish line editing in "SettingsComposerSettingsFilter" table
		And I click "Finish editing" button
		And I click "Generate" button
	* Check report
		Then "Result" spreadsheet document is equal by template
			| 'Filter:'                                                  | 'Reference.Posted Equal to "Yes" AND\nStatus Filled AND\nDocument type Equal to "Inventory transfer order"'                                                                                                                                                                                                                                                                  |
			| ''                                                         | ''                                                                                                                                                                                                                                                                                                                                                                           |
			| 'Document type'                                            | ''                                                                                                                                                                                                                                                                                                                                                                           |
			| 'Reference'                                                | 'Status'                                                                                                                                                                                                                                                                                                                                                                     |
			| 'Inventory transfer order'                                 | ''                                                                                                                                                                                                                                                                                                                                                                           |
			| 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12' | 'Row: 1. Quantity in base unit is zero\nRow: 1. Quantity not equal quantity in base unit when unit quantity equal 1\nRow: 1. Quantity in item list is not equal to quantity in row ID\nRow: 2. Quantity in base unit is zero\nRow: 2. Quantity not equal quantity in base unit when unit quantity equal 1\nRow: 2. Quantity in item list is not equal to quantity in row ID' |		
	And I close all client application windows	

Scenario: _0206006 сheck data verification in Internal supply request
	And I close all client application windows
	* Open report
		Given I open hyperlink "e1cib/app/Report.AdditionalDocumentTablesCheck"
		And I click "Change option..." button
		And I move to the tab named "FilterPage"
		And I go to line in "SettingsComposerSettingsFilterFilterAvailableFields" table
			| 'Available fields' |
			| 'Document type'    |
		And I select current line in "SettingsComposerSettingsFilterFilterAvailableFields" table
		And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I select current line in "SettingsComposerSettingsFilter" table
		And I select "Internal supply request" exact value from the drop-down list named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I finish line editing in "SettingsComposerSettingsFilter" table
		And I click "Finish editing" button
		And I click "Generate" button
	* Check report
		Then "Result" spreadsheet document is equal
			| 'Filter:'                                                 | 'Reference.Posted Equal to "Yes" AND\nStatus Filled AND\nDocument type Equal to "Internal supply request"' |
			| ''                                                        | ''                                                                                                         |
			| 'Document type'                                           | ''                                                                                                         |
			| 'Reference'                                               | 'Status'                                                                                                   |
			| 'Internal supply request'                                 | ''                                                                                                         |
			| 'Internal supply request 8 811 dated 10.03.2023 17:24:29' | 'Row: 1. Quantity is zero\nRow: 1. Quantity in base unit is zero'                                          |		
	And I close all client application windows


Scenario: _0206007 сheck data verification in Sales order
	And I close all client application windows
	* Open report
		Given I open hyperlink "e1cib/app/Report.AdditionalDocumentTablesCheck"
		And I click "Change option..." button
		And I move to the tab named "FilterPage"
		And I go to line in "SettingsComposerSettingsFilterFilterAvailableFields" table
			| 'Available fields' |
			| 'Document type'    |
		And I select current line in "SettingsComposerSettingsFilterFilterAvailableFields" table
		And I activate field named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I select current line in "SettingsComposerSettingsFilter" table
		And I select "Sales order" exact value from the drop-down list named "SettingsComposerSettingsFilterRightValue" in "SettingsComposerSettingsFilter" table
		And I finish line editing in "SettingsComposerSettingsFilter" table
		And I click "Finish editing" button
		And I click "Generate" button
	* Check report
		Then "Result" spreadsheet document is equal
			| 'Filter:'                                     | 'Reference.Posted Equal to "Yes" AND\nStatus Filled AND\nDocument type Equal to "Sales order"'                                                                                                                                                          |
			| ''                                            | ''                                                                                                                                                                                                                                                      |
			| 'Document type'                               | ''                                                                                                                                                                                                                                                      |
			| 'Reference'                                   | 'Status'                                                                                                                                                                                                                                                |
			| 'Sales order'                                 | ''                                                                                                                                                                                                                                                      |
			| 'Sales order 8 811 dated 10.03.2023 17:32:00' | 'Row: 1. Quantity in item list is not equal to quantity in row ID\nRow: 1. Net amount is greater than total amount\nRow: 1. Total amount minus net amount is not equal to tax amount\nRow: 2. Quantity in item list is not equal to quantity in row ID' |	
	And I close all client application windows	

