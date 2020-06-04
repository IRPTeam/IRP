#language: ru
@tree
@Positive
Функционал: списание дебиторской и кредиторской задолженности
Как Разработчик
Я хочу создать документ Credit_DebitNote
Для проведения списания дебиторской и кредиторской задолженности

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# Cash revenue

Сценарий: _095001 создание тестовых данных
	* Создание клиента и поставщика
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Lunch'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Customer'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Partner segments (create) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Company Lunch'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Maxim'
		И я изменяю флаг 'Customer'
		И я изменяю флаг 'Vendor'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		Тогда открылось окно 'Partner segments'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Company Maxim'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Company Aldis'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
	* Создание соглашения с поставщиком для Maxim с видом расчетов по соглашениям
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Agreement Maxim'
		И я меняю значение переключателя 'Type' на 'Vendor'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я нажимаю кнопку выбора у поля "Currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' |
			| 'TRY'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Maxim'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Vendor price, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я изменяю флаг 'Price include tax'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2019'
		И я нажимаю на кнопку 'Save and close'
	И Пауза 30
	* Создание Sales invoice по созданному клиенту
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Partner" я выбираю по строке 'Lunch'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '15,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "Currency"
		И я перехожу к закладке с именем "GroupCurrency"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '2 900'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2 900'
		И в поле 'Date' я ввожу текст '01.01.2020  10:00:00'
		И Пауза 1
		И я перехожу к закладке "Item list"
		# И Пауза 5
		# Тогда открылось окно 'Update item list info'
		# И я изменяю флаг 'Update filled prices.'
		# И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
	* Создание Purchase invoice по поставщику
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение данных о поставщике
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Maxim'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'   |
				| 'Company Maxim' |
			И в таблице "List" я выбираю текущую строку
		* Изменение номера purchase invoice на 601
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2 900'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2 900'
		* Добавление товара в Purchase Invoice
			И я перехожу к закладке "Item list"
			И  я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" в поле 'Price' я ввожу текст '550,00'
		* Изменение даты в Purchase invoice
			И я перехожу к закладке "Other"
			И в поле 'Date' я ввожу текст '01.01.2020  10:00:00'
			И Пауза 1
			И я перехожу к закладке "Item list"
			И Пауза 5
			Тогда открылось окно 'Update item list info'
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Post and close'
	* Создание ещё одного Purchase invoice по поставщику
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение данных о поставщике
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Maxim'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'   |
				| 'Company Maxim' |
			И в таблице "List" я выбираю текущую строку
		* Изменение номера purchase invoice на 2901
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2 901'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2 901'
		* Добавление товара в Purchase Invoice
			И я перехожу к закладке "Item list"
			И  я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '20,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
		* Изменение даты в Purchase invoice
			И я перехожу к закладке "Other"
			И в поле 'Date' я ввожу текст '01.01.2020  10:00:00'
			И Пауза 1
			И я перехожу к закладке "Item list"
			И Пауза 5
			Тогда открылось окно 'Update item list info'
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Post and close'
	

Сценарий: _095002 проверка проводок документа Credit_DebitNote по виду операции payable
	* Создание документа
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение реквизитов шапки
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Maxim'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Company Maxim' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение документа-основания вручную для списания задолженности
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner ap transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		* Проверка отбора документов-оснований по указанному партнеру
			Тогда в таблице "List" количество строк "меньше или равно" 2
			Тогда таблица "List" содержит строки:
			| 'Number' | 'Legal name'    | 'Partner' | 'Amount'    | 'Currency' |
			| '2 900'  | 'Company Maxim' | 'Maxim'   | '11 000,00' | 'TRY'      |
			| '2 901'  | 'Company Maxim' | 'Maxim'   | '10 000,00' | 'TRY'      |
		И в таблице "List" я перехожу к строке
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsAmount"
		И в таблице "Transactions" в поле с именем 'TransactionsAmount' я ввожу текст '1 000,00'
		И в таблице "Transactions" я завершаю редактирование строки
		И в таблице "Transactions" я активизирую поле "Business unit"
		И в таблице "Transactions" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'Distribution department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле "Expense type"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Software'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я завершаю редактирование строки
	* Изменение номера документа
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Проверка проводок документа
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Credit debit note 1*'                 | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''                        | ''                       | ''               | 'Dimensions'    | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''                    | 'Advance to supliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                     | 'Expense'     | '*'                   | ''                    | '1 000'                   | ''                       | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'            | ''                         | 'TRY'                  |
		| ''                                     | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Legal name'     | 'Currency' | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '1 000'        | 'Main Company'            | 'Company Maxim'  | 'TRY'      | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''               | ''         | ''              | ''                    | ''                         | 'Attributes'               | ''                     |
		| ''                                     | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Revenue type'   | 'Item key' | 'Currency'      | 'Additional analytic' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                     | '*'           | '171,23'    | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'USD'           | ''                    | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'Local currency'           | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'TRY'                      | 'No'                       | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | 'Attributes'           |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Basis document' | 'Partner'  | 'Legal name'    | 'Agreement'           | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'         | '171,23'       | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'TRY'                      | 'TRY'                      | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _095003 проверка проводок при изменении документа-основания и суммы в уже проведенном CreditDebitNote
	* Выбор уже созданного документа
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
	* Изменение документа-основания и суммы
		И в таблице "Transactions" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner ap transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| 'Amount'    | 'Currency' | 'Legal name'    | 'Number' | 'Partner' |
			| '10 000,00' | 'TRY'      | 'Company Maxim' | '2 901'  | 'Maxim'   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsAmount"
		И в таблице "Transactions" в поле с именем 'TransactionsAmount' я ввожу текст '2 000,00'
		И в таблице "Transactions" я завершаю редактирование строки
	* Проверка проводок
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Credit debit note 1*'                 | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''                        | ''                       | ''               | 'Dimensions'    | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''                    | 'Advance to supliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                     | 'Expense'     | '*'                   | ''                    | '2 000'                   | ''                       | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'            | ''                         | 'TRY'                  |
		| ''                                     | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Legal name'     | 'Currency' | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '2 000'        | 'Main Company'            | 'Company Maxim'  | 'TRY'      | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''               | ''         | ''              | ''                    | ''                         | 'Attributes'               | ''                     |
		| ''                                     | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Revenue type'   | 'Item key' | 'Currency'      | 'Additional analytic' | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                     | '*'           | '342,47'    | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'USD'           | ''                    | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                     | '*'           | '2 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                     | '*'           | '2 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'Local currency'           | 'No'                       | ''                     |
		| ''                                     | '*'           | '2 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'TRY'                      | 'No'                       | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | 'Attributes'           |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Basis document' | 'Partner'  | 'Legal name'    | 'Agreement'           | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'         | '342,47'       | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '2 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '2 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '2 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Agreement Maxim'     | 'TRY'                      | 'TRY'                      | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _095004 проверка проводок документа Credit_DebitNote по виду операции Receivable
	* Создание документа
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение реквизитов шапки
		И из выпадающего списка "Operation type" я выбираю точное значение 'Receivable'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lunch'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Company Lunch' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение документа-основания вручную для списания задолженности
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner AR transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		* Проверка отбора документов-оснований по указанному партнеру
			Тогда в таблице "List" количество строк "меньше или равно" 1
			Тогда таблица "List" содержит строки:
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я перехожу к строке
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsAmount"
		И в таблице "Transactions" в поле с именем 'TransactionsAmount' я ввожу текст '1 000,00'
		И в таблице "Transactions" я завершаю редактирование строки
		И в таблице "Transactions" я активизирую поле "Business unit"
		И в таблице "Transactions" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'Distribution department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле "Expense type"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Software'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я завершаю редактирование строки
	* Изменение номера документа
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	* Проверка проводок документа
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Credit debit note 2*'                 | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'  | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Basis document'                                | 'Partner'  | 'Legal name'    | 'Agreement'             | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'         | '171,23'       | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Agreements, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Agreements, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Agreements, TRY' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Agreements, TRY' | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Expenses turnovers"'       | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                     | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Expense type'                                  | 'Item key' | 'Currency'      | 'Additional analytic'   | 'Currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                     | '*'           | '171,23'    | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'USD'           | ''                      | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'TRY'           | ''                      | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'TRY'           | ''                      | 'Local currency'           | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'TRY'           | ''                      | 'TRY'                      | 'No'                       | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                | ''                    | ''                    | ''                    | ''                        | ''                                              | ''               | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                              | 'Record type'         | 'Period'              | 'Resources'           | ''                        | ''                                              | ''               | 'Dimensions'    | ''                      | ''                         | ''                         | ''                     |
		| ''                                              | ''                    | ''                    | 'Advance to supliers' | 'Transaction AP'          | 'Advance from customers'                        | 'Transaction AR' | 'Company'       | 'Partner'               | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                              | 'Expense'             | '*'                   | ''                    | ''                        | ''                                              | '1 000'          | 'Main Company'  | 'Lunch'                 | 'Company Lunch'            | 'Sales invoice 2 900*'     | 'TRY'                  |
		| ''                                              | ''                    | ''                    | ''                    | ''                        | ''                                              | ''               | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Legal name'                                    | 'Currency' | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Company Lunch'                                 | 'TRY'      | ''              | ''                      | ''                         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения

Сценарий: _095005 проверка заполнения контрагента если он у партнера только один
	* Создание документа
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение партнера и проверка заполнения контрагента
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lunch'       |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'Company Lunch'
	* Проверка перезаполнения контрагента при перевыборе партнера
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'

Сценарий: _095006 проверка перевыбора вида операции в  документе CreditDebitNote
	* Создание документа
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение реквизитов шапки
		И из выпадающего списка "Operation type" я выбираю точное значение 'Receivable'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lunch'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Company Lunch' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение документа-основания вручную для списания задолженности
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner AR transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		* Проверка отбора документов-оснований по указанному партнеру
			Тогда в таблице "List" количество строк "меньше или равно" 1
			Тогда таблица "List" содержит строки:
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я перехожу к строке
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле с именем "TransactionsAmount"
		И в таблице "Transactions" в поле с именем 'TransactionsAmount' я ввожу текст '1 000,00'
		И в таблице "Transactions" я завершаю редактирование строки
		И в таблице "Transactions" я активизирую поле "Business unit"
		И в таблице "Transactions" я выбираю текущую строку
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'Distribution department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я активизирую поле "Expense type"
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Software'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Transactions" я завершаю редактирование строки
	* Изменение номера документа
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '12'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '12'
		И я нажимаю на кнопку 'Post'
	* Перевыбор вида операции
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда в таблице "Transactions" количество строк "равно" 0
		И Я закрыл все окна клиентского приложения
	* Нажатие отмены при перевыборе вида операции
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '12'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'No'
		И     таблица "Transactions" содержит строки:
		| 'Partner AR transactions basis document'        | 'Partner' | 'Agreement'             | 'Amount'   | 'Business unit'           | 'Currency' | 'Expense type' |
		| 'Sales invoice 2 900*'                          | 'Lunch'   | 'Basic Agreements, TRY' | '1 000,00' | 'Distribution department' | 'TRY'      | 'Software'     |
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
		И     таблица "Transactions" содержит строки:
		| 'Partner AR transactions basis document'        | 'Partner' | 'Agreement'             | 'Amount'   | 'Business unit'           | 'Currency' | 'Expense type' |
		| 'Sales invoice 2 900*'                          | 'Lunch'   | 'Basic Agreements, TRY' | '1 000,00' | 'Distribution department' | 'TRY'      | 'Software'     |
	

Сценарий: _095007 проверка заполнения и перезаполнения табличной части с помощью кнопки Fill
	* Создание документа
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение реквизитов шапки
		И из выпадающего списка "Operation type" я выбираю точное значение 'Receivable'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Company Kalipso' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение табличной части
		И в таблице "Transactions" я нажимаю на кнопку 'Fill transactions'
		И     таблица "Transactions" содержит строки:
			| 'Partner AR transactions basis document'      |
			| 'Sales invoice 180*'                          |
			| 'Sales invoice 181*'                          |
			| 'Sales invoice 3*'                            |
	* Перевыбор партнера и проверка перезаполнения табличной части
		И я нажимаю кнопку выбора у поля с именем "Partner"
		Тогда открылось окно 'Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'     |
		И в таблице "List" я выбираю текущую строку
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		Тогда в таблице "Transactions" количество строк "равно" 0
		И в таблице "Transactions" я нажимаю на кнопку 'Fill transactions'
		И     таблица "Transactions" не содержит строки:
			| 'Partner AR transactions basis document'      |
			| 'Sales invoice 180*'                          |
			| 'Sales invoice 181*'                          |
			| 'Sales invoice 3*'                            |
	И Я закрыл все окна клиентского приложения

