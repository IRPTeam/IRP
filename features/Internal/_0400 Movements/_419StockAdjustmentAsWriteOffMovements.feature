#language: en
@tree
@Positive
@Movements2
@MovementsStockAdjustmentAsWriteOff


Feature: check Stock adjustment as write off movements


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _041900 preparation (StockAdjustmentAsWriteOff)
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
	* Load StockAdjustmentAsWriteOff
		When Create document StockAdjustmentAsWriteOff objects (check movements)
		When Create document StockAdjustmentAsWriteOff (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsWriteOff.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsWriteOff.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PhysicalInventory objects with StockAdjustmentAsWriteOff and StockAdjustmentAsSurplus (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.PhysicalInventory.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsWriteOff.FindByNumber(1201).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _0419001 check preparation
	When check preparation	

Scenario: _041901 check Stock adjustment as write off movements by the Register  "R4010 Actual stocks"
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'                                | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'                               | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                                              | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                                              | 'Expense'       | '15.03.2021 15:29:14'   | '2'           | 'Store 01'     | '38/Yellow'   | ''                     |
			| ''                                                              | 'Expense'       | '15.03.2021 15:29:14'   | '8'           | 'Store 01'     | 'M/White'     | ''                     |
		And I close all client application windows

Scenario: _041902 check Stock adjustment as write off movements by the Register  "R4011 Free stocks"
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'                                | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                                 | ''              | ''                      | ''            | ''             | ''             |
			| ''                                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                                              | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                                              | 'Expense'       | '15.03.2021 15:29:14'   | '2'           | 'Store 01'     | '38/Yellow'    |
			| ''                                                              | 'Expense'       | '15.03.2021 15:29:14'   | '8'           | 'Store 01'     | 'M/White'      |
		And I close all client application windows

Scenario: _041903 check Stock adjustment as write off movements by the Register  "R4050 Stock inventory"
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14'   | ''              | ''                      | ''            | ''                 | ''           | ''             |
			| 'Document registrations records'                                | ''              | ''                      | ''            | ''                 | ''           | ''             |
			| 'Register  "R4050 Stock inventory"'                             | ''              | ''                      | ''            | ''                 | ''           | ''             |
			| ''                                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'       | ''           | ''             |
			| ''                                                              | ''              | ''                      | 'Quantity'    | 'Company'          | 'Store'      | 'Item key'     |
			| ''                                                              | 'Expense'       | '15.03.2021 15:29:14'   | '2'           | 'Second Company'   | 'Store 01'   | '38/Yellow'    |
			| ''                                                              | 'Expense'       | '15.03.2021 15:29:14'   | '8'           | 'Second Company'   | 'Store 01'   | 'M/White'      |
		And I close all client application windows

Scenario: _041904 check Stock adjustment as write off with serial lot number movements by the Register  "R4010 Actual stocks"
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 1 112 dated 24.05.2022 14:10:25'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                                  | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                                 | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                                | 'Expense'       | '24.05.2022 14:10:25'   | '2'           | 'Store 01'     | 'UNIQ'       | ''                     |
			| ''                                                                | 'Expense'       | '24.05.2022 14:10:25'   | '5'           | 'Store 01'     | 'PZU'        | '8908899877'           |
			| ''                                                                | 'Expense'       | '24.05.2022 14:10:25'   | '5'           | 'Store 01'     | 'PZU'        | '8908899879'           |
		And I close all client application windows

Scenario: _041905 check Stock adjustment as write off movements by the Register  "R4032 Goods in transit (outgoing)" (without PhysicalInventory)
	And I close all client application windows
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)" 
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4032 Goods in transit (outgoing)"'    |
	And I close all client application windows

Scenario: _041906 check Stock adjustment as write off movements by the Register  "R4032 Goods in transit (outgoing)" (with PhysicalInventory)
	And I close all client application windows
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '1 201'     |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)" 
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 1 201 dated 11.08.2023 12:20:03' | ''            | ''                    | ''          | ''           | ''      | ''         |
			| 'Document registrations records'                                | ''            | ''                    | ''          | ''           | ''      | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"'                 | ''            | ''                    | ''          | ''           | ''      | ''         |
			| ''                                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''      | ''         |
			| ''                                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis' | 'Item key' |
			| ''                                                              | 'Expense'     | '11.08.2023 12:20:03' | '2'         | 'Store 06'   | ''      | 'XS/Blue'  |		
	And I close all client application windows


Scenario: _041907 check Stock adjustment as write off movements by the Register  "R4051 Stock adjustment (Write off)" (with PhysicalInventory)
	And I close all client application windows
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '1 201'     |
	* Check movements by the Register  "R4051 Stock adjustment (Write off)" 
		And I click "Registrations report" button
		And I select "R4051 Stock adjustment (Write off)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 1 201 dated 11.08.2023 12:20:03' | ''                    | ''          | ''           | ''                                                 | ''         |
			| 'Document registrations records'                                | ''                    | ''          | ''           | ''                                                 | ''         |
			| 'Register  "R4051 Stock adjustment (Write off)"'                | ''                    | ''          | ''           | ''                                                 | ''         |
			| ''                                                              | 'Period'              | 'Resources' | 'Dimensions' | ''                                                 | ''         |
			| ''                                                              | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                            | 'Item key' |
			| ''                                                              | '11.08.2023 12:20:03' | '2'         | 'Store 06'   | 'Physical inventory 201 dated 15.03.2021 15:29:31' | 'XS/Blue'  |		
	And I close all client application windows

Scenario: _041908 check Stock adjustment as write off movements by the Register  "R4051 Stock adjustment (Write off)" (without PhysicalInventory)
	And I close all client application windows
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'  |
			| '201'     |
	* Check movements by the Register  "R4051 Stock adjustment (Write off)" 
		And I click "Registrations report info" button
		And I select "R4051 Stock adjustment (Write off)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14' | ''                    | ''         | ''                                                            | ''          | ''         |
			| 'Register  "R4051 Stock adjustment (Write off)"'              | ''                    | ''         | ''                                                            | ''          | ''         |
			| ''                                                            | 'Period'              | 'Store'    | 'Basis'                                                       | 'Item key'  | 'Quantity' |
			| ''                                                            | '15.03.2021 15:29:14' | 'Store 01' | 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14' | 'M/White'   | '8'        |
			| ''                                                            | '15.03.2021 15:29:14' | 'Store 01' | 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14' | '38/Yellow' | '2'        |	
	And I close all client application windows


Scenario: _041930 Stock adjustment as write off clear posting/mark for deletion
	And I close all client application windows
	* Select Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14'    |
			| 'Document registrations records'                                 |
		And I close current window
	* Post Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'      |
			| 'R4010 Actual stocks'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as write-off 201 dated 15.03.2021 15:29:14'    |
			| 'Document registrations records'                                 |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'      |
			| 'R4010 Actual stocks'    |
		And I close all client application windows
