#language: ru
@tree
@Positive
Функционал: проведение документа Bank payment

Как Разработчик
Я хочу создать проводки документа оплаты безналичных ДС
Для того чтобы фиксировать факт оплаты

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# Валюта отчетов - лира
# экспортные сценарии CashBankDocFilters


Сценарий: _053001 проверка создания Bank payment на основании Purchase invoice
	* Открытие формы списка Purchase invoice и выбор PI №1
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
	* Проверка создания и заполнения Purchase invoice
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'             | 'Agreement'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '136 000,00' | 'Purchase invoice 1*' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Amount'    | 'Multiplicity' |
			| 'Reporting currency' | '23 287,67' | '1'            |
	* Проверка выбора перевыбора account и перезаполнения данных
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, USD'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'             | 'Agreement'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '136 000,00' | 'Purchase invoice 1*' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Agreement' | 'USD'           | 'TRY'      | '0,1770'            | '768 361,58' | '1'            |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '768 361,58' | '1'            |
	* Проверка расчета Document amount
		И     элемент формы с именем "DocumentAmount" стал равен '136 000,00'
	* Изменение basis document
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"
		И в таблице "List" я перехожу к строке:
		| 'Legal name'        | 'Partner'   | 'Document amount'           |
		| 'Company Ferron BP' | 'Ferron BP' | '496 650,00' |
		И я нажимаю на кнопку 'Select'
		# И в таблице "PaymentList" я завершаю редактирование строки
		И в таблице "PaymentList" я перехожу к следующей ячейке
	* Изменение суммы платежа
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '20 000,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'             | 'Agreement'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '20 000,00' | 'Purchase invoice 6*' |
	И Я закрыл все окна клиентского приложения




Сценарий: _053001 создание оплаты безналичных ДС Bank payment 
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-350' с именем 'IRP-350'
	И я создаю оплату безналичных ДС поставщику в лирах по Ferron BP (поступление в лирах)
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я выбираю вид операции
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		И я заполняю реквизиты документа
			И я нажимаю кнопку выбора у поля "Currency"
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
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
		* Заполнение Agreement
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			И в таблице "List" я выбираю текущую строку
		# временно
		И я заполняю документ основания в табличной части
			# костыль
			Когда Проверяю шаги на Исключение:
				|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# костыль
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# временно
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '1000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание оплаты
			Тогда таблица "List" содержит строки:
				| Number |
				|   1    |
	И я создаю оплату безналичных ДС поставщику в долларах по Ferron BP (поступление в лирах)
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю реквизиты документа
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
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
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
		* Заполнение Agreement
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			И в таблице "List" я выбираю текущую строку
		# временно
		И я заполняю документ основания в табличной части
			# костыль
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# костыль
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# временно
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '20,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание приходно-кассового ордера
			Тогда таблица "List" содержит строки:
				| Number |
				|   2    |
	И я создаю оплату безналичных ДС поставщику в евро по Ferron BP (поступление в долларах)
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю реквизиты документа
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
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
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Payee"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
		* Заполнение Agreement
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Vendor Ferron, USD' |
			И в таблице "List" я выбираю текущую строку
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '150,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И я проверяю создание расходно-кассового ордера
			Тогда таблица "List" содержит строки:
				| Number |
				|   3    |

Сценарий: _053002 проверка проведения Bank payment по регистру PartnerApTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerApTransactions"
		Тогда таблица "List" содержит строки:
			| 'Currency'   | 'Recorder'            | 'Legal name'        | 'Basis document'     | 'Company'      | 'Amount'     | 'Agreement'            | 'Partner'   |
			| 'TRY'        | 'Bank payment 1*'     | 'Company Ferron BP' |'Purchase invoice 1*' | 'Main Company' | '1 000,00'   | 'Vendor Ferron, TRY'   | 'Ferron BP' |
			| 'USD'        | 'Bank payment 2*'     | 'Company Ferron BP' |'Purchase invoice 1*' | 'Main Company' | '20,00'      | 'Vendor Ferron, TRY'   | 'Ferron BP' |
			| 'EUR'        | 'Bank payment 3*'     | 'Company Ferron BP' |'*'                   | 'Main Company' | '150,00'     | 'Vendor Ferron, USD'   | 'Ferron BP' |
		И Я закрыл все окна клиентского приложения


Сценарий: _050002 проверка проводок Bank payment с видом операции оплата поставщику
	* Открытие Bank payment 1
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Проверка проводок BankPayment 1
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Bank payment 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                             | ''               | 'Dimensions'               | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | ''            | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR' | 'Company'                  | 'Partner'              | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Expense'     | '*'                   | ''                    | '1 000'          | ''                                             | ''               | 'Main Company'             | 'Ferron BP'            | 'Company Ferron BP' | 'Purchase invoice 1*'      | 'TRY'                  |
			| ''                                         | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '1 000'     | 'Main Company' | 'Company Ferron BP' | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AP transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Agreement'             | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Bank account, TRY' | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения
	* Распроведение Bank payment 1 и проверка отсутствия проводок
		* Распроведение документа
			И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Проверка отсутствия проводок
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Bank payment 1*' |
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AccountBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Bank payment 1*' |
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ReconciliationStatement'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Bank payment 1*' |
			И я закрыл все окна клиентского приложения
	* Повторное проведение документа и проверка проводок
		* Проведение документа 
			И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Проверка проводок
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
				| 'Bank payment 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                             | ''               | 'Dimensions'               | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | ''            | ''                    | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR' | 'Company'                  | 'Partner'              | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Expense'     | '*'                   | ''                    | '1 000'          | ''                                             | ''               | 'Main Company'             | 'Ferron BP'            | 'Company Ferron BP' | 'Purchase invoice 1*'      | 'TRY'                  |
			| ''                                         | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '1 000'     | 'Main Company' | 'Company Ferron BP' | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AP transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Agreement'             | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Bank account, TRY' | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
			И Я закрыл все окна клиентского приложения

# Filters

Сценарий: _053003 проверка фильтра по собственным компаниям в документе Bank payment
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по собственным компаниям

	

Сценарий: _053004 проверка фильтра по банковским счетам (выбор кассы недоступен) + заполнение валюты из банковского счета в документе Bank payment
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по банковским счетам (выбор кассы недоступен) + заполнение валюты из банковского счета

Сценарий: _053005 проверка ввода Description в документе Bank payment
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю ввод Description

Сценарий: _053006 проверка выбора вида операции в документе Bank payment
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю выбор вида операции в документах оплаты
	

Сценарий: _053007 проверка фильтра по контрагенту в табличной части в документе Bank payment
	# при выборе  партнера, в списке выбора контрагентов должны быть доступны только его контрагенты
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по контрагенту в табличной части в документах оплаты
	


Сценарий: _053008 проверка фильтра по партнеру в табличной части в документе Bank payment
	# при выборе  контрагента, в списке выбора партнеров должны быть доступны только его партнеры
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по партнеру в табличной части в документах оплаты
	

# EndFilters

Сценарий: _053011 проверка изменения валюты в документе (BankPayment) в случае если она указана в счете
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю выбор валюты в банковском платежном документе в случае если валюта указана в счете




Сценарий: _053013 проверка отображения реквизитов на форме BankPayment с видом операции Payment to the vendor
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
	Тогда я проверяю отображение на форме доступных полей
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" не доступен
	И я проверяю отображение табличной части
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Kalipso |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" стала равной:
			| '#' | Partner | Amount | Payee              | Basis document | Planing transaction basis |
			| '1' | Kalipso | ''     | Company Kalipso    | ''             | ''                        |







Сценарий: _053015 проверка отображения реквизитов на форме BankPayment с видом операции Cash transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
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
		Если в таблице "PaymentList" нет колонки с именем "Payee" Тогда
		Если в таблице "PaymentList" нет колонки с именем "Partner" Тогда
		И     таблица "PaymentList" стала равной:
			| '#' | 'Amount' | 'Planing transaction basis' |
			| '1' | '100,00' | ''                          |

	
























	




