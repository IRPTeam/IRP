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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog PartnerItems objects
		When Create information register Taxes records (VAT)
	* Add plugin for discount
		When Create Document discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create catalog CancelReturnReasons objects
		When Create catalog Users objects
		When Create document RetailSalesReceipt objects (wrong data)
		When Create document GoodsReceipt objects (wrong data)
		When Create document InventoryTransfer (wrong data)
		When Create document InventoryTransferOrder objects (wrong data)
		When Create document InternalSupplyRequest objects (wrong data)
		When Create document SalesOrder objects (wrong data)
		When Create document RetailSalesReceipt objects (wrong movements)
		When Create document PurchaseInvoice objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(120).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(121).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _0260601 check preparation
	When check preparation	



Scenario: _0206003 сheck data verification in Goods receipt
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I remove checkbox "Only posted"		
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button	
	* Check report
		And Delay 25	
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
		And I remove checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		And Delay 25
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
		And I remove checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		And Delay 25
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
		And I remove checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		And Delay 25
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
		And I remove checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		And Delay 25
		And I expand a line in "CheckList" table
			| 'Ref'                                            |
			| 'Sales order 8 811 dated 10.03.2023 17:32:00'    |
	* Check report
		And "CheckList" table contains lines
			| 'Fixed' | 'Date'                | 'Ref'                                         | 'Error ID'                                        | 'Line number' | 'Problem while quick fix' |
			| 'No'    | '10.03.2023 17:32:00' | 'Sales order 8 811 dated 10.03.2023 17:32:00' | 'ErrorNetAmountGreaterTotalAmount'                | '1'           | ''                        |
			| 'No'    | '10.03.2023 17:32:00' | 'Sales order 8 811 dated 10.03.2023 17:32:00' | 'ErrorTotalAmountMinusNetAmountNotEqualTaxAmount' | '1'           | ''                        |
	And I close all client application windows	

Scenario: _0206008 сheck filter by Company
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I remove checkbox "Only posted"	
	* Filter by Second company
		And I click Choice button of the field named "Company"
		Then "Value list" window is opened
		And I click the button named "Add"
		And I select "Second Company" by string from the drop-down list named "Value" in "ValueList" table
		And I finish line editing in "ValueList" table
		And I click the button named "OK"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
		And Delay 25
		Then the number of "CheckList" table lines is "равно" 0		
	* Filter by Main company
		And I click Choice button of the field named "Company"
		And I select current line in "ValueList" table
		And I select "Main Company" by string from the drop-down list named "Value" in "ValueList" table
		And I finish line editing in "ValueList" table
		And I click the button named "OK"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
		And Delay 25	
	* Check report
		Then the number of "CheckList" table lines is "больше" 0	
	And I close all client application windows	

Scenario: _0206010 сheck ability to analyze an individual document after general analysis
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "07.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I remove checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		And Delay 50
		And "CheckList" table contains lines
			| 'Ref'                                                      |
			| 'Retail sales receipt 8 811 dated 07.03.2023 16:47:01'     |
			| 'Goods receipt 8 811 dated 10.03.2023 15:43:56'            |
			| 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'       |
			| 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12' |
			| 'Internal supply request 8 811 dated 10.03.2023 17:24:29'  |
			| 'Sales order 8 811 dated 10.03.2023 17:32:00'              |	
	* Check ability to analyze an individual document after general analysis
		And I go to line in "CheckList" table
			| 'Date'                | 'Fixed' | 'Ref'                                                  |
			| '07.03.2023 16:47:01' | 'No'    | 'Retail sales receipt 8 811 dated 07.03.2023 16:47:01' |
		And I expand current line in "CheckList" table
		And I go to line in "CheckList" table
			| 'Date'                | 'Error ID'                         | 'Fixed' | 'Ref'                                                  |'Line number'|
			| '07.03.2023 16:47:01' | 'ErrorItemTypeNotUseSerialNumbers' | 'No'    | 'Retail sales receipt 8 811 dated 07.03.2023 16:47:01' |'1'          |
		And I activate field named "CheckListErrorID" in "CheckList" table
		And in the table "CheckList" I click "Quick fix (selected rows)" button
		And Delay 20
		And "CheckList" table contains lines
			| 'Fixed' | 'Date'                | 'Ref'                                                  | 'Error ID'                         | 'Problem while quick fix' |'Line number'|
			| 'Yes'   | '07.03.2023 16:47:01' | 'Retail sales receipt 8 811 dated 07.03.2023 16:47:01' | 'ErrorItemTypeNotUseSerialNumbers' | ''                        |'1'          |
		Then "Fix document problems" window is opened
		And I go to the first line in "CheckList" table
		And in the table "CheckList" I click "Update check (selected rows)" button
		And "CheckList" table does not contain lines
			| 'Date'                | 'Ref'                                                  | 'Error ID'                         | 'Line number' |
			| '07.03.2023 16:47:01' | 'Retail sales receipt 8 811 dated 07.03.2023 16:47:01' | 'ErrorItemTypeNotUseSerialNumbers' | '1'           |
	And I close all client application windows
			
				
				
Scenario: _0206011 сheck error filter
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I remove checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Check documents" button
	* Check report
		And Delay 25
		And "CheckList" table contains lines
			| 'Ref'                                                      |
			| 'Goods receipt 8 811 dated 10.03.2023 15:43:56'            |
			| 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'       |
			| 'Inventory transfer order 8 811 dated 10.03.2023 17:20:12' |
			| 'Internal supply request 8 811 dated 10.03.2023 17:24:29'  |
			| 'Sales order 8 811 dated 10.03.2023 17:32:00'              |
	* Check error filter
		And I input "ErrorNetAmountGreaterTotalAmount" text in "Error filter" field
		And I move to the next attribute
		And "CheckList" table became equal
			| 'Fixed' | 'Date'                | 'Ref'                                         | 'Error ID'                         | 'Line number' | 'Problem while quick fix' |
			| 'No'    | '10.03.2023 17:32:00' | 'Sales order 8 811 dated 10.03.2023 17:32:00' | ''                                 | '2'           | ''                        |
			| 'No'    | '10.03.2023 17:32:00' | 'Sales order 8 811 dated 10.03.2023 17:32:00' | 'ErrorNetAmountGreaterTotalAmount' | '1'           | ''                        |
		And I input "ErrorQuantityIsZero" text in "Error filter" field
		And I move to the next attribute
		And "CheckList" table became equal
			| 'Fixed' | 'Date'                | 'Ref'                                                     | 'Error ID'            | 'Line number' | 'Problem while quick fix' |
			| 'No'    | '10.03.2023 17:06:48' | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'      | ''                    | '8'           | ''                        |
			| 'No'    | '10.03.2023 17:06:48' | 'Inventory transfer 8 811 dated 10.03.2023 17:06:48'      | 'ErrorQuantityIsZero' | '1'           | ''                        |
			| 'No'    | '10.03.2023 17:24:29' | 'Internal supply request 8 811 dated 10.03.2023 17:24:29' | ''                    | '2'           | ''                        |
			| 'No'    | '10.03.2023 17:24:29' | 'Internal supply request 8 811 dated 10.03.2023 17:24:29' | 'ErrorQuantityIsZero' | '1'           | ''                        |
	And I close all client application windows
	
Scenario: _0206012 check filter Skip check register
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "29.01.2024" text in the field named "DateBegin"
		And I input "29.01.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I set checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button 
	* Skip check registers
		And I move to "Posting" tab
		And I click Select button of "Skip check registers" field
		And I click the button named "Add"
		And I input "AccumulationRegister.R2050T_RetailSales" text in the field named "Value" of "ValueList" table
		And I finish line editing in "ValueList" table
		And I click the button named "OK"
		And in the table "DocumentList" I click "Check posting" button 
		And Delay 1
		And I click "Update statuses" button
	* Check
		And I expand current line in "PostingInfo" table
		And "PostingInfo" table does not contain lines
			| 'Reg name'                                |
			| 'AccumulationRegister.R2050T_RetailSales' |	
		And I close all client application windows
		

Scenario: _0206013 сheck posting in Fix document problems (Write selected row)
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		If the editing text of form attribute named "SkipCheckRegisters" became equal to "AccumulationRegister.R2050T_RetailSales" Then
			And I click Select button of "Skip check registers" field
			Then "Value list" window is opened
			And I delete a line in "ValueList" table
			And I click the button named "OK"	
		And I click Choice button of the field named "Period"
		And I input "29.01.2024" text in the field named "DateBegin"
		And I input "29.01.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I set checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button 
		And in the table "DocumentList" I click "Check posting" button 
		And Delay 1
		And I click "Update statuses" button
	* Show posting diff
		And I go to line in "PostingInfo" table
			| 'Ref'                                                  |
			| 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' |
		And I expand current line in "PostingInfo" table
		And I go to line in "PostingInfo" table
			| 'Document type'        | 'Processed' | 'Ref'                                                  | 'Reg name'                          | 'Select' |
			| 'Retail sales receipt' | 'No'        | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'AccumulationRegister.R2001T_Sales' | 'No'     |
		And in the table "PostingInfo" I click "Show posting diff" button
		And I activate "Reg name" field in "PostingInfo" table
		And I select current line in "PostingInfo" table
	* Check 	
		And "NewMovement" table became equal
			| 'Period'              | 'LineNumber' | 'Active' | 'Company'      | 'Branch' | 'CurrencyMovementType'    | 'Currency' | 'Invoice'                                              | 'ItemKey' | 'SerialLotNumber' | 'RowKey'                               | 'SalesPerson' | 'Quantity' | 'Amount' | 'NetAmount' | 'OffersAmount' |
			| '29.01.2024 15:11:19' | '1'          | 'Yes'    | 'Main Company' | ''       | 'Local currency'          | 'TRY'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'XS/Blue' | ''                | '56e7ad50-f433-4705-9bce-ac3489573a90' | ''            | '2,000'    | '986,00' | '835,59'    | '54,00'        |
			| '29.01.2024 15:11:19' | '2'          | 'Yes'    | 'Main Company' | ''       | 'Reporting currency'      | 'USD'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'XS/Blue' | ''                | '56e7ad50-f433-4705-9bce-ac3489573a90' | ''            | '2,000'    | '168,80' | '143,05'    | '9,24'         |
			| '29.01.2024 15:11:19' | '3'          | 'Yes'    | 'Main Company' | ''       | 'Local currency'          | 'TRY'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'ODS'     | '9090098908'      | '102d3faa-13aa-4ce7-b0f0-f302a8006ad5' | ''            | '2,000'    | '190,00' | '161,02'    | '10,00'        |
			| '29.01.2024 15:11:19' | '4'          | 'Yes'    | 'Main Company' | ''       | 'Reporting currency'      | 'USD'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'ODS'     | '9090098908'      | '102d3faa-13aa-4ce7-b0f0-f302a8006ad5' | ''            | '2,000'    | '32,53'  | '27,57'     | '1,71'         |
			| '29.01.2024 15:11:19' | '5'          | 'Yes'    | 'Main Company' | ''       | 'en description is empty' | 'TRY'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'XS/Blue' | ''                | '56e7ad50-f433-4705-9bce-ac3489573a90' | ''            | '2,000'    | '986,00' | '835,59'    | '54,00'        |
			| '29.01.2024 15:11:19' | '6'          | 'Yes'    | 'Main Company' | ''       | 'en description is empty' | 'TRY'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'ODS'     | '9090098908'      | '102d3faa-13aa-4ce7-b0f0-f302a8006ad5' | ''            | '2,000'    | '190,00' | '161,02'    | '10,00'        |
		And "CurrentMovement" table became equal
			| 'Period'              | 'LineNumber' | 'Active' | 'Company'      | 'Branch' | 'CurrencyMovementType' | 'Currency' | 'Invoice'                                              | 'ItemKey' | 'SerialLotNumber' | 'RowKey'                               | 'SalesPerson' | 'Quantity' | 'Amount' | 'NetAmount' | 'OffersAmount' |
			| '29.01.2024 15:11:19' | '1'          | 'Yes'    | 'Main Company' | ''       | 'TRY'                  | 'TRY'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'XS/Blue' | ''                | '56e7ad50-f433-4705-9bce-ac3489573a90' | ''            | '4,000'    | '988,00' | '835,59'    | '54,00'        |
			| '29.01.2024 15:11:19' | '2'          | 'Yes'    | 'Main Company' | ''       | 'Local currency'       | 'TRY'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'XS/Blue' | ''                | '56e7ad50-f433-4705-9bce-ac3489573a90' | ''            | '2,000'    | '986,00' | '835,59'    | '54,00'        |
			| '29.01.2024 15:11:19' | '3'          | 'Yes'    | 'Main Company' | ''       | 'Reporting currency'   | 'USD'      | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'XS/Blue' | ''                | '56e7ad50-f433-4705-9bce-ac3489573a90' | ''            | '2,000'    | '168,80' | '143,05'    | '9,24'         |
	* Write selected row
		And I go to line in "PostingInfo" table
			| 'Document type'        | 'Processed' | 'Ref'                                                  | 'Reg name'                          | 'Select' |
			| 'Retail sales receipt' | 'No'        | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'AccumulationRegister.R2001T_Sales' | 'No'     |
		And I activate "Select" field in "PostingInfo" table
		And I set "Select" checkbox in "PostingInfo" table
		And I finish line editing in "PostingInfo" table
		And in the table "PostingInfo" I click "Write selected records" button
		And Delay 1
		And I click "Update statuses" button
		And in the table "PostingInfo" I click "Update posting (selected rows)" button
		And I go to line in "PostingInfo" table
			| 'Date'       | 'Document type'        | 'Processed' | 'Ref'                                                  | 'Select' |
			| '29.01.2024' | 'Retail sales receipt' | 'No'        | 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'No'     |
		And I activate field named "PostingInfoDate" in "PostingInfo" table
		And I expand current line in "PostingInfo" table
		And "PostingInfo" table does not contain lines
			| 'Ref'                                                  | 'Reg name'                          |
			| 'Retail sales receipt 8 812 dated 29.01.2024 15:11:19' | 'AccumulationRegister.R2001T_Sales' |
	And I close all client application windows

Scenario: _0206014 сheck posting in Fix document problems (Post selected document)
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "29.01.2024" text in the field named "DateBegin"
		And I input "29.01.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I set checkbox "Only posted"	
		And in the table "DocumentList" I click "Fill documents" button 
		And in the table "DocumentList" I click "Check posting" button 
		And Delay 1
		And I click "Update statuses" button
	* Post selected document
		And I go to line in "PostingInfo" table
			| 'Document type'        | 'Processed' | 'Ref'                                                  | 'Reg name' | 'Select' |
			| 'Retail sales receipt' | 'No'        | 'Retail sales receipt 8 813 dated 29.01.2024 17:37:58' | ''         | 'No'     |
		And I activate "Select" field in "PostingInfo" table
		And I set "Select" checkbox in "PostingInfo" table
		And I finish line editing in "PostingInfo" table
		And in the table "PostingInfo" I click "Post selected document" button
		And Delay 1
		And I click "Update statuses" button
		And I go to line in "PostingInfo" table
			| 'Ref'                                                  |
			| 'Retail sales receipt 8 813 dated 29.01.2024 17:37:58' |
		And in the table "PostingInfo" I click "Update posting (selected rows)" button		
		And I move to "Filter" tab
		And in the table "DocumentList" I click "Check posting" button
		Then " [Jobs: 1]: Background multi job" window is opened
		And Delay 5
		And I click "Update statuses" button
		And Delay 5
		And "PostingInfo" table does not contain lines
			| 'Ref'                                                  |
			| 'Retail sales receipt 8 813 dated 29.01.2024 17:37:58' |	
	And I close all client application windows

Scenario: _0206015 skeep sheck for reposting
	And I close all client application windows
	* Open data proc
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
		And I click Choice button of the field named "Period"
		And I input "29.01.2021" text in the field named "DateBegin"
		And I input "29.01.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I set checkbox "Only posted"
		And in the table "DocumentList" I click "Fill documents" button
		And in the table "DocumentList" I click "Skeep check (for reposting)" button
	* Skeep checks (for reposting)
		And "PostingInfo" table contains lines
			| "Date"       | "Document type"        | "Ref"                                                  | "Select" | "Reg name" | "Processed" | "Errors" |
			| "12.02.2021" | "Purchase invoice"     | "Purchase invoice 120 dated 12.02.2021 15:40:00"       | "No"     | ""         | "No"        | ""       |
			| "12.02.2021" | "Purchase invoice"     | "Purchase invoice 121 dated 12.02.2021 15:40:00"       | "No"     | ""         | "No"        | ""       |
			| "07.03.2023" | "Retail sales receipt" | "Retail sales receipt 8 811 dated 07.03.2023 16:47:01" | "No"     | ""         | "No"        | ""       |	
// 		And in the table "DocumentList" I click "Check posting" button
// 		Then " [Jobs: 1]: Background multi job" window is opened
// 		And Delay 5
// 		And I click "Update statuses" button
// 		And "PostingInfo" table does not contain lines
// 			| "Date"       | "Document type"        | "Ref"                                                  | "Select" | "Reg name" | "Processed" | "Errors" |
// 			| "12.02.2021" | "Purchase invoice"     | "Purchase invoice 120 dated 12.02.2021 15:40:00"       | "No"     | ""         | "No"        | ""       |
// 			| "12.02.2021" | "Purchase invoice"     | "Purchase invoice 121 dated 12.02.2021 15:40:00"       | "No"     | ""         | "No"        | ""       |
	And I close all client application windows