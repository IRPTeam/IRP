#language: en
@tree
@Positive
@AccessRights

Feature: Basic role


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 950100 Basic role
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	Then I connect launched Test client "Этот клиент"
	When Create catalog AccessGroups objects
	When Create catalog AccessProfiles objects
	When Create catalog Agreements objects
	When Create catalog BusinessUnits objects
	When Create catalog CashAccounts objects
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
	When Create catalog Taxes objects (Sales tax)
	When Create catalog PaymentTerminals objects
	When Create catalog BankTerms objects
	When Create catalog CashStatementStatuses objects (Test)
	When Create catalog Hardware objects  (Test)
	When Create catalog Workstations objects  (Test)
	When Create information register TaxSettings records
	When Create information register Taxes records (VAT)
	When Create information register TaxSettings (Sales tax)
	When Create information register Taxes records (Sales tax)
	When Create information register PricesByItemKeys records
	When Create information register PricesByProperties records
	When Create catalog IntegrationSettings objects
	When Create information register CurrencyRates records
	When Create information register Barcodes records
	When Create information register UserSettings records (Retail document)
	When update ItemKeys
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
	When Create document InvoiceMatch objects
	When Create document OpeningEntry objects
	When Create document OutgoingPaymentOrder objects
	When Create document Bundling objects
	When Create document PhysicalCountByLocation objects
	When Create document PhysicalInventory objects
	When Create document ReconciliationStatement objects
	When Create document StockAdjustmentAsSurplus objects
	When Create document StockAdjustmentAsWriteOff objects
	When Create document Unbundling objects
	* Update user roles
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I click "Update all user roles" button	
	* Set password for Sofia Borisova (Manager 3)
			Given I open hyperlink "e1cib/list/Catalog.Users"
			And I go to line in "List" table
					| 'Description'                 |
					| 'Emily Jones (Manager 2)' |
			And I select current line in "List" table
	* Change localization code
			And I select "Turkish" exact value from "Data localization" drop-down list	
			And I select "English" exact value from "Interface localization" drop-down list
			And I click "Save" button
	* Set password
		And I click "Set password" button
		And I input "F12345" text in "Password" field
		And I input "F12345" text in "Confirm password" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* When Create user with access role Full access only read
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And I go to line in "List" table
				| 'Description' |
				| 'Manager'   |
		And I select current line in "List" table
		And in the table "Roles" I click "Update roles" button
		And I go to line in "Roles" table
				| 'Presentation'    |
				| 'Basic role' |
		And I set "Use" checkbox in "Roles" table
		And I finish line editing in "Roles" table
		And I click "Save and close" button
	And I connect "TestAdmin" TestClient using "EJones" login and "F12345" password
	And Delay 3
	If the warning is displayed then 
		Then I raise "Failed to open" exception
	And I close all client application windows
	And I close TestClient session

