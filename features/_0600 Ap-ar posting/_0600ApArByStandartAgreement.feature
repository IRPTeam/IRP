#language: ru
@tree
@Positive
Функционал: дебиторская/кредиторская задолженность по соглашением с типом Standart

Как Разработчик
Я хочу вести взаиморасчеты по общим соглашениям для всех партнеров


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: _060001 подготовка тестовых данных для проверки взаиморасчетов по стандартным договорам
	* Создание тестового сегмента клиентов Standart
		И я открываю навигационную ссылку 'e1cib/list/Catalog.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Standart'
		И я нажимаю на кнопку 'Save and close'
	* Создание тестового поставщика (Veritas) и клиента (Nicoletta)
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Nicoletta'
		И я изменяю флаг 'Vendor'
		И я изменяю флаг 'Customer'
		И я изменяю флаг 'Shipment confirmations before sales invoice'
		И я изменяю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standart'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Partner segments (create) *' в течение 20 секунд
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
	* Создание тестового соглашения с типом Standart
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'Kind' на 'Standard'
		И в поле 'ENG' я ввожу текст 'Standart'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' |
			| 'TRY'      |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.12.2019'
		И я нажимаю на кнопку 'Save and close'
	* Создание индивидуального соглашения для поставщика с типом взаиморасчетов Standart 
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Posting by standart agreement (Veritas)'
		И я меняю значение переключателя 'Type' на 'Vendor'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я меняю значение переключателя 'AP-AR posting detail' на 'By standard agreement'
		И я нажимаю кнопку выбора у поля "Currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' |
			| 'TRY'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Standard agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standart'    |
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
	* Создание типового соглашения для клиента с типом взаиморасчетов Standart
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Posting by standart agreement Customer'
		И я меняю значение переключателя 'Type' на 'Customer'
		И в поле 'Date' я ввожу текст '01.12.2019'
		И я меняю значение переключателя 'AP-AR posting detail' на 'By standard agreement'
		И я нажимаю кнопку выбора у поля "Currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' |
			| 'TRY'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Standard agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standart'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Standart'     |
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

Сценарий: _060002 создание Sales invoice с типом взаиморасчетов по стандартным договорам и проверка его проводок
	* Создание Sales invoice №601
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение данных о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'     |
			И в таблице "List" я выбираю текущую строку
		* Изменение номера sales invoice на 601
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '601'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
		* Добавление товара в Sales Invoice
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
		* Проверка заполнения данных в sales invoice
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'Basic Price Types' | 'pcs'  | '*'          | '*'          | '11 000,00'    | 'Store 01' |
			И я нажимаю на кнопку 'Post and close'
	* Проверка проводок SalesInvoice по регистру PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Agreement' | 'Partner'   | 'Currency movement type'   |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standart'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'en descriptions is empty' |
	И Я закрыл все окна клиентского приложения

Сценарий: _060003 создание Cash reciept с типом взаиморасчетов по стандартным договорам и проверка его проводок
	* Создание Cash reciept №601
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Выбор компании
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Заполнение реквизитов документа
			И я нажимаю кнопку выбора у поля "Cash account"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №2' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' |
				| 'TRY'  |
			И в таблице "List" я выбираю текущую строку
		* Заполнение табличной части о платеже
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле "Agreement"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                            |
				| 'Posting by standart agreement Customer' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '11 000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		* Изменение номера документа на 601
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
		И я нажимаю на кнопку 'Post and close'
	* Проверка проводок документа по регистру PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Amount'    | 'Agreement' | 'Partner'   | 'Currency movement type'   |
		| 'TRY'      | 'Cash receipt 601*' | 'Company Nicoletta' | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения

Сценарий: _060004 проверка зачета аванса по Sales invoice с типом взаиморасчетов по стандартным договорам и проверка его проводок
	* Создание Bank reciept №602
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Выбор компании
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Заполнение реквизитов документа
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение табличной части о платеже
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
			И я нажимаю кнопку очистить у поля "Agreement"
			И в таблице "PaymentList" я завершаю редактирование строки
		* Изменение номера документа на 602
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
		И я нажимаю на кнопку 'Post and close'
	* Проверка проводок документа Bank Receipt по регистру AdvanceFromCustomers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceFromCustomers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Receipt document'  | 'Partner'   | 'Currency movement type'   | 'Amount'    |
		| 'TRY'      | 'Bank receipt 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'en descriptions is empty' | '12 000,00' |
		И Я закрыл все окна клиентского приложения
	* Создание Sales invoice с типом взаиморасчетов по стандартным договорам
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение данных о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'     |
			И в таблице "List" я выбираю текущую строку
		* Изменение номера sales invoice на 602
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '602'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
		* Добавление товара в Sales Invoice
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
	* Проверка проводок SalesInvoice по регистру PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerArTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Agreement' | 'Partner'   | 'Currency movement type'   |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standart'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standart'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'en descriptions is empty' |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Nicoletta' | 'en descriptions is empty' |
	* Проверка проводок SalesInvoice по регистру AdvanceFromCustomers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceFromCustomers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Company'      | 'Receipt document'  | 'Partner'   | 'Currency movement type'   | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'Local currency'           | '11 000,00' | 'No'                   |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'Reporting currency'       | '1 883,56'  | 'No'                   |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'en descriptions is empty' | '11 000,00' | 'No'                   |

Сценарий: _060005 создание Purchase invoice с типом взаиморасчетов по стандартным договорам и проверка его проводок
	* Создание PurchaseInvoice №601
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение данных о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'     |
			И в таблице "List" я выбираю текущую строку
		* Изменение номера purchase invoice на 601
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '601'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
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
		* Проверка заполнения данных в purchase invoice
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'en descriptions is empty' | 'pcs'  | '1 677,97'   | '9 322,03'   | '11 000,00'    | 'Store 01' |
			И я нажимаю на кнопку 'Post'
	* Проверка проводок PurchaseInvoice по регистру PartnerApTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerApTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Agreement' | 'Partner' | 'Currency movement type'   |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Veritas' | 'TRY'                      |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Veritas' | 'Local currency'           |
		| 'USD'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standart'  | 'Veritas' | 'Reporting currency'       |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Veritas' | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения
	
Сценарий: _060006 создание Cash payment с типом взаиморасчетов по стандартным договорам и проверка его проводок
	* Создание Cash payment №601
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Выбор компании
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Заполнение реквизитов документа
			И я нажимаю кнопку выбора у поля "Cash account"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Cash desk №2' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' |
				| 'TRY'  |
			И в таблице "List" я выбираю текущую строку
		* Заполнение табличной части о платеже
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле "Agreement"
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Agreement"
			И в таблице "List" я перехожу к строке:
				| 'Description'                            |
				| 'Posting by standart agreement (Veritas)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '11 000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		* Изменение номера документа на 601
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '601'
		И я нажимаю на кнопку 'Post and close'
	* Проверка проводок документа по регистру PartnerArTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerApTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Amount'    | 'Agreement' | 'Partner'   | 'Currency movement type'   |
		| 'TRY'      | 'Cash payment 601*' | 'Company Veritas'   | 'Main Company' | '11 000,00' | 'Standart'  | 'Veritas'   | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения

Сценарий: _060007 проверка зачета аванса по Purchase invoice с типом взаиморасчетов по стандартным договорам и проверка его проводок
	* Создание Bank payment №602
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Выбор компании
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Заполнение реквизитов документа
			И я нажимаю кнопку выбора у поля "Account"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Bank account, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Заполнение табличной части о платеже
			И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
			И в таблице "PaymentList" я нажимаю кнопку выбора у реквизита "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку очистить у поля "Agreement"
			И в таблице "PaymentList" я активизирую поле с именем "PaymentListAmount"
			И в таблице "PaymentList" в поле с именем 'PaymentListAmount' я ввожу текст '12 000,00'
			И в таблице "PaymentList" я завершаю редактирование строки
		* Изменение номера документа на 602
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
		И я нажимаю на кнопку 'Post and close'
	* Проверка проводок документа Bank Payment по регистру AdvanceToSuppliers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceToSuppliers'
		Тогда таблица "List" содержит строки:
			| 'Currency' | 'Recorder'          | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'  | 'Currency movement type'   | 'Amount'    | 'Deferred calculation' |
			| 'TRY'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Local currency'           | '12 000,00' | 'No'                   |
			| 'USD'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Reporting currency'       | '2 054,79'  | 'No'                   |
			| 'TRY'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'en descriptions is empty' | '12 000,00' | 'No'                   |
		И Я закрыл все окна клиентского приложения
	* Создание PurchaseInvoice №602
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение данных о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Veritas'     |
			И в таблице "List" я выбираю текущую строку
		* Изменение номера purchase invoice на 602
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '602'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '602'
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
			И я нажимаю на кнопку 'Post'
	* Проверка проводок PurchaseInvoice по регистру PartnerApTransactions
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerApTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Agreement' | 'Partner' | 'Currency movement type'   |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Veritas' | 'TRY'                      |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Veritas' | 'Local currency'           |
		| 'USD'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standart'  | 'Veritas' | 'Reporting currency'       |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standart'  | 'Veritas' | 'en descriptions is empty' |
		И Я закрыл все окна клиентского приложения
	* Проверка проводок PurchaseInvoice по регистру AdvanceFromCustomers
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.AdvanceToSuppliers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'  | 'Currency movement type'   | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Local currency'           | '11 000,00' | 'No'                   |
		| 'USD'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Reporting currency'       | '1 883,56'  | 'No'                   |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'en descriptions is empty' | '11 000,00' | 'No'                   |

