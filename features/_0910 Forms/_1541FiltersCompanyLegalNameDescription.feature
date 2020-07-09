#language: ru
@tree
@Positive

Функционал: filter by Company and Legal name on document forms




Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _017006 check the filter for Legal name in the document Purchase Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	Когда check the filter by Legal name (Ferron)


Сценарий: _017007 check the filter for Company in the document Purchase Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	Когда check the filter by Company (Ferron)
	
Сценарий: _017008 check Description in the document Purchase Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	Когда check Description

Сценарий: _017009 check the filter for Vendor in the document Purchase Order
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendors in the purchase documents


Сценарий: _017010 check the filter for Vendors partner terms in the document Purchase Order
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendor partner terms in the purchase documents



Сценарий: _018013 check the filter for Legal name in the document Purchase Invoice
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	Когда check the filter by Legal name (Ferron)


Сценарий: _018014 check the filter for Company in the document Purchase Invoice
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	Когда check the filter by Company (Ferron)
	
Сценарий: _018015 check Description in the document Purchase Invoice
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	Когда check Description

Сценарий: _018016 check the filter for Vendor in the document PurchaseInvoice
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendors in the purchase documents


Сценарий: _018017 check the filter for Vendors partner terms in the document Purchase Invoice
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendor partner terms in the purchase documents


Сценарий: _022011 check the filter for Legal name in the document Purchase Return Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	Когда check the filter by Legal name (Ferron)


Сценарий: _022012 check the filter for Company in the document Purchase Return Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	Когда check the filter by Company (Ferron)
	
Сценарий: _022013 check Description in the document Purchase Return Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	Когда check Description

Сценарий: _022014 check the filter for Vendor in the document PurchaseReturnOrder
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendors in the purchase documents

Сценарий: _022015 check the filter for Vendors partner terms in the document Purchase Return Order
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendor partner terms in the purchase documents


Сценарий: _022330 check the filter for Legal name in the document Purchase Return
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	Когда check the filter by Legal name (Ferron)


Сценарий: _022331 check the filter for Company in the document Purchase Return
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	Когда check the filter by Company (Ferron)
	
Сценарий: _022332 check Description in the document Purchase Return
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	Когда check Description

Сценарий: _022333 check the filter for Vendor in the document PurchaseReturn
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendors in the purchase documents

Сценарий: _022334 check the filter for Vendors partner terms in the document Purchase Return
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by vendor partner terms in the purchase documents



Сценарий: _020015 check the filter for Company in the document Inventory Transfer Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	Когда check the filter by Company  in the inventory transfer



Сценарий: _021049 check the filter for Company in the document Inventory Transfer
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	Когда check the filter by Company  in the inventory transfer



Сценарий: _023107 check the filter for Legal name in the document Sales order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	Когда check the filter by Legal name

Сценарий: _023108 check the filter for Partner terms (segments and validity period) in the document SalesOrder
	check Partner term filter 
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	Когда check the filter by Partner term (by segments + expiration date)

Сценарий: _023109 check the filter for Company in the document Sales order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	Когда check the filter by Company
	
Сценарий: _023110 check Description in the document Sales order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	Когда check Description

Сценарий: _023111 check the filter for Customer in the document SalesOrder
	И я закрыл все окна клиентского приложения
	* Open a form to create Sales Order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by customers in the sales documents


Сценарий: _023112 check the filter for Customers partner terms in the document SalesOrder
	И я закрыл все окна клиентского приложения
	* Open a form to create Sales Order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by customer partner terms in the sales documents


Сценарий: _024036 check the filter for Legal name in the document Sales invoice
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда check the filter by Legal name

Сценарий: _024037 check the filter for Partner terms (segments and validity period) in the document
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда check the filter by Partner term (by segments + expiration date)

Сценарий: _024038 check the filter for Company in the document Sales invoice
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда check the filter by Company
	
Сценарий: _024039 check Description in the document Sales invoice
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда check Description

Сценарий: _024040 check the filter for Customer in the document SalesInvoice
	И я закрыл все окна клиентского приложения
	* Open a form to create Sales Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by customers in the sales documents


Сценарий: _024041 check the filter for Customers partner terms in the document SalesInvoice
	И я закрыл все окна клиентского приложения
	* Open a form to create SalesInvoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by customer partner terms in the sales documents



Сценарий: _028529 check the filter for Legal name in the document Sales return
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда check the filter by Legal name

Сценарий: _028530 check the filter for Partner terms (segments and validity period) in the document Sales return
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда check the filter by Partner term (by segments + expiration date)

Сценарий: _028531 check the filter for Company in the document Sales return
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда check the filter by Company
	
Сценарий: _028532 check Description in the document Sales return
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда check Description

Сценарий: _028533 check the filter for Customer in the document SalesReturn
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by customers in the sales documents


Сценарий: _028812 check the filter for Company in the document Shipment Confirmation
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	Когда check the filter by Company  in the Shipment cinfirmation and Goods receipt

Сценарий: _028813 check Description in the document Shipment Confirmation
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	Когда check Description



Сценарий: _028906 check the filter for Company in the document Goods Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	Когда check the filter by Company  in the Shipment cinfirmation and Goods receipt

Сценарий: _028907 check Description in the document Goods Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	Когда check Description




Сценарий: _029520 check the filter for Company in the document Bundling
	И я закрыл все окна клиентского приложения 
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	Когда check the filter by Company  in the Shipment cinfirmation and Goods receipt

Сценарий: _029521 check Description in the document Bundling
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	Когда check Description



Сценарий: _029613 check the filter for Company in the document Unbundling
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	Когда check the filter by Company  in the Shipment cinfirmation and Goods receipt

Сценарий: _029614 check Description in the document Unbundling
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	Когда check Description


Сценарий: _029728 check the filter for Company in the document StockAdjustmentAsWriteOff
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	Когда check the filter by Company  in the Shipment cinfirmation and Goods receipt


Сценарий: _029729 check the filter for Company in the document StockAdjustmentAsSurplus
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
	Когда check the filter by Company  in the Shipment cinfirmation and Goods receipt



Сценарий: _029816 check Description in the document PhysicalCountByLocation
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
	Когда check Description

Сценарий: _029817 check Description in the document PhysicalInventory
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
	Когда check Description
	

Сценарий: _028007 check the filter for Legal name in the document Sales return order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда check the filter by Legal name

Сценарий: _028008 check the filter for Partner terms (segments and validity period) in the document Sales return order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда check the filter by Partner term (by segments + expiration date)

Сценарий: _028009 check the filter for Company in the document Sales return order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда check the filter by Company
	
Сценарий: _028010 check Description in the document Sales return order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда check Description

Сценарий: _028011 check the filter for Customer in the document SalesReturnOrder
	И я закрыл все окна клиентского приложения
	* Open a form to create Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	Когда check the filter by customers in the sales documents

Сценарий: _028012 check Description in the document Labeling
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.Labeling'
	Когда check Description


Сценарий: check the filter by Company when selecting cash/bank in Cash expense document
	* Temporary filling in Cash desk 3 Second Company
		И я открываю навигационную ссылку 'e1cib/list/Catalog.CashAccounts'
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Open form Cash expense
		И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Checking the filter by Company when selecting cash register/bank
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Account"
		Тогда таблица "List" не содержит строки:
			| 'Description'  |
			| 'Cash desk №3' |
		И я закрыл все окна клиентского приложения
	* Changing back to Cash Desk 3 to Main Company
		И я открываю навигационную ссылку 'e1cib/list/Catalog.CashAccounts'
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Cash desk №3' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'


Сценарий: check filter by own companies in the document Cash expense
	* Open document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
	* Check the filter for Own Company
		Когда check the filter by my own company in Cash expence/Cash revenue

Сценарий: check filter by own companies in the document Cash revenue
	* Open document form
		И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
	* Check the filter for Own Company
		Когда check the filter by my own company in Cash expence/Cash revenue

Сценарий: check the filter for Company in the document Reconcilation statement 
	И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
	Когда check the filter by my own company in Reconcilation statement

Сценарий: check if the Legal name field in the Reconcilation statement is present 
	И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Legal name"
	Тогда открылось окно 'Companies'
	И Я закрыл все окна клиентского приложения

Сценарий: check Description in the document Reconcilation statement 
	И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
	Когда check Description

Сценарий: check the filter for Company in the document CreditDebitNote
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
	Когда check the filter by Company

Сценарий: check Description in the document CreditDebitNote
	И я открываю навигационную ссылку "e1cib/list/Document.CreditDebitNote"
	Когда check Description

Сценарий: check the filter for Legal name in the document Goods receipt
	И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Purchase'
	Когда check the filter by Legal name (Ferron) in Goods receipt and Shipment confirmation

Сценарий: check the filter for Legal name in the document Shipment confirmation
	И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
	Когда check the filter by Legal name (Ferron) in Goods receipt and Shipment confirmation

Сценарий: check Description in the document Opening entry 
	И я открываю навигационную ссылку "e1cib/list/Document.OpeningEntry"
	Когда check Description


Сценарий: check filter by own companies in the document  Opening entry
	* Open document form
		И я открываю навигационную ссылку "e1cib/list/Document.OpeningEntry"
	* Check the filter for Own Company
		Когда check the filter by my own company in Opening entry

Сценарий: check Description in the document Inventory transfer
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	Когда check Description
	И я закрыл все окна клиентского приложения

Сценарий: check Description in the document Invoice match
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
	Когда check Description
	И я закрыл все окна клиентского приложения

	


