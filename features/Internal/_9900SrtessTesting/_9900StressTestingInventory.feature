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
	When Create document PhysicalInventory objects (stress testing, 1000 strings)
	When Create document PhysicalInventory objects (stress testing, 100strings)
	When Create document InventoryTransfer objects (stress testing, 1000 strings)
	When Create document InventoryTransfer objects (stress testing, 100strings)

Scenario: _9900001 post Physical inventory (1000 strings)
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows

Scenario: _9900002 post Physical inventory (100 strings)
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows	

Scenario: _9900003 open Physical inventory (1000 strings)
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And I wait "Physical inventory 1 dated 22.04.2021 12:42:15" window opening in "50" seconds
	And I close all client application windows

Scenario: _9900004 open Physical inventory (100 strings)
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	And I wait "Physical inventory 2 dated 23.04.2021 12:42:15" window opening in "50" seconds
	And I close all client application windows


Scenario: _9900051 open Inventory transfer (1000 strings)
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And I select current line in "List" table
	And I wait "Inventory transfer 1 dated 26.04.2021 16:31:28" window opening in "50" seconds
	And I close all client application windows

Scenario: _9900052 post Inventory transfer (1000 strings)
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'  |
		| '1' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows

Scenario: _9900053 open Inventory transfer (100strings)
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And I select current line in "List" table
	And I wait "Inventory transfer 2 dated 26.04.2021 16:35:28" window opening in "50" seconds
	And I close all client application windows

Scenario: _9900054 post Inventory transfer (100strings)
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'  |
		| '2' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I close all client application windows