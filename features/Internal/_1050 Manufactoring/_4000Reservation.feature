	#language: en
	@tree
	@Reservation

	Feature: Reservation

	Variables:
	Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


	Background:
		Given I open new TestClient session or connect the existing one



	Scenario: _4001 Reservation
		When set True value to the constant
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog Agreements objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create catalog Companies objects (Main company)
		When Create information register CurrencyRates records
		* Add plugin for taxes calculation
				Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				If "List" table does not contain lines Then
						| "Description"              |
						| "TaxCalculateVAT_TR"       |
					When add Plugin for tax calculation
				When Create information register Taxes records (VAT)
			* Tax settings
				When filling in Tax settings for company
		When set True value to the constant
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog ItemKeys objects (MF)
		When Create catalog ItemTypes objects (MF)
		When Create catalog Units objects (MF)
		When Create catalog Units objects
		When Create catalog Items objects (MF)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog Stores objects
		When Create catalog Companies objects (Main company)
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog Currencies objects
		When Create catalog BusinessUnits objects (MF)
		When Create catalog Countries objects
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When update ItemKeys
		When Create catalog MFBillOfMaterials objects
		When Create catalog PlanningPeriods objects (MF)
		When Create catalog ObjectStatuses objects
		When Create catalog ObjectStatuses objects (MF)
		When Create catalog Stores objects
		When Create document SalesOrder objects (MF)
		And I execute 1C:Enterprise script at server
			| "Doc = Documents.SalesOrder.FindByNumber(12).GetObject();"    |
			| "Doc.Write(DocumentWriteMode.Posting);"                       |
		When Create document ProductionPlanning objects (first period)
		When Create document PlannedReceiptReservation objects
		And I execute 1C:Enterprise script at server
				| "Doc = Documents.PlannedReceiptReservation.FindByNumber(1).GetObject();"     |
				| "Doc.Date = CurrentDate();"                                                  |
				| "Doc.Write(DocumentWriteMode.Posting);"                                      |
		* Check PlannedReceiptReservation movements
			Given I open hyperlink "e1cib/data/Document.PlannedReceiptReservation?ref=b76197e183b782dc11eb6bb2f008e2ac"
			And I delete "$$DatePlannedReceiptReservation4001$$" variable
			And I delete "$$PlannedReceiptReservation4001$$" variable
			And I save the value of "Date" field as "$$DatePlannedReceiptReservation4001$$"
			And I save the window as "$$PlannedReceiptReservation4001$$"	
			And I click "Registrations report" button
			* R4035 Incoming stocks
				And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
				And I click "Generate report" button
				Then "ResultTable" spreadsheet document contains lines
				| '$$PlannedReceiptReservation4001$$'    | ''               | ''                                         | ''             | ''              | ''                                 | ''                                                     |
				| 'Document registrations records'       | ''               | ''                                         | ''             | ''              | ''                                 | ''                                                     |
				| 'Register  "R4035 Incoming stocks"'    | ''               | ''                                         | ''             | ''              | ''                                 | ''                                                     |
				| ''                                     | 'Record type'    | 'Period'                                   | 'Resources'    | 'Dimensions'    | ''                                 | ''                                                     |
				| ''                                     | ''               | ''                                         | 'Quantity'     | 'Store'         | 'Item key'                         | 'Order'                                                |
				| ''                                     | 'Expense'        | '$$DatePlannedReceiptReservation4001$$'    | '45'           | 'Store 02'      | 'Стремянка номер 6 ступенчатая'    | 'Production planning 12 dated 01.01.2021 16:47:36'     |
			* R4036 Incoming stock requested
				And I select "R4036 Incoming stock requested" exact value from "Register" drop-down list
				And I click "Generate report" button
				Then "ResultTable" spreadsheet document contains lines
				| '$$PlannedReceiptReservation4001$$'             | ''               | ''                                         | ''             | ''                  | ''                   | ''                                 | ''                                                    | ''                                             |
				| 'Document registrations records'                | ''               | ''                                         | ''             | ''                  | ''                   | ''                                 | ''                                                    | ''                                             |
				| 'Register  "R4036 Incoming stock requested"'    | ''               | ''                                         | ''             | ''                  | ''                   | ''                                 | ''                                                    | ''                                             |
				| ''                                              | 'Record type'    | 'Period'                                   | 'Resources'    | 'Dimensions'        | ''                   | ''                                 | ''                                                    | ''                                             |
				| ''                                              | ''               | ''                                         | 'Quantity'     | 'Incoming store'    | 'Requester store'    | 'Item key'                         | 'Order'                                               | 'Requester'                                    |
				| ''                                              | 'Receipt'        | '$$DatePlannedReceiptReservation4001$$'    | '45'           | 'Store 01'          | 'Store 01'           | 'Стремянка номер 6 ступенчатая'    | 'Production planning 12 dated 01.01.2021 16:47:36'    | 'Sales order 12 dated 10.02.2021 17:38:12'     |
				| ''                                              | 'Receipt'        | '$$DatePlannedReceiptReservation4001$$'    | '45'           | 'Store 02'          | 'Store 02'           | 'Стремянка номер 6 ступенчатая'    | 'Production planning 12 dated 01.01.2021 16:47:36'    | 'Sales order 12 dated 10.02.2021 17:38:12'     |
		And I close all client application windows
		When Create document Production objects
		* Check MF_Production movements
			Given I open hyperlink "e1cib/data/Document.Production?ref=b76197e183b782dc11eb6c43c5882ddc"
			And I delete "$$DateProduction4001$$" variable
			And I delete "$$Production4001$$" variable
			And I save the value of the field named "Date" as "$$DateProduction4001$$"
			And I save the window as "$$Production4001$$"	
			And I click "Registrations report" button
			* R4012 Stock Reservation
				And I select "R4012 Stock Reservation" exact value from "Register" drop-down list		
				And I click "Generate report" button
				Then "ResultTable" spreadsheet document is equal
					| '$$Production4001$$'                      | ''                | ''                           | ''              | ''               | ''                                  | ''           |
					| 'Document registrations records'          | ''                | ''                           | ''              | ''               | ''                                  | ''           |
					| 'Register  "R4012 Stock Reservation"'     | ''                | ''                           | ''              | ''               | ''                                  | ''           |
					| ''                                        | 'Record type'     | 'Period'                     | 'Resources'     | 'Dimensions'     | ''                                  | ''           |
					| ''                                        | ''                | ''                           | 'Quantity'      | 'Store'          | 'Item key'                          | 'Order'      |
					| ''                                        | 'Receipt'         | '$$DateProduction4001$$'     | '40'            | 'Store 02'       | 'Стремянка номер 6 ступенчатая'     | ''           |
			* R4036 Incoming stock requested
				And I select "R4036 Incoming stock requested" exact value from "Register" drop-down list		
				And I click "Generate report" button
				Then "ResultTable" spreadsheet document is equal
					| '$$Production4001$$'                             | ''                | ''                           | ''              | ''                   | ''                    | ''                                  | ''                                                     | ''                                              |
					| 'Document registrations records'                 | ''                | ''                           | ''              | ''                   | ''                    | ''                                  | ''                                                     | ''                                              |
					| 'Register  "R4036 Incoming stock requested"'     | ''                | ''                           | ''              | ''                   | ''                    | ''                                  | ''                                                     | ''                                              |
					| ''                                               | 'Record type'     | 'Period'                     | 'Resources'     | 'Dimensions'         | ''                    | ''                                  | ''                                                     | ''                                              |
					| ''                                               | ''                | ''                           | 'Quantity'      | 'Incoming store'     | 'Requester store'     | 'Item key'                          | 'Order'                                                | 'Requester'                                     |
					| ''                                               | 'Expense'         | '$$DateProduction4001$$'     | '40'            | 'Store 02'           | 'Store 02'            | 'Стремянка номер 6 ступенчатая'     | 'Production planning 12 dated 01.01.2021 16:47:36'     | 'Sales order 12 dated 10.02.2021 17:38:12'      |
			And I close all client application windows
		When Create document InventoryTransfer objects (MF)
		And I execute 1C:Enterprise script at server
			| "Doc = Documents.InventoryTransfer.FindByNumber(12).GetObject();"    |
			| "Doc.Date = CurrentDate();"                                          |
			| "Doc.Write(DocumentWriteMode.Posting);"                              |
		* Check InventoryTransfer movements by Register "R4012 Stock Reservation"
			Given I open hyperlink "e1cib/data/Document.InventoryTransfer?ref=b76197e183b782dc11eb6c544959f30e"
			And I delete "$$DateInventoryTransfer4001$$" variable
			And I delete "$$InventoryTransfer4001$$" variable
			And I save the value of the field named "Date" as "$$DateInventoryTransfer4001$$"
			And I save the window as "$$InventoryTransfer4001$$"	
			// And I click "Registrations report" button
			// And I select "R4012 Stock Reservation" exact value from "Register" drop-down list		
			// And I click "Generate report" button
			// Then "ResultTable" spreadsheet document is equal
			// 	| '$$InventoryTransfer4001$$'           | ''            | ''                              | ''          | ''                        | ''         | ''                                                 |
			// 	| 'Document registrations records'      | ''            | ''                              | ''          | ''                        | ''         | ''                                                 |
			// 	| 'Register  "R4012 Stock Reservation"' | ''            | ''                              | ''          | ''                        | ''         | ''                                                 |
			// 	| ''                                    | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'              | ''         | ''                                                 |
			// 	| ''                                    | ''            | ''                              | 'Quantity'  | 'Store'                   | 'Item key' | 'Order'                                            |
			// 	| ''                                    | 'Expense'     | '$$DateInventoryTransfer4001$$' | '40'        | 'Store 02' | 'Perilla'  | 'Production planning 12 dated 01.01.2021 16:47:36' |
			// And I close all client application windows
		When Create document GoodsReceipt objects (MF)
		And I execute 1C:Enterprise script at server
			| "Doc = Documents.GoodsReceipt.FindByNumber(12).GetObject();"    |
			| "Doc.Date = CurrentDate();"                                     |
			| "Doc.Write(DocumentWriteMode.Posting);"                         |
		* Check GoodsReceipt movements
			Given I open hyperlink "e1cib/data/Document.GoodsReceipt?ref=b76197e183b782dc11eb6c544959f30f"
			And I delete "$$DateGoodsReceipt4001$$" variable
			And I delete "$$GoodsReceipt4001$$" variable
			And I save the value of the field named "Date" as "$$DateGoodsReceipt4001$$"
			And I save the window as "$$GoodsReceipt4001$$"	
			And I click "Registrations report" button
			* R4036 Incoming stock requested
				And I select "R4036 Incoming stock requested" exact value from "Register" drop-down list
				And I click "Generate report" button		
				Then "ResultTable" spreadsheet document contains lines
					| 'Register  "R4036 Incoming stock requested"'     | ''                | ''                             | ''              | ''                   | ''                    | ''                                  | ''                                                     | ''                                              |
					| ''                                               | 'Record type'     | 'Period'                       | 'Resources'     | 'Dimensions'         | ''                    | ''                                  | ''                                                     | ''                                              |
					| ''                                               | ''                | ''                             | 'Quantity'      | 'Incoming store'     | 'Requester store'     | 'Item key'                          | 'Order'                                                | 'Requester'                                     |
					| ''                                               | 'Expense'         | '$$DateGoodsReceipt4001$$'     | '40'            | 'Store 01'           | 'Store 01'            | 'Стремянка номер 6 ступенчатая'     | 'Production planning 12 dated 01.01.2021 16:47:36'     | 'Sales order 12 dated 10.02.2021 17:38:12'      |
			* R4011 Free stocks
				And I select "R4011 Free stocks" exact value from "Register" drop-down list
				And I click "Generate report" button
				Then "ResultTable" spreadsheet document contains lines
					| '$$GoodsReceipt4001$$'               | ''                | ''                             | ''              | ''               | ''                                   |
					| 'Document registrations records'     | ''                | ''                             | ''              | ''               | ''                                   |
					| 'Register  "R4011 Free stocks"'      | ''                | ''                             | ''              | ''               | ''                                   |
					| ''                                   | 'Record type'     | 'Period'                       | 'Resources'     | 'Dimensions'     | ''                                   |
					| ''                                   | ''                | ''                             | 'Quantity'      | 'Store'          | 'Item key'                           |
					| ''                                   | 'Receipt'         | '$$DateGoodsReceipt4001$$'     | '40'            | 'Store 01'       | 'Стремянка номер 6 ступенчатая'      |
					| ''                                   | 'Expense'         | '$$DateGoodsReceipt4001$$'     | '40'            | 'Store 01'       | 'Стремянка номер 6 ступенчатая'      |
			* R4012 Stock Reservation
				And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
				And I click "Generate report" button
				Then "ResultTable" spreadsheet document contains lines
					| '$$GoodsReceipt4001$$'                    | ''                | ''                             | ''              | ''               | ''                                  | ''                                              |
					| 'Document registrations records'          | ''                | ''                             | ''              | ''               | ''                                  | ''                                              |
					| 'Register  "R4012 Stock Reservation"'     | ''                | ''                             | ''              | ''               | ''                                  | ''                                              |
					| ''                                        | 'Record type'     | 'Period'                       | 'Resources'     | 'Dimensions'     | ''                                  | ''                                              |
					| ''                                        | ''                | ''                             | 'Quantity'      | 'Store'          | 'Item key'                          | 'Order'                                         |
					| ''                                        | 'Receipt'         | '$$DateGoodsReceipt4001$$'     | '40'            | 'Store 01'       | 'Стремянка номер 6 ступенчатая'     | 'Sales order 12 dated 10.02.2021 17:38:12'      |
			And I close all client application windows
			






		
		
