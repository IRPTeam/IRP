#language: ru
@tree
@Positive
Функционал: create cash transfer

As an accountant
I want to transfer money from one account to another.
For actual cash accounting

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# The currency of reports is lira


Сценарий: _054001 create Cash transfer order (from cash account to cash account in the same currency)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	* Filling Sender and Send amount
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
	* Filling Receiver and Receive amount
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
	* Filling Send date and Receive date
		И в поле 'Send date' я ввожу текст '01.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '01.07.2019  0:00:00'
	* Change the document number
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Check creation
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender       | Receiver     | Company      |
		| 1      | Cash desk №1 | Cash desk №2 | Main Company |
	И Я закрыл все окна клиентского приложения

Сценарий: _054002 check Cash transfer order movements by register Planing cash transactions
	* Check movements
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'         | 'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '500,00'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '500,00'    |
		И Я закрыл все окна клиентского приложения
	* Clear postings
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
	* Re-posting document
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





Сценарий: _054003 create Cash payment and Cash reciept based on Cash transfer order + check movements
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И в таблице "List" я перехожу к строке:
		| Number | Sender       | Receiver     | Company      |
		| 1      | Cash desk №1 | Cash desk №2 | Main Company |
	И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
	* Change the document number to 4
		И в поле 'Number' я ввожу текст '4'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	* Checking the filling of the tabular part
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'    | 'Amount' |
		| 'Cash transfer order 1*'             | '500,00' |
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Creation of Cash receipt for a partial amount
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver     | Company      |
			| 1      | Cash desk №1 | Cash desk №2 | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '400,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 4
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
	* Creation of Cash receipt for the remaining amount
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver     | Company      |
			| 1      | Cash desk №1 | Cash desk №2 | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
	* Change the document number to 5
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	* Check that the tabular part shows the rest of the amount
		И я перехожу к закладке "Payments"
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'   | 'Amount' |
		| 'Cash transfer order 1*'      | '100,00'    |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	* Check movement of Cash payment and Cash reciept by register Planing cash transactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          |  'Basis document'  | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'USD'      | 'Cash payment 4*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '-500,00'   |
		| 'USD'      | 'Cash receipt 4*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '-400,00'   |
		| 'USD'      | 'Cash receipt 5*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '-100,00'   |
	И Я закрыл все окна клиентского приложения
	


Сценарий: _054004 create Cash transfer order (from cash account to cash account in the different currency)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	* Filling Sender and Send amount
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
	* Filling Receiver and Receive amount
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
	* Filling Send date and Receive date
		И в поле 'Send date' я ввожу текст '02.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '03.07.2019  0:00:00'
	* Change the document number на 2
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Check creation
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

Сценарий: _054005 create Cash receipt and Cash payment based on Cash transfer order in the different currency and check movements
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И в таблице "List" я перехожу к строке:
		| Number | Sender       | Receiver     | Company      |
		| 2      | Cash desk №2 | Cash desk №1 | Main Company |
	И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
	* Change the document number to 5
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	* Checking the filling of the tabular part
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'    | 'Amount' |
		| 'Cash transfer order 2*'             | '200,00' |
	* Filling in the employee responsible for curremcy exchange
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Arina Brown |
		И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Create Cash receipt for the full amount
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver     | Company      |
			| 2      | Cash desk №2 | Cash desk №1 | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
	* Change the document number to 7
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
	* Check that the correct receipt amount is indicated in the tabular part
		И я перехожу к закладке "Payments"
		И Пауза 5
		И     таблица "PaymentList" содержит строки:
		| 'Planing transaction basis'         | 'Partner'            | 'Amount'      | 'Amount exchange' |
		| 'Cash transfer order 2*'            | 'Arina Brown'        | '1 150,00'    | '200,00'          |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	* Check Cash payment and Cash reciept movements by register PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'               | 'Basis document'         | 'Company'      | 'Account'      | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Amount'    |
		| 'USD'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '200,00'    |
		| 'TRY'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '1 150,00'  |
		| 'USD'      | 'Cash payment 5*'        | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '-200,00'   |
		| 'TRY'      | 'Cash receipt 7*'        | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '-1 150,00' |
	* Check Cash payment and Cash reciept movements by register AccountBalance
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.AccountBalance"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'        | 'Company'      | 'Account'      | 'Amount'   |
		| 'TRY'      | 'Cash receipt 7*' | 'Main Company' | 'Cash desk №1' | '1 150,00' |
		| 'USD'      | 'Cash payment 5*' | 'Main Company' | 'Cash desk №2' | '200,00' |
		И Я закрыл все окна клиентского приложения

	
Сценарий: _054006 create Cash transfer order (from cash account to bank account in the same currency)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	* Filling Sender and Send amount
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
	* Filling Receiver and Receive amount
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, USD |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '500,00'
	* Filling Send date and Receive date
		И в поле 'Send date' я ввожу текст '01.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '02.07.2019  0:00:00'
	* Change the document number
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Check creation
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender       | Receiver          | Company      |
		| 3      | Cash desk №1 | Bank account, USD | Main Company |
	И Я закрыл все окна клиентского приложения
	* Post Cash payment
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver          | Company      |
			| 3      | Cash desk №1 | Bank account, USD | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		* Checking the filling of the tabular part
			И     таблица "PaymentList" содержит строки:
			| 'Planing transaction basis'    | 'Amount' |
			| 'Cash transfer order 3*'             | '500,00' |
		* Change the document number to 6
			И в поле 'Number' я ввожу текст '6'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '6'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	*Post Bank reciept
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver          | Company      |
			| 3      | Cash desk №1 | Bank account, USD | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		И Пауза 5
		* Change the document number to 4
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		* Checking the filling of the tabular part
			И я перехожу к закладке "Payments"
			И     таблица "PaymentList" содержит строки:
			| 'Amount' | 'Planing transaction basis'  |
			| '500,00'    |  'Cash transfer order 3*'          |
		И я нажимаю на кнопку 'Post and close'
	* Check movements by register Planing cash transactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency'| 'Recorder'               |  'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction'   | 'Amount'    |
		| 'USD'     | 'Cash transfer order 3*' | 'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'              | '500,00'    |
		| 'USD'     | 'Cash transfer order 3*' | 'Cash transfer order 3*' | 'Main Company' | 'Bank account, USD' | 'Incoming'              | '500,00'    |
		| 'USD'     | 'Cash payment 6*'        | 'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'              | '-500,00'   |
		| 'USD'     | 'Bank receipt 4*'        | 'Cash transfer order 3*' | 'Main Company' | 'Bank account, USD' | 'Incoming'              | '-500,00'   |
		И Я закрыл все окна клиентского приложения 

Сценарий: _054007 create Cash transfer order from bank account to cash account (in the same currency)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	* Filling Sender and Send amount
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, USD |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '100,00'
	* Filling Receiver and Receive amount
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
	* Filling Send date and Receive date
		И в поле 'Send date' я ввожу текст '03.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '04.07.2019  0:00:00'
	* Change the document number
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '4'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Check creation
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		Тогда таблица "List" содержит строки:
		| Number | Sender            | Receiver          | Company      |
		| 4      | Bank account, USD |Cash desk №1       | Main Company |
	И Я закрыл все окна клиентского приложения
	* Post Bank payment
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender       | Receiver          | Company      |
			| 4      | Bank account, USD |Cash desk №1  | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		* Change the document number to 4
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		* Checking the filling of the tabular part
			И     таблица "PaymentList" содержит строки:
			| 'Planing transaction basis'    | 'Amount' |
			| 'Cash transfer order 4*'             |  '100,00' |
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
		И Пауза 5
	* Post Cash receipt
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Sender            | Receiver     | Company      |
			| 4      | Bank account, USD |Cash desk №1  | Main Company |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		* Change the document number to 7
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
		* Checking the filling of the tabular part
			И     таблица "PaymentList" содержит строки:
			| Planing transaction basis |  Amount |
			| Cash transfer order 4*          | '100,00'    |
		И я нажимаю на кнопку 'Post and close'
	* Check movements by register PlaningCashTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'                  |  'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'USD'      | 'Cash transfer order 4*'    | 'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Outgoing'            | '100,00'    |
		| 'USD'      | 'Cash transfer order 4*'    | 'Cash transfer order 4*' | 'Main Company' | 'Cash desk №1'      | 'Incoming'            | '100,00'    |
		| 'USD'      | 'Cash receipt 8*'           | 'Cash transfer order 4*' | 'Main Company' | 'Cash desk №1'      | 'Incoming'            | '-100,00'   |
		| 'USD'      | 'Bank payment 4*'           | 'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Outgoing'            | '-100,00'   |
		И Я закрыл все окна клиентского приложения

Сценарий: _054008 currency exchange within one cash account with exchange in parts (exchange rate has increased)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	* Filling Sender and Send amount
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
	* Filling Receiver and Receive amount
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
	* Filling Send date and Receive date
		И в поле 'Send date' я ввожу текст '04.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '05.07.2019  0:00:00'
	* Change the document number на 5
		И в поле 'Number' я ввожу текст '5'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '5'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Check creation
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
	* Create Cash payment based on Cash transfer order in partial amount
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
		* Change the document number to 7
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '7'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '7'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Create Cash reciept based on Cash transfer order in partial amount
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| Number | Receive amount |
			| '5'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount exchange"
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '600,00'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		* Change the document number to 9
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '9'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Post Cash payment on the rest of the amount
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
		* Change the document number to 8
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '8'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '8'
		И я нажимаю на кнопку 'Post and close'
	* Post Cash reciept on the rest of the amount + 1о lirs
	# Originally 1,150 lire, but the exchange rate of 175 euros cost 1,160 lire. We have to compensate for 10 lire.
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
		* Change the document number to 10
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '10'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '10'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
		# issued 1150, spent 1160
		И Я закрыл все окна клиентского приложения


Сценарий: _054009 currency exchange within one cash account with exchange in parts (exchange rate has decreased)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	* Filling Sender and Send amount
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
	* Filling Receiver and Receive amount
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
	* Filling Send date and Receive date
		И в поле 'Send date' я ввожу текст '04.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '05.07.2019  0:00:00'
	* Change the document number на 6
		И в поле 'Number' я ввожу текст '6'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '6'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Check creation
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
	* Create Cash payment based on Cash transfer order for the full amount
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
		* Change the document number to 11
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '11'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '11'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Create Cash reciept based on Cash transfer order in partial amount
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
		* Change the document number to 11
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '11'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '11'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
		# issued 1315, spent 1300 #
		И Я закрыл все окна клиентского приложения

# Filters

Сценарий: _054010 filter check by own companies in the document Cash Transfer Order
	И я закрыл все окна клиентского приложения
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-378' с именем 'IRP-378'
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	Когда проверяю фильтр по собственным компаниям в Cash transfer order

Сценарий: _054011 check input Description in the document Cash Transfer Order
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	Когда проверяю ввод Description

# EndFilters


Сценарий: _054012 exchange currency from bank account (Cash Transfer Order)
	И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Company"
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Main Company |
	И в таблице "List" я выбираю текущую строку
	* Filling Sender and Send amount
		И я нажимаю кнопку выбора у поля "Sender"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, TRY |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Send amount' я ввожу текст '1150,00'
	* Filling Receiver and Receive amount
		И я нажимаю кнопку выбора у поля "Receiver"
		И в таблице "List" я перехожу к строке:
			| Description    |
			| Bank account, EUR |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Receive amount' я ввожу текст '175,00'
	* Filling Send date and Receive date
		И в поле 'Send date' я ввожу текст '04.07.2019  0:00:00'
		И в поле 'Receive date' я ввожу текст '05.07.2019  0:00:00'
	* Change the document number на 7
		И в поле 'Number' я ввожу текст '7'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '7'
	И я нажимаю на кнопку 'Post and close'
	И Пауза 5
	* Check creation
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
	* Create Bank payment based on Cash transfer order for the full amount
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Receive amount' |
			| '7'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '1150,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 7
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Create Bank reciept based on Cash transfer order for the full amount
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Receive amount' |
			| '7'      | '175,00'         |
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		И в таблице "PaymentList" я активизирую поле "Amount exchange"
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '1150,00'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '175,00'
		* Change the document number to 9
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '5'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '5'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
		

Сценарий: _054013 check Cash transfer order movements by register Cash in transit
# in the register Cash in transit enters cash that are transferred in the same currency
# if currency exchange takes place, then the money is credited to the person responsible for the conversion
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

Сценарий: _054014 check message output in case money is transferred from cash account to bank account and vice versa in different currencies
	* Checking when moving money from bank account to cash account in different currencies
		* Open a creation form
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in basic details
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
		* Change the document number to 101
			И в поле 'Number' я ввожу текст '101'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '101'
		* Check the message output and that the document was not created
			И Пауза 5
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency exchange is possible only through accounts with the same type (cash account or bank account)." в течение 30 секунд
			И Я закрыл все окна клиентского приложения
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			Тогда таблица "List" не содержит строки:
			| 'Number'   | 'Sender'                 | 'Receiver'          |
			| '101'      | 'Bank account, TRY'      | 'Cash desk №2'      |
	* Checking when moving money from cash account to bank account in different currencies
		* Open a creation form
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in basic details
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
		* Change the document number to 102
			И в поле 'Number' я ввожу текст '102'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '102'
		* Check the message output and that the document was not created
			И Пауза 5
			И я нажимаю на кнопку 'Post and close'
			И Пауза 5
			Затем я жду, что в сообщениях пользователю будет подстрока "Currency exchange is possible only through accounts with the same type (cash account or bank account)." в течение 30 секунд
			И Я закрыл все окна клиентского приложения
			И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
			Тогда таблица "List" не содержит строки:
			| 'Number'   | 'Sender'            | 'Receiver'          |
			| '102'      | 'Cash desk №2'      | 'Bank account, TRY' |


Сценарий: _054015 check message output in case the user tries to create a Bank payment by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank payment and check message output
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Bank payment for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054016 check message output in case the user tries to create a Cash receipt by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash receipt and check message output
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Cash receipt for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054017 check message output in case the user tries to create Bank receipt again by Cash transfer order
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank receipt and check message output
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already recieved by document Bank receipt(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054018 check message output in case the user tries to create Cash payment again by Cash transfer order
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash payment and check message output
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already payed by document Cash payment(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054019 check message output in case the user tries to create a Bank receipt by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank receipt and check message output
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Bank receipt for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054020 check message output in case the user tries to create a Cash payment by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash payment and check message output
		И я нажимаю на кнопку с именем 'FormDocumentCashPaymentGenerateCashPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Don`t need to create a Cash payment for selected Cash transfer order(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054021 check message output in case the user tries to create Bank payment again by Cash transfer order
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank payment and check message output
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already payed by document Bank payment(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _054022 check message output in case the user tries to create Cash receipt again by Cash transfer order
	* Open the list Cash transfer order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		И в таблице "List" я перехожу к строке:
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash receipt and check message output
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
		Затем я жду, что в сообщениях пользователю будет подстрока "Whole amount in Cash transfer order(s) are already recieved by document Cash receipt(s)." в течение 30 секунд
		И Я закрыл все окна клиентского приложения