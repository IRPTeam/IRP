#language: en
@tree
@Positive

Feature: filter by Company and Legal name on document forms




Background:
	Given I launch TestClient opening script or connect the existing one


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
	check Partner term filter 
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


Scenario: check the filter by Company when selecting cash/bank in Cash expense document
	* Temporary filling in Cash desk 3 Second Company
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Open form Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Check the filter by Company when selecting cash register/bank
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And "List" table does not contain lines
			| 'Description'  |
			| 'Cash desk №3' |
		And I close all client application windows
	* Changing back to Cash Desk 3 to Main Company
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company' |
		And I select current line in "List" table
		And I click "Save and close" button


Scenario: check filter by own companies in the document Cash expense
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
	* Check the filter for Own Company
		When check the filter by my own company in Cash expence/Cash revenue

Scenario: check filter by own companies in the document Cash revenue
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
	* Check the filter for Own Company
		When check the filter by my own company in Cash expence/Cash revenue

Scenario: check the filter for Company in the document Reconcilation statement 
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	When check the filter by my own company in Reconcilation statement

Scenario: check if the Legal name field in the Reconcilation statement is present 
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	And I click the button named "FormCreate"
	And I click Select button of "Legal name" field
	Then "Companies" window is opened
	And I close all client application windows

Scenario: check Description in the document Reconcilation statement 
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	When check Description

Scenario: check the filter for Company in the document CreditDebitNote
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CreditDebitNote"
	When check the filter by Company

Scenario: check Description in the document CreditDebitNote
	Given I open hyperlink "e1cib/list/Document.CreditDebitNote"
	When check Description

Scenario: check the filter for Legal name in the document Goods receipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I click the button named "FormCreate"
	And I select "Purchase" exact value from "Transaction type" drop-down list
	When check the filter by Legal name (Ferron) in Goods receipt and Shipment confirmation

Scenario: check the filter for Legal name in the document Shipment confirmation
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I click the button named "FormCreate"
	And I select "Sales" exact value from "Transaction type" drop-down list
	When check the filter by Legal name (Ferron) in Goods receipt and Shipment confirmation

Scenario: check Description in the document Opening entry 
	Given I open hyperlink "e1cib/list/Document.OpeningEntry"
	When check Description


Scenario: check filter by own companies in the document  Opening entry
	* Open document form
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
	* Check the filter for Own Company
		When check the filter by my own company in Opening entry

Scenario: check Description in the document Inventory transfer
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	When check Description
	And I close all client application windows

Scenario: check Description in the document Invoice match
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
	When check Description
	And I close all client application windows

	



