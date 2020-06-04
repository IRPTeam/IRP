#language: ru
@tree
@Positive
Функционал: проведение входящих услуг

Как Разработчик
Я хочу добавить функционал по услугам
Для проведения входящих услуг по учёту

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _029101 создание вида номенклатуры для услуги (не делает движения по складу)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в поле 'ENG' я ввожу текст 'Service'
	И я нажимаю на кнопку открытия поля "ENG"
	И в поле 'TR' я ввожу текст 'Service TR'
	И я нажимаю на кнопку 'Ok'
	И я меняю значение переключателя 'Type' на 'Service'
	И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
	И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
	И я нажимаю на кнопку с именем 'FormCreate'
	И в поле 'ENG' я ввожу текст 'Service type'
	И я нажимаю на кнопку открытия поля "ENG"
	И в поле 'TR' я ввожу текст 'Service type TR'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save and close'
	И в таблице "List" я перехожу к строке:
		| Description  |
		| Service type |
	И я нажимаю на кнопку с именем 'FormChoose'
	И в таблице "AvailableAttributes" я завершаю редактирование строки
	И я нажимаю на кнопку 'Save and close'
	И Пауза 2
	Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_en" "Service"

Сценарий: _029102 создание Item на услугу
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в поле 'ENG' я ввожу текст 'Service'
	И я нажимаю на кнопку открытия поля "ENG"
	И в поле 'TR' я ввожу текст 'Service TR'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю кнопку выбора у поля "Item type"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Service     |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Unit"
	И в таблице "List" я перехожу к строке:
		| Description |
		| pcs         |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку 'Save'
	И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
	И я добавляю item key для услуги интернета
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Service type"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Interner'
		И я нажимаю на кнопку открытия поля "ENG"
		И в поле 'TR' я ввожу текст 'Interner TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
	И я добавляю item key для услуги аренды
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Service type"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Rent'
		И я нажимаю на кнопку открытия поля "ENG"
		И в поле 'TR' я ввожу текст 'Rent TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
	И Я закрыл все окна клиентского приложения
	

Сценарий: _029103 проведение Purchase Order на услугу
	И я открываю форму для создания Purchase Order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю необходимые реквизиты
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	И я заполняю информацию о поставщике
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| Description        |
			| Vendor Ferron, TRY |
		И в таблице "List" я выбираю текущую строку
	И я устанавливаю номер документа 123
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '123'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '123'
	И я заполняю товарную часть
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Service     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я активизирую поле "Business unit"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Expense type"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Telephone communications' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '1000,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'


Сценарий: _029104 проведение Purchase Invoice на услугу на основании Purchase Order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '123'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	И я проверяю заполнение табличной части
		Тогда таблица "ItemList" содержит строки:
		| 'Price'    | 'Item'    | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Expense type'             | 'Business unit' | 'Purchase order'      |
		| '1 000,00' | 'Service' | '18%' | 'Interner' | '1,000' | '152,54'     | 'pcs'  | '847,46'     | '1 000,00'     | 'Telephone communications' | 'Front office'  | 'Purchase order 123*' |
	И я устанавливаю номер документа 123
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '123'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '123'
	И я нажимаю на кнопку 'Post'
	И я проверяю движения документа
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PurchaseTurnovers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Quantity' | 'Recorder'              | 'Row key'                     | 'Company'      | 'Purchase invoice'      | 'Item key'  | 'Amount'   |
		| 'TRY'      | '1,000'    | 'Purchase invoice 123*' | '*'                           | 'Main Company' | 'Purchase invoice 123*' | 'Interner'  | '1 000,00' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.ExpensesTurnovers'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Company'      | 'Business unit' | 'Item key' | 'Amount' | 'Expense type'               |
		| 'TRY'      | 'Purchase invoice 123*' | 'Main Company' | 'Front office'  | 'Interner' | '1 000,00' | 'Telephone communications' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.PartnerApTransactions'
		Тогда таблица "List" содержит строки:
		| 'Currency' | 'Recorder'              | 'Legal name'        | 'Basis document'        | 'Company'      | 'Amount' | 'Agreement'          | 'Partner'   |
		| 'TRY'      | 'Purchase invoice 123*' | 'Company Ferron BP' | 'Purchase invoice 123*' | 'Main Company' | '1 000,00' | 'Vendor Ferron, TRY' | 'Ferron BP' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'              | 'Row key'   | 'Order'               | 'Item key' |
		| '1,000'    | 'Purchase invoice 123*' | '*'         | 'Purchase order 123*' | 'Interner' |
		И Я закрыл все окна клиентского приложения
	
	
Сценарий: _029106 создание Purchase invoice на отгрузку товара с ордерного склада и на услугу
		И я создаю Item Router
			И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Router'
			И я нажимаю кнопку выбора у поля "Item type"
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Equipment'
			И я нажимаю на кнопку 'Save and close'
			И я нажимаю на кнопку с именем 'FormChoose'
			И я нажимаю кнопку выбора у поля "Unit"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю на кнопку 'Save and close'
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю необходимые реквизиты
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		И я заполняю информацию о поставщике
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Agreement"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, TRY |
			И в таблице "List" я выбираю текущую строку
		И я устанавливаю номер документа 124
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '124'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '124'
		И я заполняю товарную часть (добавляю услугу и товар)
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Service     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
			И в таблице "ItemList" я активизирую поле "Business unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Expense type"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Expense type"
			И в таблице "List" я перехожу к строке:
			| Description              |
			| Telephone communications |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я активизирую поле "Price"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Router      |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И я нажимаю на кнопку с именем 'FormChoose'
			И в таблице "ItemList" я активизирую поле "Business unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Front office | 
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Expense type"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Expense type"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Software    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я активизирую поле "Price"
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
		И я проверяю проводки документа через отчет
			# временно
			И я перехожу к закладке "Currency"
			И я нажимаю кнопку выбора у поля "Currency"
			И в таблице "List" я перехожу к строке:
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Post'
			# end временно
			И я нажимаю на кнопку 'Registrations report'
			Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Purchase invoice 124*'                 | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Company'       | 'Item key'                 | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '1'             | 'Main Company'  | 'Router'                   | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'        | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'               | ''                      | ''                  | ''                    | ''                         | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'        | 'Net amount'    | 'Company'                  | 'Purchase invoice'      | 'Currency'          | 'Item key'            | 'Row key'                  | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '17,12'         | '14,51'         | 'Main Company'             | 'Purchase invoice 124*' | 'USD'               | 'Interner'            | '*'                        | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '34,25'         | '29,02'         | 'Main Company'             | 'Purchase invoice 124*' | 'USD'               | 'Router'              | '*'                        | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '100'           | '84,75'         | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Interner'            | '*'                        | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '100'           | '84,75'         | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Interner'            | '*'                        | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '100'           | '84,75'         | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Interner'            | '*'                        | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '200'           | '169,49'        | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Router'              | '*'                        | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '200'           | '169,49'        | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Router'              | '*'                        | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | '*'           | '1'         | '200'           | '169,49'        | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Router'              | '*'                        | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Expenses turnovers"'        | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | 'Dimensions'    | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | 'Attributes'               | ''                     | ''                         | ''                     |
		| ''                                      | ''            | 'Amount'    | 'Company'       | 'Business unit' | 'Expense type'             | 'Item key'              | 'Currency'          | 'Additional analytic' | 'Currency movement type'   | 'Deferred calculation'     | ''                     | ''                         | ''                     |
		| ''                                      | '*'           | '17,12'     | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'USD'               | ''                    | 'Reporting currency'       | 'No'                       | ''                     | ''                         | ''                     |
		| ''                                      | '*'           | '100'       | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'TRY'               | ''                    | 'en descriptions is empty' | 'No'                       | ''                     | ''                         | ''                     |
		| ''                                      | '*'           | '100'       | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'TRY'               | ''                    | 'Local currency'           | 'No'                       | ''                     | ''                         | ''                     |
		| ''                                      | '*'           | '100'       | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'TRY'               | ''                    | 'TRY'                      | 'No'                       | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'           | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'               | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'    | 'Manual amount' | 'Net amount'    | 'Document'                 | 'Tax'                   | 'Analytics'         | 'Tax rate'            | 'Include to total amount'  | 'Row key'                  | 'Currency'             | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '2,61'      | '2,61'          | '14,51'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '5,22'      | '5,22'          | '29,02'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '15,25'     | '15,25'         | '84,75'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '15,25'     | '15,25'         | '84,75'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '15,25'     | '15,25'         | '84,75'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                      | '*'           | '30,51'     | '30,51'         | '169,49'        | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
		| ''                                      | '*'           | '30,51'     | '30,51'         | '169,49'        | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '30,51'     | '30,51'         | '169,49'        | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods in transit incoming"' | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Store'         | 'Receipt basis'            | 'Item key'              | 'Row key'           | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '1'             | 'Store 02'      | 'Purchase invoice 124*'    | 'Router'                | '*'                 | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''          | ''                    | ''               | ''                                               | ''                                               | ''                                     | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'           | ''               | ''                                               | ''                                               | 'Dimensions'                           | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Advance to supliers' | 'Transaction AP' | 'Advance from customers'                         | 'Transaction AR'                                 | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                                 | 'Currency'             | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | ''                    | '300'            | ''                                               | ''                                               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | 'Purchase invoice 124*' | 'TRY'                  | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''                    | ''               | ''                                               | ''                                               | ''                                     | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'        | 'Company'       | 'Legal name'               | 'Currency'              | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '300'           | 'Main Company'  | 'Company Ferron BP'        | 'TRY'                   | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'    | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | 'Attributes'               | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'      | 'Company'       | 'Order'                    | 'Store'                 | 'Item key'          | 'Row key'             | 'Delivery date'            | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '1'             | 'Main Company'  | 'Purchase invoice 124*'    | ''                      | 'Interner'          | '*'                   | '*'                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '1'             | 'Main Company'  | 'Purchase invoice 124*'    | 'Store 02'              | 'Router'            | '*'                   | '*'                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '1'             | 'Main Company'  | 'Purchase invoice 124*'    | ''                      | 'Interner'          | '*'                   | '*'                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'   | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'        | 'Company'       | 'Basis document'           | 'Partner'               | 'Legal name'        | 'Agreement'           | 'Currency'                 | 'Currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '51,37'         | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'USD'                      | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '300'           | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                      | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '300'           | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                      | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '300'           | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                      | 'TRY'                      | 'No'                   | ''                         | ''                     |

		И Я закрыл все окна клиентского приложения

# Сценарий: создание Purchase order - Goods reciept - Purchase invoice c услугой и товаром по непрямой схеме отгрузки

Сценарий: _029107 создание Sales order услуга + товар с неордерного склада и проверка проводок (прямая схема отгрузки)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда заполняю данные о клиенте в заказе (Ferron BP, склад 01)
	И я добавляю товар
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Service     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item    | Item key |
			| Service | Rent     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	Тогда я меняю номер документа и провожу его
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '700'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю движения документа
		# временно
		И я перехожу к закладке "Currency"
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		# end временно
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 700*'                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '17,12'     | 'Main Company' | 'Sales order 700*' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | 'Sales order 700*' | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | 'Sales order 700*' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | 'Sales order 700*' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 198,63'  | 'Main Company' | 'Sales order 700*' | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | 'Sales order 700*' | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | 'Sales order 700*' | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | 'Sales order 700*' | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'     | 'Sales order 700*' | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | 'Sales order 700*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 700*' | 'Store 01' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 700*' | 'Store 01' | '37/18SD'  | '*'       | '*'                        | ''                     |



Сценарий: _029108 создание Sales order услуга + товар с ордерного склада и проверка проводок (прямая схема отгрузки)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о клиенте
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Agreements, without VAT' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Company Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
	И я добавляю товар
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Service     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item    | Item key |
			| Service | Rent     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	Тогда я меняю номер документа и провожу его
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '701'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю движения документа
		# временно
		И я перехожу к закладке "Currency"
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		# end временно
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 701*'                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '20,21'     | 'Main Company' | 'Sales order 701*' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 701*' | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 701*' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 701*' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 309,62'  | 'Main Company' | 'Sales order 701*' | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 701*' | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 701*' | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 701*' | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 02'     | 'Sales order 701*' | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 701*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 701*' | 'Store 02' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 701*' | 'Store 02' | '37/18SD'  | '*'       | '*'                        | ''                     |




Сценарий: _029109 создание Sales order услуга + товар с неордерного склада и проверка проводок (непрямая схема отгрузки)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда заполняю данные о клиенте в заказе (Ferron BP, склад 01)
	И я добавляю товар
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Service     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item    | Item key |
			| Service | Rent     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	Тогда я меняю номер документа и провожу его
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Shipment confirmations before sales invoice'
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '702'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю движения документа
		# временно
		И я перехожу к закладке "Currency"
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		# end временно
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 702*'                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'          | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Main Company'     | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'         | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'         | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment orders"'                | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Order'            | 'Shipment confirmation' | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Sales order 702*' | 'Sales order 702*'      | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'          | 'Sales order'           | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '17,12'     | 'Main Company'     | 'Sales order 702*'      | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 198,63'  | 'Main Company'     | 'Sales order 702*'      | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Order'                 | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'         | 'Sales order 702*'      | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'         | 'Sales order 702*'      | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'         | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'          | 'Order'                 | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company'     | 'Sales order 702*'      | 'Store 01' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company'     | 'Sales order 702*'      | 'Store 01' | '37/18SD'  | '*'       | '*'                        | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Main Company'     | 'Sales order 702*'      | 'Store 01' | '37/18SD'  | '*'       | '*'                        | ''                     |





Сценарий: _029110 создание Sales order услуга + товар с ордерного склада и проверка проводок (непрямая схема отгрузки)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я заполняю данные о клиенте
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Agreements, without VAT' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Company Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
	И я добавляю товар
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Service     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item    | Item key |
			| Service | Rent     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	Тогда я меняю номер документа и провожу его
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку 'OK'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Shipment confirmations before sales invoice'
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '703'
		И я нажимаю на кнопку 'Post'
	Тогда я проверяю движения документа
		# временно
		И я перехожу к закладке "Currency"
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		# end временно
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Sales order 703*'                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 703*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency' | 'Item key' | 'Row key' | 'Currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '20,21'     | 'Main Company' | 'Sales order 703*' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 703*' | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 703*' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 703*' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 309,62'  | 'Main Company' | 'Sales order 703*' | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 703*' | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 703*' | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 703*' | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 02'     | 'Sales order 703*' | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 703*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 703*' | 'Store 02' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 703*' | 'Store 02' | '37/18SD'  | '*'       | '*'                        | ''                     |
















