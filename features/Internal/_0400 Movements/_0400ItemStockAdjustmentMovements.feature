#language: en
@tree
@Positive
@Movements
@MovementsItemStockAdjustment

Feature: check item stock adjustment movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040001 preparation (item stock adjustment movements)
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
		When Create catalog Countries objects
		When Create catalog Stores objects
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
		When Create catalog PartnersBankAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Taxes records (VAT)
	* Load item stock adjustment document
		When Create document item stock adjustment (check movements)
		When Create document ItemStockAdjustment objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
				| "Documents.ItemStockAdjustment.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.ItemStockAdjustment.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
	// * Check query for item stock adjustment movements
	// 	Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
	// 	And in the table "Info" I click "Fill movements" button
	// 	And "Info" table contains lines
	// 		| 'Document'            | 'Register'                         | 'Recorder' | 'Conditions'                                                                                                                                                             | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 'Parameters'                 | 'Receipt' | 'Expense' |
	// 		| 'ItemStockAdjustment' | 'R4010B_ActualStocks'              | 'Yes'      | 'Query Receipt:\nQuery Expense:'                                                                                                                                         | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Ref AS Ref,\n    QueryTable.Key AS Key,\n    QueryTable.ItemKey AS ItemKey1,\n    QueryTable.Unit AS Unit,\n    QueryTable.Quantity1 AS Quantity1,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.ItemKeyWriteOff AS ItemKeyWriteOff,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.SerialLotNumber AS SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff AS SerialLotNumberWriteOff\nINTO R4010B_ActualStocks\nFROM\n    ItemList AS QueryTable\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.Ref,\n    QueryTable.Key,\n    QueryTable.ItemKey,\n    QueryTable.Unit,\n    QueryTable.Quantity1,\n    QueryTable.Quantity,\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.Period,\n    QueryTable.Company,\n    QueryTable.Store,\n    QueryTable.SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff\nFROM\n    ItemList AS QueryTable'                                                                                                                                                                                                                                                                                      | 'Ref: Item stock adjustment' | 'Yes'     | 'Yes'     |
	// 		| 'ItemStockAdjustment' | 'R4050B_StockInventory'            | 'Yes'      | 'Query Receipt:\nQuery Expense:'                                                                                                                                         | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Ref AS Ref,\n    QueryTable.Key AS Key,\n    QueryTable.ItemKey AS ItemKey1,\n    QueryTable.Unit AS Unit,\n    QueryTable.Quantity1 AS Quantity1,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.ItemKeyWriteOff AS ItemKeyWriteOff,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.SerialLotNumber AS SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff AS SerialLotNumberWriteOff\nINTO R4050B_StockInventory\nFROM\n    ItemList AS QueryTable\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.Ref,\n    QueryTable.Key,\n    QueryTable.ItemKey,\n    QueryTable.Unit,\n    QueryTable.Quantity1,\n    QueryTable.Quantity,\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.Period,\n    QueryTable.Company,\n    QueryTable.Store,\n    QueryTable.SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff\nFROM\n    ItemList AS QueryTable'                                                                                                                                                                                                                                                                                    | 'Ref: Item stock adjustment' | 'Yes'     | 'Yes'     |
	// 		| 'ItemStockAdjustment' | 'R4011B_FreeStocks'                | 'Yes'      | 'Query Receipt:\nQuery Expense:'                                                                                                                                         | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Ref AS Ref,\n    QueryTable.Key AS Key,\n    QueryTable.ItemKey AS ItemKey1,\n    QueryTable.Unit AS Unit,\n    QueryTable.Quantity1 AS Quantity1,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.ItemKeyWriteOff AS ItemKeyWriteOff,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.SerialLotNumber AS SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff AS SerialLotNumberWriteOff\nINTO R4011B_FreeStocks\nFROM\n    ItemList AS QueryTable\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.Ref,\n    QueryTable.Key,\n    QueryTable.ItemKey,\n    QueryTable.Unit,\n    QueryTable.Quantity1,\n    QueryTable.Quantity,\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.Period,\n    QueryTable.Company,\n    QueryTable.Store,\n    QueryTable.SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff\nFROM\n    ItemList AS QueryTable'                                                                                                                                                                                                                                                                                        | 'Ref: Item stock adjustment' | 'Yes'     | 'Yes'     |
	// 		| 'ItemStockAdjustment' | 'R4052T_StockAdjustmentAsSurplus'  | 'Yes'      | 'TRUE'                                                                                                                                                                   | 'SELECT\n    QueryTable.ItemKeyWriteOff AS ItemKey,\n    QueryTable.Ref AS Ref,\n    QueryTable.Key AS Key,\n    QueryTable.ItemKey AS ItemKey1,\n    QueryTable.Unit AS Unit,\n    QueryTable.Quantity1 AS Quantity1,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.ItemKeyWriteOff AS ItemKeyWriteOff,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.SerialLotNumber AS SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff AS SerialLotNumberWriteOff\nINTO R4052T_StockAdjustmentAsSurplus\nFROM\n    ItemList AS QueryTable\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 'Ref: Item stock adjustment' | 'No'      | 'No'      |
	// 		| 'ItemStockAdjustment' | 'R4051T_StockAdjustmentAsWriteOff' | 'Yes'      | 'TRUE'                                                                                                                                                                   | 'SELECT\n    QueryTable.Ref AS Ref,\n    QueryTable.Key AS Key,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Unit AS Unit,\n    QueryTable.Quantity1 AS Quantity1,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.ItemKeyWriteOff AS ItemKeyWriteOff,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.SerialLotNumber AS SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff AS SerialLotNumberWriteOff\nINTO R4051T_StockAdjustmentAsWriteOff\nFROM\n    ItemList AS QueryTable\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | 'Ref: Item stock adjustment' | 'No'      | 'No'      |
	// 		| 'ItemStockAdjustment' | 'R4014B_SerialLotNumber'           | 'Yes'      | 'Query Receipt:\nNOT SerialLotNumber = VALUE(Catalog.SerialLotNumbers.EmptyRef)\nQuery Expense:\nNOT SerialLotNumberWriteOff = VALUE(Catalog.SerialLotNumbers.EmptyRef)' | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.SerialLotNumber AS SerialLotNumber,\n    QueryTable.Ref AS Ref,\n    QueryTable.Key AS Key,\n    QueryTable.ItemKey AS ItemKey1,\n    QueryTable.Unit AS Unit,\n    QueryTable.Quantity1 AS Quantity1,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.ItemKeyWriteOff AS ItemKeyWriteOff,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.SerialLotNumber AS SerialLotNumber1,\n    QueryTable.SerialLotNumberWriteOff AS SerialLotNumberWriteOff\nINTO R4014B_SerialLotNumber\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.SerialLotNumber = VALUE(Catalog.SerialLotNumbers.EmptyRef)\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.SerialLotNumberWriteOff,\n    QueryTable.Ref,\n    QueryTable.Key,\n    QueryTable.ItemKey,\n    QueryTable.Unit,\n    QueryTable.Quantity1,\n    QueryTable.Quantity,\n    QueryTable.ItemKeyWriteOff,\n    QueryTable.Period,\n    QueryTable.Company,\n    QueryTable.Store,\n    QueryTable.SerialLotNumber,\n    QueryTable.SerialLotNumberWriteOff\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.SerialLotNumberWriteOff = VALUE(Catalog.SerialLotNumbers.EmptyRef)' | 'Ref: Item stock adjustment' | 'Yes'     | 'Yes'     |
		And I close all client application windows
		

Scenario: _0400011 check preparation
	When check preparation		
				


		

Scenario: _040002 check item stock adjustment movements by the Register  "R4010 Actual stocks"
	* Select item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 dated 27.01.2021 19:04:15'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'                     | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '5'           | 'Store 02'     | '36/Yellow'   | ''                     |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '10'          | 'Store 02'     | '37/18SD'     | ''                     |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '16'          | 'Store 02'     | 'XS/Blue'     | ''                     |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '5'           | 'Store 02'     | '38/Yellow'   | ''                     |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '10'          | 'Store 02'     | '38/18SD'     | ''                     |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '16'          | 'Store 02'     | 'S/Yellow'    | ''                     |
		And I close all client application windows

Scenario: _040003 check item stock adjustment (with serial lot numbers) movements by the Register  "R4010 Actual stocks"
	* Select item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 112 dated 20.05.2022 18:23:15'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                          | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                         | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                        | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                        | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                        | 'Receipt'       | '20.05.2022 18:23:15'   | '1'           | 'Store 02'     | 'UNIQ'       | ''                     |
			| ''                                                        | 'Receipt'       | '20.05.2022 18:23:15'   | '2'           | 'Store 02'     | 'PZU'        | '8908899877'           |
			| ''                                                        | 'Expense'       | '20.05.2022 18:23:15'   | '1'           | 'Store 02'     | 'UNIQ'       | ''                     |
			| ''                                                        | 'Expense'       | '20.05.2022 18:23:15'   | '2'           | 'Store 02'     | 'PZU'        | '8908899879'           |
		And I close all client application windows

Scenario: _040004 check item stock adjustment movements by the Register  "R4050 Stock inventory"
	* Select item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4050 Stock inventory" 
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 dated 27.01.2021 19:04:15'   | ''              | ''                      | ''            | ''               | ''           | ''             |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''               | ''           | ''             |
			| 'Register  "R4050 Stock inventory"'                   | ''              | ''                      | ''            | ''               | ''           | ''             |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''             |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'     |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '5'           | 'Main Company'   | 'Store 02'   | '36/Yellow'    |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '10'          | 'Main Company'   | 'Store 02'   | '37/18SD'      |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '16'          | 'Main Company'   | 'Store 02'   | 'XS/Blue'      |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '5'           | 'Main Company'   | 'Store 02'   | '38/Yellow'    |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '10'          | 'Main Company'   | 'Store 02'   | '38/18SD'      |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '16'          | 'Main Company'   | 'Store 02'   | 'S/Yellow'     |
		And I close all client application windows	
				
Scenario: _040005 check item stock adjustment movements by the Register  "R4011 Free stocks"
	* Select item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4050 Stock inventory" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 dated 27.01.2021 19:04:15'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                       | ''              | ''                      | ''            | ''             | ''             |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '5'           | 'Store 02'     | '36/Yellow'    |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '10'          | 'Store 02'     | '37/18SD'      |
			| ''                                                    | 'Receipt'       | '27.01.2021 19:04:15'   | '16'          | 'Store 02'     | 'XS/Blue'      |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '5'           | 'Store 02'     | '38/Yellow'    |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '10'          | 'Store 02'     | '38/18SD'      |
			| ''                                                    | 'Expense'       | '27.01.2021 19:04:15'   | '16'          | 'Store 02'     | 'S/Yellow'     |
		And I close all client application windows	
	
Scenario: _040006 check item stock adjustment movements by the Register  "R4052 Stock adjustment (Surplus)"
	* Select item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4052 Stock adjustment (Surplus)"
		And I click "Registrations report" button
		And I select "R4052 Stock adjustment (Surplus)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 dated 27.01.2021 19:04:15'   | ''                      | ''            | ''             | ''        | ''             |
			| 'Document registrations records'                      | ''                      | ''            | ''             | ''        | ''             |
			| 'Register  "R4052 Stock adjustment (Surplus)"'        | ''                      | ''            | ''             | ''        | ''             |
			| ''                                                    | 'Period'                | 'Resources'   | 'Dimensions'   | ''        | ''             |
			| ''                                                    | ''                      | 'Quantity'    | 'Store'        | 'Basis'   | 'Item key'     |
			| ''                                                    | '27.01.2021 19:04:15'   | '5'           | 'Store 02'     | ''        | '38/Yellow'    |
			| ''                                                    | '27.01.2021 19:04:15'   | '10'          | 'Store 02'     | ''        | '38/18SD'      |
			| ''                                                    | '27.01.2021 19:04:15'   | '16'          | 'Store 02'     | ''        | 'S/Yellow'     |
		And I close all client application windows	

Scenario: _040007 check item stock adjustment movements by the Register  "R4051 Stock adjustment (Write off)"
	* Select item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4052 Stock adjustment (Surplus)"
		And I click "Registrations report info" button
		And I select "R4051 Stock adjustment (Write off)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 dated 27.01.2021 19:04:15' | ''                    | ''         | ''      | ''          | ''         |
			| 'Register  "R4051 Stock adjustment (Write off)"'    | ''                    | ''         | ''      | ''          | ''         |
			| ''                                                  | 'Period'              | 'Store'    | 'Basis' | 'Item key'  | 'Quantity' |
			| ''                                                  | '27.01.2021 19:04:15' | 'Store 02' | ''      | 'XS/Blue'   | '16'       |
			| ''                                                  | '27.01.2021 19:04:15' | 'Store 02' | ''      | '36/Yellow' | '5'        |
			| ''                                                  | '27.01.2021 19:04:15' | 'Store 02' | ''      | '37/18SD'   | '10'       |		
		And I close all client application windows	

Scenario: _040012 item stock adjustment clear posting/mark for deletion
	* Select item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 dated 27.01.2021 19:04:15'    |
			| 'Document registrations records'                       |
		And I close current window
	* Post item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4052 Stock adjustment (Surplus)'    |
			| 'R4011 Free stocks'                   |
			| 'R4050 Stock inventory'               |
			| 'R4010 Actual stocks'                 |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Item stock adjustment 1 dated 27.01.2021 19:04:15'    |
			| 'Document registrations records'                       |
		And I close current window
	* Unmark for deletion and post item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4052 Stock adjustment (Surplus)'    |
			| 'R4011 Free stocks'                   |
			| 'R4050 Stock inventory'               |
			| 'R4010 Actual stocks'                 |
		And I close all client application windows

		
				


		


		
			
						
		
				
		
				

