#language: en
@tree
@Positive
@StressTesting

Feature: check Bank receipt movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043400 preparation (StressTesting)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog PriceTypes objects
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
		When Create catalog Items objects (stress testing)
		When Create catalog ItemKeys objects (stress testing)
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
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
	When Create document SalesInvoice objects (stress testing, 1000 strings)
	When Create document SalesInvoice objects (stress testing, 100strings)	
	When Create document PurchaseInvoice objects (stress testing, 1000 strings)
	When Create document PurchaseInvoice objects (stress testing, 100strings)



Scenario: _9900005 post Sales invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows	

Scenario: _9900006 open Sales invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And I wait "Sales invoice 1 dated 22.04.2021 14:25:08" window opening in "50" seconds
	And I close all client application windows

Scenario: _9900007 change Sales invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Second Company' |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company' |
	And I select current line in "List" table	
	And I close all client application windows


Scenario: _9900008 calculate offer Sales invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And in the table "ItemList" I click "% Offers" button
	And I activate "%" field in "Offers" table
	And I select current line in "Offers" table
	And I input "10,00" text in "Percent" field
	And I click "Ok" button
	And in the table "Offers" I click "OK" button
	And "ItemList" table contains lines
		| 'Offers amount'    |
		| '3,00' |
	And I close all client application windows

Scenario: _9900009 create Shipment confirmation based on Sales invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	* Open link form
		And I click "Shipment confirmation" button
		Then "Add linked document rows" window is opened
	* Auto filling SC
		And I click "Ok" button	
	And I close all client application windows

Scenario: _9900010 post Sales invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows	

Scenario: _9900011 open Sales invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows

Scenario: _9900012 change Sales invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Second Company' |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company' |
	And I select current line in "List" table	
	And I close all client application windows


Scenario: _9900013 calculate offer Sales invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	And in the table "ItemList" I click "% Offers" button
	And I activate "%" field in "Offers" table
	And I select current line in "Offers" table
	And I input "10,00" text in "Percent" field
	And I click "Ok" button
	And in the table "Offers" I click "OK" button
	And "ItemList" table contains lines
		| 'Offers amount'    |
		| '3,00' |
	And I close all client application windows

Scenario: _9900014 create Shipment confirmation based on Sales invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	* Open link form
		And I click "Shipment confirmation" button
		Then "Add linked document rows" window is opened
	* Auto filling SC
		And I click "Ok" button	
	And I close all client application windows

Scenario: _9900030 open Purchase invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And I wait "Purchase invoice 1 dated 26.04.2021 10:34:49" window opening in "50" seconds
	And I close all client application windows

Scenario: _9900031 post Purchase invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows

Scenario: _9900032 change Purchase invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Second Company' |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company' |
	And I select current line in "List" table	
	And I close all client application windows


Scenario: _9900033 calculate offer Purchase invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And I click "% Offers" button
	And I activate "%" field in "Offers" table
	And I select current line in "Offers" table
	And I input "10,00" text in "Percent" field
	And I click "Ok" button
	And in the table "Offers" I click "OK" button
	And "ItemList" table contains lines
		| 'Offers amount'    |
		| '1,00' |
	And I close all client application windows

Scenario: _9900034 create Goods receipt based on Purchase invoice (1000 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	* Open link form
		And I click "Goods receipt" button
		Then "Add linked document rows" window is opened
	* Auto filling GR
		And I click "Ok" button	
	And I close all client application windows	


Scenario: _9900041 open Purchase invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	And I wait "Purchase invoice 2 dated 26.04.2021 10:34:50" window opening in "50" seconds
	And I close all client application windows

Scenario: _9900042 post Purchase invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows

Scenario: _9900043 change Purchase invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Second Company' |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company' |
	And I select current line in "List" table	
	And I close all client application windows


Scenario: _9900044 calculate offer Purchase invoice (100 strings)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	And I click "% Offers" button
	And I activate "%" field in "Offers" table
	And I select current line in "Offers" table
	And I input "10,00" text in "Percent" field
	And I click "Ok" button
	And in the table "Offers" I click "OK" button
	And "ItemList" table contains lines
		| 'Offers amount'    |
		| '1,00' |
	And I close all client application windows

Scenario: _9900045 create Goods receipt based on Purchase invoice (100 strings)
	Given I open hyperlink "ecib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	* Open link form
		And I click "Goods receipt" button
		Then "Add linked document rows" window is opened
	* Auto filling GR
		And I click "Ok" button	
	And I close all client application windows	
