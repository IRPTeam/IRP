#language: ru
@tree
@Positive


Функционал: создание based on по цепочке документов продажи

# Sales order - Sales invoice - Shipment confirmation - Bank reciept/Cash reciept

Как разработчик
Я хочу создать систему создания based on
Для удобства заполнения документов


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# Прямая схема поставки вначале инвойс, потом ордер


Сценарий: _090401 create Sales invoice по нескольким Sales order с разными контрагентами
# должно создаться 2 Sales invoice
	И я создаю тестовый Sales order 324
		Когда create the first test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 324
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '324'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '324'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю Sales order 325
		Когда create the second test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 325
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '325'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '325'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю based on Sales order 324 и 325 Sales invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 324    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Second Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Sales order'      |
			| 'Dress' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | 'Sales order 325*' |
		И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Change the document number to 325
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '325'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '325'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
		И Пауза 2
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И Пауза 5
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'  | 'Store'    | 'Sales order'      | 'Unit' | 'Q'      |
			| 'Dress'    | 'M/White'   | 'Store 02' | 'Sales order 324*' | 'pcs'  | '20,000' |
			| 'Dress'    | 'L/Green'   | 'Store 02' | 'Sales order 324*' | 'pcs'  | '20,000' |
			| 'Trousers' | '36/Yellow' | 'Store 02' | 'Sales order 324*' | 'pcs'  | '30,000' |
		* Change the document number to 324
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '324'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '324'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения

Сценарий: _090402 create Sales invoice по нескольким Sales order с одинаковым партнером, контрагентом, соглашением, валютой и складом
# Должен создаться 1 Sales invoice
	И я создаю тестовый Sales order 326
		Когда create the first test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 326
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '326'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '326'
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю тестовый Sales order 327
		Когда create the second test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 327
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '327'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '327'
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю based on Sales order 326 и 327 Sales invoice (должен создаться 1)
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 326    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'  | 'Store'    | 'Sales order'      | 'Unit' | 'Q'      |
			| 'Dress'    | 'M/White'   | 'Store 02' | 'Sales order 327*' | 'pcs'  | '10,000' |
			| 'Dress'    | 'M/White'   | 'Store 02' | 'Sales order 326*' | 'pcs'  | '20,000' |
			| 'Dress'    | 'L/Green'   | 'Store 02' | 'Sales order 326*' | 'pcs'  | '20,000' |
			| 'Trousers' | '36/Yellow' | 'Store 02' | 'Sales order 326*' | 'pcs'  | '30,000' |
		* Change the document number to 327
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '327'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '327'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения
	
Сценарий: _090403 create Sales invoice по нескольким Sales order с разными партнерами одного контрагента (соглашения одинаковые)
# Должно создаться 2 Sales invoice
	И я добавляю Partner Ferron 1 и Partner Ferron 2 в сегмент Retail
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Retail      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Partner Ferron 2 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Retail      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Partner Ferron 1 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	И я создаю первый тестовый SO 328
		Когда create the first test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 328
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '328'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '328'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 1   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю второй тестовый SO 329
		Когда create the second test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 329
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '329'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '329'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 2   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю based on Sales order 328 и 329 Sales invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 328    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 2'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Store'    | 'Unit' | 'Q'     | 'Sales order'      |
			| 'Dress'| 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | 'Sales order 329*' |
		И     элемент формы с именем "PriceIncludeTax" стал равен 'Yes'
		* Change the document number to 329
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '329'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '329'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
		И Пауза 2
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И Пауза 5
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'  | 'Store'    | 'Sales order'      | 'Unit' | 'Q'      |
			| 'Dress'    | 'M/White'   | 'Store 02' | 'Sales order 328*' | 'pcs'  | '20,000' |
			| 'Dress'    | 'L/Green'   | 'Store 02' | 'Sales order 328*' | 'pcs'  | '20,000' |
			| 'Trousers' | '36/Yellow' | 'Store 02' | 'Sales order 328*' | 'pcs'  | '30,000' |
		* Change the document number to 329
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '328'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '328'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения


Сценарий: _090404 create Sales invoice по нескольким Sales order с разными соглашениями (цена с НДС и цена без НДС)
# Должно создаться 2 Sales invoice
	И я создаю первый тестовый SO 330
		Когда create the first test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 330
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '330'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '330'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 1   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю второй тестовый SO 331 Partner Ferron 1 и ставлю соглашение Vendor Ferron Discount
		Когда create the second test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 331
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '331'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '331'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 1   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, without VAT |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю based on Sales order 330 и 331 Sales invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 330    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, without VAT'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'      | 'Unit' | 'Store'    | 'Delivery date' | 'Sales order'      |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'  | 'Store 02' | '*'             | 'Sales order 331*' |
		И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
		* Change the document number to 331
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '331'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '331'
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
		И Пауза 2
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И Пауза 5
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Delivery date' | 'Sales order'       |
			| 'Trousers' | '36/Yellow' | '30,000' | 'pcs'  | 'Store 02' | '*'             | 'Sales order 330*'  |
			| 'Dress'    | 'M/White'   | '20,000' | 'pcs'  | 'Store 02' | '*'             | 'Sales order 330*'  |
			| 'Dress'    | 'L/Green'   | '20,000' | 'pcs'  | 'Store 02' | '*'             | 'Sales order 330*'  |
		* Change the document number to 330
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '330'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '330'
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения


Сценарий: _090405 create Sales invoice по нескольким Sales order с разными складами (создается один)
# Создается один SI
	И я создаю первый тестовый PO 334
		Когда create the first test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 334
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '334'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '334'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 1   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю второй тестовый SO 335
		Когда create the second test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 335
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '335'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '335'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 1   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 03  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
		# temporarily
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
		# endвременно
		И я нажимаю на кнопку 'Post and close'
	И я создаю based on Sales order 335 и 334 Sales invoice (должен создаться 1)
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 334    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Delivery date'| 'Sales order'      |
			| 'Dress'    | 'L/Green'   | '20,000' | 'pcs'  | 'Store 02' | '*'            | 'Sales order 334*' |
			| 'Trousers' | '36/Yellow' | '30,000' | 'pcs'  | 'Store 02' | '*'            | 'Sales order 334*' |
			| 'Dress'    | 'M/White'   | '20,000' | 'pcs'  | 'Store 02' | '*'            | 'Sales order 334*' |
			| 'Dress'    | 'M/White'   | '10,000' | 'pcs'  | 'Store 03' | '*'            | 'Sales order 335*' |
		* Change the document number to 335
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '335'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '335'
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения

	
Сценарий: _090406 create Sales invoice по нескольким Sales order с разными собственными компаниями
	И я создаю первый тестовый SO 336
		Когда create the first test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 336
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '336'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '336'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 1   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Company"
			Тогда открылось окно 'Companies'
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Second Company |
			И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post and close'
	И я создаю второй тестовый SO 337
		Когда create the second test SO for a test on the creation mechanism based on
		И я устанавливаю номер документа 337
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '337'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '337'
		И я заполняю информацию о клиенте
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 1   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Basic Partner terms, TRY |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post and close'
	И я создаю based on Sales order 336 и 337 Sales invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 336    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'      | 'Unit' | 'Store'    | 'Sales order'      |
			| 'Dress' | 'M/White'  | '10,000' | 'pcs'  | 'Store 02' | 'Sales order 337*' |
		* Change the document number to 337
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '337'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '337'
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
		И Пауза 2
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Second Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И Пауза 5
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Sales order'      |
			| 'Dress'    | 'M/White'   | '20,000' | 'pcs'  | 'Store 02' | 'Sales order 336*' |
			| 'Dress'    | 'L/Green'   | '20,000' | 'pcs'  | 'Store 02' | 'Sales order 336*' |
			| 'Trousers' | '36/Yellow' | '30,000' | 'pcs'  | 'Store 02' | 'Sales order 336*' |
		* Change the document number to 136
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '336'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '336'
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения

Сценарий: _090407 create Shipment confirmation по нескольким Sales order с разными procurement method (товары и услуги)
	* Создание первого тестового SO №800
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение реквизитов
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Ferron BP' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part по товарам
			* Добавление услуги
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Service'     |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
				И в таблице "List" я перехожу к строке:
					| 'Item'    | 'Item key' |
					| 'Service' | 'Rent'     |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Procurement method"
				И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
				И я перехожу к следующему реквизиту
				И в таблице "ItemList" я активизирую поле "Price"
				И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			* Добавление товара который не будет отгружаться
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Trousers'    |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
				И в таблице "List" я перехожу к строке:
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Procurement method"
				И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Repeal'
				И я перехожу к следующему реквизиту
				И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
				И в таблице "ItemList" я завершаю редактирование строки
			* Добавление товара с методом обеспечения под закупку
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Shirt'       |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
				И в таблице "List" я перехожу к строке:
					| 'Item'  | 'Item key' |
					| 'Shirt' | '38/Black' |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Procurement method"
				И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
				И я перехожу к следующему реквизиту
				И в таблице "ItemList" я завершаю редактирование строки
			* Добавление товара с методом обеспечения со склада
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Trousers'    |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
				И в таблице "List" я перехожу к строке:
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Procurement method"
				И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
				И я перехожу к следующему реквизиту
				И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
				И в таблице "ItemList" я завершаю редактирование строки
			* Установка галочки Shipment confirmation before Sales invoice и проведение заказа
				И я перехожу к закладке "Other"
				И я устанавливаю флаг 'Shipment confirmations before sales invoice'
				* Change the document number
					И в поле 'Number' я ввожу текст '800'
					Тогда открылось окно '1C:Enterprise'
					И я нажимаю на кнопку 'Yes'
					И в поле 'Number' я ввожу текст '800'
				И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового SO №801
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение реквизитов
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Company Ferron BP' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part по товарам
			* Добавление товара который не будет отгружаться
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Trousers'    |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
				И в таблице "List" я перехожу к строке:
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Procurement method"
				И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Repeal'
				И я перехожу к следующему реквизиту
				И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
				И в таблице "ItemList" я завершаю редактирование строки
			* Добавление товара с методом обеспечения со склада
				И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Trousers'    |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
				И в таблице "List" я перехожу к строке:
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Procurement method"
				И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
				И я перехожу к следующему реквизиту
				И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
				И в таблице "ItemList" я завершаю редактирование строки
			* Установка галочки Shipment confirmation before Sales invoice и проведение заказа
				И я перехожу к закладке "Other"
				И я устанавливаю флаг 'Shipment confirmations before sales invoice'
				* Change the document number
					И в поле 'Number' я ввожу текст '801'
					Тогда открылось окно '1C:Enterprise'
					И я нажимаю на кнопку 'Yes'
					И в поле 'Number' я ввожу текст '801'
				И я нажимаю на кнопку 'Post and close'
	* Создание Sales invoice based on SO №800 и SO №801 (должна попасть только услуга)
		И в таблице "List" я перехожу к строке:
			| Number |
			| 800    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		* Check filling inтабличной части
			И     таблица "ItemList" содержит строки:
			| 'Item'    | 'Item key' | 'Q'     |
			| 'Service' | 'Rent'     | '1,000' |
			Тогда в таблице "ItemList" количество строк "меньше или равно" 1
			И я закрываю текущее окно
	* Создание Shipment confirmation based on SO №800 и SO №801 (должно попасть 2 строки по товарам из двух заказов)
		И в таблице "List" я перехожу к строке:
			| Number |
			| 800    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
		* Check filling inреквизитов
			И     элемент формы с именем "Company" стал равен 'Main Company'
			И     элемент формы с именем "Partner" стал равен 'Ferron BP'
			И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
			И     элемент формы с именем "Store" стал равен 'Store 02'
		* Check filling inтабличной части
			Тогда в таблице "ItemList" количество строк "меньше или равно" 2
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Shipment basis'   |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 02' | 'Sales order 800*' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | 'Store 02' | 'Sales order 801*' |
		И я закрываю текущее окно
	* Check filling inPurchase order (должна попасть одна строка)
		И в таблице "List" я перехожу к строке:
			| Number |
			| 800    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseOrderGeneratePurchaseOrder'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 1
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Purchase basis'   |
			| 'Shirt' | '38/Black' | '1,000' | 'Sales order 800*' |
		И я закрываю текущее окно
	* Check filling inPurchase invoice (должна попасть одна строка)
		И в таблице "List" я перехожу к строке:
			| Number |
			| 800    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 1
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Sales order'      |
			| 'Shirt' | '38/Black' | '1,000' | 'Sales order 800*' |
		И я закрыл все окна клиентского приложения







# Сценарий: _090407 create Shipment confirmation по Sales invoice с разными контрагентами по прямой схемой отгрузки 
# # Создается два SC
# 	И я создаю Shipment Confirmation к SI 325, 326
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
# 		И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 32    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Shipment Confirmation
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Shipment basis'     |
# 			| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Sales invoice 325*' |
# 	И я устанавливаю номер документа 325
# 		И в поле 'Number' я ввожу текст '325'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '325'
# 	И я нажимаю на кнопку 'Post and close'
# 	Тогда открылось окно 'Shipment confirmation (create)'
# 	И Пауза 2
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 		| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Shipment basis'     |
# 		| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Sales invoice 326*' |
# 		| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Sales invoice 326*' |
# 		| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Sales invoice 326*' |
# 	И я устанавливаю номер документа 326
# 		И в поле 'Number' я ввожу текст '326'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '326'
# 	И я нажимаю на кнопку 'Post and close'
# 	И я проверяю создание документа
# 		Тогда таблица "List" содержит строки:
# 			| 'Number' |
# 			| '325'    |
# 			| '326'    |
# 	И я закрыл все окна клиентского приложения



# Сценарий: create Goods reciept по нескольким Sales invoice с разными партнерами одного контрагента по прямой схемой отгрузки 
# # Создается один SC
# 	И я создаю Goods reciept к SI 128, 129
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
# 		И в таблице "List" я перехожу к строке:
# 				| Number |
# 				| 129    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 		| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'        |
# 		| 'Dress'    | '10,000'   | 'M/White'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 129*' |
# 		| 'Dress'    | '20,000'   | 'M/White'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 128*' |
# 		| 'Dress'    | '20,000'   | 'L/Green'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 128*' |
# 		| 'Trousers' | '30,000'   | '36/Yellow' | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 128*' |
# 	И я устанавливаю номер документа 128
# 		И в поле 'Number' я ввожу текст '128'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '128'
# 	И я нажимаю на кнопку 'Post and close'
# 	И я проверяю создание документа
# 		Тогда таблица "List" содержит строки:
# 			| Number |
# 			| 128    |
# 	И я закрыл все окна клиентского приложения

# Сценарий: create Goods reciept по нескольким Sales invoice с разными соглашениями по прямой схемой отгрузки 
# # Создается один GR
# 	И я создаю Goods reciept к SI 130, 131
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
# 		И в таблице "List" я перехожу к строке:
# 				| Number |
# 				| 131    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 		| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'        |
# 		| 'Dress'    | '10,000'   | 'M/White'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 131*' |
# 		| 'Dress'    | '20,000'   | 'M/White'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 130*' |
# 		| 'Dress'    | '20,000'   | 'L/Green'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 130*' |
# 		| 'Trousers' | '30,000'   | '36/Yellow' | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 130*' |
# 	И я устанавливаю номер документа 130
# 		И в поле 'Number' я ввожу текст '130'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '130'
# 	И я нажимаю на кнопку 'Post and close'
# 	И я проверяю создание документа
# 		Тогда таблица "List" содержит строки:
# 			| Number |
# 			| 130    |
# 	И я закрыл все окна клиентского приложения


# Сценарий: create Goods reciept по нескольким Sales invoice с разными складами по прямой схемой отгрузки (только один склад ордерный)
# # Создается один GR
# 	И я создаю Goods reciept к SI 135
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
# 		И в таблице "List" я перехожу к строке:
# 				| Number |
# 				| 135    |
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 		| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'        |
# 		| 'Dress'    | '10,000'   | 'M/White'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 135*' |
# 		И в поле 'Number' я ввожу текст '135'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '135'
# 	И я нажимаю на кнопку 'Post and close'
# 	И я проверяю создание документа
# 		Тогда таблица "List" содержит строки:
# 			| Number |
# 			| 135    |
# 	И я закрыл все окна клиентского приложения


# Сценарий: create Goods reciept по нескольким Sales order с разными собственными компаниями по прямой схеме отгрузки 
# # Создается два GR
# 	И я создаю Goods reciept к SI 137, 136
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
# 		И в таблице "List" я перехожу к строке:
# 				| Number |
# 				| 137    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Second Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 		| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'        |
# 		| 'Dress'    | '20,000'   | 'M/White'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 136*' |
# 		| 'Dress'    | '20,000'   | 'L/Green'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 136*' |
# 		| 'Trousers' | '30,000'   | '36/Yellow' | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 136*' |
# 		И в поле 'Number' я ввожу текст '136'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '136'
# 	И я нажимаю на кнопку 'Post and close'
# 	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 		| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'        |
# 		| 'Dress'    | '10,000'   | 'M/White'   | ''                | 'pcs'  | 'Store 02' | 'Sales invoice 137*' |
# 		И в поле 'Number' я ввожу текст '137'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '137'
# 	И я нажимаю на кнопку 'Post and close'
# 	# И я проверяю создание документа
# 	# 	Тогда таблица "List" содержит строки:
# 	# 		| Number |
# 	# 		| 137    |
# 	# И я закрыл все окна клиентского приложения



# # Непрямая схема поставки вначале ордер потом инвойс

# Сценарий: create Goods reciept по Sales order с разными контрагентами по непрямой схеме отгрузки 
# # должно создаться 2 Goods reciept
# 	И я создаю тестовый Sales order 140
# 		Когда create the first test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 140
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '140'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '140'
# 		И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю Sales order 141
# 		Когда create the second test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 141
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '141'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '141'
# 		И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю based on Sales order 140 и 141 Goods reciept (должно создаться 2)
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 		И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 140    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Quantity' | 'Item key' | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'       |
# 			| 'Dress' | '10,000'   | 'M/White'  | ''                  | 'pcs'  | 'Store 02' | 'Sales order 141*' |
# 		И в поле 'Number' я ввожу текст '141'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '141'
# 	И я нажимаю на кнопку 'Post and close'
# 	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'      |
# 			| 'Dress'    | '20,000'   | 'M/White'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 140*' |
# 			| 'Dress'    | '20,000'   | 'L/Green'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 140*' |
# 			| 'Trousers' | '30,000'   | '36/Yellow' | ''                  | 'pcs'  | 'Store 02' | 'Sales order 140*' |
# 		И в поле 'Number' я ввожу текст '140'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '140'
# 	И я нажимаю на кнопку 'Post and close'



# Сценарий: create Goods reciept по нескольким Sales order с разными партнерами одного контрагента по непрямой схемой отгрузки 
# # должно создаться 2 Goods reciept
# 	И я создаю первый тестовый PO 142
# 		Когда create the first test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 142
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '142'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '142'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 1   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron 1 |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 02  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю второй тестовый PO 143
# 		Когда create the second test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 143
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '143'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '143'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 2   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron Partner 2 |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 02  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю based on Sales order 142 и 143 Goods reciept (должно создаться 2)
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 		И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 142    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Quantity' | 'Item key' | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'       |
# 			| 'Dress' | '10,000'   | 'M/White'  | ''                  | 'pcs'  | 'Store 02' | 'Sales order 143*' |
# 		И в поле 'Number' я ввожу текст '143'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '143'
# 	И я нажимаю на кнопку 'Post and close'
# 	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'      |
# 			| 'Dress'    | '20,000'   | 'M/White'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 142*' |
# 			| 'Dress'    | '20,000'   | 'L/Green'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 142*' |
# 			| 'Trousers' | '30,000'   | '36/Yellow' | ''                  | 'pcs'  | 'Store 02' | 'Sales order 142*' |
# 		И в поле 'Number' я ввожу текст '142'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '142'
# 	И я нажимаю на кнопку 'Post and close'

# Сценарий: create Goods reciept по нескольким Sales order с разными соглашениями по непрямой схемой отгрузки 
# # должно создаться 2 Goods reciept
# 	И я создаю первый тестовый PO 144
# 		Когда create the first test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 144
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '144'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '144'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 1   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron 1 |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 02  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю второй тестовый PO 145 Partner Ferron 1 и ставлю соглашение Vendor Ferron Discount
# 		Когда create the second test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 144
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '145'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '145'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 1   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron Discount |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 02  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю based on Sales order 144 и 145 Goods reciept (должно создаться 2)
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 		И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 144    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Quantity' | 'Item key' | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'       |
# 			| 'Dress' | '10,000'   | 'M/White'  | ''                  | 'pcs'  | 'Store 02' | 'Sales order 145*' |
# 		И в поле 'Number' я ввожу текст '145'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '145'
# 	И я нажимаю на кнопку 'Post and close'
# 	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'      |
# 			| 'Dress'    | '20,000'   | 'M/White'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 144*' |
# 			| 'Dress'    | '20,000'   | 'L/Green'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 144*' |
# 			| 'Trousers' | '30,000'   | '36/Yellow' | ''                  | 'pcs'  | 'Store 02' | 'Sales order 144*' |
# 		И в поле 'Number' я ввожу текст '144'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '144'
# 	И я нажимаю на кнопку 'Post and close'
	


# Сценарий: create Goods reciept по нескольким Sales order с разными складами по непрямой схемой отгрузки
# # должно создаться 2 Goods reciept
# 	И я создаю первый тестовый PO 146
# 		Когда create the first test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 146
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '146'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '146'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 1   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron Discount |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 03  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю второй тестовый PO 147
# 		Когда create the second test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 147
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '147'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '147'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 1   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron Discount |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 02  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю based on Sales order 146 и 147 Goods reciept (должно создаться 2)
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 		И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 146    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Quantity' | 'Item key' | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'       |
# 			| 'Dress' | '10,000'   | 'M/White'  | ''                  | 'pcs'  | 'Store 02' | 'Sales order 147*' |
# 		И в поле 'Number' я ввожу текст '147'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '147'
# 	И я нажимаю на кнопку 'Post and close'
# 	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 03'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'      |
# 			| 'Dress'    | '20,000'   | 'M/White'   | ''                  | 'pcs'  | 'Store 03' | 'Sales order 146*' |
# 			| 'Dress'    | '20,000'   | 'L/Green'   | ''                  | 'pcs'  | 'Store 03' | 'Sales order 146*' |
# 			| 'Trousers' | '30,000'   | '36/Yellow' | ''                  | 'pcs'  | 'Store 03' | 'Sales order 146*' |
# 		И в поле 'Number' я ввожу текст '146'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '146'
# 	И я нажимаю на кнопку 'Post and close'

# Сценарий: create Goods reciept по нескольким Sales order с разными собственными компаниями по непрямой схемой отгрузки 
# # должно создаться 2 Goods reciept
# 	И я создаю первый тестовый PO 148
# 		Когда create the first test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 148
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '148'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '148'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 1   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron Discount |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 02  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Company"
# 			Тогда открылось окно 'Companies'
# 			И в таблице "List" я перехожу к строке:
# 				| Description    |
# 				| Second Company |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 	И я создаю второй тестовый PO 149
# 		Когда create the second test SO for a test on the creation mechanism based on
# 		И я устанавливаю номер документа 149
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И в поле 'Number' я ввожу текст '149'
# 			Тогда открылось окно '1C:Enterprise'
# 			И я нажимаю на кнопку 'Yes'
# 			И в поле 'Number' я ввожу текст '149'
# 		И я заполняю информацию о клиенте
# 			И я нажимаю кнопку выбора у поля "Partner"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Partner Ferron 1   |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Legal name"
# 			И в таблице "List" я перехожу к строке:
# 				| Description       |
# 				| Company Ferron BP |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Partner term"
# 			И в таблице "List" я перехожу к строке:
# 				| Description        |
# 				| Vendor Ferron Discount |
# 			И в таблице "List" я выбираю текущую строку
# 			И я нажимаю кнопку выбора у поля "Store"
# 			И в таблице "List" я перехожу к строке:
# 				| Description |
# 				| Store 02  |
# 			И в таблице "List" я выбираю текущую строку
# 			И я перехожу к закладке "Other"
# 			И я разворачиваю группу "More"
# 			И я устанавливаю флаг с именем "ShipmentConfirmationBeforeSalesInvoice"
# 		И я нажимаю на кнопку 'Post and close'
# 		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 		И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 148    |
# 		И В таблице  "List" я перехожу на одну строку вниз с выделением
# 		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Quantity' | 'Item key' | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'       |
# 			| 'Dress' | '10,000'   | 'M/White'  | ''                  | 'pcs'  | 'Store 02' | 'Sales order 149*' |
# 		И в поле 'Number' я ввожу текст '149'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '149'
# 	И я нажимаю на кнопку 'Post and close'
# 	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
# 	И я проверяю заполнение Goods reciept
# 		И     элемент формы с именем "Company" стал равен 'Second Company'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Quantity' | 'Item key'  | 'Item serial/lot number' | 'Unit' | 'Store'    | 'Receipt basis'      |
# 			| 'Dress'    | '20,000'   | 'M/White'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 148*' |
# 			| 'Dress'    | '20,000'   | 'L/Green'   | ''                  | 'pcs'  | 'Store 02' | 'Sales order 148*' |
# 			| 'Trousers' | '30,000'   | '36/Yellow' | ''                  | 'pcs'  | 'Store 02' | 'Sales order 148*' |
# 		И в поле 'Number' я ввожу текст '148'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '148'
# 	И я нажимаю на кнопку 'Post and close'


# Сценарий: create Sales invoice по нескольким Sales order с разными контрагентами по непрямой схеме отгрузки
# # должно создаться 2 Sales invoice
# 	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 	И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 140    |
# 	И В таблице  "List" я перехожу на одну строку вниз с выделением
# 	И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
# 	И я выбираю Goods Receipt по которым необходимо создать Sales invoice
# 		И я нажимаю на кнопку с именем 'FormSelectAll'
# 		И я нажимаю на кнопку 'Ok'
# 	И я проверяю заполнение Sales invoice 140
# 		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Price'  | 'Item key'  |  'Store'    | 'Unit' | 'Q'      | 'Tax amount' | 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'       |
# 			| 'Dress'    | '200,00' | 'M/White'   |  'Store 02' | 'pcs'  | '20,000' | '720,00'     | '4 000,00'   | '4 720,00'     | 'Sales order 140*' | 'Goods receipt 140*'  |
# 			| 'Dress'    | '210,00' | 'L/Green'   |  'Store 02' | 'pcs'  | '20,000' | '756,00'     | '4 200,00'   | '4 956,00'     | 'Sales order 140*' | 'Goods receipt 140*'  |
# 			| 'Trousers' | '210,00' | '36/Yellow' |  'Store 02' | 'pcs'  | '30,000' | '1 134,00'   | '6 300,00'   | '7 434,00'     | 'Sales order 140*' | 'Goods receipt 140*'  |
# 	И я устанавливаю номер документа 140
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '140'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '140'
# 	И я нажимаю на кнопку 'Post and close'
# 	Когда Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
# 	И я проверяю заполнение Sales invoice 141
# 		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
# 		И     элемент формы с именем "LegalName" стал равен 'Second Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Tax amount' | 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'      |
# 			| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '360,00'     | '2 000,00'   | '2 360,00'     | 'Sales order 141*' | 'Goods receipt 141*' |
# 	И я устанавливаю номер документа 141
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '141'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '141'
# 	И я нажимаю на кнопку 'Post and close'


# Сценарий: create Sales invoice по нескольким Sales order с разными партнерами одного контрагента по непрямой схеме отгрузки
# 	# должно создаться 2 Sales invoice
# 	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 	И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 142    |
# 	И В таблице  "List" я перехожу на одну строку вниз с выделением
# 	И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
# 	И я выбираю Goods Receipt по которым необходимо создать Sales invoice
# 		И я нажимаю на кнопку с именем 'FormSelectAll'
# 		И я нажимаю на кнопку 'Ok'
# 	И я проверяю заполнение Sales invoice 142
# 		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron 1'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Price'  | 'Item key'  |  'Store'    | 'Unit' | 'Q'      | 'Tax amount' | 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'       |
# 			| 'Dress'    | '200,00' | 'M/White'   |  'Store 02' | 'pcs'  | '20,000' | '720,00'     | '4 000,00'   | '4 720,00'     | 'Sales order 142*' | 'Goods receipt 142*'  |
# 			| 'Dress'    | '210,00' | 'L/Green'   |  'Store 02' | 'pcs'  | '20,000' | '756,00'     | '4 200,00'   | '4 956,00'     | 'Sales order 142*' | 'Goods receipt 142*'  |
# 			| 'Trousers' | '210,00' | '36/Yellow' |  'Store 02' | 'pcs'  | '30,000' | '1 134,00'   | '6 300,00'   | '7 434,00'     | 'Sales order 142*' | 'Goods receipt 142*'  |
# 	И я устанавливаю номер документа 142
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '142'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '142'
# 	И я нажимаю на кнопку 'Post and close'
# 	Когда Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
# 	И я проверяю заполнение Sales invoice 143
# 		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 2'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Partner 2'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Tax amount' | 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'      |
# 			| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '360,00'     | '2 000,00'   | '2 360,00'     | 'Sales order 143*' | 'Goods receipt 143*' |
# 	И я устанавливаю номер документа 143
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '143'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '143'
# 	И я нажимаю на кнопку 'Post and close'

# Сценарий: create Sales invoice по нескольким Sales order с разными соглашениями по непрямой схеме отгрузки
# 	# должно создаться 2 Sales invoice
# 	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 	И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 144    |
# 	И В таблице  "List" я перехожу на одну строку вниз с выделением
# 	И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
# 	И я выбираю Goods Receipt по которым необходимо создать Sales invoice
# 		И я нажимаю на кнопку с именем 'FormSelectAll'
# 		И я нажимаю на кнопку 'Ok'
# 	И я проверяю заполнение Sales invoice 144
# 		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron 1'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Price'  | 'Item key'  |  'Store'    | 'Unit' | 'Q'      | 'Tax amount' | 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'       |
# 			| 'Dress'    | '200,00' | 'M/White'   |  'Store 02' | 'pcs'  | '20,000' | '720,00'     | '4 000,00'   | '4 720,00'     | 'Sales order 144*' | 'Goods receipt 144*'  |
# 			| 'Dress'    | '210,00' | 'L/Green'   |  'Store 02' | 'pcs'  | '20,000' | '756,00'     | '4 200,00'   | '4 956,00'     | 'Sales order 144*' | 'Goods receipt 144*'  |
# 			| 'Trousers' | '210,00' | '36/Yellow' |  'Store 02' | 'pcs'  | '30,000' | '1 134,00'   | '6 300,00'   | '7 434,00'     | 'Sales order 144*' | 'Goods receipt 144*'  |
# 	И я устанавливаю номер документа 144
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '144'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '144'
# 	И я нажимаю на кнопку 'Post and close'
# 	Когда Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
# 	И я проверяю заполнение Sales invoice 145
# 		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Tax amount' | 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'      |
# 			| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '360,00'     | '2 000,00'   | '2 360,00'     | 'Sales order 145*' | 'Goods receipt 145*' |
# 	И я устанавливаю номер документа 145
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '145'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '145'
# 	И я нажимаю на кнопку 'Post and close'


# Сценарий: create Sales invoice по нескольким Sales order с разными складами по непрямой схеме отгрузки
# # должен создаться 1 Sales invoice
# 	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 	И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 146    |
# 	И В таблице  "List" я перехожу на одну строку вниз с выделением
# 	И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
# 	И я выбираю Goods Receipt по которым необходимо создать Sales invoice
# 		И я нажимаю на кнопку с именем 'FormSelectAll'
# 		И я нажимаю на кнопку 'Ok'
# 	И я проверяю заполнение Sales invoice 147
# 		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    |  'Unit' | 'Q'      | 'Tax amount'  | 'Net amount' | 'Total amount' | 'Sales order'       | 'Goods receipt'      |
# 			| 'Dress'    | '200,00' | 'M/White'   | 'Store 02' |  'pcs'  | '10,000' |  '360,00'     | '2 000,00'   | '2 360,00'     | 'Sales order 147*'  | 'Goods receipt 147*' |
# 			| 'Dress'    | '200,00' | 'M/White'   | 'Store 03' |  'pcs'  | '20,000' |  '720,00'     | '4 000,00'   | '4 720,00'     |  'Sales order 146*' | 'Goods receipt 146*' |
# 			| 'Dress'    | '210,00' | 'L/Green'   | 'Store 03' |  'pcs'  | '20,000' |  '756,00'     | '4 200,00'   | '4 956,00'     |  'Sales order 146*' | 'Goods receipt 146*' |
# 			| 'Trousers' | '210,00' | '36/Yellow' | 'Store 03' |  'pcs'  | '30,000' |  '1 134,00'   | '6 300,00'   | '7 434,00'     |  'Sales order 146*' | 'Goods receipt 146*' |
# 	И я устанавливаю номер документа 147
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '147'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '147'
# 	И я нажимаю на кнопку 'Post and close'

# Сценарий: create Sales invoice по нескольким Sales order с разными компаниями по непрямой схеме отгрузки
# # должно создаться 2 Sales invoice
# 	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
# 	И в таблице "List" я перехожу к строке:
# 			| Number |
# 			| 148    |
# 	И В таблице  "List" я перехожу на одну строку вниз с выделением
# 	И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
# 	И я выбираю Goods Receipt по которым необходимо создать Sales invoice
# 		И я нажимаю на кнопку с именем 'FormSelectAll'
# 		И я нажимаю на кнопку 'Ok'
# 	И я проверяю заполнение Sales invoice 148
# 		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Second Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Unit' | 'Q'      |'Offers amount'|'Tax amount'| 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'      |
# 			| 'Dress'    | '200,00' | 'M/White'   | 'Store 02' | 'pcs'  | '20,000' | ''            | ''         | '4 000,00'   | '4 000,00'     | 'Sales order 148*' | 'Goods receipt 148*' |
# 			| 'Dress'    | '210,00' | 'L/Green'   | 'Store 02' | 'pcs'  | '20,000' | ''            | ''         | '4 200,00'   | '4 200,00'     | 'Sales order 148*' | 'Goods receipt 148*' |
# 			| 'Trousers' | '210,00' | '36/Yellow' | 'Store 02' | 'pcs'  | '30,000' | ''            | ''         | '6 300,00'   | '6 300,00'     | 'Sales order 148*' | 'Goods receipt 148*' |
# 	И я устанавливаю номер документа 148
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '148'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '148'
# 	И я нажимаю на кнопку 'Post and close'
# 	Когда Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
# 	И я проверяю заполнение Sales invoice 149
# 		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
# 		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
# 		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
# 		И     элемент формы с именем "Description" стал равен 'Click for input description'
# 		И     элемент формы с именем "Company" стал равен 'Main Company'
# 		И     элемент формы с именем "Store" стал равен 'Store 02'
# 		И     таблица "ItemList" содержит строки:
# 			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Tax amount' | 'Net amount' | 'Total amount' | 'Sales order'      | 'Goods receipt'      |
# 			| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '360,00'     | '2 000,00'   | '2 360,00'     | 'Sales order 149*' | 'Goods receipt 149*' |
# 	И я устанавливаю номер документа 149
# 		И я перехожу к закладке "Other"
# 		И в поле 'Number' я ввожу текст '149'
# 		Тогда открылось окно '1C:Enterprise'
# 		И я нажимаю на кнопку 'Yes'
# 		И в поле 'Number' я ввожу текст '149'
# 	И я нажимаю на кнопку 'Post and close'