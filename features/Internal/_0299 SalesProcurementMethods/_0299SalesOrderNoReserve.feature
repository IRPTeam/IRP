#language: en
@tree
@Positive
@SalesOrderProcurement

Feature: create Sales order without reserve and check shipment

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: _029900 preparation (create Sales order without reserve)
	When set True value to the constant
	* Load info
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
		When  Create catalog Partners objects (Lomaniti)
		When  Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)



Scenario: _0299001 check preparation
	When check preparation

Scenario: _029901 create Sales order without reserve and check its movements (SO-SI)
	And I close all client application windows
	* Open form for create order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling the document heading
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Lomaniti'       |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'         |
			| 'Company Lomaniti'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Filling items tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "31,000" text in "Quantity" field of "ItemList" table
		And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "40,000" text in "Quantity" field of "ItemList" table
		And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Save number
		And I input end of the current month date in "Delivery date" field
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder029901$$" variable
		And I delete "$$SalesOrder029901$$" variable
		And I delete "$$DateSalesOrder029901$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029901$$"
		And I save the window as "$$SalesOrder029901$$"
		And I save the value of the field named "Date" as "$$DateSalesOrder029901$$" 
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029901$$'    |
		And I click "Registrations report" button	
	* Check SO movements (Register  "R2010 Sales orders")
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesOrder029901$$'             | ''                           | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | ''                        |
			| 'Document registrations records'   | ''                           | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | ''                        |
			| 'Register  "R2010 Sales orders"'   | ''                           | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | ''                        |
			| ''                                 | 'Period'                     | 'Resources'   | ''           | ''             | ''                | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | 'Attributes'              |
			| ''                                 | ''                           | 'Quantity'    | 'Amount'     | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Order'                  | 'Item key'    | 'Row key'   | 'Procurement method'   | 'Sales person'   | 'Deferred calculation'    |
			| ''                                 | '$$DateSalesOrder029901$$'   | '31'          | '2 122,88'   | '1 799,05'     | ''                | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | '$$SalesOrder029901$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029901$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | '$$SalesOrder029901$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029901$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | '$$SalesOrder029901$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029901$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | '$$SalesOrder029901$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029901$$'   | '40'          | '2 396,8'    | '2 031,19'     | ''                | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | '$$SalesOrder029901$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029901$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | '$$SalesOrder029901$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029901$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | '$$SalesOrder029901$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029901$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | '$$SalesOrder029901$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
	* Check SO movements Register  "R2011 Shipment of sales orders")
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesOrder029901$$'                       | ''            | ''                         | ''          | ''             | ''       | ''                     | ''          | ''        |
			| 'Document registrations records'             | ''            | ''                         | ''          | ''             | ''       | ''                     | ''          | ''        |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                         | ''          | ''             | ''       | ''                     | ''          | ''        |
			| ''                                           | 'Record type' | 'Period'                   | 'Resources' | 'Dimensions'   | ''       | ''                     | ''          | ''        |
			| ''                                           | ''            | ''                         | 'Quantity'  | 'Company'      | 'Branch' | 'Order'                | 'Item key'  | 'Row key' |
			| ''                                           | 'Receipt'     | '$$DateSalesOrder029901$$' | '31'        | 'Main Company' | ''       | '$$SalesOrder029901$$' | '38/Yellow' | '*'       |
			| ''                                           | 'Receipt'     | '$$DateSalesOrder029901$$' | '40'        | 'Main Company' | ''       | '$$SalesOrder029901$$' | '38/Black'  | '*'       |

	* Check SO movements Register  ("Register  "R2012 Invoice closing of sales orders")
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesOrder029901$$'                                | ''              | ''                           | ''            | ''         | ''             | ''               | ''         | ''                       | ''           | ''            | ''           |
			| 'Document registrations records'                      | ''              | ''                           | ''            | ''         | ''             | ''               | ''         | ''                       | ''           | ''            | ''           |
			| 'Register  "R2012 Invoice closing of sales orders"'   | ''              | ''                           | ''            | ''         | ''             | ''               | ''         | ''                       | ''           | ''            | ''           |
			| ''                                                    | 'Record type'   | 'Period'                     | 'Resources'   | ''         | ''             | 'Dimensions'     | ''         | ''                       | ''           | ''            | ''           |
			| ''                                                    | ''              | ''                           | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'   | 'Order'                  | 'Currency'   | 'Item key'    | 'Row key'    |
			| ''                                                    | 'Receipt'       | '$$DateSalesOrder029901$$'   | '31'          | '12 400'   | '10 508,47'    | 'Main Company'   | ''         | '$$SalesOrder029901$$'   | 'TRY'        | '38/Yellow'   | '*'          |
			| ''                                                    | 'Receipt'       | '$$DateSalesOrder029901$$'   | '40'          | '14 000'   | '11 864,41'    | 'Main Company'   | ''         | '$$SalesOrder029901$$'   | 'TRY'        | '38/Black'    | '*'          |
	
	And I close all client application windows

Scenario: _029902 create SI for SO without reserve and check its movements (SO-SI)
	And I close all client application windows
	* Create SI 
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029901$$'    |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029901$$" variable
		And I delete "$$SalesInvoice029901$$" variable
		And I delete "$$DateSalesInvoice029901$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029901$$"	
		And I save the value of the field named "Date" as "$$DateSalesInvoice029901$$"
		And I save the window as "$$SalesInvoice029901$$"
		And I click "Registrations report" button	
	* Check SI movements (Register  "R5010 Reconciliation statement")
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice029901$$'                       | ''              | ''                             | ''            | ''               | ''         | ''           | ''                   | ''                       |
			| 'Document registrations records'               | ''              | ''                             | ''            | ''               | ''         | ''           | ''                   | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                             | ''            | ''               | ''         | ''           | ''                   | ''                       |
			| ''                                             | 'Record type'   | 'Period'                       | 'Resources'   | 'Dimensions'     | ''         | ''           | ''                   | ''                       |
			| ''                                             | ''              | ''                             | 'Amount'      | 'Company'        | 'Branch'   | 'Currency'   | 'Legal name'         | 'Legal name contract'    |
			| ''                                             | 'Receipt'       | '$$DateSalesInvoice029901$$'   | '26 400'      | 'Main Company'   | ''         | 'TRY'        | 'Company Lomaniti'   | ''                       |
	
	* Check SI movements (Register  "R4010 Actual stocks")
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice029901$$'            | ''              | ''                             | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'    | ''              | ''                             | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'   | ''              | ''                             | ''            | ''             | ''            | ''                     |
			| ''                                  | 'Record type'   | 'Period'                       | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                  | ''              | ''                             | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                  | 'Expense'       | '$$DateSalesInvoice029901$$'   | '31'          | 'Store 01'     | '38/Yellow'   | ''                     |
			| ''                                  | 'Expense'       | '$$DateSalesInvoice029901$$'   | '40'          | 'Store 01'     | '38/Black'    | ''                     |

	* Check SI movements (Register  "R2011 Shipment of sales orders")
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice029901$$'                     | ''            | ''                           | ''          | ''             | ''       | ''                     | ''          | ''        |
		| 'Document registrations records'             | ''            | ''                           | ''          | ''             | ''       | ''                     | ''          | ''        |
		| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                           | ''          | ''             | ''       | ''                     | ''          | ''        |
		| ''                                           | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''       | ''                     | ''          | ''        |
		| ''                                           | ''            | ''                           | 'Quantity'  | 'Company'      | 'Branch' | 'Order'                | 'Item key'  | 'Row key' |
		| ''                                           | 'Expense'     | '$$DateSalesInvoice029901$$' | '31'        | 'Main Company' | ''       | '$$SalesOrder029901$$' | '38/Yellow' | '*'       |
		| ''                                           | 'Expense'     | '$$DateSalesInvoice029901$$' | '40'        | 'Main Company' | ''       | '$$SalesOrder029901$$' | '38/Black'  | '*'       |

	* Check SI movements (Register  "R4050 Stock inventory")
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice029901$$'             | ''             | ''                            | ''           | ''              | ''          | ''            |
		| 'Document registrations records'     | ''             | ''                            | ''           | ''              | ''          | ''            |
		| 'Register  "R4050 Stock inventory"'  | ''             | ''                            | ''           | ''              | ''          | ''            |
		| ''                                   | 'Record type'  | 'Period'                      | 'Resources'  | 'Dimensions'    | ''          | ''            |
		| ''                                   | ''             | ''                            | 'Quantity'   | 'Company'       | 'Store'     | 'Item key'    |
		| ''                                   | 'Expense'      | '$$DateSalesInvoice029901$$'  | '31'         | 'Main Company'  | 'Store 01'  | '38/Yellow'   |
		| ''                                   | 'Expense'      | '$$DateSalesInvoice029901$$'  | '40'         | 'Main Company'  | 'Store 01'  | '38/Black'    |

	* Check SI movements (Register  "Register  "R2001 Sales")
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice029901$$'          | ''                            | ''           | ''          | ''            | ''               | ''              | ''        | ''                              | ''          | ''                        | ''           |''                 | ''         | ''               |
		| 'Document registrations records'  | ''                            | ''           | ''          | ''            | ''               | ''              | ''        | ''                              | ''          | ''                        | ''           |''                 | ''         | ''               |
		| 'Register  "R2001 Sales"'         | ''                            | ''           | ''          | ''            | ''               | ''              | ''        | ''                              | ''          | ''                        | ''           |''                 | ''         | ''               |
		| ''                                | 'Period'                      | 'Resources'  | ''          | ''            | ''               | 'Dimensions'    | ''        | ''                              | ''          | ''                        | ''           |''                 | ''         | ''               |
		| ''                                | ''                            | 'Quantity'   | 'Amount'    | 'Net amount'  | 'Offers amount'  | 'Company'       | 'Branch'  | 'Multi currency movement type'  | 'Currency'  | 'Invoice'                 | 'Item key'   |'Serial lot number'| 'Row key'  | 'Sales person'   |
		| ''                                | '$$DateSalesInvoice029901$$'  | '31'         | '2 122,88'  | '1 799,05'    | ''               | 'Main Company'  | ''        | 'Reporting currency'            | 'USD'       | '$$SalesInvoice029901$$'  | '38/Yellow'  |''                 | '*'        | ''               |
		| ''                                | '$$DateSalesInvoice029901$$'  | '31'         | '12 400'    | '10 508,47'   | ''               | 'Main Company'  | ''        | 'Local currency'                | 'TRY'       | '$$SalesInvoice029901$$'  | '38/Yellow'  |''                 | '*'        | ''               |
		| ''                                | '$$DateSalesInvoice029901$$'  | '31'         | '12 400'    | '10 508,47'   | ''               | 'Main Company'  | ''        | 'TRY'                           | 'TRY'       | '$$SalesInvoice029901$$'  | '38/Yellow'  |''                 | '*'        | ''               |
		| ''                                | '$$DateSalesInvoice029901$$'  | '31'         | '12 400'    | '10 508,47'   | ''               | 'Main Company'  | ''        | 'en description is empty'       | 'TRY'       | '$$SalesInvoice029901$$'  | '38/Yellow'  |''                 | '*'        | ''               |
		| ''                                | '$$DateSalesInvoice029901$$'  | '40'         | '2 396,8'   | '2 031,19'    | ''               | 'Main Company'  | ''        | 'Reporting currency'            | 'USD'       | '$$SalesInvoice029901$$'  | '38/Black'   |''                 | '*'        | ''               |
		| ''                                | '$$DateSalesInvoice029901$$'  | '40'         | '14 000'    | '11 864,41'   | ''               | 'Main Company'  | ''        | 'Local currency'                | 'TRY'       | '$$SalesInvoice029901$$'  | '38/Black'   |''                 | '*'        | ''               |
		| ''                                | '$$DateSalesInvoice029901$$'  | '40'         | '14 000'    | '11 864,41'   | ''               | 'Main Company'  | ''        | 'TRY'                           | 'TRY'       | '$$SalesInvoice029901$$'  | '38/Black'   |''                 | '*'        | ''               |
		| ''                                | '$$DateSalesInvoice029901$$'  | '40'         | '14 000'    | '11 864,41'   | ''               | 'Main Company'  | ''        | 'en description is empty'       | 'TRY'       | '$$SalesInvoice029901$$'  | '38/Black'   |''                 | '*'        | ''               |

	* Check SI movements (Register  "R2021 Customer transactions")
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice029901$$'                   | ''             | ''                            | ''           | ''              | ''        | ''                              | ''          | ''                      | ''                  | ''          | ''                          | ''                        | ''                      | ''          | ''                      | ''                             |
		| 'Document registrations records'           | ''             | ''                            | ''           | ''              | ''        | ''                              | ''          | ''                      | ''                  | ''          | ''                          | ''                        | ''                      | ''          | ''                      | ''                             |
		| 'Register  "R2021 Customer transactions"'  | ''             | ''                            | ''           | ''              | ''        | ''                              | ''          | ''                      | ''                  | ''          | ''                          | ''                        | ''                      | ''          | ''                      | ''                             |
		| ''                                         | 'Record type'  | 'Period'                      | 'Resources'  | 'Dimensions'    | ''        | ''                              | ''          | ''                      | ''                  | ''          | ''                          | ''                        | ''                      | ''          | 'Attributes'            | ''                             |
		| ''                                         | ''             | ''                            | 'Amount'     | 'Company'       | 'Branch'  | 'Multi currency movement type'  | 'Currency'  | 'Transaction currency'  | 'Legal name'        | 'Partner'   | 'Agreement'                 | 'Basis'                   | 'Order'                 | 'Project'   | 'Deferred calculation'  | 'Customers advances closing'   |
		| ''                                         | 'Receipt'      | '$$DateSalesInvoice029901$$'  | '4 519,68'   | 'Main Company'  | ''        | 'Reporting currency'            | 'USD'       | 'TRY'                   | 'Company Lomaniti'  | 'Lomaniti'  | 'Basic Partner terms, TRY'  | '$$SalesInvoice029901$$'  | '$$SalesOrder029901$$'  | ''          | 'No'                    | ''                             |
		| ''                                         | 'Receipt'      | '$$DateSalesInvoice029901$$'  | '26 400'     | 'Main Company'  | ''        | 'Local currency'                | 'TRY'       | 'TRY'                   | 'Company Lomaniti'  | 'Lomaniti'  | 'Basic Partner terms, TRY'  | '$$SalesInvoice029901$$'  | '$$SalesOrder029901$$'  | ''          | 'No'                    | ''                             |
		| ''                                         | 'Receipt'      | '$$DateSalesInvoice029901$$'  | '26 400'     | 'Main Company'  | ''        | 'TRY'                           | 'TRY'       | 'TRY'                   | 'Company Lomaniti'  | 'Lomaniti'  | 'Basic Partner terms, TRY'  | '$$SalesInvoice029901$$'  | '$$SalesOrder029901$$'  | ''          | 'No'                    | ''                             |
		| ''                                         | 'Receipt'      | '$$DateSalesInvoice029901$$'  | '26 400'     | 'Main Company'  | ''        | 'en description is empty'       | 'TRY'       | 'TRY'                   | 'Company Lomaniti'  | 'Lomaniti'  | 'Basic Partner terms, TRY'  | '$$SalesInvoice029901$$'  | '$$SalesOrder029901$$'  | ''          | 'No'                    | ''                             |
	* Check SI movements (Register  "R2040 Taxes incoming")
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$SalesInvoice029901$$'           | ''            | ''                           | ''          | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| 'Document registrations records'   | ''            | ''                           | ''          | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| 'Register  "R2040 Taxes incoming"' | ''            | ''                           | ''          | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| ''                                 | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| ''                                 | ''            | ''                           | 'Amount'    | 'Company'      | 'Branch' | 'Tax' | 'Tax rate' | 'Invoice type' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' |
			| ''                                 | 'Receipt'     | '$$DateSalesInvoice029901$$' | '323,83'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Reporting currency'           | 'USD'      | 'TRY'                  |
			| ''                                 | 'Receipt'     | '$$DateSalesInvoice029901$$' | '365,61'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Reporting currency'           | 'USD'      | 'TRY'                  |
			| ''                                 | 'Receipt'     | '$$DateSalesInvoice029901$$' | '1 891,53'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Local currency'               | 'TRY'      | 'TRY'                  |
			| ''                                 | 'Receipt'     | '$$DateSalesInvoice029901$$' | '1 891,53'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'en description is empty'      | 'TRY'      | 'TRY'                  |
			| ''                                 | 'Receipt'     | '$$DateSalesInvoice029901$$' | '2 135,59'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Local currency'               | 'TRY'      | 'TRY'                  |
			| ''                                 | 'Receipt'     | '$$DateSalesInvoice029901$$' | '2 135,59'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'en description is empty'      | 'TRY'      | 'TRY'                  |
	* Check SI movements (Register  "R4050 Stock inventory")
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice029901$$'             | ''             | ''                            | ''           | ''              | ''          | ''            |
		| 'Document registrations records'     | ''             | ''                            | ''           | ''              | ''          | ''            |
		| 'Register  "R4050 Stock inventory"'  | ''             | ''                            | ''           | ''              | ''          | ''            |
		| ''                                   | 'Record type'  | 'Period'                      | 'Resources'  | 'Dimensions'    | ''          | ''            |
		| ''                                   | ''             | ''                            | 'Quantity'   | 'Company'       | 'Store'     | 'Item key'    |
		| ''                                   | 'Expense'      | '$$DateSalesInvoice029901$$'  | '31'         | 'Main Company'  | 'Store 01'  | '38/Yellow'   |
		| ''                                   | 'Expense'      | '$$DateSalesInvoice029901$$'  | '40'         | 'Main Company'  | 'Store 01'  | '38/Black'    |
	* Check SI movements (Register  "R2011 Shipment of sales orders")
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice029901$$'                     | ''            | ''                           | ''          | ''             | ''       | ''                     | ''          | ''        |
		| 'Document registrations records'             | ''            | ''                           | ''          | ''             | ''       | ''                     | ''          | ''        |
		| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                           | ''          | ''             | ''       | ''                     | ''          | ''        |
		| ''                                           | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''       | ''                     | ''          | ''        |
		| ''                                           | ''            | ''                           | 'Quantity'  | 'Company'      | 'Branch' | 'Order'                | 'Item key'  | 'Row key' |
		| ''                                           | 'Expense'     | '$$DateSalesInvoice029901$$' | '31'        | 'Main Company' | ''       | '$$SalesOrder029901$$' | '38/Yellow' | '*'       |
		| ''                                           | 'Expense'     | '$$DateSalesInvoice029901$$' | '40'        | 'Main Company' | ''       | '$$SalesOrder029901$$' | '38/Black'  | '*'       |
	* Check SI movements (Register  "R4011B Free stocks")
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "R4011 Free stocks"'   | ''   | ''   | ''   | ''   | ''    |
	// * Check that there is no movements in the Register  "R2013 Procurement of sales orders"
	// 	And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
	// 	And I click "Generate report" button
	// 	And "ResultTable" spreadsheet document does not contain values
	// 		| 'Register  "R2013 Procurement of sales orders"' | '' | '' | '' | '' | '' |

		And I close all client application windows


Scenario: _029903 create Sales order without reserve and check its movements (SO-SC-SI)
	And I close all client application windows
	* Open form for create order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling the document heading
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Lomaniti'       |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'         |
			| 'Company Lomaniti'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	* Filling items tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "31,000" text in "Quantity" field of "ItemList" table
		And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "40,000" text in "Quantity" field of "ItemList" table
		And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Save number
		And I move to "Other" tab
		And I input end of the current month date in "Delivery date" field	
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder029903$$" variable
		And I delete "$$SalesOrder029903$$" variable
		And I delete "$$DateSalesOrder029903$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029903$$"
		And I save the window as "$$SalesOrder029903$$"
		And I save the value of the field named "Date" as "$$DateSalesOrder029903$$" 
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029903$$'    |
		And I click "Registrations report" button	
	* Check SO movements (Register  "R2010 Sales orders")
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesOrder029903$$'             | ''                           | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | ''                        |
			| 'Document registrations records'   | ''                           | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | ''                        |
			| 'Register  "R2010 Sales orders"'   | ''                           | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | ''                        |
			| ''                                 | 'Period'                     | 'Resources'   | ''           | ''             | ''                | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''            | ''          | ''                     | ''               | 'Attributes'              |
			| ''                                 | ''                           | 'Quantity'    | 'Amount'     | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Order'                  | 'Item key'    | 'Row key'   | 'Procurement method'   | 'Sales person'   | 'Deferred calculation'    |
			| ''                                 | '$$DateSalesOrder029903$$'   | '31'          | '2 122,88'   | '1 799,05'     | ''                | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | '$$SalesOrder029903$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029903$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | '$$SalesOrder029903$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029903$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | '$$SalesOrder029903$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029903$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | '$$SalesOrder029903$$'   | '38/Yellow'   | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029903$$'   | '40'          | '2 396,8'    | '2 031,19'     | ''                | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | '$$SalesOrder029903$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029903$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | '$$SalesOrder029903$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029903$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | '$$SalesOrder029903$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
			| ''                                 | '$$DateSalesOrder029903$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | '$$SalesOrder029903$$'   | '38/Black'    | '*'         | 'No reserve'           | ''               | 'No'                      |
	* Check SO movements Register  "R2011 Shipment of sales orders")
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesOrder029903$$'                       | ''            | ''                         | ''          | ''             | ''       | ''                     | ''          | ''        |
			| 'Document registrations records'             | ''            | ''                         | ''          | ''             | ''       | ''                     | ''          | ''        |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                         | ''          | ''             | ''       | ''                     | ''          | ''        |
			| ''                                           | 'Record type' | 'Period'                   | 'Resources' | 'Dimensions'   | ''       | ''                     | ''          | ''        |
			| ''                                           | ''            | ''                         | 'Quantity'  | 'Company'      | 'Branch' | 'Order'                | 'Item key'  | 'Row key' |
			| ''                                           | 'Receipt'     | '$$DateSalesOrder029903$$' | '31'        | 'Main Company' | ''       | '$$SalesOrder029903$$' | '38/Yellow' | '*'       |
			| ''                                           | 'Receipt'     | '$$DateSalesOrder029903$$' | '40'        | 'Main Company' | ''       | '$$SalesOrder029903$$' | '38/Black'  | '*'       |

	* Check SO movements Register  "Register  "R2012 Invoice closing of sales orders")
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesOrder029903$$'                                | ''              | ''                           | ''            | ''         | ''             | ''               | ''         | ''                       | ''           | ''            | ''           |
			| 'Document registrations records'                      | ''              | ''                           | ''            | ''         | ''             | ''               | ''         | ''                       | ''           | ''            | ''           |
			| 'Register  "R2012 Invoice closing of sales orders"'   | ''              | ''                           | ''            | ''         | ''             | ''               | ''         | ''                       | ''           | ''            | ''           |
			| ''                                                    | 'Record type'   | 'Period'                     | 'Resources'   | ''         | ''             | 'Dimensions'     | ''         | ''                       | ''           | ''            | ''           |
			| ''                                                    | ''              | ''                           | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'   | 'Order'                  | 'Currency'   | 'Item key'    | 'Row key'    |
			| ''                                                    | 'Receipt'       | '$$DateSalesOrder029903$$'   | '31'          | '12 400'   | '10 508,47'    | 'Main Company'   | ''         | '$$SalesOrder029903$$'   | 'TRY'        | '38/Yellow'   | '*'          |
			| ''                                                    | 'Receipt'       | '$$DateSalesOrder029903$$'   | '40'          | '14 000'   | '11 864,41'    | 'Main Company'   | ''         | '$$SalesOrder029903$$'   | 'TRY'        | '38/Black'    | '*'          |
	
		And I close all client application windows		

Scenario: _029904 create Shipment confirmation for SO without reserve and check its movements (SO-SC-SI)
		And I close all client application windows
		* Create SC 
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number'                         |
				| '$$NumberSalesOrder029903$$'     |
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			And I click "Ok" button	
			And I click the button named "FormPost"
			And I delete "$$NumberShipmentConfirmation029903$$" variable
			And I delete "$$ShipmentConfirmation029903$$" variable
			And I delete "$$DateShipmentConfirmation029903$$" variable
			And I save the value of "Number" field as "$$NumberShipmentConfirmation029903$$"
			And I save the window as "$$ShipmentConfirmation029903$$"
			And I save the value of the field named "Date" as  "$$DateShipmentConfirmation029903$$"
			And I click "Registrations report" button
		* Check SC movements Register  "Register  "R4010 Actual stocks")
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$ShipmentConfirmation029903$$'    | ''              | ''                                     | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'    | ''              | ''                                     | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'   | ''              | ''                                     | ''            | ''             | ''            | ''                     |
			| ''                                  | 'Record type'   | 'Period'                               | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                  | ''              | ''                                     | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                  | 'Expense'       | '$$DateShipmentConfirmation029903$$'   | '31'          | 'Store 02'     | '38/Yellow'   | ''                     |
			| ''                                  | 'Expense'       | '$$DateShipmentConfirmation029903$$'   | '40'          | 'Store 02'     | '38/Black'    | ''                     |
	
	
		* Check SC movements Register  "R2031 Shipment invoicing"
			And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$ShipmentConfirmation029903$$'         | ''              | ''                                     | ''            | ''               | ''         | ''           | ''                                 | ''             |
			| 'Document registrations records'         | ''              | ''                                     | ''            | ''               | ''         | ''           | ''                                 | ''             |
			| 'Register  "R2031 Shipment invoicing"'   | ''              | ''                                     | ''            | ''               | ''         | ''           | ''                                 | ''             |
			| ''                                       | 'Record type'   | 'Period'                               | 'Resources'   | 'Dimensions'     | ''         | ''           | ''                                 | ''             |
			| ''                                       | ''              | ''                                     | 'Quantity'    | 'Company'        | 'Branch'   | 'Store'      | 'Basis'                            | 'Item key'     |
			| ''                                       | 'Receipt'       | '$$DateShipmentConfirmation029903$$'   | '31'          | 'Main Company'   | ''         | 'Store 02'   | '$$ShipmentConfirmation029903$$'   | '38/Yellow'    |
			| ''                                       | 'Receipt'       | '$$DateShipmentConfirmation029903$$'   | '40'          | 'Main Company'   | ''         | 'Store 02'   | '$$ShipmentConfirmation029903$$'   | '38/Black'     |
		* Check SC movements Register  "R2011 Shipment of sales orders"
			And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$ShipmentConfirmation029903$$'             | ''            | ''                                   | ''          | ''             | ''       | ''                     | ''          | ''        |
				| 'Document registrations records'             | ''            | ''                                   | ''          | ''             | ''       | ''                     | ''          | ''        |
				| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                                   | ''          | ''             | ''       | ''                     | ''          | ''        |
				| ''                                           | 'Record type' | 'Period'                             | 'Resources' | 'Dimensions'   | ''       | ''                     | ''          | ''        |
				| ''                                           | ''            | ''                                   | 'Quantity'  | 'Company'      | 'Branch' | 'Order'                | 'Item key'  | 'Row key' |
				| ''                                           | 'Expense'     | '$$DateShipmentConfirmation029903$$' | '31'        | 'Main Company' | ''       | '$$SalesOrder029903$$' | '38/Yellow' | '*'       |
				| ''                                           | 'Expense'     | '$$DateShipmentConfirmation029903$$' | '40'        | 'Main Company' | ''       | '$$SalesOrder029903$$' | '38/Black'  | '*'       |
		* Check SC movements Register  "R4011B_FreeStocks")
			And I select "R4011 Free stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$ShipmentConfirmation029903$$'    | ''               | ''                                      | ''             | ''              | ''              |
				| 'Document registrations records'    | ''               | ''                                      | ''             | ''              | ''              |
				| 'Register  "R4011 Free stocks"'     | ''               | ''                                      | ''             | ''              | ''              |
				| ''                                  | 'Record type'    | 'Period'                                | 'Resources'    | 'Dimensions'    | ''              |
				| ''                                  | ''               | ''                                      | 'Quantity'     | 'Store'         | 'Item key'      |
				| ''                                  | 'Expense'        | '$$DateShipmentConfirmation029903$$'    | '31'           | 'Store 02'      | '38/Yellow'     |
				| ''                                  | 'Expense'        | '$$DateShipmentConfirmation029903$$'    | '40'           | 'Store 02'      | '38/Black'      |
		
		And I close all client application windows
	

Scenario: _029905 create Sales ivoice for SO (SC first) without reserve and check its movements (SO-SC-SI)
		And I close all client application windows
		* Create SI 
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number'                         |
				| '$$NumberSalesOrder029903$$'     |
			And I click the button named "FormDocumentSalesInvoiceGenerate"
			And I click "Ok" button	
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice029903$$" variable
			And I delete "$$SalesInvoice029903$$" variable
			And I delete "$$DateSalesInvoice029903$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice029903$$"
			And I save the window as "$$SalesInvoice029903$$"
			And I save the value of the field named "Date" as "$$DateSalesInvoice029903$$"
			And I click "Registrations report" button
		* Check SI movements (Register  "R5010 Reconciliation statement")
			And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice029903$$'                        | ''               | ''                              | ''             | ''                | ''          | ''            | ''                    | ''                        |
				| 'Document registrations records'                | ''               | ''                              | ''             | ''                | ''          | ''            | ''                    | ''                        |
				| 'Register  "R5010 Reconciliation statement"'    | ''               | ''                              | ''             | ''                | ''          | ''            | ''                    | ''                        |
				| ''                                              | 'Record type'    | 'Period'                        | 'Resources'    | 'Dimensions'      | ''          | ''            | ''                    | ''                        |
				| ''                                              | ''               | ''                              | 'Amount'       | 'Company'         | 'Branch'    | 'Currency'    | 'Legal name'          | 'Legal name contract'     |
				| ''                                              | 'Receipt'        | '$$DateSalesInvoice029903$$'    | '26 400'       | 'Main Company'    | ''          | 'TRY'         | 'Company Lomaniti'    | ''                        |
		* Check SI movements (Register  "R2011 Shipment of sales orders")
			And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document does not contain values
				| 'Register  "R2011 Shipment of sales orders"'   | ''              | ''                             | ''            | ''               | ''         | ''                       | ''             |
				| ''                                             | 'Record type'   | 'Period'                       | 'Resources'   | 'Dimensions'     | ''         | ''                       | ''             |
				| ''                                             | ''              | ''                             | 'Quantity'    | 'Company'        | 'Branch'   | 'Order'                  | 'Item key'     |
				| ''                                             | 'Expense'       | '$$DateSalesInvoice029903$$'   | '31'          | 'Main Company'   | ''         | '$$SalesOrder029903$$'   | '38/Yellow'    |
				| ''                                             | 'Expense'       | '$$DateSalesInvoice029903$$'   | '40'          | 'Main Company'   | ''         | '$$SalesOrder029903$$'   | '38/Black'     |
		* Check SI movements (Register  "R4050 Stock inventory")
			And I select "R4050 Stock inventory" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice029903$$'              | ''              | ''                             | ''            | ''               | ''           | ''             |
				| 'Document registrations records'      | ''              | ''                             | ''            | ''               | ''           | ''             |
				| 'Register  "R4050 Stock inventory"'   | ''              | ''                             | ''            | ''               | ''           | ''             |
				| ''                                    | 'Record type'   | 'Period'                       | 'Resources'   | 'Dimensions'     | ''           | ''             |
				| ''                                    | ''              | ''                             | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'     |
				| ''                                    | 'Expense'       | '$$DateSalesInvoice029903$$'   | '31'          | 'Main Company'   | 'Store 02'   | '38/Yellow'    |
				| ''                                    | 'Expense'       | '$$DateSalesInvoice029903$$'   | '40'          | 'Main Company'   | 'Store 02'   | '38/Black'     |
		* Check SI movements (Register  "Register  "R2001 Sales")
			And I select "R2001 Sales" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice029903$$'           | ''                             | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                         | ''            |''                 | ''          | ''                |
				| 'Document registrations records'   | ''                             | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                         | ''            |''                 | ''          | ''                |
				| 'Register  "R2001 Sales"'          | ''                             | ''            | ''           | ''             | ''                | ''               | ''         | ''                               | ''           | ''                         | ''            |''                 | ''          | ''                |
				| ''                                 | 'Period'                       | 'Resources'   | ''           | ''             | ''                | 'Dimensions'     | ''         | ''                               | ''           | ''                         | ''            |''                 | ''          | ''                |
				| ''                                 | ''                             | 'Quantity'    | 'Amount'     | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                  | 'Item key'    |'Serial lot number'|  'Row key'   | 'Sales person'    |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '31'          | '2 122,88'   | '1 799,05'     | ''                | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | '$$SalesInvoice029903$$'   | '38/Yellow'   |''                 | '*'         | ''                |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | '$$SalesInvoice029903$$'   | '38/Yellow'   |''                 | '*'         | ''                |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | '$$SalesInvoice029903$$'   | '38/Yellow'   |''                 | '*'         | ''                |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '31'          | '12 400'     | '10 508,47'    | ''                | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | '$$SalesInvoice029903$$'   | '38/Yellow'   |''                 | '*'         | ''                |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '40'          | '2 396,8'    | '2 031,19'     | ''                | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | '$$SalesInvoice029903$$'   | '38/Black'    |''                 | '*'         | ''                |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | '$$SalesInvoice029903$$'   | '38/Black'    |''                 | '*'         | ''                |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | '$$SalesInvoice029903$$'   | '38/Black'    |''                 | '*'         | ''                |
				| ''                                 | '$$DateSalesInvoice029903$$'   | '40'          | '14 000'     | '11 864,41'    | ''                | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | '$$SalesInvoice029903$$'   | '38/Black'    |''                 | '*'         | ''                |
		* Check SI movements (Register  "R2021 Customer transactions")
			And I select "R2021 Customer transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice029903$$'                    | ''              | ''                             | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                         | ''                       | ''           | ''                       | ''                              |
				| 'Document registrations records'            | ''              | ''                             | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                         | ''                       | ''           | ''                       | ''                              |
				| 'Register  "R2021 Customer transactions"'   | ''              | ''                             | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                         | ''                       | ''           | ''                       | ''                              |
				| ''                                          | 'Record type'   | 'Period'                       | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                         | ''                       | ''           | 'Attributes'             | ''                              |
				| ''                                          | ''              | ''                             | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'         | 'Partner'    | 'Agreement'                  | 'Basis'                    | 'Order'                  | 'Project'    | 'Deferred calculation'   | 'Customers advances closing'    |
				| ''                                          | 'Receipt'       | '$$DateSalesInvoice029903$$'   | '4 519,68'    | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | '$$SalesInvoice029903$$'   | '$$SalesOrder029903$$'   | ''           | 'No'                     | ''                              |
				| ''                                          | 'Receipt'       | '$$DateSalesInvoice029903$$'   | '26 400'      | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | '$$SalesInvoice029903$$'   | '$$SalesOrder029903$$'   | ''           | 'No'                     | ''                              |
				| ''                                          | 'Receipt'       | '$$DateSalesInvoice029903$$'   | '26 400'      | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | '$$SalesInvoice029903$$'   | '$$SalesOrder029903$$'   | ''           | 'No'                     | ''                              |
				| ''                                          | 'Receipt'       | '$$DateSalesInvoice029903$$'   | '26 400'      | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | '$$SalesInvoice029903$$'   | '$$SalesOrder029903$$'   | ''           | 'No'                     | ''                              |
		* Check SI movements (Register  "R2040 Taxes incoming")
			And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| '$$SalesInvoice029903$$'           | ''            | ''                           | ''          | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
				| 'Document registrations records'   | ''            | ''                           | ''          | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
				| 'Register  "R2040 Taxes incoming"' | ''            | ''                           | ''          | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
				| ''                                 | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     |
				| ''                                 | ''            | ''                           | 'Amount'    | 'Company'      | 'Branch' | 'Tax' | 'Tax rate' | 'Invoice type' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' |
				| ''                                 | 'Receipt'     | '$$DateSalesInvoice029903$$' | '323,83'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Reporting currency'           | 'USD'      | 'TRY'                  |
				| ''                                 | 'Receipt'     | '$$DateSalesInvoice029903$$' | '365,61'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Reporting currency'           | 'USD'      | 'TRY'                  |
				| ''                                 | 'Receipt'     | '$$DateSalesInvoice029903$$' | '1 891,53'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Local currency'               | 'TRY'      | 'TRY'                  |
				| ''                                 | 'Receipt'     | '$$DateSalesInvoice029903$$' | '1 891,53'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'en description is empty'      | 'TRY'      | 'TRY'                  |
				| ''                                 | 'Receipt'     | '$$DateSalesInvoice029903$$' | '2 135,59'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Local currency'               | 'TRY'      | 'TRY'                  |
				| ''                                 | 'Receipt'     | '$$DateSalesInvoice029903$$' | '2 135,59'  | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'en description is empty'      | 'TRY'      | 'TRY'                  |		
		* Check SI movements (Register  "R4050 Stock inventory")
			And I select "R4050 Stock inventory" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice029903$$'              | ''              | ''                             | ''            | ''               | ''           | ''             |
			| 'Document registrations records'      | ''              | ''                             | ''            | ''               | ''           | ''             |
			| 'Register  "R4050 Stock inventory"'   | ''              | ''                             | ''            | ''               | ''           | ''             |
			| ''                                    | 'Record type'   | 'Period'                       | 'Resources'   | 'Dimensions'     | ''           | ''             |
			| ''                                    | ''              | ''                             | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'     |
			| ''                                    | 'Expense'       | '$$DateSalesInvoice029903$$'   | '31'          | 'Main Company'   | 'Store 02'   | '38/Yellow'    |
			| ''                                    | 'Expense'       | '$$DateSalesInvoice029903$$'   | '40'          | 'Main Company'   | 'Store 02'   | '38/Black'     |
		// * Check that there is no movements in the Register  "R2013 Procurement of sales orders"
		// 	And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		// 	And I click "Generate report" button
		// 	And "ResultTable" spreadsheet document does not contain values
		// 		| 'Register  "R2013 Procurement of sales orders"' |
	
		* Check SI movements (Register  "R4010 Actual stocks")
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document does not contain values
				| 'Register  "R4010 Actual stocks"'     |
		* Check SI movements (Register  "R4011B Free stocks")
			And I select "R4011 Free stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document does not contain values
				| 'Register "R4011 Free stocks"'     |
			And I close all client application windows
			
			

				
		
