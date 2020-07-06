#language: ru
@tree
@Positive
Функционал: create Bank payment


As an accountant
I want to pay by bank payment.
To close debts to partners

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# The currency of reports is lira
# CashBankDocFilters export scenarios


Сценарий: _053001 create Bank payment based on Purchase invoice
	* Open list form Purchase invoice and select PI №1
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И я нажимаю на кнопку с именем 'FormDocumentBankPaymentGenarateBankPayment'
	* Create and filling in Purchase invoice
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '136 000,00' | 'Purchase invoice 1*' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Amount'    | 'Multiplicity' |
			| 'Reporting currency' | '23 287,67' | '1'            |
	* Data overflow check
		И я нажимаю кнопку выбора у поля "Account"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, USD'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '136 000,00' | 'Purchase invoice 1*' |
		И     таблица "PaymentListCurrencies" содержит строки:
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'USD'           | 'TRY'      | '0,1770'            | '768 361,58' | '1'            |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '768 361,58' | '1'            |
	* Check calculation Document amount
		И     элемент формы с именем "DocumentAmount" стал равен '136 000,00'
	* Change in basis document
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"
		И в таблице "List" я перехожу к строке:
		| 'Legal name'        | 'Partner'   | 'Document amount'           |
		| 'Company Ferron BP' | 'Ferron BP' | '496 650,00' |
		И я нажимаю на кнопку 'Select'
		И в таблице "PaymentList" я перехожу к следующей ячейке
	* Change in payment amount
		И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
		И в таблице "PaymentList" я выбираю текущую строку
		И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '20 000,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		И     таблица "PaymentList" содержит строки:
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '20 000,00' | 'Purchase invoice 6*' |
	И Я закрыл все окна клиентского приложения




Сценарий: _053001 create Bank payment (independently)
	* Create Bank payment in lire for Ferron BP (Purchase invoice in lire)
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
		* Select transaction type
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		* Filling in the details of the document
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
		* Change the document number to 1
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		* Filling in partners in a tabular part
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
		* Filling in an Partner term
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			И в таблице "List" я выбираю текущую строку
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			Когда Проверяю шаги на Исключение:
				|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# temporarily
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# temporarily
		* Filling in amount in a tabular part
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '1000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		* Check creation
			Тогда таблица "List" содержит строки:
				| Number |
				|   1    |
	* Create Bank payment in USD for Ferron BP (Purchase invoice in lire)
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the details of the document
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
		* Change the document number to 2
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		* Filling in partners in a tabular part
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
		* Filling in an Partner term
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			И в таблице "List" я выбираю текущую строку
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# temporarily
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			И я нажимаю на кнопку 'Select'
		# temporarily
		* Filling in amount in a tabular part
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '20,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		* Check creation a Cash receipt
			Тогда таблица "List" содержит строки:
				| Number |
				|   2    |
	* Create Bank payment in Euro for Ferron BP (Purchase invoice in USD)
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the details of the document
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
		* Change the document number to 3
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3'
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		* Filling in partners in a tabular part
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
		* Filling in an Partner term
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Vendor Ferron, USD' |
			И в таблице "List" я выбираю текущую строку
		* Filling in amount in a tabular part
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '150,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		* Check creation a Bank payment
			Тогда таблица "List" содержит строки:
				| Number |
				|   3    |

Сценарий: _053002 check Bank payment movements by register PartnerApTransactions
		И я открываю навигационную ссылку "e1cib/list/AccumulationRegister.PartnerApTransactions"
		Тогда таблица "List" содержит строки:
			| 'Currency'   | 'Recorder'            | 'Legal name'        | 'Basis document'     | 'Company'      | 'Amount'     | 'Partner term'            | 'Partner'   |
			| 'TRY'        | 'Bank payment 1*'     | 'Company Ferron BP' |'Purchase invoice 1*' | 'Main Company' | '1 000,00'   | 'Vendor Ferron, TRY'   | 'Ferron BP' |
			| 'USD'        | 'Bank payment 2*'     | 'Company Ferron BP' |'Purchase invoice 1*' | 'Main Company' | '20,00'      | 'Vendor Ferron, TRY'   | 'Ferron BP' |
			| 'EUR'        | 'Bank payment 3*'     | 'Company Ferron BP' |'*'                   | 'Main Company' | '150,00'     | 'Vendor Ferron, USD'   | 'Ferron BP' |
		И Я закрыл все окна клиентского приложения


Сценарий: _050002 check Bank payment movements with transaction type Payment to the vendor
	* Open Bank payment 1
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
	* Check movements Bank payment 1
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Bank payment 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                             | ''               | 'Dimensions'               | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR' | 'Company'                  | 'Partner'              | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Expense'     | '*'                   | ''                    | '1 000'          | ''                                             | ''               | 'Main Company'             | 'Ferron BP'            | 'Company Ferron BP' | 'Purchase invoice 1*'      | 'TRY'                  |
			| ''                                         | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '1 000'     | 'Main Company' | 'Company Ferron BP' | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AP transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Partner term'             | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Multi currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Bank account, TRY' | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения
	* Clear postings Bank payment 1 and check that there is no movement on the registers
		* Clear postings документа
			И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		* Check that there is no movement on the registers
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
	* * Re-posting the document and checking postings on the registers
		* Posting the document
			И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
			И в таблице "List" я перехожу к строке:
				| 'Number' |
				| '1'      |
			И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		* Check movements
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
				| 'Bank payment 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                             | ''               | 'Dimensions'               | ''                     | ''                  | ''                         | ''                     |
			| ''                                         | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR' | 'Company'                  | 'Partner'              | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Expense'     | '*'                   | ''                    | '1 000'          | ''                                             | ''               | 'Main Company'             | 'Ferron BP'            | 'Company Ferron BP' | 'Purchase invoice 1*'      | 'TRY'                  |
			| ''                                         | ''            | ''                    | ''                    | ''               | ''                                             | ''               | ''                         | ''                     | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '1 000'     | 'Main Company' | 'Company Ferron BP' | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AP transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Partner term'             | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 1*'  | 'Ferron BP' | 'Company Ferron BP'     | 'Vendor Ferron, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Multi currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Bank account, TRY' | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Bank account, TRY' | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
			И Я закрыл все окна клиентского приложения

# Filters

Сценарий: _053003 filter check by own companies in the document Bank payment
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по собственным компаниям

	

Сценарий: _053004 check the filter by bank accounts (the choice of Cash/Bank accounts is not available) + filling in currency from the bank account in Bank payment document
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по банковским счетам (выбор кассы недоступен) + заполнение валюты из банковского счета

Сценарий: _053005 check input Description in the document Bank payment
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю ввод Description

Сценарий: _053006 checking the choice of transaction type in the document Bank payment
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю выбор вида операции в документах оплаты
	

Сценарий: _053007 check legal name filter in tabular part in document Bank payment
	# when selecting a partner, only its legal names should be available on the selection list
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по контрагенту в табличной части в документах оплаты
	


Сценарий: _053008 check partner filter in tabular part in document Bank payment
	# when selecting a legal name, only its partners should be available on the partner selection list
	И я закрыл все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	Когда проверяю фильтр по партнеру в табличной части в документах оплаты
	

# EndFilters

Сценарий: _053011 check currency selection in Bank payment document in case the currency is specified in the account
	И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю выбор валюты в банковском платежном документе в случае если валюта указана в счете




Сценарий: _053013 check the display of details on the form Bank payment with the type of operation Payment to the vendor
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
	* Then I check the display on the form of available fields
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" не доступен
	* And I check the display of the tabular part
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Kalipso |
		И в таблице "List" я выбираю текущую строку
		И     таблица "PaymentList" стала равной:
			| '#' | Partner | Amount | Payee              | Basis document | Planing transaction basis |
			| '1' | Kalipso | ''     | Company Kalipso    | ''             | ''                        |







Сценарий: _053015 check the display of details on the form Bank payment with the type of operation Cash transfer
	И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
	И я нажимаю на кнопку с именем 'FormCreate'
	И из выпадающего списка "Transaction type" я выбираю точное значение 'Cash transfer order'
	Then I check the display on the form of available fields
		И     элемент формы с именем "Company" доступен
		И     элемент формы с именем "Account" доступен
		И     элемент формы с именем "Description" доступен
		И     элемент формы с именем "TransactionType" стал равен 'Cash transfer order'
		И     элемент формы с именем "Currency" доступен
		И     элемент формы с именем "Date" доступен
		И     элемент формы с именем "TransitAccount" не доступен
	And I check the display of the tabular part
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" в поле 'Amount' я ввожу текст '100,00'
		И в таблице "PaymentList" я завершаю редактирование строки
		Если в таблице "PaymentList" нет колонки с именем "Payee" Тогда
		Если в таблице "PaymentList" нет колонки с именем "Partner" Тогда
		И     таблица "PaymentList" стала равной:
			| '#' | 'Amount' | 'Planning transaction basis' |
			| '1' | '100,00' | ''                          |

	
























	




