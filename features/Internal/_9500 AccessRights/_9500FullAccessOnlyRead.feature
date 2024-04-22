#language: en
@tree
@Positive
@AccessRights

Feature: role Full access only read


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 950000 preparation (role Full access only read)
	When set True value to the constant
	When Create catalog AccessGroups objects
	When Create catalog AccessProfiles objects
	When Create catalog Agreements objects
	When Create catalog BusinessUnits objects
	When Create catalog CashAccounts objects
	When Create catalog ChequeBonds objects
	When Create catalog Companies objects (Main company)
	When Create catalog Companies objects (partners company)
	When Create catalog Countries objects
	When Create catalog ExpenseAndRevenueTypes objects
	When Create catalog FileStorageVolumes objects
	When Create catalog InterfaceGroups objects
	When Create catalog ItemSegments objects
	When Create catalog ItemTypes objects (Clothes, Shoes)
	When Create catalog ItemTypes objects (Coat, Jeans)
	When Create catalog ObjectStatuses objects
	When Create catalog Partners objects (Ferron BP)
	When Create catalog Partners objects (Partner 01)
	When Create catalog Partners objects (Kalipso)
	When Create catalog Partners objects (Lomaniti)
	When Create catalog Partners objects (Employee)
	When Create catalog PaymentTypes objects
	When Create catalog Stores objects
	When Create catalog Units objects (box (8 pcs))
	When Create catalog Units objects (pcs)
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog ItemKeys objects
	When Create catalog ItemTypes objects
	When Create catalog ItemTypes objects (Furniture)
	When Create catalog Units objects
	When Create catalog Items objects
	When Create catalog Items objects (Boots)
	When Create catalog PartnerSegments objects
	When Create catalog Partners objects
	When Create catalog ExternalDataProc objects
	When Create catalog PriceTypes objects
	When Create catalog Specifications objects
	When Create catalog UserGroups objects
	When Create catalog Users objects
	When Create catalog RetailCustomers objects
	When Create chart of characteristic types AddAttributeAndProperty objects
	When Create catalog AddAttributeAndPropertyValues objects
	When Create catalog AddAttributeAndPropertySets objects
	When Create information register PartnerSegments records
	When Create catalog TaxRates objects
	When Create catalog Taxes objects
	When Create catalog PaymentTerminals objects
	When Create catalog BankTerms objects
	When Create catalog CashStatementStatuses objects (Test)
	When Create catalog Hardware objects  (Test)
	When Create catalog Workstations objects  (Test)
	When create items for work order
	When Create catalog BillOfMaterials objects
	When Create information register TaxSettings records
	When Create information register Taxes records (VAT)
	When Create information register PricesByItemKeys records
	When Create information register PricesByProperties records
	When Create catalog IntegrationSettings objects
	When Create information register CurrencyRates records
	When Create information register Barcodes records
	When Create information register UserSettings records (Retail document)
	When Create catalog ItemKeys objects (Table)
	When Create catalog Items objects (Table)
	When Create information register UserSettings records
	When Create catalog SpecialOfferRules objects
	When Create catalog SpecialOfferTypes objects
	When Create catalog SpecialOffers objects
	When Create document SalesInvoice objects
	When Create document SalesOrder objects
	When Create document SalesReturnOrder objects
	When Create document ShipmentConfirmation objects
	When Create document PriceList objects
	When Create document PurchaseOrder objects
	When Create document PurchaseReturnOrder objects
	When Create document RetailReturnReceipt objects
	When Create document RetailSalesReceipt objects
	When Create document BankPayment objects
	When Create document BankReceipt objects
	When Create document CashExpense objects
	When Create document CashPayment objects
	When Create document CashReceipt objects
	When Create document CashRevenue objects
	When Create document CashTransferOrder objects
	When Create document CreditNote objects
	When Create document DebitNote objects
	When Create document GoodsReceipt objects
	When Create document IncomingPaymentOrder objects
	When Create document InternalSupplyRequest objects
	When Create document InventoryTransfer objects
	When Create document InventoryTransferOrder objects
	When Create document OpeningEntry objects
	When Create document Production objects (Test)
	When Create document ProductionPlanning objects (Test)
	When Create document ProductionPlanningClosing objects (Test)
	When Create document ProductionPlanningCorrection objects (Test)
	When Create document WorkOrder objects (Test)
	When Create document WorkSheet objects (Test)
	When Create document OutgoingPaymentOrder objects
	When Create document Bundling objects
	When Create document PhysicalCountByLocation objects
	When Create document PhysicalInventory objects
	When Create document ReconciliationStatement objects
	When Create document StockAdjustmentAsSurplus objects
	When Create document StockAdjustmentAsWriteOff objects
	When Create document Unbundling objects
	When Create document VendorsAdvancesClosing objects
	When Create document CustomersAdvancesClosing objects
	When Create catalog PlanningPeriods objects
	* Set password for Sofia Borisova (Manager 3)
			Given I open hyperlink "e1cib/list/Catalog.Users"
			And I go to line in "List" table
					| 'Description'                     |
					| 'Sofia Borisova (Manager 3)'      |
			And I select current line in "List" table
	* Change localization code
			And I select "English" exact value from "Data localization" drop-down list	
			And I select "English" exact value from "Interface localization" drop-down list
			And I click "Save" button
	* Set password
		And I click "Set password" button
		And I input "F12345" text in "Password" field
		And I input "F12345" text in "Confirm password" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Update user roles
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I go to line in "List" table
			| 'Description'    |
			| 'Manager'        |
		And I click "Update all user roles" button		
	And I connect "TestAdmin" TestClient using "SBorisova" login and "F12345" password
	And Delay 3
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"   |

Scenario: 9500001 check preparation
	When check preparation


Scenario: 950001 check role Full access only read (Payment types)
		And In the command interface I select "Master data" "Payment types"	
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Cash'           |
		And I select current line in "List" table
		Then system warning window does not appear


Scenario: 950002 check role Full access only read (Cash/Bank accounts) 
	And I close all client application windows
	* Master data
		And In the command interface I select "Master data" "Cash/Bank accounts"
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	* Treasury
		And In the command interface I select "Master data" "Cash/Bank accounts"
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950003 check role Full access only read (Currencies)
		And I close all client application windows
		And In the command interface I select "Master data" "Currencies"
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	
Scenario: 950004 check role Full access only read (ExpenseAndRevenueTypes)
		And I close all client application windows
		And In the command interface I select "Master data" "Expense and revenue types"
		And I go to line in "List" table
			| 'Description'    |
			| 'Rent'           |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950005 check role Full access only read (Tax rates)
	And I close all client application windows
	* Master data
		And In the command interface I select "Settings" "Tax rates"		
		And I go to line in "List" table
			| 'Description'    |
			| '18%'            |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	


Scenario: 950006 check role Full access only read (Company taxes)
		And I close all client application windows
		And In the command interface I select "Master data" "Company taxes"		
		And I go to line in "List" table
			| 'Tax'    |
			| 'VAT'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950007 check role Full access only read (Companies)
		And I close all client application windows
		And In the command interface I select "Master data" "Companies"		
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950008 check role Full access only read (Stores)
	And I close all client application windows
	* Master data
		And In the command interface I select "Master data" "Stores"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	
	* Inventory
		And In the command interface I select "Inventory" "Stores"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window	
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950009 check role Full access only read (Partner terms)
		And I close all client application windows
		And In the command interface I select "Master data" "Partner terms"		
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window
		And I go to line in "List" table
			| 'Description'            |
			| 'Standard (Customer)'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close current window


Scenario: 950010 check role Full access only read (Price types)
		And I close all client application windows
	* Master data
		And In the command interface I select "Master data" "Price types"		
		And I go to line in "List" table
			| 'Description'          |
			| 'Basic Price Types'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	
	* Sales - A/R
		And In the command interface I select "Sales - A/R" "Price types"		
		And I go to line in "List" table
			| 'Description'          |
			| 'Basic Price Types'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950011 check role Full access only read (Partner segment)
		And I close all client application windows
		And In the command interface I select "Master data" "Partner segments"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Dealer'         |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 9500110 check role Full access only read (Countries)
		And I close all client application windows
		And In the command interface I select "Master data" "Countries"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Turkey'         |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950012 check role Full access only read (Partners)
		And I close all client application windows
		And In the command interface I select "Master data" "Partners"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Lomaniti'       |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950013 check role Full access only read (Items and item key)
		And I close all client application windows
	* Master data
		And In the command interface I select "Master data" "Items"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And In this window I click command interface button "Item keys"
		And I activate "Item key" field in "List" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception			
		And I close all client application windows		
	* Inventory	
		And In the command interface I select "Inventory" "Items"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And In this window I click command interface button "Item keys"
		And I activate "Item key" field in "List" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception			
		And I close all client application windows	
	* Sales
		And In the command interface I select "Sales - A/R" "Items"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And In this window I click command interface button "Item keys"
		And I activate "Item key" field in "List" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception			
		And I close all client application windows	
	* Purchase
		And In the command interface I select "Purchase  - A/P" "Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And In this window I click command interface button "Item keys"
		And I activate "Item key" field in "List" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception			
	

Scenario: 950014 check role Full access only read (Item units)
		And I close all client application windows
	* Master data
		And In the command interface I select "Master data" "Item units"		
		And I go to line in "List" table
			| 'Description'    |
			| 'box (8 pcs)'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	
	* Inventory
		And In the command interface I select "Master data" "Item units"		
		And I go to line in "List" table
			| 'Description'    |
			| 'box (8 pcs)'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950015 check role Full access only read (Item types)
		And I close all client application windows
	* Master data
		And In the command interface I select "Master data" "Item types"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	
	* Inventory
		And In the command interface I select "Inventory" "Item types"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	
	

Scenario: 950016 check role Full access only read (Users)
		And I close all client application windows
		And In the command interface I select "Settings" "Users"		
		And I go to line in "List" table
			| 'Description'                   |
			| 'Sofia Borisova (Manager 3)'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950017 check role Full access only read (User access group)
		And I close all client application windows
		And In the command interface I select "Settings" "User access groups"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Financier'      |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950018 check role Full access only read (User access profile)
		And I close all client application windows
		And In the command interface I select "Settings" "User access profiles"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Financier'      |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950019 check role Full access only read (User groups)
		And I close all client application windows
		And In the command interface I select "Settings" "User groups"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Admin'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	



Scenario: 950020 check role Full access only read (Additional attribute sets)
		And I close all client application windows
		And In the command interface I select "Settings" "Additional attribute sets"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Item key'       |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950021 check role Full access only read (Additional attribute types)
		And I close all client application windows
		And In the command interface I select "Settings" "Additional attribute types"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Brand'          |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950022 check role Full access only read (Additional attribute values)
		And I close all client application windows
		And In the command interface I select "Settings" "Additional attribute values"		
		And I go to line in "List" table
			| 'Additional attribute'    |
			| 'Size'                    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950023 check role Full access only read (Contact info sets)
		And I close all client application windows
		And In the command interface I select "Settings" "Contact info sets"		
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Catalog_Companies'       |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950024 check role Full access only read (Integration settings)
		And I close all client application windows
		And In the command interface I select "Settings" "Integration settings"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank UA'        |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950025 check role Full access only read (Plugins)
		And I close all client application windows
		And In the command interface I select "Settings" "Plugins"		
		And I go to line in "List" table
			| 'Description'       |
			| 'ExternalBankUa'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows




Scenario: 950027 check role Full access only read (Workstations)
		And I close all client application windows
		And In the command interface I select "Settings" "Workstations"		
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950028 check role Full access only read (Equipment drivers)
		And I close all client application windows
		And In the command interface I select "Settings" "Equipment drivers"		
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950029 check role Full access only read (Hardware)
		And I close all client application windows
		And In the command interface I select "Settings" "Hardware"		
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950030 check role Full access only read (Definable UI commands)
		And I close all client application windows
		And In the command interface I select "Settings" "Hardware"		
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950031 check role Full access only read (UI groups)
		And I close all client application windows
		And In the command interface I select "Settings" "UI groups"		
		And I go to line in "List" table
			| 'Description'            |
			| 'Product information'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950032 check role Full access only read (Object statuses)
		And I close all client application windows
		And In the command interface I select "Settings" "Objects statuses"		
		And I go to line in "List" table
			| 'Code'                |
			| 'Objects statuses'    |
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data name      |
			| InventoryTransferOrder    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950034 check role Full access only read (Tax rate settings not available from user interface)
	And I close all client application windows
	* Master data
		When I Check the steps for Exception
			| 'And In the command interface I select "Settings" "Tax rate settings"'    |
		And I close all client application windows	




Scenario: 950037 check role Full access only read (Item segments)
		And I close all client application windows
	* Master data
		And In the command interface I select "Master data" "Item segments"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Sale autum'     |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	* Inventory
		And In the command interface I select "Inventory" "Item segments"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Sale autum'     |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950038 check role Full access only read (Customers partner terms)
		And I close all client application windows
		And In the command interface I select "Sales - A/R" "Customers partner terms"	
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

	
Scenario: 950040 check role Full access only read (Vendors partner terms)
		And I close all client application windows
		And In the command interface I select "Purchase  - A/P" "Vendors partner terms"
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, EUR'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950041 check role Full access only read (Sales invoice)
		And I close all client application windows
		And In the command interface I select "Sales - A/R" "Sales invoices"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	
Scenario: 950042 check role Full access only read (Sales order)
		And I close all client application windows
		And In the command interface I select "Sales - A/R" "Sales orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	
Scenario: 950043 check role Full access only read (Sales return order)
		And I close all client application windows
		And In the command interface I select "Sales - A/R" "Sales return orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	
Scenario: 950044 check role Full access only read (Shipment confirmation)
		And I close all client application windows
	* Sales - A/R
		And In the command interface I select "Sales - A/R" "Shipment confirmations"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	* Inventory
		And In the command interface I select "Inventory" "Shipment confirmations"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950045 check role Full access only read (Price list)
		And I close all client application windows
		And In the command interface I select "Sales - A/R" "Price lists"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
	
Scenario: 950046 check role Full access only read (Purchase order)
		And I close all client application windows
		And In the command interface I select "Purchase  - A/P" "Purchase orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950047 check role Full access only read (Purchas return order)
		And I close all client application windows
		And In the command interface I select "Purchase  - A/P" "Purchase return orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950048 check role Full access only read (Retail return receipts)
		And I close all client application windows
		And In the command interface I select "Retail" "Retail return receipts"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950049 check role Full access only read (Retail sales receipts)
		And I close all client application windows
		And In the command interface I select "Retail" "Retail sales receipts"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950050 check role Full access only read (Bank payment)
		And I close all client application windows
		And In the command interface I select "Treasury" "Bank payments"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950051 check role Full access only read (Bank receipt)
		And I close all client application windows
		And In the command interface I select "Treasury" "Bank receipts"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950053 check role Full access only read (Cash expense)
		And I close all client application windows
		And In the command interface I select "Treasury" "Cash expenses"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950054 check role Full access only read (Cash payment)
		And I close all client application windows
		And In the command interface I select "Treasury" "Cash payments"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950055 check role Full access only read (Cash receipt)
		And I close all client application windows
		And In the command interface I select "Treasury" "Cash receipts"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950056 check role Full access only read (Cash revenue)
		And I close all client application windows
		And In the command interface I select "Treasury" "Cash revenues"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950057 check role Full access only read (Cash transfer order)
		And I close all client application windows
		And In the command interface I select "Treasury" "Cash transfer orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950058 check role Full access only read (Credit note)
		And I close all client application windows
		And In the command interface I select "Treasury" "Credit notes"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950059 check role Full access only read (Dedit note)
		And I close all client application windows
		And In the command interface I select "Treasury" "Debit notes"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950060 check role Full access only read (GoodsReceipt)
		And I close all client application windows
		And In the command interface I select "Inventory" "Goods receipts"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950061 check role Full access only read (Incoming payment order)
		And I close all client application windows
		And In the command interface I select "Treasury" "Incoming payment orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950062 check role Full access only read (Outgoing payment order)
		And I close all client application windows
		And In the command interface I select "Treasury" "Outgoing payment orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950063 check role Full access only read (Internal supply request)
		And I close all client application windows
		And In the command interface I select "Inventory" "Internal supply requests"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950065 check role Full access only read (Vendors advances closing)
		And I close all client application windows
		Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows




Scenario: 950066 check role Full access only read (Inventory transfers)
		And I close all client application windows
		And In the command interface I select "Inventory" "Inventory transfers"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950067 check role Full access only read (Inventory transfer orders)
		And I close all client application windows
		And In the command interface I select "Inventory" "Inventory transfer orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950068 check role Full access only read (Bundling)
		And I close all client application windows
		And In the command interface I select "Inventory" "Bundling list"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950069 check role Full access only read (Unbundling)
		And I close all client application windows
		And In the command interface I select "Inventory" "Unbundling list"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950070 check role Full access only read (PhysicalCountByLocation)
		And I close all client application windows
		And In the command interface I select "Inventory" "Physical count by location list"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950071 check role Full access only read (Physical inventory)
		And I close all client application windows
		And In the command interface I select "Inventory" "Physical inventories"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950072 check role Full access only read (StockAdjustmentAsSurplus)
		And I close all client application windows
		And In the command interface I select "Inventory" "Stock adjustments as surplus"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950073 check role Full access only read (StockAdjustmentAsWriteOff)
		And I close all client application windows
		And In the command interface I select "Inventory" "Stock adjustments as write-off"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950074 check role Full access only read (ReconciliationStatement)
		And I close all client application windows
		And In the command interface I select "Treasury" "Reconciliation statements"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950075 check role Full access only read (Opening entry)
		And I close all client application windows
		And In the command interface I select "Master data" "Opening entries"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950076 check role Full access only read (Retail customers)
		And I close all client application windows
		And In the command interface I select "Retail" "Retail customers"		
		And I go to line in "List" table
			| 'Description'      |
			| 'Test01 Test01'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950077 check role Full access only read (Cash statement statuses)
		And I close all client application windows
		And In the command interface I select "Settings" "Cash statement statuses"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Test'           |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950078 check role Full access only read (Bank terms)
		And I close all client application windows
		And In the command interface I select "Master data" "Bank terms"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Test01'         |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950079 check role Full access only read (Special offer rules)
		And I close all client application windows
		And In the command interface I select "Master data" "Special offer rules"		
		And I go to line in "List" table
			| 'Description'                     |
			| 'Range Discount Basic (Dress)'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950080 check role Full access only read (Special offer types)
		And I close all client application windows
		And In the command interface I select "Master data" "Special offer types"		
		And I go to line in "List" table
			| 'Description'         |
			| 'Discount Price 1'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950081 check role Full access only read (Special offers)
		And I close all client application windows
		And In the command interface I select "Master data" "Special offers"		
		And I go to line in "List" table
			| 'Description'          |
			| 'Document discount'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows	

Scenario: 950082 check role Full access only read (Customers advances closing)
		And I close all client application windows
		Given I open hyperlink 'e1cib/list/Document.CustomersAdvancesClosing'	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950035 check role Full access only read (Cheque bonds)
		And I close all client application windows
		And In the command interface I select "Treasury" "Cheque bonds"		
		And I go to line in "List" table
			| 'Cheque No'       |
			| 'Own cheque 2'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950083 check role Full access only read (Work order)
		And I close all client application windows
		And In the command interface I select "Sales - A/R" "Work orders"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950084 check role Full access only read (Work sheet)
		And I close all client application windows
		And In the command interface I select "Sales - A/R" "Work sheets"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows
		

Scenario: 950086 check role Full access only read (Production)
		And I close all client application windows
		And In the command interface I select "Manufacturing" "Productions"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950087 check role Full access only read (Production planning)
		And I close all client application windows
		And In the command interface I select "Manufacturing" "Production plannings"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950088 check role Full access only read (Production planning correction)
		And I close all client application windows
		And In the command interface I select "Manufacturing" "Production planning corrections"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows


Scenario: 950091 check role Full access only read (Bill of materials)
		And I close all client application windows
		And In the command interface I select "Manufacturing" "Bill of materials"		
		And I go to line in "List" table
			| 'Description'               |
			| 'Furniture installation'    |
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: 950089 check role Full access only read (Production planning closing)
		And I close all client application windows
		And In the command interface I select "Manufacturing" "Production planning closings"	
		And I select current line in "List" table
		If the warning is displayed then 
			Then I raise "Failed to open" exception
		And I close all client application windows

Scenario: _999999 close TestClient session
		And I close TestClient session
		Then I connect launched Test client "Этот клиент"
