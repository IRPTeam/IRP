#language: en
@tree
@Positive
@ObjectsRemovel

Functionality: test objects removel


Variables:
import "Variables.feature"

Background:
		Given I open new TestClient session or connect the existing one


Scenario: _985001 preparation (load test data)
When set True value to the constant
When Create catalog ExternalDataProc objects (test data base)
* Add ExternalDataProc
		* VAT
				Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				And I go to line in "List" table
						| 'Description'          |
						| 'TaxCalculation'       |
				And I select current line in "List" table
				And I select external file "$Path$/DataProcessor/TaxCalculateVAT_TR.epf"
				And I click the button named "FormAddExtDataProc"
				And I input "" text in "Path to plugin for test" field
				And I click "Save and close" button
				And I wait "Plugins (create)" window closing in 5 seconds
		* Discount
				Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				And I go to line in "List" table
						| 'Description'            |
						| 'DocumentDiscount'       |
				And I select current line in "List" table
				And I select external file "$Path$/DataProcessor/DocumentDiscount.epf"
				And I click the button named "FormAddExtDataProc"
				And I input "" text in "Path to plugin for test" field
				And I click "Save and close" button
				And I wait "Plugins (create)" window closing in 5 seconds
		* Contact info
				Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				And I go to line in "List" table
						| 'Description'       |
						| 'Address'           |
				And I select current line in "List" table
				And I select external file "$Path$/DataProcessor/InputAddress.epf"
				And I click the button named "FormAddExtDataProc"
				And I input "" text in "Path to plugin for test" field
				And I click "Save and close" button
				And I wait "Plugins (create)" window closing in 5 seconds
When Create catalog AddAttributeAndPropertySets objects (test data base)
When Create catalog AddAttributeAndPropertyValues objects (test data base)
When Create catalog IDInfoAddresses objects (test data base)
When Create catalog RowIDs objects (test data base)
When Create catalog BankTerms objects (test data base)
When Create catalog BusinessUnits objects (test data base)
When Create catalog CancelReturnReasons objects (test data base)
When Create catalog CashStatementStatuses objects (test data base)
When Create catalog CashAccounts objects (test data base)
When Create catalog Companies objects (test data base)
When Create catalog ConfigurationMetadata objects (test data base)
When Create catalog IDInfoSets objects (test data base)
When Create catalog Countries objects (test data base)
When Create catalog Currencies objects (test data base)
When Create catalog DataBaseStatus objects (test data base)
When Create catalog ExpenseAndRevenueTypes objects (test data base)
When Create catalog IntegrationSettings objects (test data base)
When Create catalog ItemKeys objects (test data base)
When Create catalog ItemTypes objects (test data base)
When Create catalog Units objects (test data base)
When Create catalog Items objects (test data base)
When Create catalog CurrencyMovementSets objects (test data base)
When Create catalog ObjectStatuses objects (test data base)
When Create catalog PartnerSegments objects (test data base)
When Create catalog Agreements objects (test data base)
When Create catalog Partners objects (test data base)
When Create catalog PartnersBankAccounts objects (test data base)
When Create catalog PaymentTerminals objects (test data base)
When Create catalog PaymentSchedules objects (test data base)
When Create catalog PaymentTypes objects (test data base)
When Create catalog PriceTypes objects (test data base)
When Create catalog RetailCustomers objects (test data base)	
When Create catalog SpecialOfferTypes objects (test data base)
When Create catalog SpecialOffers objects (test data base)
When Create catalog Specifications objects (test data base)
When Create catalog Stores objects (test data base)
When Create catalog TaxRates objects (test data base)
When Create catalog Taxes objects (test data base)
When Create information register Taxes records (test data base)
* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
						| 'Description'         |
						| 'Own company 1'       |
		And I select current line in "List" table
		And I move to "Tax types" tab
		And I go to line in "CompanyTaxes" table
						| 'Tax'       |
						| 'VAT'       |
		And I select current line in "CompanyTaxes" table
		And I click Open button of "Tax" field
		And I select "VAT" exact value from the drop-down list named "Kind"
		And I click "Save and close" button
		And I close all client application windows
When Create catalog InterfaceGroups objects (test data base)
When Create catalog AccessGroups objects (test data base)
When Create catalog AccessProfiles objects (test data base)
When Create catalog UserGroups objects (test data base)
When Create catalog Users objects (test data base)
When Create catalog Workstations objects (test data base)
When Create catalog PlanningPeriods objects (test data base)
When Create document CashTransferOrder objects (test data base)
When Create document BankPayment objects (test data base)
When Create document BankReceipt objects (test data base)
When Create document Bundling objects (test data base)
When Create document CashExpense objects (test data base)
When Create document CashPayment objects (test data base)
When Create document CashReceipt objects (test data base)
When Create document CashRevenue objects (test data base)
When Create document CreditNote objects (test data base)
When Create document DebitNote objects (test data base)
When Create document GoodsReceipt objects (test data base)
When Create document IncomingPaymentOrder objects (test data base)
When Create document InternalSupplyRequest objects (test data base)
When Create document InventoryTransfer objects (test data base)
When Create document InventoryTransferOrder objects (test data base)
When Create document OpeningEntry objects (test data base)
When Create document OutgoingPaymentOrder objects (test data base)
When Create document PhysicalCountByLocation objects (test data base)
When Create document PhysicalInventory objects (test data base)
When Create document PlannedReceiptReservation objects (test data base)
When Create document PriceList objects (test data base)
When Create document PurchaseInvoice objects (test data base)
When Create document PurchaseOrder objects (test data base)
When Create document PurchaseOrderClosing objects (test data base)
When Create document PurchaseReturn objects (test data base)
When Create document ReconciliationStatement objects (test data base)
When Create document RetailReturnReceipt objects (test data base)
When Create document RetailSalesReceipt objects (test data base)
When Create document SalesInvoice objects (test data base)
When Create document SalesOrder objects (test data base)
When Create document SalesReturn objects (test data base)
When Create document SalesReturnOrder objects (test data base)
When Create document ShipmentConfirmation objects (test data base)
When Create document StockAdjustmentAsSurplus objects (test data base)
When Create document StockAdjustmentAsWriteOff objects (test data base)
When Create document Unbundling objects (test data base)
When Create document ItemStockAdjustment objects  (test data base)
When Create document PurchaseReturnOrder objects (test data base)
When Create chart of characteristic types AddAttributeAndProperty objects (test data base)
When Create chart of characteristic types IDInfoTypes objects (test data base)
When Create chart of characteristic types CustomUserSettings objects (test data base)
When Create chart of characteristic types CurrencyMovementType objects (test data base)
When Create information register BundleContents records (test data base)
When Create information register BranchBankTerms records (test data base)
When Create information register CurrencyRates records (test data base)
When Create information register Barcodes records (test data base)
When Create information register PartnerSegments records (test data base)
When Create information register TaxSettings records (test data base)
When Create information register UserSettings records (test data base)
When Create document CashStatement objects  (test data base)
When Create catalog PartnerItems objects (test data base)
* Posting first documents
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
* Posting Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		Then "Opening entries" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
* Posting Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting Sales invoice
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 And Delay "3"
* Posting Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
		And I close all client application windows
* Posting Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting PurchaseReturnOrder
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
		And I close all client application windows
* Posting Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
		And I close all client application windows
* Posting Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting PurchaseOrderClosing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting SalesOrderClosing
		When Create document SalesOrderClosing objects (test data base)
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting PlannedReceiptReservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashPayment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting BankPayment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting BankReceipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashReceipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting CashExpense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashRevenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CreditNote
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting DebitNote
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting ReconciliationStatement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting IncomingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting OutgoingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting ItemStockAdjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting RetailSalesReceipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting RetailReturnReceipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting PriceList
		Given I open hyperlink "e1cib/list/Document.PriceList"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting SalesReturn
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
And I close all client application windows

Scenario: _985002 check preparation
	When check preparation

Scenario: _985003 test objects removel
	* AddAttributeAndPropertySets
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.AddAttributeAndPropertySets.Select();"    |
			| "Ob.Next();"                                             |
			| "Ob.GetObject().Delete();"                               |
	* AddAttributeAndPropertyValues
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.AddAttributeAndPropertyValues.Select();"    |
			| "Ob.Next();"                                               |
			| "Ob.GetObject().Delete();"                                 |
	* IDInfoAddresses
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.AddAttributeAndPropertyValues.Select();"    |
			| "Ob.Next();"                                               |
			| "Ob.GetObject().Delete();"                                 |
	* BankTerms
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.BankTerms.Select();"    |
			| "Ob.Next();"                           |
			| "Ob.GetObject().Delete();"             |
	* BusinessUnits
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.BusinessUnits.Select();"    |
			| "Ob.Next();"                               |
			| "Ob.GetObject().Delete();"                 |
	* CancelReturnReasons
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.CancelReturnReasons.Select();"    |
			| "Ob.Next();"                                     |
			| "Ob.GetObject().Delete();"                       |
	* CashStatementStatuses
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.CashStatementStatuses.Select();"    |
			| "Ob.Next();"                                       |
			| "Ob.GetObject().Delete();"                         |
	* CashAccounts
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.CashAccounts.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* Companies
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Companies.Select();"    |
			| "Ob.Next();"                           |
			| "Ob.GetObject().Delete();"             |
	* ConfigurationMetadata
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.ConfigurationMetadata.Select();"    |
			| "Ob.Next();"                                       |
			| "Ob.GetObject().Delete();"                         |
	* IDInfoSets
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.IDInfoSets.Select();"    |
			| "Ob.Next();"                            |
			| "Ob.GetObject().Delete();"              |
	* Countries
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Countries.Select();"    |
			| "Ob.Next();"                           |
			| "Ob.GetObject().Delete();"             |
	* Currencies
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Currencies.Select();"    |
			| "Ob.Next();"                            |
			| "Ob.GetObject().Delete();"              |
	* DataBaseStatus
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.DataBaseStatus.Select();"    |
			| "Ob.Next();"                                |
			| "Ob.GetObject().Delete();"                  |
	* ExpenseAndRevenueTypes
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.ExpenseAndRevenueTypes.Select();"    |
			| "Ob.Next();"                                        |
			| "Ob.GetObject().Delete();"                          |
	* IntegrationSettings
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.IntegrationSettings.Select();"    |
			| "Ob.Next();"                                     |
			| "Ob.GetObject().Delete();"                       |
	* ItemKeys
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.ItemKeys.Select();"    |
			| "Ob.Next();"                          |
			| "Ob.GetObject().Delete();"            |
	* ItemTypes
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.ItemTypes.Select();"    |
			| "Ob.Next();"                           |
			| "Ob.GetObject().Delete();"             |
	* Units
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Units.Select();"    |
			| "Ob.Next();"                       |
			| "Ob.GetObject().Delete();"         |
	* Items
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Items.Select();"    |
			| "Ob.Next();"                       |
			| "Ob.GetObject().Delete();"         |
	* CurrencyMovementSets
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.CurrencyMovementSets.Select();"    |
			| "Ob.Next();"                                      |
			| "Ob.GetObject().Delete();"                        |
	* ObjectStatuses
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.ObjectStatuses.Select();"    |
			| "Ob.Next();"                                |
			| "Ob.GetObject().Delete();"                  |
	* PartnerSegments
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PartnerSegments.Select();"    |
			| "Ob.Next();"                                 |
			| "Ob.GetObject().Delete();"                   |
	* Agreements
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Agreements.Select();"    |
			| "Ob.Next();"                            |
			| "Ob.GetObject().Delete();"              |
	* Partners
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Partners.Select();"    |
			| "Ob.Next();"                          |
			| "Ob.GetObject().Delete();"            |
	* PartnersBankAccounts
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PartnersBankAccounts.Select();"    |
			| "Ob.Next();"                                      |
			| "Ob.GetObject().Delete();"                        |
	* PaymentTerminals
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PaymentTerminals.Select();"    |
			| "Ob.Next();"                                  |
			| "Ob.GetObject().Delete();"                    |
	* PaymentSchedules
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PaymentSchedules.Select();"    |
			| "Ob.Next();"                                  |
			| "Ob.GetObject().Delete();"                    |
	* PaymentTypes
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PaymentTypes.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* PriceTypes
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PriceTypes.Select();"    |
			| "Ob.Next();"                            |
			| "Ob.GetObject().Delete();"              |
	* RetailCustomers
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.RetailCustomers.Select();"    |
			| "Ob.Next();"                                 |
			| "Ob.GetObject().Delete();"                   |
	* SpecialOfferTypes
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.SpecialOfferTypes.Select();"    |
			| "Ob.Next();"                                   |
			| "Ob.GetObject().Delete();"                     |
	* SpecialOffers
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.SpecialOffers.Select();"    |
			| "Ob.Next();"                               |
			| "Ob.GetObject().Delete();"                 |
	* Stores
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Stores.Select();"    |
			| "Ob.Next();"                        |
			| "Ob.GetObject().Delete();"          |
	* TaxRates
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.TaxRates.Select();"    |
			| "Ob.Next();"                          |
			| "Ob.GetObject().Delete();"            |
	* Taxes
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Taxes.Select();"    |
			| "Ob.Next();"                       |
			| "Ob.GetObject().Delete();"         |
	* InterfaceGroups
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.InterfaceGroups.Select();"    |
			| "Ob.Next();"                                 |
			| "Ob.GetObject().Delete();"                   |
	* AccessGroups
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.AccessGroups.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* AccessProfiles
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.AccessProfiles.Select();"    |
			| "Ob.Next();"                                |
			| "Ob.GetObject().Delete();"                  |
	* UserGroups
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.UserGroups.Select();"    |
			| "Ob.Next();"                            |
			| "Ob.GetObject().Delete();"              |
	* Workstations
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.Workstations.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* PlanningPeriods
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PlanningPeriods.Select();"    |
			| "Ob.Next();"                                 |
			| "Ob.GetObject().Delete();"                   |
	* PartnerItems
		And I execute 1C:Enterprise script at server
			| "Ob = Catalogs.PartnerItems.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* BankPayment
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.BankPayment.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* BankReceipt
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.BankReceipt.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* Bundling
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.Bundling.Select();"    |
			| "Ob.Next();"                           |
			| "Ob.GetObject().Delete();"             |
	* CashExpense
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.CashExpense.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* CashPayment
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.CashPayment.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* CashReceipt
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.CashReceipt.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* CashRevenue
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.CashRevenue.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* CashTransferOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.CashTransferOrder.Select();"    |
			| "Ob.Next();"                                    |
			| "Ob.GetObject().Delete();"                      |
	* CreditNote
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.CreditNote.Select();"    |
			| "Ob.Next();"                             |
			| "Ob.GetObject().Delete();"               |
	* DebitNote
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.DebitNote.Select();"    |
			| "Ob.Next();"                            |
			| "Ob.GetObject().Delete();"              |
	* GoodsReceipt
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.GoodsReceipt.Select();"    |
			| "Ob.Next();"                               |
			| "Ob.GetObject().Delete();"                 |
	* IncomingPaymentOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.IncomingPaymentOrder.Select();"    |
			| "Ob.Next();"                                       |
			| "Ob.GetObject().Delete();"                         |
	* InternalSupplyRequest
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.InternalSupplyRequest.Select();"    |
			| "Ob.Next();"                                        |
			| "Ob.GetObject().Delete();"                          |
	* InventoryTransfer
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.InventoryTransfer.Select();"    |
			| "Ob.Next();"                                    |
			| "Ob.GetObject().Delete();"                      |
	* InventoryTransferOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.InventoryTransferOrder.Select();"    |
			| "Ob.Next();"                                         |
			| "Ob.GetObject().Delete();"                           |
	* OpeningEntry
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.OpeningEntry.Select();"    |
			| "Ob.Next();"                               |
			| "Ob.GetObject().Delete();"                 |
	* OutgoingPaymentOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.OutgoingPaymentOrder.Select();"    |
			| "Ob.Next();"                                       |
			| "Ob.GetObject().Delete();"                         |
	* PhysicalCountByLocation 
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PhysicalCountByLocation.Select();"    |
			| "Ob.Next();"                                          |
			| "Ob.GetObject().Delete();"                            |
	* PhysicalInventory 
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PhysicalInventory.Select();"    |
			| "Ob.Next();"                                    |
			| "Ob.GetObject().Delete();"                      |
	* PlannedReceiptReservation
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PlannedReceiptReservation.Select();"    |
			| "Ob.Next();"                                            |
			| "Ob.GetObject().Delete();"                              |
	* PriceList
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PriceList.Select();"    |
			| "Ob.Next();"                            |
			| "Ob.GetObject().Delete();"              |
	* PurchaseInvoice
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PurchaseInvoice.Select();"    |
			| "Ob.Next();"                                  |
			| "Ob.GetObject().Delete();"                    |
	* PurchaseOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PurchaseOrder.Select();"    |
			| "Ob.Next();"                                |
			| "Ob.GetObject().Delete();"                  |
	* PurchaseOrderClosing
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PurchaseOrderClosing.Select();"    |
			| "Ob.Next();"                                       |
			| "Ob.GetObject().Delete();"                         |
	* PurchaseReturn
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PurchaseReturn.Select();"    |
			| "Ob.Next();"                                 |
			| "Ob.GetObject().Delete();"                   |
	* ReconciliationStatement
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.ReconciliationStatement.Select();"    |
			| "Ob.Next();"                                          |
			| "Ob.GetObject().Delete();"                            |
	* RetailReturnReceipt
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.RetailReturnReceipt.Select();"    |
			| "Ob.Next();"                                      |
			| "Ob.GetObject().Delete();"                        |
	* RetailSalesReceipt
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.RetailSalesReceipt.Select();"    |
			| "Ob.Next();"                                     |
			| "Ob.GetObject().Delete();"                       |
	* SalesInvoice
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.SalesInvoice.Select();"    |
			| "Ob.Next();"                               |
			| "Ob.GetObject().Delete();"                 |
	* SalesOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.SalesOrder.Select();"    |
			| "Ob.Next();"                             |
			| "Ob.GetObject().Delete();"               |
	* SalesReturn
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.SalesReturn.Select();"    |
			| "Ob.Next();"                              |
			| "Ob.GetObject().Delete();"                |
	* SalesReturnOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.SalesReturnOrder.Select();"    |
			| "Ob.Next();"                                   |
			| "Ob.GetObject().Delete();"                     |
	* ShipmentConfirmation
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.ShipmentConfirmation.Select();"    |
			| "Ob.Next();"                                       |
			| "Ob.GetObject().Delete();"                         |
	* StockAdjustmentAsSurplus
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.StockAdjustmentAsSurplus.Select();"    |
			| "Ob.Next();"                                           |
			| "Ob.GetObject().Delete();"                             |
	* StockAdjustmentAsWriteOff
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.StockAdjustmentAsWriteOff.Select();"    |
			| "Ob.Next();"                                            |
			| "Ob.GetObject().Delete();"                              |
	* Unbundling
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.Unbundling.Select();"    |
			| "Ob.Next();"                             |
			| "Ob.GetObject().Delete();"               |
	* ItemStockAdjustment
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.ItemStockAdjustment.Select();"    |
			| "Ob.Next();"                                      |
			| "Ob.GetObject().Delete();"                        |
	* CashStatement
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.CashStatement.Select();"    |
			| "Ob.Next();"                                |
			| "Ob.GetObject().Delete();"                  |
	* PurchaseReturnOrder
		And I execute 1C:Enterprise script at server
			| "Ob = Documents.PurchaseReturnOrder.Select();"    |
			| "Ob.Next();"                                      |
			| "Ob.GetObject().Delete();"                        |
	* AddAttributeAndProperty
		And I execute 1C:Enterprise script at server
			| "Ob = ChartsOfCharacteristicTypes.AddAttributeAndProperty.Select();"    |
			| "Ob.Next();"                                                            |
			| "Ob.GetObject().Delete();"                                              |
	* IDInfoTypes
		And I execute 1C:Enterprise script at server
			| "Ob = ChartsOfCharacteristicTypes.IDInfoTypes.Select();"    |
			| "Ob.Next();"                                                |
			| "Ob.GetObject().Delete();"                                  |
	* CustomUserSettings
		And I execute 1C:Enterprise script at server
			| "Ob = ChartsOfCharacteristicTypes.CustomUserSettings.Select();"    |
			| "Ob.Next();"                                                       |
			| "Ob.GetObject().Delete();"                                         |
	* CurrencyMovementType
		And I execute 1C:Enterprise script at server
			| "Ob = ChartsOfCharacteristicTypes.CurrencyMovementType.Select();"    |
			| "Ob.Next();"                                                         |
			| "Ob.GetObject().Delete();"                                           |
	
	
		
	
		

