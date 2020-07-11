#language: ru
@tree
@Positive

Функционал: check the display of the header of the collapsible group in documents



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: check the display of the header of the collapsible group in Purchase Order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _018021 check the display of the header of the collapsible group in Purchase Invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _022017 check the display of the header of the collapsible group in Purchase Return Order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _022337 check the display of the header of the collapsible group in Purchase Return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _020016 check the display of the header of the collapsible group in Inventory Transfer Order
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	Когда check the display of the header of the collapsible group in inventory transfer
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store sender: Store 02   Store receiver: Store 03   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store sender"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _021050 check the display of the header of the collapsible group in Inventory Transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	Когда check the display of the header of the collapsible group in inventory transfer
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store sender: Store 02   Store receiver: Store 03"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store sender"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _023114 check the display of the header of the collapsible group in Sales order
	* Open list form Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in sales, purchase and return documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Approved"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _024044 check the display of the header of the collapsible group in Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _028014 check the display of the header of the collapsible group in Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028536 check the display of the header of the collapsible group in Sales return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028814 check the display of the header of the collapsible group in Shipment Confirmation
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028908 check the display of the header of the collapsible group in Goods Receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _028909 check the display of the header of the collapsible group in StockAdjustmentAsWriteOff
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _028909 check the display of the header of the collapsible group in StockAdjustmentAsSurplus
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _029522 check the display of the header of the collapsible group in Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения




Сценарий: _029615 check the display of the header of the collapsible group in Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _050012 check the display of the header of the collapsible group in Cash reciept
	И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
	Когда check the display of the header of the collapsible group in cash receipt document
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Cash account: Cash desk №2   Currency: USD   Transaction type: Payment from customer   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _051011 check the display of the header of the collapsible group in Cash payment
	И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
	Когда check the display of the header of the collapsible group in cash payment document
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Cash account: Cash desk №2   Currency: USD   Transaction type: Payment to the vendor   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _052012 check the display of the header of the collapsible group in Bank Receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
	Когда check the display of the header of the collapsible group in bank payments documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Transaction type: Payment from customer   Currency: USD   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _053012 check the display of the header of the collapsible group in Bank payment
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	Когда check the display of the header of the collapsible group in bank payments documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Transaction type: Payment to the vendor   Currency: USD   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения




Сценарий: _056006 check the display of the header of the collapsible group in Invoice Match
	И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
	Когда check the display of the header of the collapsible group in invoice match
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Operation type: With customer   Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Partner term: Basic Partner terms, TRY"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02013 check the display of the header of the collapsible group in Reconcilation statement
	И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in sales, purchase and return documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02014 check the display of the header of the collapsible group in PhysicalCountByLocation
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in PhysicalCountByLocation
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Store: Store 01"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Responsible person"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _020140 check the display of the header of the collapsible group in Physical Inventory
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in PhysicalInventory
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Store: Store 01"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _02015 check the display of the header of the collapsible group in OpeningEntry
	И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in OpeningEntry
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02016 check the display of the header of the collapsible group in Cash expense
	И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in expence/revenue documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, TRY"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02017 check the display of the header of the collapsible group in CreditDebitNote
	И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in sales, purchase and return documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02018 check the display of the header of the collapsible group in Internal supply request
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст " Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02019 check the display of the header of the collapsible group in OutgoingPaymentOrder
	И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in bank payments documents
		Когда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Currency: USD   Status: Wait   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02020 check the display of the header of the collapsible group in IncomingPaymentOrder
	И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
	* Check the display of the header of the collapsible group
		Когда check the display of the header of the collapsible group in bank payments documents
		Когда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Currency: USD "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения