#language: ru
@tree
@Positive
Функционал: проведение документа перемещения ДС

Как Разработчик
Я хочу создать документа перемещения ДС
Для отражения факта перемещения ДС в отчете

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# Валюта отчетов - лира


Сценарий: _054001 создание документа перемещения ДС Cash transfer order (из кассы в кассу в одной валюте)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-353' с именем 'IRP-353'
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я заполняю информацию об отправителе и отправляемой сумме
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '500,00'
		И я нажимаю кнопку выбора у поля "Send currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я выбираю текущую строку
	И я заполняю информацию о получателе и получаемой сумме
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '500,00'
		И я нажимаю кнопку выбора у поля "Receive currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
	И я указываю дату отправления и дату получения
		И в поле 'Send date' я ввожу текст '01.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '01.07.2019  0:00:00'
	И я изменяю номер документа
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю что документ создан
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender       | Receiver     | Company      |
		| 1      | Cash desk №1 | Cash desk №2 | Main Company |
	И Я закрыл все окна клиентского приложения

Сценарий: _054002 проверка проводок документа Cash transfer order по регистру Planing cash transactions
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-353' с именем 'IRP-353'
	* Проверка движений
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'         | 'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '500,00'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '500,00'    |
		И Я закрыл все окна клиентского приложения
	* Распроведение документа списания недостач и проверка отмены проводок
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '1'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" не содержит строки:
			| 'Currency' | 'Recorder'         | 'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '500,00'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '500,00'    |
		И Я закрыл все окна клиентского приложения
	* Повторное проведение документа инвентаризации и проверка его движений
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '1'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'         | 'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '500,00'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '500,00'    |
		И Я закрыл все окна клиентского приложения





Сценарий: _054003 создание на основании Cash transfer order документа Cash payment и Cash reciept и проверка их проводок
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-353' с именем 'IRP-353'
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И в таблице "List" я перехожу к строке:
		| Number | Sender       | Receiver     | Company      |
		| 1      | Cash desk №1 | Cash desk №2 | Main Company |
	И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
	И я меняю номер документа на 4
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я проверяю заполнение табличной части
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'    | 'Amount' |
		| 'Cash transfer order 1*'             | '500,00' |
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я создаю приходный ордер на неполную сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver     | Company      |
			| 1      | Cash desk №1 | Cash desk №2 | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '400,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 4
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
	И я создаю приходный ордер на оставшуюся сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver     | Company      |
			| 1      | Cash desk №1 | Cash desk №2 | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
	И я меняю номер документа на 5
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	И я проверяю, что в табличной части указан остаток суммы
		И я перехожу к закладке "Payments"
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'   | 'Amount' |
		| 'Cash transfer order 1*'      | '100,00'    |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	И я проверяю проводки CashPayment и CashReciept созданного на основании по регистру  PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          |  'Basis document'  | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'USD'      | 'Cash payment 4*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '-500,00'   |
		| 'USD'      | 'Cash receipt 4*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '-400,00'   |
		| 'USD'      | 'Cash receipt 5*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '-100,00'   |
	И Я закрыл все окна клиентского приложения
	


Сценарий: _054004 создание документа перемещения ДС Cash transfer order (из кассы в кассу c конвертацией валюты)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-353' с именем 'IRP-353'
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я заполняю информацию об отправителе и отправляемой сумме
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '200,00'
		И я нажимаю кнопку выбора у поля "Send currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я выбираю текущую строку
	И я заполняю информацию о получателе и получаемой сумме
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '1150,00'
		И я нажимаю кнопку выбора у поля "Receive currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description  |
			| TRY  | Turkish lira |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash advance holder"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Arina Brown' |
		И в таблице "List" я выбираю текущую строку
	И я указываю дату отправления и дату получения
		И в поле 'Send date' я ввожу текст '02.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '03.07.2019  0:00:00'
	И я изменяю номер документа на 2
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	# И я проверяю заполнение курса по умолчанию
	# 	И я перехожу к закладке "Other"
	# 	И     элемент формы с именем "SendReportingCurrency" стал равен 'TRY'
	# 	И     элемент формы с именем "SendReportingCurrencySource" стал равен 'Forex Seling'
	# 	И     элемент формы с именем "SendReportingCurrencyMultiplicity" стал равен '1'
	# 	И     элемент формы с именем "ReceiveReportingCurrency" стал равен 'TRY'
	# 	И     элемент формы с именем "ReceiveReportingCurrencySource" стал равен 'Forex Seling'
	# 	И     у элемента формы с именем "ReceiveReportingCurrencyRate" текст редактирования стал равен '1,0000'
	# 	И     элемент формы с именем "ReceiveReportingCurrencyMultiplicity" стал равен '1'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю что документ создан
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender       | Receiver     | Company      |
		| 2      | Cash desk №2 | Cash desk №1 | Main Company |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'               | 'Basis document'         | 'Company'      | 'Account'      | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Amount'   |
		| 'USD'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '200,00'   |
		| 'TRY'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '1 150,00' |
	И Я закрыл все окна клиентского приложения

Сценарий: _054005 создание расходного и приходного ордера на основании перемещения ДС Cash transfer order в разных валютах и проверка проводок
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И в таблице "List" я перехожу к строке:
		| Number | Sender       | Receiver     | Company      |
		| 2      | Cash desk №2 | Cash desk №1 | Main Company |
	И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
	И я меняю номер документа на 5
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	И я проверяю заполнение табличной части
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'    | 'Amount' |
		| 'Cash transfer order 2*'             | '200,00' |
	И я заполняю  сотрудника ответсвенного за обмен денег
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Arina Brown |
		И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я создаю приходный ордер на всю сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver     | Company      |
			| 2      | Cash desk №2 | Cash desk №1 | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
	И я меняю номер документа на 7
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
	И я проверяю, что в табличной части указана верная сумма зачисления
		И я перехожу к закладке "Payments"
		И Пауза 5
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'         | 'Partner'            | 'Amount'      | 'Amount exchange' |
		| 'Cash transfer order 2*'            | 'Arina Brown'        | '1 150,00'    | '200,00'          |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	И я проверяю проводки CashPayment и CashReciept созданного на основании по регистру  PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'               | 'Basis document'         | 'Company'      | 'Account'      | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Amount'    |
		| 'USD'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '200,00'    |
		| 'TRY'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '1 150,00'  |
		| 'USD'      | 'Cash payment 5*'        | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '-200,00'   |
		| 'TRY'      | 'Cash receipt 7*'        | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '-1 150,00' |
	И я проверяю проводки CashPayment и Cash receipt созданного на основании по Cash transfer order (конвертация) по регистру AccountBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.AccountBalance"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'        | 'Company'      | 'Account'      | 'Amount'   |
		| 'TRY'      | 'Cash receipt 7*' | 'Main Company' | 'Cash desk №1' | '1 150,00' |
		| 'USD'      | 'Cash payment 5*' | 'Main Company' | 'Cash desk №2' | '200,00' |
		И Я закрыл все окна клиентского приложения

	
Сценарий: _054006 создание перемещения ДС Cash transfer order (из кассы в банк в одной валюте)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я заполняю информацию об отправителе и отправляемой сумме
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Send currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '500,00'
	И я заполняю информацию о получателе и получаемой сумме
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, USD |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '500,00'
	И я указываю дату отправления и дату получения
		И в поле 'Send date' я ввожу текст '01.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '02.07.2019  0:00:00'
	И я изменяю номер документа
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю что документ создан
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender       | Receiver          | Company      |
		| 3      | Cash desk №1 | Bank account, USD | Main Company |
	И Я закрыл все окна клиентского приложения
	И я провожу Cash payment
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver          | Company      |
			| 3      | Cash desk №1 | Bank account, USD | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		И я проверяю заполнение табличной части
			И     таблица "PaymentList" содержит строки:
			| 'Planing transaction basis'    | 'Amount' |
			| 'Cash transfer order 3*'             | '500,00' |
		И я меняю номер документа на 6
			И в поле 'Number' я ввожу текст '6'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '6'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	И я провожу Bank reciept
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver          | Company      |
			| 3      | Cash desk №1 | Bank account, USD | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		И Пауза 5
		И я меняю номер документа на 4
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я проверяю заполнение табличной части
			И я перехожу к закладке "Payments"
			И     таблица "PaymentList" содержит строки:
			| 'Amount' | 'Planing transaction basis'  |
			| '500,00'    |  'Cash transfer order 3*'          |
		И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки документов по регистру PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency'| 'Recorder'               |  'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction'   | 'Amount'    |
		| 'USD'     | 'Cash transfer order 3*' | 'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'              | '500,00'    |
		| 'USD'     | 'Cash transfer order 3*' | 'Cash transfer order 3*' | 'Main Company' | 'Bank account, USD' | 'Incoming'              | '500,00'    |
		| 'USD'     | 'Cash payment 6*'        | 'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'              | '-500,00'   |
		| 'USD'     | 'Bank receipt 4*'        | 'Cash transfer order 3*' | 'Main Company' | 'Bank account, USD' | 'Incoming'              | '-500,00'   |
		И Я закрыл все окна клиентского приложения 

Сценарий: _054007 создание перемещения ДС Cash transfer order из банка в кассу (в одной валюте)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я заполняю информацию об отправителе и отправляемой сумме
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, USD |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '100,00'
	И я заполняю информацию о получателе и получаемой сумме
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №1 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '100,00'
		И я нажимаю кнопку выбора у поля "Receive currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description     |
			| USD  | American dollar |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
	И я указываю дату отправления и дату получения
		И в поле 'Send date' я ввожу текст '03.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '04.07.2019  0:00:00'
	И я изменяю номер документа
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю что документ создан
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender            | Receiver          | Company      |
		| 4      | Bank account, USD |Cash desk №1       | Main Company |
	И Я закрыл все окна клиентского приложения
	И я провожу Bank payment
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver          | Company      |
			| 4      | Bank account, USD |Cash desk №1  | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		И я меняю номер документа на 4
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я проверяю заполнение табличной части
			И     таблица "PaymentList" содержит строки:
			| 'Planing transaction basis'    | 'Amount' |
			| 'Cash transfer order 4*'             |  '100,00' |
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
		И Пауза 5
	И я провожу Cash receipt
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender            | Receiver     | Company      |
			| 4      | Bank account, USD |Cash desk №1  | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		И я меняю номер документа на 7
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
		И я проверяю заполнение табличной части
			И     таблица "PaymentList" содержит строки:
			| Planing transaction basis |  Amount |
			| Cash transfer order 4*          | '100,00'    |
		И я нажимаю на кнопку 'Post and close'
	И я проверяю проводки документов по регистру PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'                  |  'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'USD'      | 'Cash transfer order 4*'    | 'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Outgoing'            | '100,00'    |
		| 'USD'      | 'Cash transfer order 4*'    | 'Cash transfer order 4*' | 'Main Company' | 'Cash desk №1'      | 'Incoming'            | '100,00'    |
		| 'USD'      | 'Cash receipt 8*'           | 'Cash transfer order 4*' | 'Main Company' | 'Cash desk №1'      | 'Incoming'            | '-100,00'   |
		| 'USD'      | 'Bank payment 4*'           | 'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Outgoing'            | '-100,00'   |
		И Я закрыл все окна клиентского приложения

Сценарий: _054008 конвертация валюты в рамках одной кассы c обменом по частям (курс в процессе обмена вырос)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я заполняю информацию об отправителе и отправляемой сумме
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '1150,00'
		И я нажимаю кнопку выбора у поля "Send currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description  |
			| TRY  | Turkish lira |
		И в таблице "List" я выбираю текущую строку
	И я заполняю информацию о получателе и получаемой сумме
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '175,00'
		И я нажимаю кнопку выбора у поля "Receive currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| EUR  |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash advance holder"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Arina Brown' |
		И в таблице "List" я выбираю текущую строку
	И я указываю дату отправления и дату получения
		И в поле 'Send date' я ввожу текст '04.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '05.07.2019  0:00:00'
	И я изменяю номер документа на 5
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю что документ создан
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender       | Receiver     | Company      |
		| 5      | Cash desk №2 | Cash desk №2 | Main Company |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	Тогда таблица "List" содержит строки:
		| 'Currency'   | 'Recorder'         |  'Basis document'  | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'TRY'        | 'Cash transfer order 5*' | 'Cash transfer order 5*' | 'Main Company' | 'Cash desk №2'      | 'Outgoing'            | '1 150,00'  |
		| 'EUR'        | 'Cash transfer order 5*' | 'Cash transfer order 5*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '175,00'    |
	И Я закрыл все окна клиентского приложения
	И я создаю Cash payment по Cash transfer order на частичную сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Receive amount |
			| '5'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Arina Brown |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '650,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 7
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	И я создаю Cash reciept по Cash transfer order на частичную сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Receive amount |
			| '5'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount exchange"
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '600,00'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И я меняю номер документа на 9
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '9'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	И я провожу Cash payment на остаток суммы
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Receive amount |
			| '5'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Arina Brown |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" содержит строки:
			| 'Partner'     | 'Amount'  | 'Planing transaction basis'    |
			| 'Arina Brown' | '500,00'  | 'Cash transfer order 5*'             |
		И я меняю номер документа на 8
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '8'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '8'
		И я нажимаю на кнопку 'Post and close'
	И я провожу Cash reciept на остаток суммы + 1о лир
	# изначально выдали на руки 1150 лир, но из-за курса 175 евро стали стоить 1160лир. Должны компенсировать 10 лир
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Receive amount |
			| '5'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '560,00'
		И Пауза 5
		И     таблица "PaymentList" содержит строки:
			|'Partner'      | 'Amount' | 'Planing transaction basis'    | 'Amount exchange' |
			| 'Arina Brown' | '75,00'     |  'Cash transfer order 5*'            | '560,00'          |
		И я меняю номер документа на 10
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '10'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '10'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	# И я проверяю, что по регистрам мы должны компенсировать сотруднику 10 лир из-за роста курса
	# 	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerApTransactions"
	# 	Тогда таблица "List" содержит строки:
	# 	| 'Currency' | 'Recorder'         | 'Legal name' | 'Basis document'         | 'Company'      | 'Amount' | 'Agreement' | 'Partner'     |
	# 	| 'TRY'      | 'Cash payment 7*'  | ''           | 'Cash transfer order 5*' | 'Main Company' | '650,00' | ''          | 'Arina Brown' |
	# 	| 'TRY'      | 'Cash receipt 9*'  | ''           | 'Cash transfer order 5*' | 'Main Company' | '600,00' | ''          | 'Arina Brown' |
	# 	| 'TRY'      | 'Cash payment 8*'  | ''           | 'Cash transfer order 5*' | 'Main Company' | '500,00' | ''          | 'Arina Brown' |
	# 	| 'TRY'      | 'Cash receipt 10*' | ''           | 'Cash transfer order 5*' | 'Main Company' | '560,00' | ''          | 'Arina Brown' |
		# выдано 1150, потрачено 1160
		И Я закрыл все окна клиентского приложения


Сценарий: _054009 конвертация валюты в рамках одной кассы c обменом по частям (курс в процессе обмена упал)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я заполняю информацию об отправителе и отправляемой сумме
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '1315,00'
		И я нажимаю кнопку выбора у поля "Send currency"
		И в таблице "List" я перехожу к строке:
			| Code | Description  |
			| TRY  | Turkish lira |
		И в таблице "List" я выбираю текущую строку
	И я заполняю информацию о получателе и получаемой сумме
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Cash desk №2 |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '200,00'
		И я нажимаю кнопку выбора у поля "Receive currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| EUR  |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Cash advance holder"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Arina Brown' |
		И в таблице "List" я выбираю текущую строку
	И я указываю дату отправления и дату получения
		И в поле 'Send date' я ввожу текст '04.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '05.07.2019  0:00:00'
	И я изменяю номер документа на 6
		И в поле 'Number' я ввожу текст '6'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '6'
	# И я проверяю заполнение курса по умолчанию
	# 	И я перехожу к закладке "Other"
	# 	И     элемент формы с именем "SendReportingCurrency" стал равен 'TRY'
	# 	И     элемент формы с именем "SendReportingCurrencySource" стал равен 'Forex Seling'
	# 	И     у элемента формы с именем "SendReportingCurrencyRate" текст редактирования стал равен '1,00'
	# 	И     элемент формы с именем "ReceiveReportingCurrency" стал равен 'TRY'
	# 	И     элемент формы с именем "ReceiveReportingCurrencySource" стал равен 'Forex Seling'
	# 	И     элемент формы с именем "ReceiveReportingCurrencyRate" стал равен '6,5400'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю что документ создан
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender       | Receiver     | Company      |
		| 6      | Cash desk №2 | Cash desk №2 | Main Company |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	Тогда таблица "List" содержит строки:
		| 'Currency'   | 'Recorder'         |  'Basis document'  | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'TRY'        | 'Cash transfer order 6*' | 'Cash transfer order 6*' | 'Main Company' | 'Cash desk №2'      | 'Outgoing'            | '1 315,00'  |
		| 'EUR'        | 'Cash transfer order 6*' | 'Cash transfer order 6*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '200,00'    |
	И Я закрыл все окна клиентского приложения
	И я создаю Cash payment по Cash transfer order на полную сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Receive amount' |
			| '6'      | '200,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Arina Brown |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '1315,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 11
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '11'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '11'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	И я создаю Cash reciept по Cash transfer order на частичную сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Receive amount' |
			| '6'      | '200,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Arina Brown |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "Amount exchange"
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '1300,00'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '200,00'
		И я меняю номер документа на 11
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '11'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '11'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	# И я проверяю, что по регистрам мы должны компенсировать сотруднику 15 лир из-за роста курса
	# 	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerApTransactions"
	# 	Тогда таблица "List" содержит строки:
	# 		| 'Currency' | 'Recorder'         | 'Legal name' | 'Basis document'         | 'Company'      | 'Amount'   | 'Agreement' | 'Partner'     |
	# 		| 'TRY'      | 'Cash payment 11*' | ''           | 'Cash transfer order 6*' | 'Main Company' | '1 315,00' | ''          | 'Arina Brown' |
	# 		| 'TRY'      | 'Cash receipt 11*' | ''           | 'Cash transfer order 6*' | 'Main Company' | '1 300,00' | ''          | 'Arina Brown' |
	# 	# выдано 1315, потрачено 1300
		И Я закрыл все окна клиентского приложения

# Filters

Сценарий: _054010 проверка фильтра по собственным компаниям в документе Cash Transfer Order
	И я закрыл все окна клиентского приложения
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-378' с именем 'IRP-378'
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	Когда проверяю фильтр по собственным компаниям в Cash transfer order

Сценарий: _054011 проверка ввода Description в документе Cash Transfer
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	Когда проверяю ввод Description

# EndFilters


Сценарий: _054012 конвертация валюты с банковского счета в документе Cash Transfer
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	И я заполняю информацию об отправителе и отправляемой сумме
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '1150,00'
	И я заполняю информацию о получателе и получаемой сумме
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, EUR |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '175,00'
	И я указываю дату отправления и дату получения
		И в поле 'Send date' я ввожу текст '04.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '05.07.2019  0:00:00'
	И я изменяю номер документа на 7
		И в поле 'Number' я ввожу текст '7'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '7'
	# И я проверяю заполнение курса по умолчанию
	# 	И я перехожу к закладке "Other"
	# 	И     элемент формы с именем "SendReportingCurrency" стал равен 'TRY'
	# 	И     элемент формы с именем "SendReportingCurrencySource" стал равен 'Forex Seling'
	# 	И     у элемента формы с именем "SendReportingCurrencyRate" текст редактирования стал равен '1,00'
	# 	И     элемент формы с именем "ReceiveReportingCurrency" стал равен 'TRY'
	# 	И     элемент формы с именем "ReceiveReportingCurrencySource" стал равен 'Forex Seling'
	# 	И     элемент формы с именем "ReceiveReportingCurrencyRate" стал равен '6,5400'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	И я проверяю что документ создан
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender            | Receiver          | Company      |
		| 7      | Bank account, TRY | Bank account, EUR | Main Company |
	И Я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	Тогда таблица "List" содержит строки:
		| 'Currency'   | 'Recorder'         |  'Basis document'  | 'Company'      | 'Account'                | 'Cash flow direction' | 'Amount'    |
		| 'TRY'        | 'Cash transfer order 7*' | 'Cash transfer order 7*' | 'Main Company' | 'Bank account, TRY'      | 'Outgoing'            | '1 150,00'  |
		| 'EUR'        | 'Cash transfer order 7*' | 'Cash transfer order 7*' | 'Main Company' | 'Bank account, EUR'      | 'Incoming'            | '175,00'    |
	И Я закрыл все окна клиентского приложения
	И я создаю Bank payment по Cash transfer order на всю сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Receive amount' |
			| '7'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '1150,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И я меняю номер документа на 7
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	И я создаю Bank reciept по Cash transfer order на всю сумму
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Receive amount' |
			| '7'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount exchange"
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '1150,00'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '175,00'
		И я меняю номер документа на 9
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
		

Сценарий: _054013 проверка проводок документа Cash transfer order по регистру деньги в пути (CashInTransit)
# в регистр деньги в пути попадаю ДС которые перемещаются в одной и той же валюте
# если происходит конвертация, то деньги числятся на ответсенном за конвертацию лицо
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.CashInTransit"
	Тогда таблица "List" содержит строки:
		| 'Currency' |  'Basis document'         | 'Company'      | 'From account'      | 'To account'        | 'Amount' |
		| 'USD'      |  'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Cash desk №2'      | '500,00' |
		| 'USD'      |  'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Cash desk №2'      | '400,00' |
		| 'USD'      |  'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Cash desk №2'      | '100,00' |
		| 'USD'      |  'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Bank account, USD' | '500,00' |
		| 'USD'      |  'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Cash desk №1'      | '100,00' |
	Тогда таблица "List" не содержит строки:
		|  'Basis document'   |
		|  'Cash transfer order 2*' |
		|  'Cash transfer order 5*' |
		|  'Cash transfer order 6*' |
		|  'Cash transfer order 7*' |
	И я закрыл все окна клиентского приложения

Сценарий: _054014 проверка вывода сообщения в случае если деньги перемещаются из кассы в банк и наоборот в разных валютах
	* Проверка при перемещении ДС из банка в кассу в разных валютах
		* Открытие формы создания
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение основных реквизитов
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Sender"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Send amount' я ввожу текст '1150,00'
			И я нажимаю кнопку выбора у поля "Receiver"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Cash desk №2   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Receive currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Receive amount' я ввожу текст '200,00'
		* Изменение номер документа на 101
			И в поле 'Number' я ввожу текст '101'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '101'
		* Проверка вывода сообщения и того что документ не создался
			И Пауза 5
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency exchange is possible only through accounts with the same type (cash account or bank account)." в течение 30 секунд
			И Я закрыл все окна клиентского приложения
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			Тогда таблица "List" не содержит строки:
			| 'Number'   | 'Sender'                 | 'Receiver'          |
			| '101'      | 'Bank account, TRY'      | 'Cash desk №2'      |
	* Проверка при перемещении ДС из кассы в банк в разных валютах
		* Открытие формы создания
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение основных реквизитов
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Sender"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Cash desk №2   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Send currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Send amount' я ввожу текст '20,00'
			И я нажимаю кнопку выбора у поля "Receiver"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Receive amount' я ввожу текст '1150,00'
		* Изменение номер документа на 102
			И в поле 'Number' я ввожу текст '102'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '102'
		* Проверка вывода сообщения и того что документ не создался
			И Пауза 5
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency exchange is possible only through accounts with the same type (cash account or bank account)." в течение 30 секунд
			И Я закрыл все окна клиентского приложения
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			Тогда таблица "List" не содержит строки:
			| 'Number'   | 'Sender'            | 'Receiver'          |
			| '102'      | 'Cash desk №2'      | 'Bank account, TRY' |
		* 

Сценарий: _054015 проверка вывода сообщения в случае если пользователь пробует создать Bank payment по Cash transfer order по которому его не нужно создавать
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Bank payment for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054016 проверка вывода сообщения в случае если пользователь пробует создать Cash receipt по Cash transfer order по которому его не нужно создавать
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Cash receipt for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054017 проверка вывода сообщения в случае если пользователь повторно пробует создать Bank receipt по Cash transfer order
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already recieved by document Bank receipt(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054018 проверка вывода сообщения в случае если пользователь повторно пробует создать Cash payment по Cash transfer order
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already payed by document Cash payment(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054019 проверка вывода сообщения в случае если пользователь пробует создать Bank receipt по Cash transfer order по которому его не нужно создавать
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Bank receipt for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054020 проверка вывода сообщения в случае если пользователь пробует создать Cash payment по Cash transfer order по которому его не нужно создавать
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Cash payment for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054021 проверка вывода сообщения в случае если пользователь повторно пробует создать Bank payment по Cash transfer order
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already payed by document Bank payment(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054022 проверка вывода сообщения в случае если пользователь повторно пробует создать Cash receipt по Cash transfer order
	* Открытие списка Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Выбор подходящего Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Попытка создания BankPayment и проверка вывода сообщения
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already recieved by document Cash receipt(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения