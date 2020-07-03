#language: ru
@tree
@Positive

Функционал: проверка сворачиваемых заголовков в документах

Как тестировщик
Я хочу проверить наличие в документах сворачиваемых заголовков


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: проверяю отображения заголовка сворачиваемой группы при создании документа Purchase Order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _018021 проверяю отображения заголовка сворачиваемой группы при создании Purchase Invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _022017 проверяю отображения заголовка сворачиваемой группы при создании документа Purchase Return Order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _022337 проверяю отображения заголовка сворачиваемой группы при создании Purchase Return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _020016 check the display of the header of the collapsible group in документе Inventory Transfer Order
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	Когда check the display of the header of the collapsible group in inventory transfer
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store sender: Store 02   Store receiver: Store 03   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store sender"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _021050 check the display of the header of the collapsible group in документе Inventory Transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	Когда check the display of the header of the collapsible group in inventory transfer
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store sender: Store 02   Store receiver: Store 03"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store sender"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _023114 проверяю отображения заголовка сворачиваемой группы при создании документа Sales order
	* Open list form документов Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in sales, purchase and return documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Approved"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _024044 проверяю отображения заголовка сворачиваемой группы при создании Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _028014 проверяю отображения заголовка сворачиваемой группы при создании документа Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028536 проверяю отображения заголовка сворачиваемой группы при создании документа Sales return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда check the display of the header of the collapsible group in sales, purchase and return documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028814 проверяю отображения заголовка сворачиваемой группы при создании документа Shipment Confirmation
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028908 проверяю отображения заголовка сворачиваемой группы при создании документа Goods Receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _028909 проверяю отображения заголовка сворачиваемой группы при создании документа StockAdjustmentAsWriteOff
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _028909 проверяю отображения заголовка сворачиваемой группы при создании документа StockAdjustmentAsSurplus
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _029522 проверяю отображения заголовка сворачиваемой группы при создании документа Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения




Сценарий: _029615 проверяю отображения заголовка сворачиваемой группы при создании документа Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _050012 check the display of the header of the collapsible group in в документе Cash reciept
	И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
	Когда check the display of the header of the collapsible group in cash receipt document
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Cash account: Cash desk №2   Currency: USD   Transaction type: Payment from customer   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _051011 check the display of the header of the collapsible group in документе Cash payment
	И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
	Когда check the display of the header of the collapsible group in cash payment document
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Cash account: Cash desk №2   Currency: USD   Transaction type: Payment to the vendor   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _052012 check the display of the header of the collapsible group in документе Bank Receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
	Когда check the display of the header of the collapsible group in bank payments documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Transaction type: Payment from customer   Currency: USD   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _053012 check the display of the header of the collapsible group in документе Bank payment
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	Когда check the display of the header of the collapsible group in bank payments documents
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Transaction type: Payment to the vendor   Currency: USD   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения




Сценарий: _056006 check the display of the header of the collapsible group in документе Invoice Match
	И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
	Когда check the display of the header of the collapsible group in invoice match
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Operation type: With customer   Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Agreement: Basic Agreements, TRY"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02013 check the display of the header of the collapsible group in документе Reconcilation statement
	И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in sales, purchase and return documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02014 check the display of the header of the collapsible group in документе PhysicalCountByLocation
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in PhysicalCountByLocation
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Store: Store 01"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Responsible person"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _020140 check the display of the header of the collapsible group in документе Physical Inventory
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in PhysicalInventory
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Store: Store 01"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _02015 check the display of the header of the collapsible group in документе OpeningEntry
	И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in OpeningEntry
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02016 check the display of the header of the collapsible group in документе Cash expense
	И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in expence/revenue documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, TRY"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02017 check the display of the header of the collapsible group in документе CreditDebitNote
	И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in sales, purchase and return documents
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02018 check the display of the header of the collapsible group in документе Internal supply request
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст " Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02019 check the display of the header of the collapsible group in документе OutgoingPaymentOrder
	И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in bank payments documents
		Когда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Currency: USD   Status: Wait   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02020 check the display of the header of the collapsible group in документе IncomingPaymentOrder
	И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
	* Проверка формирования заголовка сворачиваемой группы
		Когда check the display of the header of the collapsible group in bank payments documents
		Когда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Currency: USD "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения