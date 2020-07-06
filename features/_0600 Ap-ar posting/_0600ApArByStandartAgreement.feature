#language: ru
@tree
@Positive
Функционал: accounting of receivables / payables under Standard type Partner terms

As an accountant
I want to settle general Partner terms for all partners.


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: _060001 preparation
	* Create a test segment of Standard clients
		И я открываю навигационную ссылку 'e1cib/list/Catalog.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Standard'
		И я нажимаю на кнопку 'Save and close'
	* Create vendor (Veritas) and client (Nicoletta)
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Nicoletta'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Customer'
		И я изменяю флаг 'Shipment confirmations before sales invoice'
		И я изменяю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments content'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standard'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Partner segments content (create) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Company Nicoletta'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Veritas'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Shipment confirmations before sales invoice'
		И я изменяю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Company Veritas '
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Turkey'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
	* Create Partner term Standard
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'Kind' на 'Standard'
		И в поле 'ENG' я ввожу текст 'Standard'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' |
			| 'TRY'      |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.12.2019'
		И я нажимаю на кнопку 'Save and close'
	* Create an individual Partner term for the vendor with the type of settlements Standard 
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Posting by Standard Partner term (Veritas)'
		И я меняю значение переключателя 'Type' на 'Vendor'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By standard Partner term'
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' |
			| 'TRY'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Standard Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standard'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Veritas'     |
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
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я нажимаю на кнопку 'Save and close'
	* Create an individual Partner term for the customer with the type of settlements Standard
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Posting by Standard Partner term Customer'
		И я меняю значение переключателя 'Type' на 'Customer'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By standard Partner term'
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' |
			| 'TRY'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Standard Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standard'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standard'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Basic Price Types' |
		И в таблице "List" я выбираю текущую строку
		И я изменяю флаг 'Price include tax'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _060002 create Sales invoice with the type of settlements under standard Partner terms and check its movements
	* Create Sales invoice №601
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'     |
			И в таблице "List" я выбираю текущую строку
		* Change the sales invoice number to 601
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '601'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
		* Adding items to Sales Invoice
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
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
			И я нажимаю на кнопку 'Post'
		* Check filling in sales invoice
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'Basic Price Types' | 'pcs'  | '*'          | '*'          | '11 000,00'    | 'Store 01' |
			И я нажимаю на кнопку 'Post and close'
	* Check movements Sales Invoice by register PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
	И Я закрыл все окна клиентского приложения

Сценарий: _060003 create Cash reciept with the type of settlements under standard Partner terms and check its movements
	* Create Cash reciept №601
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Select company
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Filling in the details of the document
			И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №2' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' |
				| 'TRY'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле "Partner term"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                            |
				| 'Posting by Standard Partner term Customer' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '11 000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 601
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
		И я нажимаю на кнопку 'Post and close'
	* Check movements by register PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Cash receipt 601*' | 'Company Nicoletta' | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения

Сценарий: _060004 check the offset of the advance for Sales invoice with the type of settlement under standard Partner terms and check its movements
	* Create Bank reciept №602
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Select company
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Filling in the details of the document
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '12 000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
			И в таблице "PaymentList" я выбираю текущую строку
			И я нажимаю кнопку очистить у поля "Partner term"
			И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 602
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
		И я нажимаю на кнопку 'Post and close'
	* Check movements Bank Receipt by register AdvanceFromCustomers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceFromCustomers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Receipt document'  | 'Partner'   | 'Multi currency movement type'   | 'Amount'    |
		| 'TRY'      | 'Bank receipt 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'en descriptions is empty' | '12 000,00' |
		И Я закрыл все окна клиентского приложения
	* Create Sales invoice with the type of settlements under standard Partner terms
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'     |
			И в таблице "List" я выбираю текущую строку
		* Change the sales invoice number to 602
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '602'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
		* Adding items to Sales Invoice
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
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
			И я нажимаю на кнопку 'Post and close'
	* Check movements SalesInvoice by register PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
	* Check movements SalesInvoice by register AdvanceFromCustomers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceFromCustomers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Company'      | 'Receipt document'  | 'Partner'   | 'Multi currency movement type'   | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'Local currency'           | '11 000,00' | 'No'                   |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'Reporting currency'       | '1 883,56'  | 'No'                   |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'en descriptions is empty' | '11 000,00' | 'No'                   |

Сценарий: _060005 create Purchase invoice with the type of settlements under standard contracts and check its postings
	* Create Purchase invoice №601
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'     |
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 601
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '601'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
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
		* Check filling in purchase invoice
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'en descriptions is empty' | 'pcs'  | '1 677,97'   | '9 322,03'   | '11 000,00'    | 'Store 01' |
			И я нажимаю на кнопку 'Post'
	* Check movements Purchase Invoice by register PartnerApTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerApTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner' | 'Multi currency movement type'   |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'TRY'                      |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'Local currency'           |
		| 'USD'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Veritas' | 'Reporting currency'       |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения
	
Сценарий: _060006 create Cash payment with the type of settlements under standard contracts and check its postings
	* Create Cash payment №601
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Select company
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Filling in the details of the document
			И я нажимаю кнопку выбора у поля "Cash/Bank accounts"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №2' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' |
				| 'TRY'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле "Partner term"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                            |
				| 'Posting by Standard Partner term (Veritas)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '11 000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 601
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
		И я нажимаю на кнопку 'Post and close'
	* Check movements документа by register PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerApTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Cash payment 601*' | 'Company Veritas'   | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas'   | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения

Сценарий: _060007 check the offset of Purchase invoice advance with the type of settlement under standard contracts and check its movements
	* Create Bank payment №602
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Select company
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Filling in the details of the document
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку очистить у поля "Partner term"
			И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '12 000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		* Change the document number to 602
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
		И я нажимаю на кнопку 'Post and close'
	* Check movements Bank Payment by register AdvanceToSuppliers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceToSuppliers'
		Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'          | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'  | 'Multi currency movement type'   | 'Amount'    | 'Deferred calculation' |
			| 'TRY'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Local currency'           | '12 000,00' | 'No'                   |
			| 'USD'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Reporting currency'       | '2 054,79'  | 'No'                   |
			| 'TRY'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'en descriptions is empty' | '12 000,00' | 'No'                   |
		И Я закрыл все окна клиентского приложения
	* Create Purchase Invoice №602
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'     |
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 602
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '602'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
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
			И я нажимаю на кнопку 'Post'
	* Check movements PurchaseInvoice by register PartnerApTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerApTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner' | 'Multi currency movement type'   |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'TRY'                      |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'Local currency'           |
		| 'USD'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Veritas' | 'Reporting currency'       |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения
	* Check movements Purchase Invoice by register AdvanceFromCustomers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceToSuppliers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'  | 'Multi currency movement type'   | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Local currency'           | '11 000,00' | 'No'                   |
		| 'USD'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Reporting currency'       | '1 883,56'  | 'No'                   |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'en descriptions is empty' | '11 000,00' | 'No'                   |

