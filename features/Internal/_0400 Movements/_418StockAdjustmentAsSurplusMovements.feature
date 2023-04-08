﻿#language: en
@tree
@Positive
@Movements2
@MovementsStockAdjustmentAsSurplus


Feature: check Stock adjustment as surplus movements


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _041800 preparation (StockAdjustmentAsSurplus)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create document StockAdjustmentAsSurplus objects (stock control serial lot numbers)
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Load StockAdjustmentAsSurplus
		When Create document StockAdjustmentAsSurplus objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsSurplus.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsSurplus.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _0418001 check preparation
	When check preparation	

Scenario: _041801 check Stock adjustment as surplus movements by the Register  "R4010 Actual stocks"
	* Select Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as surplus 201 dated 01.03.2021 12:00:00' | ''            | ''                    | ''          | ''           | ''         | ''         |
			| 'Document registrations records'                            | ''            | ''                    | ''          | ''           | ''         | ''         |
			| 'Register  "R4010 Actual stocks"'                           | ''            | ''                    | ''          | ''           | ''         | ''         |
			| ''                                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''         |
			| ''                                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '4'         | 'Store 05'   | '36/18SD'  | ''  |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '7'         | 'Store 05'   | '36/Red'   | ''   |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '8'         | 'Store 05'   | 'XS/Blue'  | ''  |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '8'         | 'Store 05'   | 'M/White'  | ''  |	
		And I close all client application windows

Scenario: _041802 check Stock adjustment as surplus movements by the Register  "R4011 Free stocks"
	* Select Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as surplus 201 dated 01.03.2021 12:00:00' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                             | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '4'         | 'Store 05'   | '36/18SD'  |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '7'         | 'Store 05'   | '36/Red'   |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '8'         | 'Store 05'   | 'XS/Blue'  |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '8'         | 'Store 05'   | 'M/White'  |
		And I close all client application windows

Scenario: _041803 check Stock adjustment as surplus movements by the Register  "R4050 Stock inventory"
	* Select Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as surplus 201 dated 01.03.2021 12:00:00' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'                            | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'                         | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '4'         | 'Main Company' | 'Store 05' | '36/18SD'  |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '7'         | 'Main Company' | 'Store 05' | '36/Red'   |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '8'         | 'Main Company' | 'Store 05' | 'XS/Blue'  |
			| ''                                                          | 'Receipt'     | '01.03.2021 12:00:00' | '8'         | 'Main Company' | 'Store 05' | 'M/White'  |
		And I close all client application windows

Scenario: _041804 check Stock adjustment as surplus movements by the Register  "R4010 Actual stocks"
	* Select Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '1 112' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as surplus 1 112 dated 20.05.2022 17:19:31' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'                              | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'                             | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                                            | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                                            | 'Receipt'     | '20.05.2022 17:19:31' | '5'         | 'Store 02'   | 'PZU'      | '8908899877'        |
			| ''                                                            | 'Receipt'     | '20.05.2022 17:19:31' | '5'         | 'Store 02'   | 'PZU'      | '8908899879'        |
			| ''                                                            | 'Receipt'     | '20.05.2022 17:19:31' | '10'        | 'Store 02'   | 'XL/Green' | ''                  |
			| ''                                                            | 'Receipt'     | '20.05.2022 17:19:31' | '10'        | 'Store 02'   | 'UNIQ'     | ''                  |	
		And I close all client application windows


Scenario: _041830 Stock adjustment as surplus clear posting/mark for deletion
	And I close all client application windows
	* Select Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as surplus 201 dated 01.03.2021 12:00:00' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks' |
			| 'R4010 Actual stocks' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Stock adjustment as surplus 201 dated 01.03.2021 12:00:00' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks' |
			| 'R4010 Actual stocks' |
		And I close all client application windows
