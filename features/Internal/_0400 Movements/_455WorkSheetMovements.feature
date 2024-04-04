#language: en
@tree
@Positive
@Movements3
@MovementsWorkSheetAndWorkOrder


Feature: check Work sheet and Work order movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _045501 preparation (work sheet movements)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
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
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create catalog PartnersBankAccounts objects
		When create items for work order
		And Delay 5
		When Create catalog BillOfMaterials objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create catalog CancelReturnReasons objects
	* Load documents
		When Create document SO-WO-WS-SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(182).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(182).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(182).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(182).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.WorkOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.WorkSheet.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create WO and WS (with no reserve)
		And I execute 1C:Enterprise script at server
			| "Documents.WorkOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.WorkSheet.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _045502 check preparation
	When check preparation

Scenario: _045503 check WorkSheet movements by the Register  "R4010 Actual stocks"
	* Select Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work sheet 3 dated 22.09.2022 15:55:17'   | ''              | ''                      | ''            | ''             | ''             | ''                     |
			| 'Document registrations records'           | ''              | ''                      | ''            | ''             | ''             | ''                     |
			| 'Register  "R4010 Actual stocks"'          | ''              | ''                      | ''            | ''             | ''             | ''                     |
			| ''                                         | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             | ''                     |
			| ''                                         | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     | 'Serial lot number'    |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '1,521'       | 'Store 01'     | 'Material 3'   | ''                     |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '2'           | 'Store 01'     | 'Material 1'   | ''                     |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '2'           | 'Store 01'     | 'Material 1'   | ''                     |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '2'           | 'Store 01'     | 'Material 2'   | ''                     |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '4'           | 'Store 01'     | 'Material 2'   | ''                     |
		And I close all client application windows
		
Scenario: _045504 check WorkOrder movements by the Register  "R4011 Free stocks" (stock)
	* Select Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work order 31 dated 22.09.2022 12:41:21'   | ''              | ''                      | ''            | ''             | ''              |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''             | ''              |
			| 'Register  "R4011 Free stocks"'             | ''              | ''                      | ''            | ''             | ''              |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''              |
			| ''                                          | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'      |
			| ''                                          | 'Expense'       | '22.09.2022 12:41:21'   | '1,521'       | 'Store 01'     | 'Material 3'    |
			| ''                                          | 'Expense'       | '22.09.2022 12:41:21'   | '2'           | 'Store 01'     | 'Material 1'    |
			| ''                                          | 'Expense'       | '22.09.2022 12:41:21'   | '2'           | 'Store 01'     | 'Material 1'    |
			| ''                                          | 'Expense'       | '22.09.2022 12:41:21'   | '2'           | 'Store 01'     | 'Material 2'    |
			| ''                                          | 'Expense'       | '22.09.2022 12:41:21'   | '4'           | 'Store 01'     | 'Material 2'    |
		And I close all client application windows				

Scenario: _045505 check WorkSheet movements by the Register  "R4050 Stock inventory"
	* Select Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R4050 Stock inventory" 
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work sheet 3 dated 22.09.2022 15:55:17'   | ''              | ''                      | ''            | ''               | ''           | ''              |
			| 'Document registrations records'           | ''              | ''                      | ''            | ''               | ''           | ''              |
			| 'Register  "R4050 Stock inventory"'        | ''              | ''                      | ''            | ''               | ''           | ''              |
			| ''                                         | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''              |
			| ''                                         | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'      |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '1,521'       | 'Main Company'   | 'Store 01'   | 'Material 3'    |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '2'           | 'Main Company'   | 'Store 01'   | 'Material 1'    |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '2'           | 'Main Company'   | 'Store 01'   | 'Material 1'    |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '2'           | 'Main Company'   | 'Store 01'   | 'Material 2'    |
			| ''                                         | 'Expense'       | '22.09.2022 15:55:17'   | '4'           | 'Main Company'   | 'Store 01'   | 'Material 2'    |
		And I close all client application windows

Scenario: _045506 check WorkSheet movements by the Register  "T3010S Row ID info"
	* Select Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "T3010S Row ID info" 
		And I click "Registrations report" button
		And I select "T3010S Row ID info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work sheet 3 dated 22.09.2022 15:55:17'   | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                          | ''                                        |
			| 'Document registrations records'           | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                          | ''                                        |
			| 'Register  "T3010S Row ID info"'           | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                          | ''                                        |
			| ''                                         | 'Resources'                              | ''        | ''           | ''       | 'Dimensions'                             | ''                                       | ''            | ''                                          | ''                                        |
			| ''                                         | 'Row ref'                                | 'Price'   | 'Currency'   | 'Unit'   | 'Key'                                    | 'Row ID'                                 | 'Unique ID'   | 'Basis'                                     | 'Basis key'                               |
			| ''                                         | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | ''        | ''           | 'pcs'    | '8eb2727f-a1ed-4b08-86fe-c827c2a16a58'   | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | '*'           | 'Work order 31 dated 22.09.2022 12:41:21'   | 'fc41e496-14e3-4646-b488-c33a97dfe6dd'    |
			| ''                                         | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | ''        | ''           | 'pcs'    | '400f5011-7637-4e38-a8cb-37b2e5a5025e'   | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | '*'           | 'Work order 31 dated 22.09.2022 12:41:21'   | '008ffbc8-93f9-4022-9276-ae3f150c1736'    |
		And I close all client application windows

Scenario: _045507 check WorkOrder movements by the Register  "R4011 Free stocks" (no reserve)
	* Select Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work order 32 dated 28.09.2022 19:53:33'   | ''              | ''                      | ''            | ''             | ''              |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''             | ''              |
			| 'Register  "R4011 Free stocks"'             | ''              | ''                      | ''            | ''             | ''              |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''              |
			| ''                                          | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'      |
			| ''                                          | 'Expense'       | '28.09.2022 19:53:33'   | '1,521'       | 'Store 01'     | 'Material 3'    |
			| ''                                          | 'Expense'       | '28.09.2022 19:53:33'   | '2'           | 'Store 01'     | 'Material 1'    |
			| ''                                          | 'Expense'       | '28.09.2022 19:53:33'   | '2'           | 'Store 01'     | 'Material 1'    |
			| ''                                          | 'Expense'       | '28.09.2022 19:53:33'   | '2'           | 'Store 01'     | 'Material 2'    |
		And I close all client application windows

Scenario: _045508 check WorkSheet movements by the Register  "R4011 Free stocks" (no reserve)
		And I close all client application windows
	* Select Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work sheet 4 dated 29.09.2022 19:07:21'   | ''              | ''                      | ''            | ''             | ''              |
			| 'Document registrations records'           | ''              | ''                      | ''            | ''             | ''              |
			| 'Register  "R4011 Free stocks"'            | ''              | ''                      | ''            | ''             | ''              |
			| ''                                         | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''              |
			| ''                                         | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'      |
			| ''                                         | 'Expense'       | '29.09.2022 19:07:21'   | '4'           | 'Store 01'     | 'Material 2'    |
		And I close all client application windows

Scenario: _045510 check WorkOrder movements by the Register  "T3010S Row ID info"
	* Select Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
	* Check movements by the Register  "T3010S Row ID info" 
		And I click "Registrations report" button
		And I select "T3010S Row ID info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work order 31 dated 22.09.2022 12:41:21'   | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                            | ''                                        |
			| 'Document registrations records'            | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                            | ''                                        |
			| 'Register  "T3010S Row ID info"'            | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                            | ''                                        |
			| ''                                          | 'Resources'                              | ''        | ''           | ''       | 'Dimensions'                             | ''                                       | ''            | ''                                            | ''                                        |
			| ''                                          | 'Row ref'                                | 'Price'   | 'Currency'   | 'Unit'   | 'Key'                                    | 'Row ID'                                 | 'Unique ID'   | 'Basis'                                       | 'Basis key'                               |
			| ''                                          | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | '100'     | 'TRY'        | 'pcs'    | 'fc41e496-14e3-4646-b488-c33a97dfe6dd'   | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | '*'           | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'    |
			| ''                                          | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | '100'     | 'TRY'        | 'pcs'    | '008ffbc8-93f9-4022-9276-ae3f150c1736'   | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | '*'           | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'    |
		And I close all client application windows

Scenario: _045511 check WorkOrder movements by the Register  "TM1010B Row ID movements"
	* Select Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
	* Check movements by the Register  "TM1010B Row ID movements" 
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work order 31 dated 22.09.2022 12:41:21'   | ''              | ''                      | ''            | ''                                       | ''                                       | ''           | ''                                            | ''                                        |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''                                       | ''                                       | ''           | ''                                            | ''                                        |
			| 'Register  "TM1010B Row ID movements"'      | ''              | ''                      | ''            | ''                                       | ''                                       | ''           | ''                                            | ''                                        |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'                             | ''                                       | ''           | ''                                            | ''                                        |
			| ''                                          | ''              | ''                      | 'Quantity'    | 'Row ref'                                | 'Row ID'                                 | 'Step'       | 'Basis'                                       | 'Basis key'                               |
			| ''                                          | 'Receipt'       | '22.09.2022 12:41:21'   | '1'           | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | 'SI&WS'      | 'Work order 31 dated 22.09.2022 12:41:21'     | 'fc41e496-14e3-4646-b488-c33a97dfe6dd'    |
			| ''                                          | 'Receipt'       | '22.09.2022 12:41:21'   | '1'           | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | 'SI&WS'      | 'Work order 31 dated 22.09.2022 12:41:21'     | '008ffbc8-93f9-4022-9276-ae3f150c1736'    |
			| ''                                          | 'Expense'       | '22.09.2022 12:41:21'   | '1'           | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'   | 'SI&WO&WS'   | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'f81d8d3d-3ac3-4b17-ab39-bea7738990fb'    |
			| ''                                          | 'Expense'       | '22.09.2022 12:41:21'   | '1'           | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'   | 'SI&WO&WS'   | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'c4929c56-c974-4162-b7b9-debfcbba6b3b'    |
		And I close all client application windows


Scenario: _045512 check WorkOrder movements by the Register  "R4012 Stock Reservation"
	* Select Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
	* Check movements by the Register  "R4012 Stock Reservation" 
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work order 32 dated 28.09.2022 19:53:33'   | ''              | ''                      | ''            | ''             | ''             | ''                                           |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''             | ''             | ''                                           |
			| 'Register  "R4012 Stock Reservation"'       | ''              | ''                      | ''            | ''             | ''             | ''                                           |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             | ''                                           |
			| ''                                          | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     | 'Order'                                      |
			| ''                                          | 'Receipt'       | '28.09.2022 19:53:33'   | '1,521'       | 'Store 01'     | 'Material 3'   | 'Work order 32 dated 28.09.2022 19:53:33'    |
			| ''                                          | 'Receipt'       | '28.09.2022 19:53:33'   | '2'           | 'Store 01'     | 'Material 1'   | 'Work order 32 dated 28.09.2022 19:53:33'    |
			| ''                                          | 'Receipt'       | '28.09.2022 19:53:33'   | '2'           | 'Store 01'     | 'Material 1'   | 'Work order 32 dated 28.09.2022 19:53:33'    |
			| ''                                          | 'Receipt'       | '28.09.2022 19:53:33'   | '2'           | 'Store 01'     | 'Material 2'   | 'Work order 32 dated 28.09.2022 19:53:33'    |
		And I close all client application windows

Scenario: _045513 check WorkSheet movements by the Register  "R4012 Stock Reservation"
		And I close all client application windows
	* Select Work Sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R4012 Stock Reservation" 
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work sheet 3 dated 22.09.2022 15:55:17' | ''                    | ''           | ''         | ''           | ''                                        | ''         |
			| 'Register  "R4012 Stock Reservation"'    | ''                    | ''           | ''         | ''           | ''                                        | ''         |
			| ''                                       | 'Period'              | 'RecordType' | 'Store'    | 'Item key'   | 'Order'                                   | 'Quantity' |
			| ''                                       | '22.09.2022 15:55:17' | 'Expense'    | 'Store 01' | 'Material 1' | 'Work order 31 dated 22.09.2022 12:41:21' | '4'        |
			| ''                                       | '22.09.2022 15:55:17' | 'Expense'    | 'Store 01' | 'Material 3' | 'Work order 31 dated 22.09.2022 12:41:21' | '1,521'    |
			| ''                                       | '22.09.2022 15:55:17' | 'Expense'    | 'Store 01' | 'Material 2' | 'Work order 31 dated 22.09.2022 12:41:21' | '6'        |	
		And I close all client application windows

Scenario: _045520 Work sheet clear posting/mark for deletion
	* Select Work sheet closing
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work sheet 3 dated 22.09.2022 15:55:17'    |
			| 'Document registrations records'            |
		And I close current window
	* Post Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'Register  "R4010 Actual stocks"'    |
			| 'R4050 Stock inventory'              |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work sheet 3 dated 22.09.2022 15:55:17'    |
			| 'Document registrations records'            |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'Register  "R4010 Actual stocks"'    |
			| 'R4050 Stock inventory'              |
		And I close all client application windows


Scenario: _045521 Work order clear posting/mark for deletion
		And I close all client application windows
	* Select Work order closing
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work order 31 dated 22.09.2022 12:41:21'    |
			| 'Document registrations records'             |
		And I close current window
	* Post Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'TM1010B Row ID movements'    |
			| 'T3010S Row ID info'          |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Work order 31 dated 22.09.2022 12:41:21'    |
			| 'Document registrations records'             |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'TM1010B Row ID movements'    |
			| 'T3010S Row ID info'          |
		And I close all client application windows
