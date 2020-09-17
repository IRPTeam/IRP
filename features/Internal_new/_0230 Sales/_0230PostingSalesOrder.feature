#language: en
@tree
@Positive
@Group5
Feature: create document Sales order

As a sales manager
I want to create a Sales order document
To track the items ordered by the customer

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _023000 preparation (Sales order)
	* Constants
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	




Scenario: _023001 create document Sales order - Shipment confirmation is not used
	When create SalesOrder023001

Scenario: _023002 check Sales Order posting by register OrderBalance (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Order'          | 'Item key' |
	| '5,000'    | '$$SalesOrder023001$$' | 'Store 01' | '$$SalesOrder023001$$' | 'L/Green'  |
	| '4,000'    | '$$SalesOrder023001$$' | 'Store 01' | '$$SalesOrder023001$$' | '36/Yellow'   |

Scenario: _023003 check Sales Order posting by register StockReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | '$$SalesOrder023001$$' | 'Store 01' | 'L/Green'  |
	| '4,000'    | '$$SalesOrder023001$$' | 'Store 01' | '36/Yellow'   |

Scenario: _023004 check Sales Order posting by register OrderReservation (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | '$$SalesOrder023001$$' | 'Store 01' | 'L/Green'  |
	| '4,000'    | '$$SalesOrder023001$$' | 'Store 01' | '36/Yellow'   |

Scenario: _023005 create document Sales order - Shipment confirmation used
	When create SalesOrder023005

Scenario: _023006 check Sales Order posting by register OrderBalance (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
	| 'Quantity'  | 'Recorder'        | 'Store'    | 'Order'          | 'Item key' |
	| '10,000'    | '$$SalesOrder023005$$' | 'Store 02' | '$$SalesOrder023005$$' | 'L/Green'  |
	| '14,000'    | '$$SalesOrder023005$$' | 'Store 02' | '$$SalesOrder023005$$' | '36/Yellow'   |

Scenario: _023007 check Sales Order posting by register StockReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | '$$SalesOrder023005$$' | 'Store 02' | 'L/Green'  |
	| '14,000'    | '$$SalesOrder023005$$' | 'Store 02' | '36/Yellow'   |

Scenario: _023008 check Sales Order posting by register OrderReservation (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | '$$SalesOrder023005$$' | 'Store 02' | 'L/Green'  |
	| '14,000'    | '$$SalesOrder023005$$' | 'Store 02' | '36/Yellow'   |


Scenario: _023014 check movements by status and status history of a Sales Order document
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number'                     | 'Partner'   |
		| '$$NumberSalesOrder023001$$' | 'Ferron BP' |
	And I select current line in "List" table
	* Change status to Wait (doesn't post)
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Wait" exact value from "Status" drop-down list
	And I click "Post and close" button
	* Check the absence of movements Sales Order
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Recorder'       | 'Order'          |
			| '$$SalesOrder023001$$' |'$$SalesOrder023001$$'  |
			| '$$SalesOrder023001$$' |'$$SalesOrder023001$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table does not contain lines
			| 'Recorder'       |
			| '$$SalesOrder023001$$' |
			| '$$SalesOrder023001$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
		And "List" table does not contain lines
			| 'Recorder'       |
			| '$$SalesOrder023001$$' |
			| '$$SalesOrder023001$$' |
		And I close current window
	* Opening a previously created order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                    | 'Partner'   |
			| '$$NumberSalesOrder023001$$' | 'Ferron BP' |
		And I select current line in "List" table
	* Change sales order status to Approved
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'         | 'Status'   |
			| '$$SalesOrder023001$$' | 'Wait'     |
			| '$$SalesOrder023001$$' | 'Approved' |
		And I close current window
		And I click "Post and close" button
	* Check document movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Recorder'       | 'Order'          |
			| '$$SalesOrder023001$$' |'$$SalesOrder023001$$'  |
			| '$$SalesOrder023001$$' |'$$SalesOrder023001$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Recorder'       |
			| '$$SalesOrder023001$$' |
			| '$$SalesOrder023001$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
		And "List" table contains lines
			| 'Recorder'       |
			| '$$SalesOrder023001$$' |
			| '$$SalesOrder023001$$' |
		And I close current window



Scenario: _023101 displaying in the Sales order only available valid Partner terms for the selected customer
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And "List" table became equal
		| 'Description'                   |
		| 'Basic Partner terms, TRY'         |
		| 'Basic Partner terms, $'           |
		| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And "List" table became equal
		| 'Description'            |
		| 'Basic Partner terms, TRY'         |
		| 'Basic Partner terms, $'           |
		| 'Basic Partner terms, without VAT' |
		| 'Personal Partner terms, $' |
	And I close current window
	And I close current window
	And I click "No" button
	* Check that expired Partner terms are not displayed in the selection list
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I go to line in "List" table
		| 'Description'           |
		| 'Basic Partner terms, $' |
		And I select current line in "List" table
		And I input "02.11.2018" text in "End of use" field
		And I click "Save and close" button
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And "List" table became equal
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
		And I close current window
		And I close current window
		And I click "No" button
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, $' |
		And I select current line in "List" table
		And I input "02.11.2019" text in "End of use" field
		And I click "Save and close" button
		And I close current window

Scenario: _023102 select only your own companies in the Company field
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description' |
		| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'           |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And "List" table became equal
		| 'Description'  |
		| 'Main Company' |
	And I close current window
	And I close current window
	And I click "No" button

Scenario: _023103 filling in Company field from the Partner term
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'           |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	Then the form attribute named "Company" became equal to "Main Company"
	And I close current window
	And I click "No" button


Scenario: _023104 filling in Store field from the Partner term
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	Then the form attribute named "Store" became equal to "Store 02"
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'       |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	Then the form attribute named "Store" became equal to "Store 01"
	And I close current window
	And I click "No" button

Scenario: _023105 check that the Account field is missing from the order
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And field "Account" is not present on the form


Scenario: _023106 check the form of selection of items (sales order)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'       |
				| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description' |
				| 'Company Ferron BP'  |
		And I select current line in "List" table
	When check the product selection form with price information in Sales order
	And in the table "ItemList" I click "% Offers" button
	And in the table "Offers" I click the button named "FormOK"
	And I click "Post and close" button
	* Check Sales order Saving
		And "List" table contains lines
		| 'Currency'  | 'Partner'     | 'Status'   | 'Σ'         |
		| 'TRY'       | 'Ferron BP'   | 'Approved' | '2 050,00'  |
	And I close all client application windows




Scenario: _023113 check totals in the document Sales order
	* Open list form Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
	* Select Sales order
		And I go to line in "List" table
		| Number |
		| 1      |
		And I select current line in "List" table
	* Check for document results
		Then the form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "3 686,44"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "663,56"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "4 350,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"


