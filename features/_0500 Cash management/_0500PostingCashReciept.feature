#language: ru
@tree
@Positive
Функционал: create Cash reciept

As a сashier
I want to accept the cash in hand.
For Cash/Bank accountsing



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.
# The currency of reports is lira
# CashBankDocFilters export scenarios


Сценарий: _050001 create Cash reciept based on Sales invoice
	* Open list form Sales invoice and select SI №1
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И я нажимаю на кнопку с именем 'FormDocumentCashReceiptGenarateCashReceipt'
	* Create and filling in Cash reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 350,00' | 'Company Ferron BP' | 'Sales invoice 1*' | ''                          |
		И     таблица "CurrenciesPaymentList" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '744,86' | '1'            |
	* Checking account selection and saving 
		И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
		И в таблице "List" я перехожу к строке:
		| 'Description'  |
		| 'Cash desk №2' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "CashAccount" стал равен 'Cash desk №2'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 350,00' | 'Company Ferron BP' | 'Sales invoice 1*' | ''                          |
		И     таблица "CurrenciesPaymentList" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '744,86' | '1'            |
		И     элемент формы с именем "DocumentAmount" стал равен '4 350,00'
	* Change of Partner term and basis document
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я активизирую поле "Partner term"
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Partner terms, without VAT' |
		И в таблице "List" я выбираю текущую строку
		# temporarily
		И Пауза 2
		Когда Проверяю шаги на Исключение:
		|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
		# temporarily
		И в таблице "List" я перехожу к строке:
			| 'Company'      | 'Document amount' | 'Legal name'        | 'Partner'   |
			| 'Main Company' | '11 099,93'       | 'Company Ferron BP' | 'Ferron BP' |
		И я нажимаю на кнопку 'Select'
	* Change in payment amount
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '20 000,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Partner term'                     | 'Amount'    | 'Payer'             | 'Basis document'  |
			| 'Ferron BP' | 'Basic Partner terms, without VAT' | '20 000,00' | 'Company Ferron BP' | 'Sales invoice 2*' |
	И Я закрыл все окна клиентского приложения 




Сценарий: _050001 create Cash reciept (independently)
	* Create Cash receipt in lire for Ferron BP (Sales invoice in lire)
		И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the details of the document
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Code | Description  |
				| TRY  | Turkish lira |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Cash desk №1 |
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 1
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		* Filling in a partner in a tabular part
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
		* Filling in an Partner term
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Filling in basis documents in a tabular part
			# temporarily
			И Пауза 2
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# temporarily
			И Пауза 2
			Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		* Filling in amount in a tabular part
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		* Check creation a Cash receipt
			Тогда таблица "List" содержит строки:
			| Number |
			|   1    |
	* Create Cash receipt in USD for Ferron BP (Sales invoice in lire)
		И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the details of the document
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| Code |
				| USD  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Cash desk №1 |
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 2
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		* Filling in a partner in a tabular part
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
		* Filling in an Partner term
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'           |
					| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# temporarily
			Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# temporarily
		* Filling in amount in a tabular part
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		* Check creation a Cash receipt
			Тогда таблица "List" содержит строки:
			| Number |
			|   2    |
	* Create Cash receipt in Euro for Ferron BP (Sales invoice in USD)
		Когда создаю Sales invoice для Ferron BP в долларах
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the details of the document
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Cash desk №2 |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| Code | Description |
				| EUR  | Euro        |
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 3
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		* Filling in a partner in a tabular part
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
		* Filling in an Partner term
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'           |
					| 'Ferron, USD' |
			И в таблице "List" я выбираю текущую строку
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# temporarily
			Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '200,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# temporarily
		* Filling in amount in a tabular part
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '50,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		* Check creation a Cash receipt
			Тогда таблица "List" содержит строки:
			| Number |
			|   3    |

Сценарий: _050002 check Cash receipt movements by register PartnerArTransactions
	И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerArTransactions"
	Тогда таблица "List" содержит строки:
	| 'Currency' | 'Recorder'           | 'Legal name'        |  'Basis document'     | 'Company'      | 'Amount'    | 'Partner term'                     | 'Partner'   |
	| 'TRY'      | 'Cash receipt 1*'    | 'Company Ferron BP' |  'Sales invoice 1*'   | 'Main Company' | '100,00'    | 'Basic Partner terms, TRY'         | 'Ferron BP' |
	| 'USD'      | 'Cash receipt 2*'    | 'Company Ferron BP' |  'Sales invoice 1*'   | 'Main Company' | '100,00'    | 'Basic Partner terms, TRY'         | 'Ferron BP' |
	| 'EUR'      | 'Cash receipt 3*'    | 'Company Ferron BP' |  'Sales invoice 234*' | 'Main Company' | '50,00'     | 'Ferron, USD'                   | 'Ferron BP' |

Сценарий: _050002 check Cash receipt movements with transaction type Payment from customer
	* Open Cash receipt 1
		И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Check movements Cash receipt 1
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Cash receipt 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Partner term'             | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '17,12'     | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'               | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                  | 'Partner'               | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                     | 'Expense'     | '*'                   | ''                    | ''               | ''                                          | '100'            | 'Main Company'             | 'Ferron BP'             | 'Company Ferron BP' | 'Sales invoice 1*'         | 'TRY'                  |
			| ''                                     | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Company Ferron BP'    | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Multi currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company'    | 'Cash desk №1'         | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения
	* Clear postings Cash receipt 1 and check that there is no movement on the registers
		* Clear postings документа
			И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Check that there is no movement on the registers
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Cash receipt 1*' |
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AccountBalance'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Cash receipt 1*' |
			И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ReconciliationStatement'
			Тогда таблица "List" не содержит строки:
				| 'Recorder'           |
				| 'Cash receipt 1*' |
			И я закрыл все окна клиентского приложения
	* Re-posting the document and checking postings on the registers
		* Posting the document
			И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Check movements
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Cash receipt 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Partner term'             | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '17,12'     | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'               | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                  | 'Partner'               | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                     | 'Expense'     | '*'                   | ''                    | ''               | ''                                          | '100'            | 'Main Company'             | 'Ferron BP'             | 'Company Ferron BP' | 'Sales invoice 1*'         | 'TRY'                  |
			| ''                                     | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Company Ferron BP'    | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Multi currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company'    | 'Cash desk №1'         | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
			И Я закрыл все окна клиентского приложения




# Filters

Сценарий: _050003 filter check by own companies in the document Cash reciept
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	Когда проверяю фильтр по собственным компаниям

Сценарий: _050004 cash filter check (bank selection not available)
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	Когда проверяю фильтр по кассам (выбор банка недоступен)


Сценарий: _050005 check input Description in the documentCash reciept
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	Когда проверяю ввод Description

Сценарий: _050006 check the choice of transaction type in the documentCash reciept
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	Когда проверяю выбор вида операции в документах поступления оплаты


Сценарий: _050007 check legal name filter in tabular part in document Cash reciept
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	Когда проверяю фильтр по контрагенту в табличной части в документах поступления оплаты

Сценарий: _050008 check partner filter in tabular part in document Cash reciept
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	Когда проверяю фильтр по партнеру в табличной части в документах поступления оплаты



# EndFilters


Сценарий: _050011 check currency selection in Cash reciept document in case the currency is specified in the account
# the choice is not available
	Когда создаю временную кассу Cash desk №4 со строго фиксированной валютой (лиры)
	И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю выбор валюты в кассовом платежном документе в случае если валюта указана в счете
	И я удаляю элемент справочника "CashAccounts" со значением поля Description_en "Cash desk №4"






Сценарий: _050013 check the display of details on the form Cash reciept with the type of operation Payment from customer
	И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
	* Then I check the display on the form of available fields
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "CashAccount" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "CurrencyExchange" не доступен
	* And I check the display of the tabular part
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Kalipso |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" стала равной:
		| # | Partner | Amount | Payer                | Basis document | Planing transaction basis |
		| 1 | Kalipso | ''     | Company Kalipso    | ''             | ''                        |



Сценарий: _050014 check the display of details on the form Cash reciept with the type of operation Currency exchange
	И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Currency exchange'
	* Then I check the display on the form of available fields
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "CashAccount" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Currency exchange'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "CurrencyExchange" доступен
	* And I check the display of the tabular part
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я активизирую поле "Amount exchange"
		И в таблице "PaymentList" в поле 'Amount exchange' я ввожу текст '2 000,00'
		И     таблица "PaymentList" стала равной:
			| '#' | 'Partner' | 'Amount' | 'Amount exchange' | 'Planning transaction basis' |
			| '1' | ''        | '100,00' | '2 000,00'        | ''                          |



Сценарий: _050015 check the display of details on the form Cash reciept with the type of operation Cash transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
	* Then I check the display on the form of available fields
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "CashAccount" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Cash transfer order'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "CurrencyExchange" не доступен
	* And I check the display of the tabular part
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		Если в таблице "PaymentList" нет колонки с именем "Payer" Тогда
		Если в таблице "PaymentList" нет колонки с именем "Partner" Тогда
		И     таблица "PaymentList" содержит строки:
		| '#' | 'Amount' | 'Planning transaction basis' |
		| '1' | '100,00' | ''                          |