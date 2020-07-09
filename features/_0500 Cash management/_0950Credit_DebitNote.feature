#language: ru
@tree
@Positive
Функционал: write-off of accounts receivable and payable

As an accountant
I want to create a Credit_DebitNote document.
For write-off of accounts receivable and payable

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _095001 preparation
	* Create customer and vendor
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Lunch'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Customer'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments content'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Partner segments content (create) *' в течение 20 секунд
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
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments content'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		
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
	* Create vendor Partner term for Maxim, Ap-Ar - posting details (by Partner terms)
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Partner term Maxim'
		И я меняю значение переключателя 'Type' на 'Vendor'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
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
	* Create a Sales invoice for creating customer
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Partner" я выбираю по строке 'Lunch'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
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
		И я нажимаю на кнопку 'Post and close'
	* Create Purchase invoice for creating vendor
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling data о поставщике
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
		* Change the document number to 601
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2 900'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2 900'
		* Adding items to Purchase Invoice
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
		* Change of date in Purchase invoice
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
	* Create one more Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling data о поставщике
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
		* Change the document number to 2901
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2 901'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2 901'
		* Adding items to Purchase Invoice
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
		* Change of date in Purchase invoice
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
	

Сценарий: _095002 check movements of the document Credit_DebitNote by operation type payable
	* Create document
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
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
	* Filling in the basis document for debt write-offs
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner ap transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Purchase invoice' |
		И в таблице "" я выбираю текущую строку
		* Checking the selection of basis documents for the specified partner
			Тогда в таблице "List" количество строк "меньше или равно" 2
			Тогда таблица "List" содержит строки:
			| 'Number' | 'Legal name'    | 'Partner' | 'Amount'    | 'Currency' |
			| '2 900'  | 'Company Maxim' | 'Maxim'   | '11 000,00' | 'TRY'      |
			| '2 901'  | 'Company Maxim' | 'Maxim'   | '10 000,00' | 'TRY'      |
		И в таблице "List" я перехожу к строке:
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
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Check movements документа
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Credit debit note 1*'                 | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''                        | ''                       | ''               | 'Dimensions'    | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                     | 'Expense'     | '*'                   | ''                    | '1 000'                   | ''                       | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'            | ''                         | 'TRY'                  |
		| ''                                     | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Legal name'     | 'Currency' | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '1 000'        | 'Main Company'            | 'Company Maxim'  | 'TRY'      | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''               | ''         | ''              | ''                    | ''                         | 'Attributes'               | ''                     |
		| ''                                     | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Revenue type'   | 'Item key' | 'Currency'      | 'Additional analytic' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                     | '*'           | '171,23'    | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'USD'           | ''                    | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'Local currency'           | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'TRY'                      | 'No'                       | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | 'Attributes'           |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Basis document' | 'Partner'  | 'Legal name'    | 'Partner term'           | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'         | '171,23'       | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'TRY'                      | 'TRY'                      | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _095003 change of the basis document and the amount in the already performed Credit debit note and movement check
	* Choose a document already created
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'      |
		И в таблице "List" я выбираю текущую строку
	* Сhange of the basis document and the amount
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
	* Check movements
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Credit debit note 1*'                 | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''                        | ''                       | ''               | 'Dimensions'    | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                     | 'Expense'     | '*'                   | ''                    | '2 000'                   | ''                       | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'            | ''                         | 'TRY'                  |
		| ''                                     | ''            | ''                    | ''                    | ''                        | ''                       | ''               | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Legal name'     | 'Currency' | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '2 000'        | 'Main Company'            | 'Company Maxim'  | 'TRY'      | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"'       | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''               | ''         | ''              | ''                    | ''                         | 'Attributes'               | ''                     |
		| ''                                     | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Revenue type'   | 'Item key' | 'Currency'      | 'Additional analytic' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                     | '*'           | '342,47'    | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'USD'           | ''                    | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                     | '*'           | '2 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                     | '*'           | '2 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'Local currency'           | 'No'                       | ''                     |
		| ''                                     | '*'           | '2 000'     | 'Main Company' | 'Distribution department' | 'Software'       | ''         | 'TRY'           | ''                    | 'TRY'                      | 'No'                       | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''             | ''                        | ''               | ''         | ''              | ''                    | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''               | ''         | ''              | ''                    | ''                         | ''                         | 'Attributes'           |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Basis document' | 'Partner'  | 'Legal name'    | 'Partner term'           | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'         | '342,47'       | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '2 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '2 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '2 000'        | 'Main Company'            | ''               | 'Maxim'    | 'Company Maxim' | 'Partner term Maxim'     | 'TRY'                      | 'TRY'                      | 'No'                   |
		И Я закрыл все окна клиентского приложения

Сценарий: _095004 check movements of the document Credit_DebitNote by operation type Receivable
	* Create a document
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
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
	* Filling in the basis document for debt write-offs
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner AR transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		* Checking the selection of basis documents for the specified partner
			Тогда в таблице "List" количество строк "меньше или равно" 1
			Тогда таблица "List" содержит строки:
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я перехожу к строке:
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
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	* Check movements документа
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Credit debit note 2*'                 | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'  | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Basis document'                                | 'Partner'  | 'Legal name'    | 'Partner term'             | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'         | '171,23'       | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Partner terms, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                      | 'en descriptions is empty' | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'    | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Expenses turnovers"'       | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                     | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Expense type'                                  | 'Item key' | 'Currency'      | 'Additional analytic'   | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                     | '*'           | '171,23'    | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'USD'           | ''                      | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'TRY'           | ''                      | 'en descriptions is empty' | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'TRY'           | ''                      | 'Local currency'           | 'No'                       | ''                     |
		| ''                                     | '*'           | '1 000'     | 'Main Company' | 'Distribution department' | 'Software'                                      | ''         | 'TRY'           | ''                      | 'TRY'                      | 'No'                       | ''                     |
		| ''                                     | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                | ''                    | ''                    | ''                    | ''                        | ''                                              | ''               | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                              | 'Record type'         | 'Period'              | 'Resources'           | ''                        | ''                                              | ''               | 'Dimensions'    | ''                      | ''                         | ''                         | ''                     |
		| ''                                              | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers'                        | 'Transaction AR' | 'Company'       | 'Partner'               | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                              | 'Expense'             | '*'                   | ''                    | ''                        | ''                                              | '1 000'          | 'Main Company'  | 'Lunch'                 | 'Company Lunch'            | 'Sales invoice 2 900*'     | 'TRY'                  |
		| ''                                              | ''                    | ''                    | ''                    | ''                        | ''                                              | ''               | ''              | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''             | ''                        | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''                                              | ''         | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'       | 'Company'                 | 'Legal name'                                    | 'Currency' | ''              | ''                      | ''                         | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '1 000'        | 'Main Company'            | 'Company Lunch'                                 | 'TRY'      | ''              | ''                      | ''                         | ''                         | ''                     |
		И Я закрыл все окна клиентского приложения

Сценарий: _095005 check the legal name filling if the partner has only one
	* Create a document
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in legal name
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lunch'       |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'Company Lunch'
	* Checking legal name re-filling at partner re-selection.
		И я нажимаю кнопку выбора у поля с именем "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'

Сценарий: _095006 check re-selection of the transaction type in the Credit Debit Note document
	* Create a document
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
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
	* Filling in the basis document for debt write-offs
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита "Partner AR transactions basis document"
		Тогда открылось окно 'Select data type'
		И в таблице "" я перехожу к строке:
			| ''                 |
			| 'Sales invoice' |
		И в таблице "" я выбираю текущую строку
		* Checking the selection of basis documents for the specified partner
			Тогда в таблице "List" количество строк "меньше или равно" 1
			Тогда таблица "List" содержит строки:
			| 'Number' |
			| '2 900'  |
		И в таблице "List" я перехожу к строке:
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
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '12'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '12'
		И я нажимаю на кнопку 'Post'
	* Re-select operatiom type
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда в таблице "Transactions" количество строк "равно" 0
		И Я закрыл все окна клиентского приложения
	* Click cancel when re-selecting the operation type
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
		| 'Partner AR transactions basis document'        | 'Partner' | 'Partner term'             | 'Amount'   | 'Business unit'           | 'Currency' | 'Expense type' |
		| 'Sales invoice 2 900*'                          | 'Lunch'   | 'Basic Partner terms, TRY' | '1 000,00' | 'Distribution department' | 'TRY'      | 'Software'     |
		И из выпадающего списка "Operation type" я выбираю точное значение 'Payable'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Cancel'
		И     таблица "Transactions" содержит строки:
		| 'Partner AR transactions basis document'        | 'Partner' | 'Partner term'             | 'Amount'   | 'Business unit'           | 'Currency' | 'Expense type' |
		| 'Sales invoice 2 900*'                          | 'Lunch'   | 'Basic Partner terms, TRY' | '1 000,00' | 'Distribution department' | 'TRY'      | 'Software'     |
	

Сценарий: _095007 check filling and refilling of the tabular part using the Fill button
	* Create a document
		И я открываю навигационную ссылку 'e1cib/list/Document.CreditDebitNote'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
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
	* Filling in the tabular part
		И в таблице "Transactions" я нажимаю на кнопку 'Fill transactions'
		И     таблица "Transactions" содержит строки:
			| 'Partner AR transactions basis document'      |
			| 'Sales invoice 180*'                          |
			| 'Sales invoice 181*'                          |
			| 'Sales invoice 3*'                            |
	* Re-select partner and check re-filling tabular part
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

