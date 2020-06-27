#language: ru
@tree
@Positive
Функционал: проведение документа Bank reciept

Как Разработчик
Я хочу создать проводки документа поступления безналичных ДС
Для того чтобы фиксировать оплаты от клиентов

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# Валюта отчетов - лира
# экспортные сценарии CashBankDocFilters

Сценарий: _050001 проверка создания Bank reciept на основании Sales invoice
	* Открытие формы списка Sales invoice и выбор SI №1
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И я нажимаю на кнопку с именем 'FormDocumentBankReceiptGenarateBankReceipt'
	* Проверка создания и заполнения Bank reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planing transaction basis' |
			| 'Ferron BP' | 'Basic Agreements, TRY' | '4 250,00' | 'Company Ferron BP' | 'Sales invoice 1*' | ''                          |
		И     таблица "CurrenciesPaymentList" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '727,74' | '1'            |
	* Проверка выбора account и сохранения данных 
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Account" стал равен 'Bank account, USD'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planing transaction basis' |
			| 'Ferron BP' | 'Basic Agreements, TRY' | '4 250,00' | 'Company Ferron BP' | 'Sales invoice 1*' | ''                          |
		И     таблица "CurrenciesPaymentList" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'    | 'Multiplicity' |
			| 'TRY'                | 'Agreement' | 'USD'           | 'TRY'      | '0,1770'            | '24 011,30' | '1'            |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '24 011,30' | '1'            |
		И     элемент формы с именем "DocumentAmount" стал равен '4 250,00'
	* Изменение соглашения и basis document
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "Agreement"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Agreements, without VAT' |
		И в таблице "List" я выбираю текущую строку
		# костыль
		И Пауза 2
		Когда Проверяю шаги на Исключение:
		|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# костыль
		И в таблице "List" я перехожу к строке:
			| 'Company'      | 'Document amount' | 'Legal name'        | 'Partner'   |
			| 'Main Company' | '11 099,93'       | 'Company Ferron BP' | 'Ferron BP' |
		И я нажимаю на кнопку 'Select'
		# И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я перехожу к следующей ячейке
	* Изменение суммы платежа
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '20 000,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Agreement'                     | 'Amount'    | 'Payer'             | 'Basis document'  |
			| 'Ferron BP' | 'Basic Agreements, without VAT' | '20 000,00' | 'Company Ferron BP' | 'Sales invoice 2*' |
	И Я закрыл все окна клиентского приложения 


Сценарий: _052001 создание поступления безнала от клиента Bank reciept
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-350' с именем 'IRP-350'
	И я создаю поступление безналичных ДС в лирах по Ferron BP (реализация в лирах)
		И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю реквизиты документа
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Code | Description  |
				| TRY  | Turkish lira |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, TRY |
			И в таблице "List" я выбираю текущую строку
		И я меняю номер документа на 1
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И я заполняю партнера в табличной части
			И в таблице "PaymentList" я активизирую поле "Partner"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		# временно
		И я заполняю документ основания в табличной части
			# костыль
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# костыль
			Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# временно
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание приходно-кассового ордера
			Тогда таблица "List" содержит строки:
				| Number |
				|   1    |
	И я создаю поступление безналичных ДС от клиента в долларах по Ferron BP (реализация в лирах)
		И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю реквизиты документа
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Code | Description     |
				| USD  | American dollar |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, USD |
			И в таблице "List" я выбираю текущую строку
		И я меняю номер документа на 2
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И я заполняю партнера в табличной части
			И в таблице "PaymentList" я активизирую поле "Partner"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
		* Заполнение Agreement
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
		# временно
		И я заполняю документ основания в табличной части
			# костыль
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# костыль
			Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# временно
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание приходно-кассового ордера
			Тогда таблица "List" содержит строки:
			| Number |
			|   2    |
	И я создаю поступление безналичных ДС в евро по Ferron BP (реализация в долларах)
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю реквизиты документа
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Code | Description |
				| EUR  | Euro        |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Bank account, EUR |
			И в таблице "List" я выбираю текущую строку
		И я меняю номер документа на 3
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И я заполняю партнера в табличной части
			И в таблице "PaymentList" я активизирую поле "Partner"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payer"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
		* Заполнение Agreement
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
					| 'Description'           |
					| 'Ferron, USD' |
			И в таблице "List" я выбираю текущую строку
		# временно
		И я заполняю документ основания в табличной части
			# костыль
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# костыль
			Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '200,00'          | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# временно
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '50,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание приходно-кассового ордера
			Тогда таблица "List" содержит строки:
			| Number |
			|   3    |	
	

Сценарий: _052002 проверка проведения документа Bank reciept по регистру PartnerArTransactions
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerArTransactions"
	Тогда таблица "List" содержит строки:
		| 'Currency'   | 'Recorder'           | 'Legal name'        |  'Basis document'     | 'Company'      | 'Amount'    | 'Agreement'                     | 'Partner'   |
		| 'TRY'        | 'Bank receipt 1*'    | 'Company Ferron BP' |  'Sales invoice 1*'   | 'Main Company' | '100,00'    | 'Basic Agreements, TRY'         | 'Ferron BP' |
		| 'USD'        | 'Bank receipt 2*'    | 'Company Ferron BP' |  'Sales invoice 1*'   | 'Main Company' | '100,00'    | 'Basic Agreements, TRY'         | 'Ferron BP' |
		| 'EUR'        | 'Bank receipt 3*'    | 'Company Ferron BP' |  'Sales invoice 234*'  | 'Main Company' | '50,00'    | '*'                             | 'Ferron BP' |
	И Я закрыл все окна клиентского приложения


Сценарий: _050002 проверка проводок  Bank reciept с видом операции оплата от клиента
	* Открытие BankReceipt 1
		И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Проверка проводок BankReceipt 1
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Bank receipt 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Agreement'             | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'      | '17,12'     | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| 'Register  "Accounts statement"'           | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
		| ''                                         | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'               | ''                      | ''                  | ''                         | ''                     |
		| ''                                         | ''            | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                  | 'Partner'               | 'Legal name'        | 'Basis document'           | 'Currency'             |
		| ''                                         | 'Expense'     | '*'                   | ''                    | ''               | ''                                          | '100'            | 'Main Company'             | 'Ferron BP'             | 'Company Ferron BP' | 'Sales invoice 1*'         | 'TRY'                  |
		| ''                                         | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Company Ferron BP' | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
		| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company' | 'Bank account, TRY' | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения
	* Распроведение Bank receipt 1 и проверка отсутствия проводок
		* Распроведение документа
			И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Проверка отсутствия проводок
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Bank receipt 1*' |
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AccountBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Bank receipt 1*' |
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ReconciliationStatement'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Bank receipt 1*' |
			И я закрыл все окна клиентского приложения
	* Повторное проведение документа и проверка проводок
		* Проведение документа 
			И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Проверка проводок
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Bank receipt 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Agreement'             | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '17,12'     | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Sales invoice 1*'     | 'Ferron BP' | 'Company Ferron BP'     | 'Basic Agreements, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'               | ''                      | ''                  | ''                         | ''                     |
			| ''                                         | ''            | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                  | 'Partner'               | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Expense'     | '*'                   | ''                    | ''               | ''                                          | '100'            | 'Main Company'             | 'Ferron BP'             | 'Company Ferron BP' | 'Sales invoice 1*'         | 'TRY'                  |
			| ''                                         | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'Company Ferron BP' | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company' | 'Bank account, TRY' | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
			И Я закрыл все окна клиентского приложения

# Filters

Сценарий: _052003 проверка фильтра по собственным компаниям в документе Bank Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	Когда проверяю фильтр по собственным компаниям

Сценарий: _052004 проверка фильтра по банковским счетам (выбор кассы недоступен) + заполнение валюты из банковского счета в документе Bank Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	Когда проверяю фильтр по банковским счетам (выбор кассы недоступен) + заполнение валюты из банковского счета


Сценарий: _052005 проверка ввода Description в документе Bank Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	Когда проверяю ввод Description

Сценарий: _052006 проверка выбора вида операции в документе Bank Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	Когда проверяю выбор вида операции в документах поступления оплаты

Сценарий: _052007 проверка фильтра по контрагенту в табличной части в документе Bank Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	Когда проверяю фильтр по контрагенту в табличной части в документах поступления оплаты

Сценарий: _052008 проверка фильтра по партнеру в табличной части в документе Bank Receipt
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	Когда проверяю фильтр по партнеру в табличной части в документах поступления оплаты


# EndFilters

Сценарий: _052011 проверка изменения валюты в документе (BankReceipt) в случае если она указана в счете
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю выбор валюты в банковском платежном документе в случае если валюта указана в счете




Сценарий: _052013 проверка отображения реквизитов на форме Bank Receipt с видом операции Payment from customer
	И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	Тогда я проверяю отображение на форме доступных полей
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" не доступен
		И     элемент формы с именем "CurrencyExchange" не доступен
	И я проверяю отображение табличной части
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Kalipso |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" стала равной:
			| '#' | Partner | Amount | Payer              | Basis document | Planing transaction basis |
			| '1' | Kalipso | ''     | Company Kalipso    | ''             | ''                        |



Сценарий: _052014 проверка отображения реквизитов на форме Bank receipt с видом операции Currency exchange
	И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	Тогда я проверяю отображение на форме доступных полей
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Currency exchange'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" доступен
	И я проверяю отображение табличной части
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я активизирую поле "Amount exchange"
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '2 000,00'
		И     таблица "PaymentList" стала равной:
			| '#' | 'Amount' | 'Amount exchange' | 'Planing transaction basis' |
			| '1' | '100,00' | '2 000,00'        | ''                          |




Сценарий: _052015 проверка отображения реквизитов на форме Bank receipt с видом операции Cash transfer order
	И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
	Тогда я проверяю отображение на форме доступных полей
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Cash transfer order'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" не доступен
	И я проверяю отображение табличной части
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		Если в таблице "PaymentList" нет колонки с именем "Payer" Тогда
		Если в таблице "PaymentList" нет колонки с именем "Partner" Тогда
		И     таблица "PaymentList" стала равной:
			| '#' | 'Amount' | 'Planing transaction basis' |
			| '1' | '100,00' | ''                          |







