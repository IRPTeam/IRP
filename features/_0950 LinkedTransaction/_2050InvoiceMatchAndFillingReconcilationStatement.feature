#language: ru
@tree
@Positive

Функционал: кнопки выбора документов-оснований



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# партнеры Crystal

Сценарий: _2050001 проверка наличия и создание тестовых данных
	* Проверка наличия Purchase invoice по Crystal
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Legal name'   | 'Partner' | 'Currency' | 'Company'      |
		| '9 000'  | 'Company Adel' | 'Crystal' | 'TRY'      | 'Main Company' |
		| '9 001'  | 'Company Adel' | 'Crystal' | 'TRY'      | 'Main Company' |
	* Проверка наличия Sales invoice по Crystal
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Legal name'   | 'Partner' | 'Currency' |
		| '9 000'  | 'Company Adel' | 'Crystal' | 'TRY'      |
		| '9 002'  | 'Company Adel' | 'Crystal' | 'TRY'      |
		| '9 003'  | 'Company Adel' | 'Crystal' | 'TRY'      |
	* Создание Bank payment без привязки к соглашению и документу
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment to the vendor'
		И я заполняю реквизиты документа
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
		И я меняю номер документа на 700
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '700'
			И в поле "Date" я ввожу начало текущего месяца
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И я заполняю партнера в табличной части
			И в таблице "PaymentList" я активизирую поле "Partner"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '1000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Создание Bank receipt без привязки к соглашению и документу
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
		И я заполняю реквизиты документа
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
		И я меняю номер документа на 700
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '700'
			И в поле "Date" я ввожу начало текущего месяца
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И я заполняю партнера в табличной части
			И в таблице "PaymentList" я активизирую поле "Partner"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '20000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Создание Cash receipt c привязкой по документу
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Payment from customer'
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
			И я нажимаю кнопку выбора у поля "Cash account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Cash desk №3 |
			И в таблице "List" я выбираю текущую строку
		И я меняю номер документа на 700
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '700'
			И в поле "Date" я ввожу начало текущего месяца
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И я заполняю партнера в табличной части
			И в таблице "PaymentList" я активизирую поле "Partner"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
		* Заполнение Agreement
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение документа основания в табличной части
			# костыль
			И Пауза 2
			Когда Проверяю шаги на Исключение:
			|'И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Basis document"'|
			# костыль
			И Пауза 2
			Дано В активном окне открылась форма с заголовком "Documents for incoming payment"
			И в таблице "List" я перехожу к строке:
				| 'Document amount' | 'Legal name'   | 'Partner' |
				| '1 740,00'        | 'Company Adel' | 'Crystal' |
			И я нажимаю на кнопку 'Select'
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '5000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Создание Cash payment без привязки к соглашению и документу
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
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
			И я нажимаю кнопку выбора у поля "Cash account"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Cash desk №3 |
			И в таблице "List" я выбираю текущую строку
		И я меняю номер документа на 700
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '700'
			И в поле "Date" я ввожу начало текущего месяца
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И я заполняю партнера в табличной части
			И в таблице "PaymentList" я активизирую поле "Partner"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
		И я заполняю сумму в табличной части
			И в таблице "PaymentList" я активизирую поле "Amount"
			И в таблице "PaymentList" в поле 'Amount' я ввожу текст '5000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'

Сценарий: 2050002 проверка заполнения Reconcilation statement
	* Открытие формы создания Reconcilation statement
		И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнения шапки документа
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Begin period"
		И в поле 'Begin period' я ввожу начало текущего месяца
		И в поле 'End period' я ввожу конец текущего месяца
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Crystal' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Company Adel' |
		И в таблице "List" я выбираю текущую строку
	* Проверка заполнения табличной части
		И в таблице "Transactions" я нажимаю на кнопку 'Fill'
		И     таблица "Transactions" содержит строки:
		| 'Date' | 'Document'                | 'Credit'    | 'Debit'     |
		| '*'    | 'Cash payment 700*'       | ''          | '5 000,00'  |
		| '*'    | 'Cash receipt 700*'       | '5 000,00'  | ''          |
		| '*'    | 'Bank payment 700*'       | ''          | '1 000,00'  |
		| '*'    | 'Bank receipt 700*'       | '20 000,00' | ''          |
		| '*'    | 'Sales invoice 9 000*'    | ''          | '19 240,00' |
		| '*'    | 'Sales invoice 9 002*'    | ''          | '1 740,00'  |
		| '*'    | 'Sales invoice 9 003*'    | ''          | '28 686,30' |
		| '*'    | 'Purchase invoice 9 000*' | '13 570,00' | ''          |
		| '*'    | 'Purchase invoice 9 001*' | '4 212,60'  | ''          |
	* Проверка документа
		И я нажимаю на кнопку 'Post'
	* Распроведение документа
		И я нажимаю на кнопку 'Clear posting'
		И Я закрыл все окна клиентского приложения


Сценарий: _2050003 проверка автозаполнения документа Invoice match с клиентом по авансам
	* Открытие формы создания Invoice match
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И из выпадающего списка "Operation type" я выбираю точное значение 'With customer'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "PartnerArTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| 'Column1'       |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '9 000'  | 'Crystal' |
		И в таблице "List" я активизирую поле "Partner"
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части по нераспределенным авансам
		И я перехожу к закладке "Advances"
		И в таблице "Advances" я нажимаю на кнопку 'Fill advances'
	* Проверка заполнения
		И     таблица "Advances" содержит строки:
			| 'Receipt document'  | 'Closing amount' | 'Partner' | 'Amount'    | 'Legal name'   | 'Currency' |
			| 'Bank receipt 700*' | '20 000,00'      | 'Crystal' | '20 000,00' | 'Company Adel' | 'TRY'      |
		Тогда в таблице "Advances" количество строк "меньше или равно" 2
	И Я закрыл все окна клиентского приложения

Сценарий: _2050004 проверка автозаполнения документа Invoice match с поставщиком по авансам
	* Открытие формы создания Invoice match
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И из выпадающего списка "Operation type" я выбираю точное значение 'With vendor'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "PartnerApTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| 'Column1'       |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '9 000'  | 'Crystal' |
		И в таблице "List" я активизирую поле "Partner"
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части по нераспределенным авансам
		И я перехожу к закладке "Advances"
		И в таблице "Advances" я нажимаю на кнопку 'Fill advances'
	* Проверка заполнения
		И     таблица "Advances" содержит строки:
			| 'Closing amount' | 'Payment document'  | 'Partner' | 'Amount'   | 'Legal name'   | 'Currency' |
			| '5 000,00'       | 'Cash payment 700*' | 'Crystal' | '5 000,00' | 'Company Adel' | 'TRY'      |
			| '1 000,00'       | 'Bank payment 700*' | 'Crystal' | '1 000,00' | 'Company Adel' | 'TRY'      |
		Тогда в таблице "Advances" количество строк "меньше или равно" 2
	И Я закрыл все окна клиентского приложения

Сценарий: _2050005 проверка движений документа Invoice match с поставщиком по авансам (заполнение вручную)
	* Открытие формы создания Invoice match
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И из выпадающего списка "Operation type" я выбираю точное значение 'With vendor'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "PartnerApTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| 'Column1'       |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '9 000'  | 'Crystal' |
		И в таблице "List" я активизирую поле "Partner"
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части по авансам вручную
		И в таблице "Advances" я нажимаю на кнопку 'Add'
		# временно
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Payment document"'
		# временно
		И в таблице "" я перехожу к строке:
			| ''             |
			| 'Bank payment' |
		И в таблице "" я выбираю текущую строку
		И я активизирую окно "Bank payments*"
		И в таблице "List" я перехожу к первой строке:
			# | 'Number' | 'Reference'         |
			# | '700'    | 'Bank payment 700*' |
		# И в таблице "List" я активизирую поле "Account"
		# И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "Advances" я активизирую поле "Partner"
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Advances" я активизирую поле "Legal name"
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Company Adel' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Advances" я активизирую поле "Currency"
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Advances" я активизирую поле "Amount"
		И в таблице "Advances" в поле 'Amount' я ввожу текст '1 000,00'
		И в таблице "Advances" я активизирую поле "Closing amount"
		И в таблице "Advances" в поле 'Closing amount' я ввожу текст '1 000,00'
		И в таблице "Advances" я завершаю редактирование строки
	* Изменение номера документа и его проведение
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
		И я нажимаю на кнопку 'Post'
	* Проверка движений документа
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Invoice match 1*'                    | ''            | ''       | ''          | ''             | ''                        | ''             | ''             | ''                  | ''                         | ''                         | ''                     |
		| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                        | ''             | ''             | ''                  | ''                         | ''                         | ''                     |
		| 'Register  "Advance to suppliers"'    | ''            | ''       | ''          | ''             | ''                        | ''             | ''             | ''                  | ''                         | ''                         | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''             | ''             | ''                  | ''                         | 'Attributes'               | ''                     |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'                 | 'Legal name'   | 'Currency'     | 'Payment document'  | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                    | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Crystal'                 | 'Company Adel' | 'USD'          | 'Bank payment 700*' | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Crystal'                 | 'Company Adel' | 'TRY'          | 'Bank payment 700*' | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Crystal'                 | 'Company Adel' | 'TRY'          | 'Bank payment 700*' | 'Local currency'           | 'No'                       | ''                     |
		| ''                                    | ''            | ''       | ''          | ''             | ''                        | ''             | ''             | ''                  | ''                         | ''                         | ''                     |
		| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''                        | ''             | ''             | ''                  | ''                         | ''                         | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''             | ''             | ''                  | ''                         | ''                         | 'Attributes'           |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'          | 'Partner'      | 'Legal name'   | 'Agreement'         | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                    | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Purchase invoice 9 000*' | 'Crystal'      | 'Company Adel' | 'Vendor, TRY'       | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 9 000*' | 'Crystal'      | 'Company Adel' | 'Vendor, TRY'       | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Purchase invoice 9 000*' | 'Crystal'      | 'Company Adel' | 'Vendor, TRY'       | 'TRY'                      | 'Local currency'           | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _2050005 проверка движений документа Invoice match с клиентом по авансам (заполнение вручную)
	* Открытие формы создания Invoice match
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И из выпадающего списка "Operation type" я выбираю точное значение 'With customer'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "PartnerArTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| 'Column1'       |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '9 000'  | 'Crystal' |
		И в таблице "List" я активизирую поле "Partner"
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части по авансам вручную
		И в таблице "Advances" я нажимаю на кнопку 'Add'
		# временно
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Receipt document"'
		# временно
		И в таблице "" я перехожу к строке:
			| ''             |
			| 'Bank receipt' |
		И в таблице "" я выбираю текущую строку
		И я активизирую окно "Bank receipts*"
		И в таблице "List" я перехожу к первой строке:
			# | 'Number' | 'Reference'         |
			# | '700'    | 'Bank payment 700*' |
		# И в таблице "List" я активизирую поле "Account"
		# И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "Advances" я активизирую поле "Partner"
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Advances" я активизирую поле "Legal name"
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Company Adel' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Advances" я активизирую поле "Currency"
		И в таблице "Advances" я нажимаю кнопку выбора у реквизита "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Advances" я активизирую поле "Amount"
		И в таблице "Advances" в поле 'Amount' я ввожу текст '1 000,00'
		И в таблице "Advances" я активизирую поле "Closing amount"
		И в таблице "Advances" в поле 'Closing amount' я ввожу текст '1 000,00'
		И в таблице "Advances" я завершаю редактирование строки
	* Изменение номера документа и его проведение
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
		И я нажимаю на кнопку 'Post'
	* Проверка движений документа
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Invoice match 2*'                    | ''            | ''       | ''          | ''             | ''                     | ''             | ''             | ''                      | ''                         | ''                         | ''                     |
		| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                     | ''             | ''             | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''                     | ''             | ''             | ''                      | ''                         | ''                         | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                     | ''             | ''             | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'       | 'Partner'      | 'Legal name'   | 'Agreement'             | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                    | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal'      | 'Company Adel' | 'Basic Agreements, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal'      | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal'      | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                    | ''            | ''       | ''          | ''             | ''                     | ''             | ''             | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Advance from customers"'  | ''            | ''       | ''          | ''             | ''                     | ''             | ''             | ''                      | ''                         | ''                         | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                     | ''             | ''             | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'              | 'Legal name'   | 'Currency'     | 'Receipt document'      | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                    | 'Expense'     | '*'      | '171,23'    | 'Main Company' | 'Crystal'              | 'Company Adel' | 'USD'          | 'Bank receipt 700*'     | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Crystal'              | 'Company Adel' | 'TRY'          | 'Bank receipt 700*'     | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                    | 'Expense'     | '*'      | '1 000'     | 'Main Company' | 'Crystal'              | 'Company Adel' | 'TRY'          | 'Bank receipt 700*'     | 'Local currency'           | 'No'                       | ''                     |
		И Я закрыл все окна клиентского приложения


Сценарий: _2050006 проверка движений документа Invoice match с клиентом при перекидывании суммы с документа на документ
	* Открытие формы создания Invoice match
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа
		И из выпадающего списка "Operation type" я выбираю точное значение 'With customer'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "PartnerArTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| 'Column1'       |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '9 000'  | 'Crystal' |
		И в таблице "List" я активизирую поле "Partner"
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части Transaction
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита с именем "TransactionsPartnerArTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| ''              |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '9 002'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsPartner"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита с именем "TransactionsPartner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsLegalName"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита с именем "TransactionsLegalName"
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsAgreement"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита с именем "TransactionsAgreement"
		И в таблице "List" я перехожу к строке:
			| 'AP-AR posting detail' | 'Description'           | 'Kind'    |
			| 'By documents'         | 'Basic Agreements, TRY' | 'Regular' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsCurrency"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита с именем "TransactionsCurrency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsAmount"
		И в таблице "Transactions" в поле с именем 'TransactionsAmount' я ввожу текст '2 000,00'
		И в таблице "Transactions" я завершаю редактирование строки
		И в таблице "Transactions" я активизирую поле с именем "TransactionsClosingAmount"
		И в таблице "Transactions" я выбираю текущую строку
		И в таблице "Transactions" в поле с именем 'TransactionsClosingAmount' я ввожу текст '2 000,00'
		И в таблице "Transactions" я завершаю редактирование строки
	* Изменение номера документа
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '12'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3'
	* Проведение документа и проверка движений
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Invoice match 3*'                    | ''            | ''       | ''          | ''             | ''                     | ''        | ''             | ''                      | ''         | ''                         | ''                     |
		| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                     | ''        | ''             | ''                      | ''         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''                     | ''        | ''             | ''                      | ''         | ''                         | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                     | ''        | ''             | ''                      | ''         | ''                         | 'Attributes'           |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'       | 'Partner' | 'Legal name'   | 'Agreement'             | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-342,47'   | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '342,47'    | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _2050007 отмена проведения и повторное проведение Invoice match №3 и проверка движений
	* Открытие списка Invoice match и выбор нужного документа
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '3'     |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
	* Проверка отсутствия движений
		И я нажимаю на кнопку 'Registrations report'
		И табличный документ "ResultTable" не содержит значения:
		| Register  "Partner AR transactions" |
		И Я закрываю текущее окно
	* Повторное проведение документа и проверка движений
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '3'     |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Invoice match 3*'                    | ''            | ''       | ''          | ''             | ''                     | ''        | ''             | ''                      | ''         | ''                         | ''                     |
		| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                     | ''        | ''             | ''                      | ''         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''                     | ''        | ''             | ''                      | ''         | ''                         | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                     | ''        | ''             | ''                      | ''         | ''                         | 'Attributes'           |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'       | 'Partner' | 'Legal name'   | 'Agreement'             | 'Currency' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-342,47'   | 'Main Company' | 'Sales invoice 9 002*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '342,47'    | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | 'Sales invoice 9 000*' | 'Crystal' | 'Company Adel' | 'Basic Agreements, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _2050008 проверка доступности выбора Purchase return и Sales return в документе Invoice match
	* Открытие формы создания Invoice match
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение шапки документа для операции с клиентом
		И из выпадающего списка "Operation type" я выбираю точное значение 'With customer'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "PartnerArTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| 'Column1'       |
			| 'Purchase return' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '1'      | 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		Тогда элемент формы с именем "PartnerArTransactionsBasisDocument" стал равен шаблону "Purchase return 1*"
	* Заполнение шапки документа для операции с поставщиком
		И из выпадающего списка "Operation type" я выбираю точное значение 'With vendor'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "PartnerApTransactionsBasisDocument"
		И в таблице "" я перехожу к строке:
			| 'Column1'       |
			| 'Sales return' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '1'      | 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		Тогда элемент формы с именем "PartnerArTransactionsBasisDocument" стал равен шаблону "Purchase return 1*"
	И Я закрыл все окна клиентского приложения


