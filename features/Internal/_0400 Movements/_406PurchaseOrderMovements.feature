#language: en
@tree
@Positive
@Movements
@MovementsPurchaseOrder


Feature: check Purchase order movements



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _040115 preparation (Purchase order)
	
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
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
		When Create catalog CancelReturnReasons objects
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	


// GR before PI, Use receipt sheduling

Scenario: _040116 check Purchase order movements by the Register  "R1012 Invoice closing of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders" 
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Register  "R1012 Invoice closing of purchase orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                             | ''         | ''          | ''                                     |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                        | 'Currency' | 'Item key'  | 'Row key'                              |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:44:43' | '2'         | '300'    | '254,24'     | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''         | 'Interner'  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:44:43' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''         | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:44:43' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''         | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' |	
		And I close all client application windows
		
Scenario: _040117 check Purchase order movements by the Register  "R4035 Incoming stocks"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4035 Incoming stocks" 
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43' | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Register  "R4035 Incoming stocks"'            | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          | ''                                             |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  | 'Order'                                        |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:43' | '5'         | 'Store 02'   | '36/Yellow' | 'Purchase order 115 dated 12.02.2021 12:44:43' |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:43' | '10'        | 'Store 02'   | 'S/Yellow'  | 'Purchase order 115 dated 12.02.2021 12:44:43' |	
		And I close all client application windows
		
Scenario: _040118 check Purchase order movements by the Register  "R2013 Procurement of sales orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2013 Procurement of sales orders"'                     |
			
		And I close all client application windows
		
Scenario: _040119 check Purchase order movements by the Register  "R1014 Canceled purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R1014 Canceled purchase orders" 
		And I click "Registrations report" button
		And I select "R1014 Canceled purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| 'Register  "R1014 Canceled purchase orders"'   | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| ''                                             | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | 'Attributes'           |
			| ''                                             | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                        | 'Item key' | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                             | '12.02.2021 12:44:43' | '8'         | '164,35' | '139,28'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/18SD'  | '62d24ced-315a-473c-b47a-5bc9c4a824e0' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '8'         | '960'    | '813,56'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/18SD'  | '62d24ced-315a-473c-b47a-5bc9c4a824e0' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '8'         | '960'    | '813,56'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/18SD'  | '62d24ced-315a-473c-b47a-5bc9c4a824e0' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '8'         | '960'    | '813,56'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/18SD'  | '62d24ced-315a-473c-b47a-5bc9c4a824e0' | 'not available' | 'No'                   |	
		And I close all client application windows
		
Scenario: _040120 check Purchase order movements by the Register  "R4016 Ordering of internal supply requests"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4016 Ordering of internal supply requests" 
		And I click "Registrations report" button
		And I select "R4016 Ordering of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4016 Ordering of internal supply requests"'    |
			
		And I close all client application windows
		
Scenario: _040121 check Purchase order movements by the Register  "R1010 Purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R1010 Purchase orders" 
		And I click "Registrations report" button
		And I select "R1010 Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| 'Register  "R1010 Purchase orders"'            | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| ''                                             | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                             | ''          | ''                                     | 'Attributes'           |
			| ''                                             | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                        | 'Item key'  | 'Row key'                              | 'Deferred calculation' |
			| ''                                             | '12.02.2021 12:44:43' | '2'         | '51,36'  | '43,53'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Interner'  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '2'         | '300'    | '254,24'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Interner'  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '2'         | '300'    | '254,24'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Interner'  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '2'         | '300'    | '254,24'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Interner'  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '5'         | '171,2'  | '145,09'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '10'        | '171,2'  | '145,09'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:43' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' | 'No'                   |	
		And I close all client application windows
		
Scenario: _040122 check Purchase order movements by the Register  "R4033 Scheduled goods receipts"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4033 Scheduled goods receipts" 
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43' | ''            | ''                    | ''          | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Register  "R4033 Scheduled goods receipts"'   | ''            | ''                    | ''          | ''             | ''                                             | ''         | ''          | ''                                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                             | ''         | ''          | ''                                     |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Basis'                                        | 'Store'    | 'Item key'  | 'Row key'                              |
			| ''                                             | 'Receipt'     | '12.02.2021 00:00:00' | '5'         | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Store 02' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' |
			| ''                                             | 'Receipt'     | '12.02.2021 00:00:00' | '10'        | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Store 02' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' |	
		And I close all client application windows
		
Scenario: _040123 check Purchase order movements by the Register  "R1011 Receipt of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R1011 Receipt of purchase orders" 
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43' | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Register  "R1011 Receipt of purchase orders"' | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                             | ''          |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                        | 'Item key'  |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:43' | '5'         | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:43' | '10'        | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  |
		And I close all client application windows
	

// GR before PI, not Use receipt sheduling

Scenario: _0401162 check Purchase order movements by the Register  "R1012 Invoice closing of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders" 
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 116 dated 12.02.2021 12:44:59'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Register  "R1012 Invoice closing of purchase orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                             | ''         | ''          | ''                                     |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                        | 'Currency' | 'Item key'  | 'Row key'                              |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:44:59' | '2'         | '300'    | '254,24'     | 'Main Company' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''         | 'Interner'  | '59a126c2-0ca4-4dad-b39b-606e75973f8e' |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:44:59' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''         | '36/Yellow' | '2f854b37-44db-469e-a5cb-6478adca5001' |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:44:59' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''         | 'S/Yellow'  | 'baf60337-67a7-4627-8518-6881217d1593' |	
		And I close all client application windows
		
Scenario: _0401172 check Purchase order movements by the Register  "R4035 Incoming stocks"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R4035 Incoming stocks" 
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 116 dated 12.02.2021 12:44:59' | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Register  "R4035 Incoming stocks"'            | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          | ''                                             |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  | 'Order'                                        |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:59' | '5'         | 'Store 02'   | '36/Yellow' | 'Purchase order 116 dated 12.02.2021 12:44:59' |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:59' | '10'        | 'Store 02'   | 'S/Yellow'  | 'Purchase order 116 dated 12.02.2021 12:44:59' |	
		And I close all client application windows
		
Scenario: _0401182 check Purchase order movements by the Register  "R2013 Procurement of sales orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2013 Procurement of sales orders"'                     |
			
		And I close all client application windows
		
Scenario: _0401192 check Purchase order movements by the Register  "R1014 Canceled purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R1014 Canceled purchase orders" 
		And I click "Registrations report" button
		And I select "R1014 Canceled purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 116 dated 12.02.2021 12:44:59' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| 'Register  "R1014 Canceled purchase orders"'   | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| ''                                             | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | 'Attributes'           |
			| ''                                             | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                        | 'Item key' | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                             | '12.02.2021 12:44:59' | '8'         | '164,35' | '139,28'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/18SD'  | '7b9432c6-b2fa-4763-b4ae-8cfaecd6fc7c' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '8'         | '960'    | '813,56'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/18SD'  | '7b9432c6-b2fa-4763-b4ae-8cfaecd6fc7c' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '8'         | '960'    | '813,56'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/18SD'  | '7b9432c6-b2fa-4763-b4ae-8cfaecd6fc7c' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '8'         | '960'    | '813,56'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/18SD'  | '7b9432c6-b2fa-4763-b4ae-8cfaecd6fc7c' | 'not available' | 'No'                   |	
		And I close all client application windows
		
Scenario: _0401202 check Purchase order movements by the Register  "R4016 Ordering of internal supply requests"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R4016 Ordering of internal supply requests" 
		And I click "Registrations report" button
		And I select "R4016 Ordering of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4016 Ordering of internal supply requests"'    |
			
		And I close all client application windows
		
Scenario: _0401212 check Purchase order movements by the Register  "R1010 Purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R1010 Purchase orders" 
		And I click "Registrations report" button
		And I select "R1010 Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 116 dated 12.02.2021 12:44:59' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| 'Register  "R1010 Purchase orders"'            | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| ''                                             | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                             | ''          | ''                                     | 'Attributes'           |
			| ''                                             | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                        | 'Item key'  | 'Row key'                              | 'Deferred calculation' |
			| ''                                             | '12.02.2021 12:44:59' | '2'         | '51,36'  | '43,53'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'Interner'  | '59a126c2-0ca4-4dad-b39b-606e75973f8e' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '2'         | '300'    | '254,24'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'Interner'  | '59a126c2-0ca4-4dad-b39b-606e75973f8e' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '2'         | '300'    | '254,24'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'Interner'  | '59a126c2-0ca4-4dad-b39b-606e75973f8e' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '2'         | '300'    | '254,24'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'Interner'  | '59a126c2-0ca4-4dad-b39b-606e75973f8e' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '5'         | '171,2'  | '145,09'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/Yellow' | '2f854b37-44db-469e-a5cb-6478adca5001' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/Yellow' | '2f854b37-44db-469e-a5cb-6478adca5001' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/Yellow' | '2f854b37-44db-469e-a5cb-6478adca5001' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '5'         | '1 000'  | '847,46'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/Yellow' | '2f854b37-44db-469e-a5cb-6478adca5001' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '10'        | '171,2'  | '145,09'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'S/Yellow'  | 'baf60337-67a7-4627-8518-6881217d1593' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'S/Yellow'  | 'baf60337-67a7-4627-8518-6881217d1593' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'S/Yellow'  | 'baf60337-67a7-4627-8518-6881217d1593' | 'No'                   |
			| ''                                             | '12.02.2021 12:44:59' | '10'        | '1 000'  | '847,46'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'S/Yellow'  | 'baf60337-67a7-4627-8518-6881217d1593' | 'No'                   |	
		And I close all client application windows
		
Scenario: _0401222 check Purchase order movements by the Register  "R4033 Scheduled goods receipts"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R4033 Scheduled goods receipts" 
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4033 Scheduled goods receipts"'   |
		And I close all client application windows
		
Scenario: _0401232 check Purchase order movements by the Register  "R1011 Receipt of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R1011 Receipt of purchase orders" 
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 116 dated 12.02.2021 12:44:59' | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Register  "R1011 Receipt of purchase orders"' | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                             | ''          |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                        | 'Item key'  |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:59' | '5'         | 'Main Company' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '36/Yellow' |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:59' | '10'        | 'Main Company' | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'S/Yellow'  |
		And I close all client application windows
	

// PI before GR, not Use receipt sheduling


Scenario: _0401163 check Purchase order movements by the Register  "R1012 Invoice closing of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders" 
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Register  "R1012 Invoice closing of purchase orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                             | ''         | ''          | ''                                     |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                             | ''         | ''          | ''                                     |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                        | 'Currency' | 'Item key'  | 'Row key'                              |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:45:05' | '2'         | '270'    | '228,81'     | 'Main Company' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''         | 'Interner'  | '1b90516b-b3ac-4ca5-bb47-44477975f242' |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:45:05' | '5'         | '900'    | '762,71'     | 'Main Company' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''         | '36/Yellow' | '923e7825-c20f-4a3e-a983-2b85d80e475a' |
			| ''                                                     | 'Receipt'     | '12.02.2021 12:45:05' | '10'        | '900'    | '762,71'     | 'Main Company' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''         | 'S/Yellow'  | '4fcbb4cf-3824-47fb-89b5-50d151315d4d' |
		And I close all client application windows
		
Scenario: _0401173 check Purchase order movements by the Register  "R4035 Incoming stocks"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R4035 Incoming stocks" 
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05' | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Register  "R4035 Incoming stocks"'            | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          | ''                                             |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  | 'Order'                                        |
			| ''                                             | 'Receipt'     | '12.02.2021 12:45:05' | '5'         | 'Store 02'   | '36/Yellow' | 'Purchase order 117 dated 12.02.2021 12:45:05' |
			| ''                                             | 'Receipt'     | '12.02.2021 12:45:05' | '10'        | 'Store 02'   | 'S/Yellow'  | 'Purchase order 117 dated 12.02.2021 12:45:05' |	
		And I close all client application windows
		
Scenario: _0401183 check Purchase order movements by the Register  "R2013 Procurement of sales orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2013 Procurement of sales orders"'                     |
			
		And I close all client application windows
		
Scenario: _0401193 check Purchase order movements by the Register  "R1014 Canceled purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R1014 Canceled purchase orders" 
		And I click "Registrations report" button
		And I select "R1014 Canceled purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| 'Register  "R1014 Canceled purchase orders"'   | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | ''                     |
			| ''                                             | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                             | ''         | ''                                     | ''              | 'Attributes'           |
			| ''                                             | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                        | 'Item key' | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                             | '12.02.2021 12:45:05' | '8'         | '147,92' | '125,35'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/18SD'  | 'b8237550-9ab5-42b0-ad04-792d3d748785' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '8'         | '864'    | '732,2'      | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/18SD'  | 'b8237550-9ab5-42b0-ad04-792d3d748785' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '8'         | '864'    | '732,2'      | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/18SD'  | 'b8237550-9ab5-42b0-ad04-792d3d748785' | 'not available' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '8'         | '864'    | '732,2'      | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/18SD'  | 'b8237550-9ab5-42b0-ad04-792d3d748785' | 'not available' | 'No'                   |	
		And I close all client application windows
		
Scenario: _0401203 check Purchase order movements by the Register  "R4016 Ordering of internal supply requests"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R4016 Ordering of internal supply requests" 
		And I click "Registrations report" button
		And I select "R4016 Ordering of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05'           | ''            | ''                    | ''          | ''             | ''         | ''                                                    | ''         |
			| 'Document registrations records'                         | ''            | ''                    | ''          | ''             | ''         | ''                                                    | ''         |
			| 'Register  "R4016 Ordering of internal supply requests"' | ''            | ''                    | ''          | ''             | ''         | ''                                                    | ''         |
			| ''                                                       | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                                    | ''         |
			| ''                                                       | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Internal supply request'                             | 'Item key' |
			| ''                                                       | 'Receipt'     | '12.02.2021 12:45:05' | '10'        | 'Main Company' | 'Store 02' | 'Internal supply request 1 dated 12.02.2021 14:39:38' | 'S/Yellow' |	
		And I close all client application windows
		
Scenario: _0401213 check Purchase order movements by the Register  "R1010 Purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R1010 Purchase orders" 
		And I click "Registrations report" button
		And I select "R1010 Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| 'Register  "R1010 Purchase orders"'            | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                             | ''          | ''                                     | ''                     |
			| ''                                             | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                             | ''          | ''                                     | 'Attributes'           |
			| ''                                             | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                        | 'Item key'  | 'Row key'                              | 'Deferred calculation' |
			| ''                                             | '12.02.2021 12:45:05' | '2'         | '46,22'  | '39,17'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'Interner'  | '1b90516b-b3ac-4ca5-bb47-44477975f242' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '2'         | '270'    | '228,81'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'Interner'  | '1b90516b-b3ac-4ca5-bb47-44477975f242' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '2'         | '270'    | '228,81'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'Interner'  | '1b90516b-b3ac-4ca5-bb47-44477975f242' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '2'         | '270'    | '228,81'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'Interner'  | '1b90516b-b3ac-4ca5-bb47-44477975f242' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '5'         | '154,08' | '130,58'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/Yellow' | '923e7825-c20f-4a3e-a983-2b85d80e475a' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '5'         | '900'    | '762,71'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/Yellow' | '923e7825-c20f-4a3e-a983-2b85d80e475a' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '5'         | '900'    | '762,71'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/Yellow' | '923e7825-c20f-4a3e-a983-2b85d80e475a' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '5'         | '900'    | '762,71'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/Yellow' | '923e7825-c20f-4a3e-a983-2b85d80e475a' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '10'        | '154,08' | '130,58'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'S/Yellow'  | '4fcbb4cf-3824-47fb-89b5-50d151315d4d' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '10'        | '900'    | '762,71'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'S/Yellow'  | '4fcbb4cf-3824-47fb-89b5-50d151315d4d' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '10'        | '900'    | '762,71'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'S/Yellow'  | '4fcbb4cf-3824-47fb-89b5-50d151315d4d' | 'No'                   |
			| ''                                             | '12.02.2021 12:45:05' | '10'        | '900'    | '762,71'     | 'Main Company' | 'en description is empty'      | ''         | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'S/Yellow'  | '4fcbb4cf-3824-47fb-89b5-50d151315d4d' | 'No'                   |
		And I close all client application windows
		
Scenario: _0401223 check Purchase order movements by the Register  "R4033 Scheduled goods receipts"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R4033 Scheduled goods receipts" 
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4033 Scheduled goods receipts"'   |
		And I close all client application windows
		
Scenario: _0401233 check Purchase order movements by the Register  "R1011 Receipt of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R1011 Receipt of purchase orders" 
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05' | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Register  "R1011 Receipt of purchase orders"' | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                             | ''          |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                        | 'Item key'  |
			| ''                                             | 'Receipt'     | '12.02.2021 12:45:05' | '5'         | 'Main Company' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '36/Yellow' |
			| ''                                             | 'Receipt'     | '12.02.2021 12:45:05' | '10'        | 'Main Company' | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'S/Yellow'  |
		And I close all client application windows


Scenario: _0401234 check Purchase order movements by the Register  "R1005 Special offers of purchases"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '117' |
	* Check movements by the Register  "R1005 Special offers of purchases" 
		And I click "Registrations report" button
		And I select "R1005 Special offers of purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'Register  "R1005 Special offers of purchases"' |
		And I close all client application windows
	
