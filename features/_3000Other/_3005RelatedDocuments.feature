#language: ru
@tree
@Positive
Функционал: related documents

Как Разработчик
Я хочу к документам подключить систему структуры подчиненности
Для того чтобы видеть зависимости документов

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _300501 check connection to Internal Supply Request report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                           | 'Amount' |
		# | 'Internal supply request 1*'    | '*'       |
		# | 'Inventory transfer order 200*' | '*'       |
		# | 'Purchase order 1*'             | '*'      |
	И я закрыл все окна клиентского приложения

Сценарий: _300502 check connection to Purchase order report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 2      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                      | 'Amount'  |
		# | 'Purchase order 2*'        | '161 660' |
		# | 'Purchase invoice 1*'      | '161 660' |
		# | 'Purchase return 2*'       | '708,00'  |
		# | 'Purchase return order 2*' | '708,00'  |
	И я закрыл все окна клиентского приложения

Сценарий: _300503 check connection to Purchase invoice report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 2      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                      | 'Amount'   |
		# | 'Purchase order 3*'        | '23 600'       |
		# | 'Purchase invoice 2*'      | '23 600'       |
		# | 'Bank payment 1*'          | '1 000,00' |
		# | 'Cash payment 1*'          | '1 000,00' |
		# | 'Cash payment 2*'          | '20,00'    |
		# | 'Cash payment 3*'          | '150,00'   |
		# | 'Goods receipt 106*'       | '*'         |
		# | 'Purchase return 1*'       | '94,40'    |
		# | 'Purchase return order 1*' | '94,40'    |
	И я закрыл все окна клиентского приложения

Сценарий: _300504 check connection to Sales order report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                   | 'Amount'   |
		# | 'Sales order 1*'        | '4 350,00' |
		# | 'Sales invoice 1*'      | '4 350,00' |
		# | 'Sales return order 2*' | '2 700,00' |
		# | 'Sales return 4*'       | '2 700,00' |
	И я закрыл все окна клиентского приложения

Сценарий: _300505 check connection to Sales invoice report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                   | 'Amount'   |
		# | 'Sales order 1*'        | '4 350,00' |
		# | 'Sales invoice 1*'      | '4 350,00' |
		# | 'Cash receipt 1*'       | '100,00'   |
		# | 'Cash receipt 2*'       | '100,00'   |
		# | 'Sales return order 2*' | '2 700,00' |
		# | 'Sales return 4*'       | '2 700,00' |
		# | 'Bank receipt 1*'       | '100,00'   |
	И я закрыл все окна клиентского приложения

Сценарий: _300506 check connection to Shipment Confirmation report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 181      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                       | 'Amount'    |
		# | 'Sales order 2*'            | '11 099,93' |
		# | 'Sales invoice 2*'          | '11 099,93' |
		# | 'Shipment confirmation 95*' | '*'        |
	И я закрыл все окна клиентского приложения


Сценарий: _300507 check connection to GoodsReceipt report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 170      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                | Amount |
		# | 'Boxing 2*'          | '*'     |
		# | 'Goods receipt 170'  | '*'     |
	И я закрыл все окна клиентского приложения

Сценарий: _300508 check connection to PurchaseReturnOrder report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturnOrder"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                      | 'Amount' |
		# | 'Purchase order 3*'        | '*'     |
		# | 'Purchase invoice 2*'      | '*'     |
		# | 'Purchase return order 1*' | '94,40'  |
		# | 'Purchase return 1*'       | '94,40'  |
	И я закрыл все окна клиентского приложения

Сценарий: _300509 check connection to PurchaseReturn report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturn"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                      | 'Amount' |
		# | 'Purchase invoice 2*'      | '*'     |
		# | 'Purchase return order 1*' | '94,40'  |
		# | 'Purchase return 1*'       | '94,40'  |
	И я закрыл все окна клиентского приложения

Сценарий: _300510 check connection to SalesReturnOrder report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                   | 'Amount'    |
		# | 'Sales order 2*'        | '11 099,93' |
		# | 'Sales invoice 2*'      | '11 099,93' |
		# | 'Sales return order 1*' | '550,00'    |
		# | 'Sales return 3*'       | '550,00'    |
	И я закрыл все окна клиентского приложения

Сценарий: _300511 check connection to SalesReturn report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.SalesReturn"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 2      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'              | 'Amount'    |
		# | 'Sales order 2*'   | '11 099,93' |
		# | 'Sales invoice 2*' | '11 099,93' |
		# | 'Sales return 2*'  | '550,00'    |
	И я закрыл все окна клиентского приложения

Сценарий: _300512 check connection to CashPayment report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.CashPayment"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                 | 'Amount'   |
		# | 'Purchase order 3*'   | '*'        |
		# | 'Purchase invoice 2*' | '*'        |
		# | 'Cash payment 1*'     | '1 000,00' |
	И я закрыл все окна клиентского приложения

Сценарий: _300513 check connection to CashReciept report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'              | 'Amount'   |
		# | 'Sales order 1*'   | '4 350,00' |
		# | 'Sales invoice 1*' | '4 350,00' |
		# | 'Cash receipt 1*'  | '100,00'   |
	И я закрыл все окна клиентского приложения

Сценарий: _300514 check connection to BankPayment report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'                 | 'Amount'   |
		# | 'Purchase order 3*'   | '*'        |
		# | 'Purchase invoice 2*' | '*'        |
		# | 'Bank payment 1*'     | '1 000,00' |
	И я закрыл все окна клиентского приложения

Сценарий: _300515 check connection to BankReciept report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'              | 'Amount'   |
		# | 'Sales order 1*'   | '4 350,00' |
		# | 'Sales invoice 1*' | '4 350,00' |
		# | 'Bank receipt 1*'  | '100,00'   |
	И я закрыл все окна клиентского приложения


Сценарий: _300516 check connection to CashTransferOrder report "Related documents" и формирования отчета для текущего элемента (Cash receipt)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Ref'                    | 'Amount' |
		| 'Cash transfer order 1*' | '*'      |
		| 'Cash payment 4*'        | '500,00' |
		| 'Cash receipt 4*'        | '400,00' |
		| 'Cash receipt 5*'        | '100,00' |
	* * Check the report generation для элемента из списка
		И в таблице "DocumentsTree" я перехожу к последней строке
		И в таблице "DocumentsTree" я нажимаю на кнопку с именем 'DocumentsTreeGenerateForCurrent'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Ref'                    | 'Amount' |
		| 'Cash transfer order 1*' | ''       |
		| 'Cash receipt 5*'        | '100,00' |
	И я закрыл все окна клиентского приложения





Сценарий: _300519 check connection to Bundling report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.Bundling"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'         | Amount |
		# | 'Bundling 1*' | ''     |
	И я закрыл все окна клиентского приложения

Сценарий: _300520 check connection to Unbundling report "Related documents"
	И я открываю навигационную ссылку "e1cib/list/Document.Unbundling"
	И я формирую отчет по структуре подчиненности
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И я нажимаю на кнопку с именем 'FormFilterCriterionRelatedDocumentsRelatedDocuments'
		И Пауза 1
	Когда открылось окно 'Related documents'
		# Тогда таблица "DocumentsTree" содержит строки:
		# | 'Ref'           | Amount |
		# | 'Unbundling 1*' | ''     |
	И я закрыл все окна клиентского приложения


Сценарий: _300521 check post/unpost/mark for deletion from report "Related documents"
	* Preparation
		* Создание Sales order
			И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02 TR' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers TR' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'        | 'Item key'     |
				| 'Trousers TR' | '38/Yellow TR' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Manager segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| '2 Region'    |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Shipment confirmations before sales invoice'
			И в поле 'Number' я ввожу текст '9 012'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 012'
			И я нажимаю на кнопку 'Post'
		* Создание Shipment confirmation based on созданного SO
			И я нажимаю на кнопку 'Shipment confirmation'
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '9 012'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 012'
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
		* Создание Sales invoice based on созданного SC
			И я нажимаю на кнопку 'Sales invoice'
			И я нажимаю на кнопку с именем 'FormSelectAll'
			И я нажимаю на кнопку 'Ok'
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '9 012'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 012'
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
		* Открытие структуры подчинанности
			Когда В панели открытых я выбираю 'Sales order 9 012*'
			И я нажимаю на кнопку 'Related documents'
			Тогда таблица "DocumentsTree" содержит строки:
			| 'Ref'                          |
			| 'Sales order 9 012*'           |
			| 'Shipment confirmation 9 012*' |
			| 'Sales invoice 9 012*'         |
		* Проверка распроведения Sales invoice из структуры подчиненности
			И в таблице "DocumentsTree" я перехожу к последней строке
			И в таблице "DocumentsTree" я нажимаю на кнопку с именем 'DocumentsTreeUnpost'
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerArTransactions"
			И Пауза 10
			Тогда таблица "List" не содержит строки:
			| 'Recorder'             |
			| 'Sales invoice 9 012*' |
		* Проверка проведения Sales invoice из структуры подчиненности
			И В панели открытых я выбираю 'Related documents'
			И в таблице "DocumentsTree" я перехожу к последней строке
			И в таблице "DocumentsTree" я нажимаю на кнопку с именем 'DocumentsTreePost'
			И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerArTransactions"
			И я нажимаю на кнопку 'Refresh'
			И Пауза 10
			Тогда таблица "List" содержит строки:
			| 'Recorder'             |
			| 'Sales invoice 9 012*' |
		* Пометка на удаление Sales invoice из структуры подчиненности
			И В панели открытых я выбираю 'Related documents'
			И в таблице "DocumentsTree" я перехожу к последней строке
			И в таблице "DocumentsTree" я нажимаю на кнопку с именем 'DocumentsTreeDelete'
			И в таблице "DocumentsTree" я перехожу к последней строке
			# И в таблице "List" текущая строка помечена на удаление
		* Снятие пометки на удаление Sales invoice из структуры подчиненности
			И В панели открытых я выбираю 'Related documents'
			И в таблице "DocumentsTree" я перехожу к последней строке
			И в таблице "DocumentsTree" я нажимаю на кнопку с именем 'DocumentsTreeDelete'
			И в таблице "DocumentsTree" я перехожу к последней строке
			# И в таблице "DocumentsTree" текущая строка не помечена на удаление
		И я закрыл все окна клиентского приложения





