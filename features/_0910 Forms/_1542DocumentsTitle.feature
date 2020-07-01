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
	Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _018021 проверяю отображения заголовка сворачиваемой группы при создании Purchase Invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _022017 проверяю отображения заголовка сворачиваемой группы при создании документа Purchase Return Order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _022337 проверяю отображения заголовка сворачиваемой группы при создании Purchase Return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _020016 проверяю отображения заголовка сворачиваемой группы в документе Inventory Transfer Order
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	Когда проверяю отображения заголовка сворачиваемой группы в документах перемещения товара
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store sender: Store 02   Store receiver: Store 03   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store sender"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _021050 проверяю отображения заголовка сворачиваемой группы в документе Inventory Transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	Когда проверяю отображения заголовка сворачиваемой группы в документах перемещения товара
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store sender: Store 02   Store receiver: Store 03"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store sender"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _023114 проверяю отображения заголовка сворачиваемой группы при создании документа Sales order
	* Открытие формы списка документов Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Approved"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _024044 проверяю отображения заголовка сворачиваемой группы при создании Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _028014 проверяю отображения заголовка сворачиваемой группы при создании документа Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Status: Wait"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028536 проверяю отображения заголовка сворачиваемой группы при создании документа Sales return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Partner"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028814 проверяю отображения заголовка сворачиваемой группы при создании документа Shipment Confirmation
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	Когда проверяю отображения заголовка сворачиваемой группы в документах 	приходного и расходного ордера по складу, Bundling/Unbundling, Boxing/Unboxing
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _028908 проверяю отображения заголовка сворачиваемой группы при создании документа Goods Receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	Когда проверяю отображения заголовка сворачиваемой группы в документах 	приходного и расходного ордера по складу, Bundling/Unbundling, Boxing/Unboxing
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _028909 проверяю отображения заголовка сворачиваемой группы при создании документа StockAdjustmentAsWriteOff
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	Когда проверяю отображения заголовка сворачиваемой группы в документах 	приходного и расходного ордера по складу, Bundling/Unbundling, Boxing/Unboxing
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _028909 проверяю отображения заголовка сворачиваемой группы при создании документа StockAdjustmentAsSurplus
	И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
	Когда проверяю отображения заголовка сворачиваемой группы в документах 	приходного и расходного ордера по складу, Bundling/Unbundling, Boxing/Unboxing
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _029522 проверяю отображения заголовка сворачиваемой группы при создании документа Bundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	Когда проверяю отображения заголовка сворачиваемой группы в документах 	приходного и расходного ордера по складу, Bundling/Unbundling, Boxing/Unboxing
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения




Сценарий: _029615 проверяю отображения заголовка сворачиваемой группы при создании документа Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	Когда проверяю отображения заголовка сворачиваемой группы в документах 	приходного и расходного ордера по складу, Bundling/Unbundling, Boxing/Unboxing
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _050012 проверяю отображения заголовка сворачиваемой группы в в документе Cash reciept
	И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
	Когда проверяю отображения заголовка сворачиваемой группы в поступлении денег в кассу
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Cash account: Cash desk №2   Currency: USD   Transaction type: Payment from customer   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _051011 проверяю отображения заголовка сворачиваемой группы в документе Cash payment
	И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
	Когда проверяю отображения заголовка сворачиваемой группы в оплате из кассы
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Cash account: Cash desk №2   Currency: USD   Transaction type: Payment to the vendor   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _052012 проверяю отображения заголовка сворачиваемой группы в документе Bank Receipt
	И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
	Когда проверяю отображения заголовка сворачиваемой группы в платежных документах по банку
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Transaction type: Payment from customer   Currency: USD   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _053012 проверяю отображения заголовка сворачиваемой группы в документе Bank payment
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	Когда проверяю отображения заголовка сворачиваемой группы в платежных документах по банку
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Transaction type: Payment to the vendor   Currency: USD   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения




Сценарий: _056006 проверяю отображения заголовка сворачиваемой группы в документе Invoice Match
	И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
	Когда проверяю отображения заголовка сворачиваемой группы в документе сопоставления оплаты с документами основаниями
	Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Operation type: With customer   Company: Main Company   Partner: Ferron BP   Legal name: Company Ferron BP   Agreement: Basic Agreements, TRY"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02013 проверяю отображения заголовка сворачиваемой группы в документе Reconcilation statement
	И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02014 проверяю отображения заголовка сворачиваемой группы в документе PhysicalCountByLocation
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в PhysicalCountByLocation
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Store: Store 01"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Responsible person"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _020140 проверяю отображения заголовка сворачиваемой группы в документе Physical Inventory
	И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в PhysicalInventory
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Store: Store 01"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Store"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения



Сценарий: _02015 проверяю отображения заголовка сворачиваемой группы в документе OpeningEntry
	И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в OpeningEntry
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02016 проверяю отображения заголовка сворачиваемой группы в документе Cash expense
	И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в документах расходов/доходов
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, TRY"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения


Сценарий: _02017 проверяю отображения заголовка сворачиваемой группы в документе CreditDebitNote
	И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в документах продажи, закупки и возвратов при создании документа
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Legal name: Company Ferron BP"
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02018 проверяю отображения заголовка сворачиваемой группы в документе Internal supply request
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в документах 	приходного и расходного ордера по складу, Bundling/Unbundling, Boxing/Unboxing
		Тогда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст " Company: Main Company   Store: Store 03   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02019 проверяю отображения заголовка сворачиваемой группы в документе OutgoingPaymentOrder
	И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в платежных документах по банку
		Когда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Currency: USD   Status: Wait   "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения

Сценарий: _02020 проверяю отображения заголовка сворачиваемой группы в документе IncomingPaymentOrder
	И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
	* Проверка формирования заголовка сворачиваемой группы
		Когда проверяю отображения заголовка сворачиваемой группы в платежных документах по банку
		Когда значение поля с именем "DecorationGroupTitleUncollapsedLabel" содержит текст "Company: Main Company   Account: Bank account, USD   Currency: USD "
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleUncollapsedLabel"
	Когда Проверяю шаги на Исключение:
        |'И     я нажимаю кнопку выбора у поля "Company"'|
	И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
	И Я закрыл все окна клиентского приложения