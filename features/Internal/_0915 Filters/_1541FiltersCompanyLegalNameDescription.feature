#language: en
@tree
@Positive
@Filters

Feature: filter by Company, Legal name and Legal name contract on document forms




Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: _0154000 preparation
	When set True value to the constant
	When set True value to the constant Use consolidated retail sales
	* Load info
		When Create catalog Countries objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create catalog Partners objects (Kalipso)
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create catalog LegalNameContracts objects (Ferron, filters)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects

	
Scenario: _01540001 check preparation
	When check preparation


Scenario: _017006 check the filter for Legal name in the document Purchase Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	When check the filter by Legal name (Ferron)


Scenario: _017007 check the filter for Company in the document Purchase Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	When check the filter by Company (Ferron)
	
Scenario: _017008 check Description in the document Purchase Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	When check Description

Scenario: _017009 check the filter for Vendor in the document Purchase Order
	And I close all client application windows
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	When check the filter by vendors in the purchase documents


Scenario: _017010 check the filter for Vendors partner terms in the document Purchase Order
	And I close all client application windows
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	When check the filter by vendor partner terms in the purchase documents

Scenario: _017011 check Description in the document Additional cost allocation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
	When check Description

Scenario: _017012 check Description in the document Sales report from trade agent
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
	When check Description

Scenario: _017013 check Description in the document Sales report to consignor
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	When check Description

Scenario: _017014 check the filter for Company in the document Sales report from trade agent
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
	When check the filter by my own company

Scenario: _017015 check the filter for Company in the document Sales report to consignor
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	When check the filter by my own company


Scenario: _018013 check the filter for Legal name in the document Purchase Invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	When check the filter by Legal name (Ferron)


Scenario: _018014 check the filter for Company in the document Purchase Invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	When check the filter by Company (Ferron)
	
Scenario: _018015 check Description in the document Purchase Invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	When check Description

Scenario: _018016 check the filter for Vendor in the document PurchaseInvoice
	And I close all client application windows
	* Open a form to create Purchase Invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	When check the filter by vendors in the purchase documents


Scenario: _018017 check the filter for Vendors partner terms in the document Purchase Invoice
	And I close all client application windows
	* Open a form to create Purchase Invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	When check the filter by vendor partner terms in the purchase documents


Scenario: _022011 check the filter for Legal name in the document Purchase Return Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	When check the filter by Legal name (Ferron)


Scenario: _022012 check the filter for Company in the document Purchase Return Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	When check the filter by Company (Ferron)
	
Scenario: _022013 check Description in the document Purchase Return Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	When check Description

Scenario: _022014 check the filter for Vendor in the document PurchaseReturnOrder
	And I close all client application windows
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	When check the filter by vendors in the purchase documents

Scenario: _022015 check the filter for Vendors partner terms in the document Purchase Return Order
	And I close all client application windows
	* Open a form to create Purchase Invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	When check the filter by vendor partner terms in the purchase documents


Scenario: _022330 check the filter for Legal name in the document Purchase Return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	When check the filter by Legal name (Ferron)


Scenario: _022331 check the filter for Company in the document Purchase Return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	When check the filter by Company (Ferron)
	
Scenario: _022332 check Description in the document Purchase Return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	When check Description

Scenario: _022333 check the filter for Vendor in the document PurchaseReturn
	And I close all client application windows
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	When check the filter by vendors in the purchase documents

Scenario: _022334 check the filter for Vendors partner terms in the document Purchase Return
	And I close all client application windows
	* Open a form to create Purchase Invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	When check the filter by vendor partner terms in the purchase documents



Scenario: _020015 check the filter for Company in the document Inventory Transfer Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	When check the filter by Company  in the inventory transfer



Scenario: _021049 check the filter for Company in the document Inventory Transfer
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	When check the filter by Company  in the inventory transfer



Scenario: _023107 check the filter for Legal name in the document Sales order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	When check the filter by Legal name

Scenario: _023108 check the filter for Partner terms (segments and validity period) in the document SalesOrder
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	When check the filter by Partner term (by segments + expiration date)

Scenario: _023109 check the filter for Company in the document Sales order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	When check the filter by Company
	
Scenario: _023110 check Description in the document Sales order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	When check Description

Scenario: _023111 check the filter for Customer in the document SalesOrder
	And I close all client application windows
	* Open a form to create Sales Order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	When check the filter by customers in the sales documents


Scenario: _023112 check the filter for Customers partner terms in the document SalesOrder
	And I close all client application windows
	* Open a form to create Sales Order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	When check the filter by customer partner terms in the sales documents


Scenario: _023113 check the filter for Legal name in the document Work order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	When check the filter by Legal name


Scenario: _023114 check the filter for Company in the document Work order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	When check the filter by Company
	
Scenario: _023115 check Description in the document Work order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	When check Description

Scenario: _023116 check the filter for Customer in the document WorkOrder
	And I close all client application windows
	* Open a form to create Work Order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click the button named "FormCreate"
	When check the filter by customers in the sales documents


Scenario: _023117 check the filter for Customers partner terms in the document WorkOrder
	And I close all client application windows
	* Open a form to create Work Order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click the button named "FormCreate"
	When check the filter by customer partner terms in the sales documents


Scenario: _023118 check the filter for Legal name in the document Work sheet
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkSheet"
	When check the filter by Legal name


Scenario: _023119 check the filter for Company in the document Work sheet
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkSheet"
	When check the filter by Company
	
Scenario: _023120 check Description in the document Work sheet
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkSheet"
	When check Description

Scenario: _023121 check the filter for Customer in the document WorkSheet
	And I close all client application windows
	* Open a form to create Work Sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click the button named "FormCreate"
	When check the filter by customers in the sales documents


Scenario: _024036 check the filter for Legal name in the document Sales invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	When check the filter by Legal name

Scenario: _024037 check the filter for Partner terms (segments and validity period) in the document
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	When check the filter by Partner term (by segments + expiration date)

Scenario: _024038 check the filter for Company in the document Sales invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	When check the filter by Company
	
Scenario: _024039 check Description in the document Sales invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	When check Description

Scenario: _024040 check the filter for Customer in the document SalesInvoice
	And I close all client application windows
	* Open a form to create Sales Invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	When check the filter by customers in the sales documents


Scenario: _024041 check the filter for Customers partner terms in the document SalesInvoice
	And I close all client application windows
	* Open a form to create SalesInvoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	When check the filter by customer partner terms in the sales documents



Scenario: _028529 check the filter for Legal name in the document Sales return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	When check the filter by Legal name

Scenario: _028530 check the filter for Partner terms (segments and validity period) in the document Sales return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	When check the filter by Partner term (by segments + expiration date)

Scenario: _028531 check the filter for Company in the document Sales return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	When check the filter by Company
	
Scenario: _028532 check Description in the document Sales return
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	When check Description

Scenario: _028533 check the filter for Customer in the document SalesReturn
	And I close all client application windows
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	When check the filter by customers in the sales documents


Scenario: _028812 check the filter for Company in the document Shipment Confirmation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	When check the filter by Company  in the Shipment cinfirmation and Goods receipt

Scenario: _028813 check Description in the document Shipment Confirmation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	When check Description



Scenario: _028906 check the filter for Company in the document Goods Receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	When check the filter by Company  in the Shipment cinfirmation and Goods receipt

Scenario: _028907 check Description in the document Goods Receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	When check Description




Scenario: _029520 check the filter for Company in the document Bundling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	When check the filter by Company  in the Shipment cinfirmation and Goods receipt

Scenario: _029521 check Description in the document Bundling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	When check Description



Scenario: _029613 check the filter for Company in the document Unbundling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	When check the filter by Company  in the Shipment cinfirmation and Goods receipt

Scenario: _029614 check Description in the document Unbundling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	When check Description


Scenario: _029728 check the filter for Company in the document StockAdjustmentAsWriteOff
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	When check the filter by Company  in the Shipment cinfirmation and Goods receipt


Scenario: _029729 check the filter for Company in the document StockAdjustmentAsSurplus
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	When check the filter by Company  in the Shipment cinfirmation and Goods receipt

Scenario: _029730 check Description in the document StockAdjustmentAsSurplus
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	When check Description

Scenario: _029731 check Description in the document StockAdjustmentAsWriteOff
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	When check Description

Scenario: _029816 check Description in the document PhysicalCountByLocation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
	When check Description

Scenario: _029817 check Description in the document PhysicalInventory
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	When check Description
	

Scenario: _028007 check the filter for Legal name in the document Sales return order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	When check the filter by Legal name

Scenario: _028008 check the filter for Partner terms (segments and validity period) in the document Sales return order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	When check the filter by Partner term (by segments + expiration date)

Scenario: _028009 check the filter for Company in the document Sales return order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	When check the filter by Company
	
Scenario: _028010 check Description in the document Sales return order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	When check Description

Scenario: _028011 check the filter for Customer in the document SalesReturnOrder
	And I close all client application windows
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	When check the filter by customers in the sales documents

Scenario: _028012 check Description in the document Labeling
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Labeling"
	When check Description

Scenario: _028013 check Description in the document Money transfer
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
	When check Description

Scenario: _028014 check Description in the document DebitCreditNote
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
	When check Description

Scenario: _028015 check filter for Legal name contract in the document BankPayment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check filter for Legal name contract (in BP, CP)

Scenario: _028016 check filter for Legal name contract in the document BankReceipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	When check filter for Legal name contract (in BR, CR)

Scenario: _028017 check filter for Legal name contract in the document CashReceipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check filter for Legal name contract (in BR, CR)

Scenario: _028018 check filter for Legal name contract in the document CashPayment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check filter for Legal name contract (in BP, CP)

Scenario: _028019 check filter for Legal name contract in the document CreditNote
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CreditNote"
	When check filter for Legal name contract (in CN, DN)

Scenario: _028020 check filter for Legal name contract in the document DebitNote
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.DebitNote"
	When check filter for Legal name contract (in CN, DN)

Scenario: _028021 check filter for Legal name contract in the document PurchaseInvoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	When check filter for Legal name contract (LNC in header)

Scenario: _028022 check filter for Legal name contract in the document SalesInvoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	When check filter for Legal name contract (LNC in header)

Scenario: _028023 check filter for Legal name contract in the document SalesReturn
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	When check filter for Legal name contract (LNC in header)

Scenario: _028024 check filter for Legal name contract in the document PurchaseReturn
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	When check filter for Legal name contract (LNC in header)

Scenario: _028025 check filter for Legal name contract in the document RetailSalesReceipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	When check filter for Legal name contract (LNC in header)

Scenario: _028026 check filter for Legal name contract in the document RetailReturnReceipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	When check filter for Legal name contract (LNC in header)

Scenario: _028027 check filter for Legal name contract in the document RetailReceiptCorrection
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReceiptCorrection"
	When check filter for Legal name contract (LNC in header)


Scenario: _028050 check the filter by Company when selecting cash/bank in Cash expense document
	* Temporary filling in Cash desk 3 Second Company
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I click "Save and close" button
	* Open form Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Check the filter by Company when selecting cash register/bank
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And "List" table does not contain lines
			| 'Description'     |
			| 'Cash desk №3'    |
		And I close all client application windows
	* Changing back to Cash Desk 3 to Main Company
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click "Save and close" button


Scenario: _028051 check filter by own companies in the document Cash expense
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
	* Check the filter for Own Company
		When check the filter by my own company in Cash expence/Cash revenue

Scenario: _028052 check filter by own companies in the document Cash revenue
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
	* Check the filter for Own Company
		When check the filter by my own company in Cash expence/Cash revenue

Scenario: _028053 check the filter for Company in the document Reconcilation statement 
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	When check the filter by my own company in Reconcilation statement

Scenario: _028054 check if the Legal name field in the Reconcilation statement is present 
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	And I click the button named "FormCreate"
	And I click Select button of "Legal name" field
	Then "Companies" window is opened
	And I close all client application windows

Scenario: _028055 check Description in the document Reconcilation statement 
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	When check Description



Scenario: _028056 check Description in the document CreditNote
	Given I open hyperlink "e1cib/list/Document.CreditNote"
	When check Description

Scenario: _028057 check Description in the document DebitNote
	Given I open hyperlink "e1cib/list/Document.DebitNote"
	When check Description

Scenario: _028058 check the filter for Legal name in the document Goods receipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I click the button named "FormCreate"
	And I select "Purchase" exact value from "Transaction type" drop-down list
	When check the filter by Legal name (Ferron) in Goods receipt and Shipment confirmation

Scenario: _028059 check the filter for Legal name in the document Shipment confirmation
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I click the button named "FormCreate"
	And I select "Sales" exact value from "Transaction type" drop-down list
	When check the filter by Legal name (Ferron) in Goods receipt and Shipment confirmation

Scenario: _028060 check Description in the document Opening entry 
	Given I open hyperlink "e1cib/list/Document.OpeningEntry"
	When check Description


Scenario: _028061 check filter by own companies in the document  Opening entry
	* Open document form
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry/Item stock adjustment

Scenario: _028062 check Description in the document Inventory transfer
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	When check Description
	And I close all client application windows


Scenario: _028063 check Description in the document ConsolidatedRetailSales
	Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
	When check Description


Scenario: _028064 check Description in the document ItemStockAdjustment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
	When check Description


Scenario: _028065 check filter by own companies in the document Item stock adjustment
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry/Item stock adjustment


Scenario: _028066 check filter by partner in the document Goods receipt (Return from customer)
	* Open document form
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Check filter by partner in the document Goods receipt (Return from customer)
		And I select "Return from customer" exact value from "Transaction type" drop-down list			
		When check the filter by customers in the sales documents


Scenario: _028067 check filter by partner in the document Goods receipt (Purchase)
	* Open document form
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Check filter by partner in the document Goods receipt (Return from customer)
		And I select "Purchase" exact value from "Transaction type" drop-down list	
		When check the filter by vendors in the purchase documents


Scenario: _028067 check filter by partner in the document Shipment confirmation (Return to vendor)
	* Open document form
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Check filter by partner in the document Shipment confirmation (Return to vendor)
		And I select "Return to vendor" exact value from "Transaction type" drop-down list			
		When check the filter by vendors in the purchase documents

	
Scenario: _028068 check Description in the document PlannedReceiptReservation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
	When check Description

Scenario: _028069 check filter by own companies in the document PlannedReceiptReservation
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry/Item stock adjustment



Scenario: _028071 check Description in the document SalesOrderClosing
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
	When check Description


Scenario: _028072 check filter by own companies in the document Vendors advances closing
	* Open document form
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry/Item stock adjustment

Scenario: _028073 check filter by own companies in the document Customers advances closing
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry/Item stock adjustment


Scenario: _028074 check Description in the document Retail sales receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	When check Description

Scenario: _028075 check Description in the document Retail return receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	When check Description

Scenario: _028076 check filter by own companies in the document Consolidated retail sales
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry/Item stock adjustment

Scenario: _028077 check filter by own companies in the document DebitCreditNote
	* Open document form
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry/Item stock adjustment