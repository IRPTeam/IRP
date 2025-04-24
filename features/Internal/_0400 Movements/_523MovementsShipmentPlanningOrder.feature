#language: en
@tree
@Positive
@Movements3
@MovementsShipmentPlanningOrder

Feature: check Shipment Planning Order Movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _052301 preparation (Shipment Planning Order)
	When set True value to the constant
	When set True value to the constant Use shipment and receipt planing orders
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
		When Create information register Taxes records (VAT)
		When create Sales Orders (Shipment Planning Order)
		* Repost SO
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I select all lines of "List" table
			And I click the button named "FormPost"
			And delay 1
	And I close all client application windows
		
Scenario: _052302 check preparation
	When check preparation		

Scenario: _052303 create SPO same with SO
	And I close all client application windows
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' | 'Partner'  | 'Amount'    |
			| '316'    | 'Lomaniti' | '5 000,00'  |
		And I select current line in "List" table
		And I delete "$$SalesOrder01$$" variable
		And I delete "$$NumberSalesOrder01$$" variable
		And I save the window as "$$SalesOrder01$$"
		And I save the value of "Number" field as "$$NumberSalesOrder01$$"
	* Create SPO
		And I click the button named "FormDocumentShipmentPlaningOrderGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click the button named "FormOk"
		And I click Choice button of the field named "ShipmentPeriod"
		And I input "01.04.2025" text in the field named "DateBegin"
		And I input "30.04.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click the button named "FormPost"
		And I delete "$$ShipmentPlaningOrder01$$" variable
		And I delete "$$NumberShipmentPlaningOrder01$$" variable
		And I save the window as "$$ShipmentPlaningOrder01$$"
		And I save the value of "Number" field as "$$NumberShipmentPlaningOrder01$$"
	* Check registers
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		Then "ResultTable" spreadsheet document is equal
			| '$$ShipmentPlaningOrder01$$'            | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "Posted documents registry"' | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Document'                   | 'Date'                                 | 'Number'                               | 'Create date'                          | 'Modify date'                          | 'Author'                               | 'Editor'                               | 'Manual movements edit' | ''                 | ''                 |
			| ''                                      | '$$ShipmentPlaningOrder01$$' | '*'                                    | '*'                                    | '*'                                    | ''                                     | '*'                                    | ''                                     | 'No'                    | ''                 | ''                 |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "R9610 Shipment planing"'    | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Period'                     | 'Company'                              | 'Branch'                               | 'Partner'                              | 'Store'                                | 'Item key'                             | 'Source of origin'                     | 'Order'                 | 'Planned quantity' | 'Shipped quantity' |
			| ''                                      | '*'                          | 'Main Company'                         | ''                                     | 'Lomaniti'                             | 'Store 01'                             | 'Chewing gum/Chewing gum'              | ''                                     | '$$SalesOrder01$$'      | ''                 | '1 000'            |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "T3010S Row ID info"'        | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Key'                        | 'Row ID'                               | 'Unique ID'                            | 'Basis'                                | 'Basis key'                            | 'Row ref'                              | 'Price'                                | 'Currency'              | 'Unit'             | ''                 |
			| ''                                      | '*'                          | '06c243aa-3ec3-4301-b062-21c7beb30762' | '*'                                    | '$$SalesOrder01$$'                     | '06c243aa-3ec3-4301-b062-21c7beb30762' | '06c243aa-3ec3-4301-b062-21c7beb30762' | ''                                     | ''                      | 'pcs'              | ''                 |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "TM1010B Row ID movements"'  | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Period'                     | 'RecordType'                           | 'Row ref'                              | 'Row ID'                               | 'Step'                                 | 'Basis'                                | 'Basis key'                            | 'Quantity'              | ''                 | ''                 |
			| ''                                      | '*'                          | 'Receipt'                              | '06c243aa-3ec3-4301-b062-21c7beb30762' | '06c243aa-3ec3-4301-b062-21c7beb30762' | 'SI&SC'                                | '$$ShipmentPlaningOrder01$$'           | '*'                                    | '1 000'                 | ''                 | ''                 |
			| ''                                      | '*'                          | 'Expense'                              | '06c243aa-3ec3-4301-b062-21c7beb30762' | '06c243aa-3ec3-4301-b062-21c7beb30762' | 'SI&SC&SPO'                            | '$$SalesOrder01$$'                     | '06c243aa-3ec3-4301-b062-21c7beb30762' | '1 000'                 | ''                 | ''                 |
	And I close all client application windows		
				
Scenario: _052304 create SPO with different Store
	And I close all client application windows
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' | 'Partner'  | 'Amount'    |
			| '317'    | 'Lomaniti' | '6 000,00'  |
		And I select current line in "List" table
		And I delete "$$SalesOrder02$$" variable
		And I delete "$$NumberSalesOrder02$$" variable
		And I save the window as "$$SalesOrder02$$"
		And I save the value of "Number" field as "$$NumberSalesOrder02$$"
	* Create SPO
		And I click the button named "FormDocumentShipmentPlaningOrderGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click the button named "FormOk"
		And I select from the drop-down list named "Store" by "Store 02" string
		Then "1C:Enterprise" window is opened
		And I click the button named "Button0"
		And I click Choice button of the field named "ShipmentPeriod"
		And I input "01.04.2025" text in the field named "DateBegin"
		And I input "30.04.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1 500,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table								
		And I click the button named "FormPost"
		And I delete "$$ShipmentPlaningOrder02$$" variable
		And I delete "$$NumberShipmentPlaningOrder02$$" variable
		And I save the window as "$$ShipmentPlaningOrder02$$"
		And I save the value of "Number" field as "$$NumberShipmentPlaningOrder02$$"
	* Check registers
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"				
		Then "ResultTable" spreadsheet document is equal
			| '$$ShipmentPlaningOrder02$$'            | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "Posted documents registry"' | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Document'                   | 'Date'                                 | 'Number'                               | 'Create date'                          | 'Modify date'                          | 'Author'                               | 'Editor'                               | 'Manual movements edit' | ''                 | ''                 |
			| ''                                      | '$$ShipmentPlaningOrder02$$' | '*'                                    | '*'                                    | '*'                                    | ''                                     | '*'                                    | ''                                     | 'No'                    | ''                 | ''                 |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "R9610 Shipment planing"'    | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Period'                     | 'Company'                              | 'Branch'                               | 'Partner'                              | 'Store'                                | 'Item key'                             | 'Source of origin'                     | 'Order'                 | 'Planned quantity' | 'Shipped quantity' |
			| ''                                      | '*'                          | 'Main Company'                         | ''                                     | 'Lomaniti'                             | 'Store 02'                             | 'Chewing gum/Chewing gum'              | ''                                     | '$$SalesOrder02$$'      | ''                 | '1 500'            |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "T3010S Row ID info"'        | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Key'                        | 'Row ID'                               | 'Unique ID'                            | 'Basis'                                | 'Basis key'                            | 'Row ref'                              | 'Price'                                | 'Currency'              | 'Unit'             | ''                 |
			| ''                                      | '*'                          | '2caf9482-91cd-4774-903e-b820d89d760f' | '*'                                    | '$$SalesOrder02$$'                     | '2caf9482-91cd-4774-903e-b820d89d760f' | '2caf9482-91cd-4774-903e-b820d89d760f' | ''                                     | ''                      | 'pcs'              | ''                 |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "TM1010B Row ID movements"'  | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Period'                     | 'RecordType'                           | 'Row ref'                              | 'Row ID'                               | 'Step'                                 | 'Basis'                                | 'Basis key'                            | 'Quantity'              | ''                 | ''                 |
			| ''                                      | '*'                          | 'Receipt'                              | '2caf9482-91cd-4774-903e-b820d89d760f' | '2caf9482-91cd-4774-903e-b820d89d760f' | 'SI&SC'                                | '$$ShipmentPlaningOrder02$$'           | '*'                                    | '1 500'                 | ''                 | ''                 |
			| ''                                      | '*'                          | 'Expense'                              | '2caf9482-91cd-4774-903e-b820d89d760f' | '2caf9482-91cd-4774-903e-b820d89d760f' | 'SI&SC&SPO'                            | '$$SalesOrder02$$'                     | '2caf9482-91cd-4774-903e-b820d89d760f' | '1 500'                 | ''                 | ''                 |
	And I close all client application windows		
										
Scenario: _052305 create SPO with different ItemKey
	And I close all client application windows
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' | 'Partner'  | 'Amount'    |
			| '318'    | 'Lomaniti' | '10 000,00' |
		And I select current line in "List" table
		And I delete "$$SalesOrder03$$" variable
		And I delete "$$NumberSalesOrder03$$" variable
		And I save the window as "$$SalesOrder03$$"
		And I save the value of "Number" field as "$$NumberSalesOrder03$$"
	* Create SPO
		And I click the button named "FormDocumentShipmentPlaningOrderGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click the button named "FormOk"
		And I click Choice button of the field named "ShipmentPeriod"
		And I input "01.04.2025" text in the field named "DateBegin"
		And I input "30.04.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I activate field named "ItemListItemKey" in "ItemList" table				
		And I select "Mint/Mango" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table						
		And I click the button named "FormPost"
		And I delete "$$ShipmentPlaningOrder03$$" variable
		And I delete "$$NumberShipmentPlaningOrder03$$" variable
		And I save the window as "$$ShipmentPlaningOrder03$$"
		And I save the value of "Number" field as "$$NumberShipmentPlaningOrder03$$"
	* Check registers
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"				
		Then "ResultTable" spreadsheet document is equal
			| '$$ShipmentPlaningOrder03$$'            | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "Posted documents registry"' | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Document'                   | 'Date'                                 | 'Number'                               | 'Create date'                          | 'Modify date'                          | 'Author'                               | 'Editor'                               | 'Manual movements edit' | ''                 | ''                 |
			| ''                                      | '$$ShipmentPlaningOrder03$$' | '*'                                    | '*'                                    | '*'                                    | ''                                     | '*'                                    | ''                                     | 'No'                    | ''                 | ''                 |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "R9610 Shipment planing"'    | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Period'                     | 'Company'                              | 'Branch'                               | 'Partner'                              | 'Store'                                | 'Item key'                             | 'Source of origin'                     | 'Order'                 | 'Planned quantity' | 'Shipped quantity' |
			| ''                                      | '*'                          | 'Main Company'                         | ''                                     | 'Lomaniti'                             | 'Store 01'                             | 'Mint/Mango'                           | ''                                     | '$$SalesOrder03$$'      | ''                 | '5 000'            |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "T3010S Row ID info"'        | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Key'                        | 'Row ID'                               | 'Unique ID'                            | 'Basis'                                | 'Basis key'                            | 'Row ref'                              | 'Price'                                | 'Currency'              | 'Unit'             | ''                 |
			| ''                                      | '*'                          | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | '*'                                    | '$$SalesOrder03$$'                     | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | ''                                     | ''                      | 'pcs'              | ''                 |
			| ''                                      | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| 'Register  "TM1010B Row ID movements"'  | ''                           | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                                     | ''                      | ''                 | ''                 |
			| ''                                      | 'Period'                     | 'RecordType'                           | 'Row ref'                              | 'Row ID'                               | 'Step'                                 | 'Basis'                                | 'Basis key'                            | 'Quantity'              | ''                 | ''                 |
			| ''                                      | '*'                          | 'Receipt'                              | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | 'SI&SC'                                | '$$ShipmentPlaningOrder03$$'           | '*'                                    | '5 000'                 | ''                 | ''                 |
			| ''                                      | '*'                          | 'Expense'                              | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | 'SI&SC&SPO'                            | '$$SalesOrder03$$'                     | '9dd30e29-95d5-4e48-8c03-2dbf2b1b8ef8' | '5 000'                 | ''                 | ''                 |
	And I close all client application windows

Scenario: _052306 create SPO
	And I close all client application windows
	* Create SPO
		Given I open hyperlink "e1cib/list/Document.ShipmentPlaningOrder"
		And I click the button named "FormCreate"
	* FIlling main info
		And I select from the drop-down list named "Partner" by "Lomaniti" string
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Store" by "Store 03" string
		And I click Choice button of the field named "ShipmentPeriod"
		And I input "01.04.2025" text in the field named "DateBegin"
		And I input "30.04.2025" text in the field named "DateEnd"
		And I click the button named "Select"
	* Add Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Skittles" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I input "10 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$ShipmentPlaningOrder04$$" variable
		And I delete "$$NumberShipmentPlaningOrder04$$" variable
		And I save the window as "$$ShipmentPlaningOrder04$$"
		And I save the value of "Number" field as "$$NumberShipmentPlaningOrder04$$"
	* Check registers
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		Then "ResultTable" spreadsheet document is equal
			| '$$ShipmentPlaningOrder04$$'            | ''                           | ''           | ''          | ''            | ''                                     | ''                           | ''          | ''                      | ''     |
			| 'Register  "Posted documents registry"' | ''                           | ''           | ''          | ''            | ''                                     | ''                           | ''          | ''                      | ''     |
			| ''                                      | 'Document'                   | 'Date'       | 'Number'    | 'Create date' | 'Modify date'                          | 'Author'                     | 'Editor'    | 'Manual movements edit' | ''     |
			| ''                                      | '$$ShipmentPlaningOrder04$$' | '*'          | '*'         | '*'           | ''                                     | '*'                          | ''          | 'No'                    | ''     |
			| ''                                      | ''                           | ''           | ''          | ''            | ''                                     | ''                           | ''          | ''                      | ''     |
			| 'Register  "T3010S Row ID info"'        | ''                           | ''           | ''          | ''            | ''                                     | ''                           | ''          | ''                      | ''     |
			| ''                                      | 'Key'                        | 'Row ID'     | 'Unique ID' | 'Basis'       | 'Basis key'                            | 'Row ref'                    | 'Price'     | 'Currency'              | 'Unit' |
			| ''                                      | '*'                          | '*'          | '*'         | ''            | '                                    ' | '*'                          | ''          | ''                      | 'pcs'  |
			| ''                                      | ''                           | ''           | ''          | ''            | ''                                     | ''                           | ''          | ''                      | ''     |
			| 'Register  "TM1010B Row ID movements"'  | ''                           | ''           | ''          | ''            | ''                                     | ''                           | ''          | ''                      | ''     |
			| ''                                      | 'Period'                     | 'RecordType' | 'Row ref'   | 'Row ID'      | 'Step'                                 | 'Basis'                      | 'Basis key' | 'Quantity'              | ''     |
			| ''                                      | '*'                          | 'Receipt'    | '*'         | '*'           | 'SI&SC'                                | '$$ShipmentPlaningOrder04$$' | '*'         | '10 000'                | ''     |
	And I close all client application windows		
				