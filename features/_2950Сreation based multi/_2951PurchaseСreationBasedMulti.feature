#language: ru
@tree
@Positive


Функционал: создание based on по цепочке документов закупки

Как разработчик
Я хочу создать систему создания based on
Для удобства заполнения документов


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

# Internal supply request - Purchase order - Purchase invoice - Goods reciept - Bank payment/Cash payment
# Прямая схема поставки вначале инвойс, потом ордер



Сценарий: _090302 create Purchase invoice по нескольким Purchase order с разными контрагентами
	# должно создаться 2 Purchase invoice
	* Создание тестового Purchase order 124
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 124
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '124'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '124'
		И я нажимаю на кнопку 'Post and close'
	* Создание Purchase order 125
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 125
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '125'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '125'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 124 и 125 Purchase invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 124    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 3
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      | 'Goods receipt' | 'Sales order' |
			| '200,00' | 'Dress' | '18%' | 'M/White'  | '10,000' | 'pcs'  | '305,08'     | '1 694,92'   | '2 000,00'     | 'Store 02' | 'Purchase order 125*' | ''              | ''            |
			* * Change the document number to 126
				И в поле 'Number' я ввожу текст '126'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '126'
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      | 'Goods receipt' | 'Sales order' | 'Additional analytic' |
			| '200,00' | 'Dress'    | '18%' | 'M/White'   | '20,000' | 'pcs'  | '610,17'     | '3 389,83'   | '4 000,00'     | 'Store 02' | 'Purchase order 124*' | ''              | ''            | ''                    |
			| '210,00' | 'Dress'    | '18%' | 'L/Green'   | '20,000' | 'pcs'  | '640,68'     | '3 559,32'   | '4 200,00'     | 'Store 02' | 'Purchase order 124*' | ''              | ''            | ''                    |
			| '210,00' | 'Trousers' | '18%' | '36/Yellow' | '30,000' | 'pcs'  | '961,02'     | '5 338,98'   | '6 300,00'     | 'Store 02' | 'Purchase order 124*' | ''              | ''            | ''                    |
			* * Change the document number to 125
				И в поле 'Number' я ввожу текст '125'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '125'
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 3
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      | 'Goods receipt' | 'Sales order' |
			| '200,00' | 'Dress' | '18%' | 'M/White'  | '10,000' | 'pcs'  | '305,08'     | '1 694,92'   | '2 000,00'     | 'Store 02' | 'Purchase order 125*' | ''              | ''            |
			* * Change the document number to 126
				И в поле 'Number' я ввожу текст '126'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '126'
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      | 'Goods receipt' | 'Sales order' | 'Additional analytic' |
			| '200,00' | 'Dress'    | '18%' | 'M/White'   | '20,000' | 'pcs'  | '610,17'     | '3 389,83'   | '4 000,00'     | 'Store 02' | 'Purchase order 124*' | ''              | ''            | ''                    |
			| '210,00' | 'Dress'    | '18%' | 'L/Green'   | '20,000' | 'pcs'  | '640,68'     | '3 559,32'   | '4 200,00'     | 'Store 02' | 'Purchase order 124*' | ''              | ''            | ''                    |
			| '210,00' | 'Trousers' | '18%' | '36/Yellow' | '30,000' | 'pcs'  | '961,02'     | '5 338,98'   | '6 300,00'     | 'Store 02' | 'Purchase order 124*' | ''              | ''            | ''                    |
			* * Change the document number to 125
				И в поле 'Number' я ввожу текст '125'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '125'
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '125'       |
			| '126'       |
		И я закрыл все окна клиентского приложения




		

Сценарий: _090303 create Purchase invoice по нескольким Purchase order с одинаковым партнером, контрагентом, соглашением, валютой и складом
# Должен создаться 1 Purchase invoice
	* Создание тестового Purchase order 126
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 126
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '126'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '126'
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post and close'
	* Создание тестового Purchase order 127
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 127
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '127'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '127'
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 126 и 127 Purchase invoice (должен создаться 1)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 126    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Unit' | 'Total amount' | 'Store'    | 'Purchase order'      |
			| '3 389,83'   | 'Dress'    | '200,00' | 'M/White'   | '20,000' | 'pcs'  | '4 000,00'     | 'Store 02' | 'Purchase order 126*' |
			| '3 559,32'   | 'Dress'    | '210,00' | 'L/Green'   | '20,000' | 'pcs'  | '4 200,00'     | 'Store 02' | 'Purchase order 126*' |
			| '5 338,98'   | 'Trousers' | '210,00' | '36/Yellow' | '30,000' | 'pcs'  | '6 300,00'     | 'Store 02' | 'Purchase order 126*' |
			| '1 694,92'   | 'Dress'    | '200,00' | 'M/White'   | '10,000' | 'pcs'  | '2 000,00'     | 'Store 02' | 'Purchase order 127*' |
		* * Change the document number to 127
			И в поле 'Number' я ввожу текст '127'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '127'
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '127'       |
		И я закрыл все окна клиентского приложения
	
Сценарий: _090304 create Purchase invoice по нескольким Purchase order с разными партнерами одного контрагента (соглашения разные)
# Должно создаться 2 Purchase invoice
	И я для Company Ferron BP добавляю нового партнера Partner Ferron 1
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Partner Ferron 1'
		И я устанавливаю флаг 'Customer'
		И я устанавливаю флаг 'Vendor'
		И я нажимаю кнопку выбора у поля "Main partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region 2    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner terms'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Vendor Ferron 1'
		И я меняю значение переключателя 'Type' на 'Vendor'
		И в поле 'Number' я ввожу текст '125'
		И в поле с именем "StartUsing" я ввожу текущую дату
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Partner Ferron 1 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'TRY'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Vendor price, TRY |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Vendor Ferron Discount'
		И я меняю значение переключателя 'Type' на 'Vendor'
		И в поле 'Number' я ввожу текст '126'
		И в поле с именем "StartUsing" я ввожу текущую дату
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Partner Ferron 1 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'TRY'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Vendor price, TRY |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я закрыл все окна клиентского приложения
	И я для Company Ferron BP добавляю нового партнера Partner Ferron 2
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Partner Ferron 2'
		И я устанавливаю флаг 'Customer'
		И я устанавливаю флаг 'Vendor'
		И я нажимаю кнопку выбора у поля "Main partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region 2    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner terms'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Vendor Ferron Partner 2'
		И я меняю значение переключателя 'Type' на 'Vendor'
		И в поле 'Number' я ввожу текст '126'
		И в поле с именем "StartUsing" я ввожу текущую дату
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Partner Ferron 2 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'TRY'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Vendor price, TRY |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я закрыл все окна клиентского приложения
	* Создание первого тестового PO 128
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 128
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '128'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '128'
		* Заполнение информации о поставщике
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
				| Vendor Ferron 1 |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание первого тестового PO 129
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 129
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '129'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '129'
		* Заполнение информации о поставщике
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 2   |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron Partner 2 |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 128 и 129 Purchase invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 128    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 3
		* * Change the document number to 130
			И в поле 'Number' я ввожу текст '130'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '130'
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
		И Пауза 2
		Тогда в таблице "ItemList" количество строк "меньше или равно" 3
		* * Change the document number to 131
			И в поле 'Number' я ввожу текст '131'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '131'
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения
	* create документов
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Store'    | 'Order'               | 'Item key'  |
		| '20,000'   | 'Store 02' | 'Purchase order 128*' | 'M/White'   |
		| '20,000'   | 'Store 02' | 'Purchase order 128*' | 'L/Green'   |
		| '30,000'   | 'Store 02' | 'Purchase order 128*' | '36/Yellow' |
		| '10,000'   | 'Store 02' | 'Purchase order 129*' | 'M/White'   |
		| '20,000'   | 'Store 02' | 'Purchase order 128*' | 'M/White'   |
		| '20,000'   | 'Store 02' | 'Purchase order 128*' | 'L/Green'   |
		| '30,000'   | 'Store 02' | 'Purchase order 128*' | '36/Yellow' |
		| '10,000'   | 'Store 02' | 'Purchase order 129*' | 'M/White'   |
		И Пауза 5
		И Я закрыл все окна клиентского приложения



Сценарий: _090305 create Purchase invoice по нескольким Purchase order с разными соглашениями
# Должно создаться 2 Purchase invoice
	* Создание первого тестового PO 130
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 130
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '130'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '130'
		* Заполнение информации о поставщике
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
				| Vendor Ferron 1 |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового PO 131 Partner Ferron 1 и ставлю соглашение Vendor Ferron Discount
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 131
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '131'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '131'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 130 и 131 Purchase invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 130    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Partner term" имеет значение "Vendor Ferron 1" тогда
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      |
				| '200,00' | 'Dress'    | '18%' | 'M/White'   | '20,000' | 'pcs'  | '720,00'     | '4 000,00'   | '4 720,00'     | 'Store 02' | 'Purchase order 130*' |
				| '210,00' | 'Dress'    | '18%' | 'L/Green'   | '20,000' | 'pcs'  | '756,00'     | '4 200,00'   | '4 956,00'     | 'Store 02' | 'Purchase order 130*' |
				| '210,00' | 'Trousers' | '18%' | '36/Yellow' | '30,000' | 'pcs'  | '1 134,00'   | '6 300,00'   | '7 434,00'     | 'Store 02' | 'Purchase order 130*' |
			* * Change the document number to 141
				И в поле 'Number' я ввожу текст '141'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '141'
		Если поле с именем "Partner term" имеет значение "Vendor Ferron Discount" тогда
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      |
				| '200,00' | 'Dress' | '18%' | 'M/White'  | '10,000' | 'pcs'  | '360,00'     | '2 000,00'   | '2 360,00'     | 'Store 02' | 'Purchase order 131*' |
			* * Change the document number to 140
				И в поле 'Number' я ввожу текст '140'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '140'
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
		* Check filling inвторого PurchaseInvoice
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Partner term" имеет значение "Vendor Ferron 1" тогда
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      |
				| '200,00' | 'Dress'    | '18%' | 'M/White'   | '20,000' | 'pcs'  | '720,00'     | '4 000,00'   | '4 720,00'     | 'Store 02' | 'Purchase order 130*' |
				| '210,00' | 'Dress'    | '18%' | 'L/Green'   | '20,000' | 'pcs'  | '756,00'     | '4 200,00'   | '4 956,00'     | 'Store 02' | 'Purchase order 130*' |
				| '210,00' | 'Trousers' | '18%' | '36/Yellow' | '30,000' | 'pcs'  | '1 134,00'   | '6 300,00'   | '7 434,00'     | 'Store 02' | 'Purchase order 130*' |
			* * Change the document number to 141
				И в поле 'Number' я ввожу текст '141'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '141'
		Если поле с именем "Partner term" имеет значение "Vendor Ferron Discount" тогда
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      |
				| '200,00' | 'Dress' | '18%' | 'M/White'  | '10,000' | 'pcs'  | '360,00'     | '2 000,00'   | '2 360,00'     | 'Store 02' | 'Purchase order 131*' |
			* * Change the document number to 140
				И в поле 'Number' я ввожу текст '140'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '140'
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения
	* create документов
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Store'    | 'Order'               | 'Item key'  |
		| '20,000'   | 'Store 02' | 'Purchase order 130*' | 'M/White'   |
		| '20,000'   | 'Store 02' | 'Purchase order 130*' | 'L/Green'   |
		| '30,000'   | 'Store 02' | 'Purchase order 130*' | '36/Yellow' |
		| '10,000'   | 'Store 02' | 'Purchase order 131*' | 'M/White'   |
		| '20,000'   | 'Store 02' | 'Purchase order 130*' | 'M/White'   |
		| '20,000'   | 'Store 02' | 'Purchase order 130*' | 'L/Green'   |
		| '30,000'   | 'Store 02' | 'Purchase order 130*' | '36/Yellow' |
		| '10,000'   | 'Store 02' | 'Purchase order 131*' | 'M/White'   |
		И Пауза 5
		И Я закрыл все окна клиентского приложения



Сценарий: _090306 create Purchase invoice по нескольким Purchase order с разными складами (создается один)
# Создается один PI
	* Создание первого тестового PO 134
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 134
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '134'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '134'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 01  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового PO 135
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 135
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '135'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '135'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 135 и 134 Purchase invoice (должен создаться 1)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 134    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  |  'Store'    | 'Unit' | 'Q'      | 'Offers amount' | 'Net amount' | 'Total amount' | 'Purchase order'      |
			| 'Dress'    | '200,00' | 'M/White'   |  'Store 01' | 'pcs'  | '20,000' | ''              | '4 000,00'   | '4 720,00'     | 'Purchase order 134*' |
			| 'Dress'    | '210,00' | 'L/Green'   |  'Store 01' | 'pcs'  | '20,000' | ''              | '4 200,00'   | '4 956,00'     | 'Purchase order 134*' |
			| 'Trousers' | '210,00' | '36/Yellow' |  'Store 01' | 'pcs'  | '30,000' | ''              | '6 300,00'   | '7 434,00'     | 'Purchase order 134*' |
			| 'Dress'    | '200,00' | 'M/White'   |  'Store 02' | 'pcs'  | '10,000' | ''              | '2 000,00'   | '2 360,00'     | 'Purchase order 135*' |
		* * Change the document number to 135
			И в поле 'Number' я ввожу текст '135'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '135'
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '135'       |
		И я закрыл все окна клиентского приложения

	
Сценарий: _090307 create Purchase invoice по нескольким Purchase order с разными собственными компаниями
	# Создается один PI
	* Создание первого тестового PO 136
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 136
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '136'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '136'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Second Company |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового PO 137
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 137
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '137'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '137'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 136 и 137 Purchase invoice (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 136    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Company" имеет значение "Main Company" тогда	
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Net amount' | 'Total amount' | 'Purchase order'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 000,00'   | '2 360,00'     | 'Purchase order 137*' |
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
			* * Change the document number to 137
				И в поле 'Number' я ввожу текст '137'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '137'
		Если поле с именем "Company" имеет значение "Second Company" тогда
			и таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  |  'Store'     | 'Unit' | 'Q'      | 'Net amount' | 'Total amount' | 'Purchase order'     |
			| 'Dress'    | '200,00' | 'M/White'   |  'Store 02'  | 'pcs'  | '20,000' | '4 000,00'   | '4 000,00'     | 'Purchase order 136*' |
			| 'Dress'    | '210,00' | 'L/Green'   |  'Store 02'  | 'pcs'  | '20,000' | '4 200,00'   | '4 200,00'     | 'Purchase order 136*' |
			| 'Trousers' | '210,00' | '36/Yellow' |  'Store 02'  | 'pcs'  | '30,000' | '6 300,00'   | '6 300,00'     | 'Purchase order 136*' |
			* * Change the document number to 136
				И в поле 'Number' я ввожу текст '136'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '136'
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Company" имеет значение "Main Company" тогда	
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Net amount' | 'Total amount' | 'Purchase order'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 000,00'   | '2 360,00'     | 'Purchase order 137*' |
			И     элемент формы с именем "PriceIncludeTax" стал равен 'No'
			* * Change the document number to 137
				И в поле 'Number' я ввожу текст '137'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '137'
		Если поле с именем "Company" имеет значение "Second Company" тогда
			и таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  |  'Store'     | 'Unit' | 'Q'      | 'Net amount' | 'Total amount' | 'Purchase order'     |
			| 'Dress'    | '200,00' | 'M/White'   |  'Store 02'  | 'pcs'  | '20,000' | '4 000,00'   | '4 000,00'     | 'Purchase order 136*' |
			| 'Dress'    | '210,00' | 'L/Green'   |  'Store 02'  | 'pcs'  | '20,000' | '4 200,00'   | '4 200,00'     | 'Purchase order 136*' |
			| 'Trousers' | '210,00' | '36/Yellow' |  'Store 02'  | 'pcs'  | '30,000' | '6 300,00'   | '6 300,00'     | 'Purchase order 136*' |
			* * Change the document number to 136
				И в поле 'Number' я ввожу текст '136'
				Тогда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
				И в поле 'Number' я ввожу текст '136'
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '136'       |
			| '137'       |
		И я закрыл все окна клиентского приложения




Сценарий: _090308 create Goods reciept по Purchase invoice с разными контрагентами по прямой схемой отгрузки 
# Создается два GR
	* Создание Goods reciept к PI 125, 126
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		Тогда устанавливаю сортировку списка по номеру документа 
			И я нажимаю на кнопку 'Configure list...'
			И я перехожу к закладке "Order"
			И в таблице "SettingsComposerUserSettingsItem1Order" я нажимаю на кнопку с именем 'SettingsComposerUserSettingsItem1OrderDelete'
			И в таблице "SettingsComposerUserSettingsItem1AvailableFieldsTable" я перехожу к строке:
				| 'Available fields' |
				| 'Number'           |
			И в таблице "SettingsComposerUserSettingsItem1AvailableFieldsTable" я выбираю текущую строку
			И я нажимаю на кнопку 'Finish editing'
		И в таблице "List" я перехожу к строке:
				| Number |
				| 125    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '126'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '126'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 125*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 125*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 125*' |
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '125'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '125'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
			| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 126*' |
		И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inвторого Goods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '126'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '126'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 125*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 125*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 125*' |
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '125'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '125'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
			| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 126*' |
		И я нажимаю на кнопку 'Post and close'
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '125'       |
			| '126'       |
		И я закрыл все окна клиентского приложения



Сценарий: _090309 create Goods reciept по нескольким Purchase invoice с разными партнерами одного контрагента по прямой схемой отгрузки 
# Создается 2 GR
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
				| Number |
				| 130    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Partner" имеет значение "Partner Ferron 2" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
				| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
			И в поле 'Number' я ввожу текст '129'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '129'
		Если поле с именем "Partner" имеет значение "Partner Ferron 1" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
			И в поле 'Number' я ввожу текст '130'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '130'
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inвторого Goods reciept
		Если поле с именем "Partner" имеет значение "Partner Ferron 2" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
				| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
			И в поле 'Number' я ввожу текст '129'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '129'
		Если поле с именем "Partner" имеет значение "Partner Ferron 1" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 13*' |
			И в поле 'Number' я ввожу текст '130'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '130'
	И я нажимаю на кнопку 'Post and close'
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '129'       |
			| '130'       |
		И я закрыл все окна клиентского приложения


Сценарий: _090310 create Goods reciept по нескольким Purchase invoice с разными соглашениями по прямой схемой отгрузки 
# Создается два GR так как соглашения разные
	* Создание Goods reciept к PI 140, 141
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
				| Number |
				| 140    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И я запоминаю количество строк таблицы "ItemList" как "Q"
		Если переменная "Q" имеет значение 1 Тогда
			И в поле 'Number' я ввожу текст '140'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '140'
			И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' | 'Receipt basis'         |
			| 'Dress' | '10,000'   | 'M/White'  | 'Store 02' | 'pcs'  | 'Purchase invoice 140*' |
		Если переменная "Q" имеет значение 3 Тогда
			И в поле 'Number' я ввожу текст '141'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '141'	
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'         |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 141*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 141*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 141*' |
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inвторого Goods reciept
		И я запоминаю количество строк таблицы "ItemList" как "D"
		Если переменная "D" имеет значение 1 Тогда
			И в поле 'Number' я ввожу текст '140'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '140'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
			| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 140*' |
		Если переменная "D" имеет значение 3 Тогда
			И в поле 'Number' я ввожу текст '141'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '141'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 141*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 141*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 141*' |
	И я нажимаю на кнопку 'Post and close'
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '140'       |
			| '141'       |
		И я закрыл все окна клиентского приложения


Сценарий: _090311 create Goods reciept по нескольким Purchase invoice с разными складами по прямой схемой отгрузки (только один склад ордерный)
# Создается один GR
	* Создание Goods reciept к PI 135
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
				| Number |
				| 135    |
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
		| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 135*' |
		И в поле 'Number' я ввожу текст '135'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '135'
	И я нажимаю на кнопку 'Post and close'
	И я проверяю создание документа
		Тогда таблица "List" содержит строки:
			| Number |
			| 135    |
	И я закрыл все окна клиентского приложения
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '135'       |
		И я закрыл все окна клиентского приложения


Сценарий: _090312 create Goods reciept по нескольким Purchase order с разными собственными компаниями по прямой схеме отгрузки 
# Создается два GR
	* Создание Goods reciept к PI 137, 136
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 136    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Company" имеет значение "Second Company" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 136*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 136*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 136*' |
			И в поле 'Number' я ввожу текст '136'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '136'
		Если поле с именем "Company" имеет значение "Main Company" тогда
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
				| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' |
			И в поле 'Number' я ввожу текст '137'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '137'
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inGoods reciept
		Если поле с именем "Company" имеет значение "Second Company" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'        |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase invoice 136*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase invoice 136*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase invoice 136*' |
			И в поле 'Number' я ввожу текст '136'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '136'
		Если поле с именем "Company" имеет значение "Main Company" тогда
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
				| 'Dress'    | '10,000'   | 'M/White'   | 'pcs'  | 'Store 02' |
			И в поле 'Number' я ввожу текст '137'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '137'
	И я нажимаю на кнопку 'Post and close'
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '136'       |
			| '137'       |
		И я закрыл все окна клиентского приложения



# Непрямая схема поставки вначале ордер потом инвойс

Сценарий: _090313 create Goods reciept по Purchase order с разными контрагентами по непрямой схеме отгрузки 
# должно создаться 2 Goods reciept
	* Создание тестового Purchase order 140
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 140
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '140'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '140'
		И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
		И я нажимаю на кнопку 'Post and close'
	* Создание Purchase order 141
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 141
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '141'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '141'
		И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 140 и 141 Goods reciept (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 140    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '143'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '143'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 141*' |
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '142'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '142'
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 140*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 140*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 140*' |
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '143'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '143'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 141*' |	
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда 
			И в поле 'Number' я ввожу текст '142'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '142'
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 140*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 140*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 140*' |
	И я нажимаю на кнопку 'Post and close'
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '142'       |
			| '143'       |
		И я закрыл все окна клиентского приложения



Сценарий: _090314 create Goods reciept по нескольким Purchase order с разными партнерами одного контрагента по непрямой схемой отгрузки 
# должно создаться 2 Goods reciept
	* Создание первого тестового PO 142
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 142
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '142'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '142'
		* Заполнение информации о поставщике
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
				| Vendor Ferron 1 |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового PO 143
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 143
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '143'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '143'
		* Заполнение информации о поставщике
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Partner Ferron 2   |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron Partner 2 |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 142 и 143 Goods reciept (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 142    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		Если поле с именем "Partner" имеет значение "Partner Ferron 2" тогда 
			И в поле 'Number' я ввожу текст '154'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '154'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 143*' |
		Если поле с именем  "Partner" имеет значение "Partner Ferron 1" тогда 
			И в поле 'Number' я ввожу текст '155'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '155'
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 142*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 142*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 142*' |
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inGoods reciept
		Если поле с именем "Partner" имеет значение "Partner Ferron 2" тогда 
			И в поле 'Number' я ввожу текст '154'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '154'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 143*' |
		Если поле с именем "Partner" имеет значение "Partner Ferron 1" тогда 
			И в поле 'Number' я ввожу текст '155'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '155'
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 142*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 142*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 142*' |
	И я нажимаю на кнопку 'Post and close'
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '154'       |
			| '155'       |
		И я закрыл все окна клиентского приложения

Сценарий: _090315 create Goods reciept по нескольким Purchase order с разными соглашениями по непрямой схемой отгрузки 
# должно создаться 2 Goods reciept
	* Создание первого тестового PO 144
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 144
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '144'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '144'
		* Заполнение информации о поставщике
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
				| Vendor Ferron 1 |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового PO 145 Partner Ferron 1 и ставлю соглашение Vendor Ferron Discount
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 144
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '145'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '145'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 144 и 145 Goods reciept (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 144    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И я запоминаю количество строк таблицы "ItemList" как "N"
		Если переменная "N" имеет значение 1 Тогда
			И в поле 'Number' я ввожу текст '145'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '145'
			Тогда таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
			| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 145*' |
		Если переменная "N" имеет значение 3 Тогда
			И в поле 'Number' я ввожу текст '144'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '144'
			Тогда таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 144*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 144*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 144*' |
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inвторого Goods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И я запоминаю количество строк таблицы "ItemList" как "A"
		Если переменная "A" имеет значение 1 Тогда
			И в поле 'Number' я ввожу текст '145'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '145'
			Тогда таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
			| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 145*' |
		Если переменная "A" имеет значение 3 Тогда
			И в поле 'Number' я ввожу текст '144'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '144'
			Тогда таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 144*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 144*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 144*' |
	И я нажимаю на кнопку 'Post and close'
	* create Goods reciept
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '144'       |
			| '145'       |
		И я закрыл все окна клиентского приложения



Сценарий: _090316 create Goods reciept по нескольким Purchase order с разными складами по непрямой схемой отгрузки
# должно создаться 2 Goods reciept
	* Создание первого тестового PO 146
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 146
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '146'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '146'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 03  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового PO 147
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 147
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '147'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '147'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание based on Purchase order 146 и 147 Goods reciept (должно создаться 2)
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 146    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		Если поле с именем "Store" имеет значение "Store 02" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 147*' |
			И в поле 'Number' я ввожу текст '147'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '147'
		Если поле с именем "Store" имеет значение "Store 03" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 03' | 'Purchase order 146*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 03' | 'Purchase order 146*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 03' | 'Purchase order 146*' |
			И в поле 'Number' я ввожу текст '146'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '146'
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inGoods reciept
		И     элемент формы с именем "Company" стал равен 'Main Company'
		Если поле с именем "Store" имеет значение "Store 02" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 147*' |
			И в поле 'Number' я ввожу текст '147'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '147'
		Если поле с именем "Store" имеет значение "Store 03" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 03' | 'Purchase order 146*' |
				| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 03' | 'Purchase order 146*' |
				| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 03' | 'Purchase order 146*' |
			И в поле 'Number' я ввожу текст '146'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '146'
	И я нажимаю на кнопку 'Post and close'
	* create документов
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Receipt basis'       | 'Store'    | 'Item key'  |
		| '20,000'   | 'Purchase order 146*' | 'Store 03' | 'M/White'   |
		| '20,000'   | 'Purchase order 146*' | 'Store 03' | 'L/Green'   |
		| '30,000'   | 'Purchase order 146*' | 'Store 03' | '36/Yellow' |
		| '10,000'   | 'Purchase order 147*' | 'Store 02' | 'M/White'   |
		| '10,000'   | 'Purchase order 147*' | 'Store 02' | 'M/White'   |
		| '20,000'   | 'Purchase order 146*' | 'Store 03' | 'M/White'   |
		| '20,000'   | 'Purchase order 146*' | 'Store 03' | 'L/Green'   |
		| '30,000'   | 'Purchase order 146*' | 'Store 03' | '36/Yellow' |
		И Пауза 5
	И Я закрыл все окна клиентского приложения

Сценарий: _090317 create Goods reciept по нескольким Purchase order с разными собственными компаниями по непрямой схемой отгрузки 
# должно создаться 2 Goods reciept
	* Создание первого тестового PO 148
		Когда create the first test PO for a test on the creation mechanism based on
		* * Change the document number to 148
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '148'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '148'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description    |
				| Second Company |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'L/Green'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Trousers' |'36/Yellow'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
		И я нажимаю на кнопку 'Post and close'
	* Создание второго тестового PO 149
		Когда create the second test PO for a test on the creation mechanism based on
		* * Change the document number to 149
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '149'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '149'
		* Заполнение информации о поставщике
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
				| Vendor Ferron Discount |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled price types on Vendor price, TRY'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И я устанавливаю флаг с именем "GoodsReceiptBeforePurchaseInvoice"
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'  |'Item key' |
			| 'Dress' |'M/White'  |
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
	* Создание Goods reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| Number |
			| 149    |
		И В таблице  "List" я перехожу на одну строку вверх с выделением
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
	* Check filling inGoods reciept
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Company" имеет значение "Main Company" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 149*' |
			И в поле 'Number' я ввожу текст '149'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '149'
		Если поле с именем "Company" имеет значение "Second Company" тогда 
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 148*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 148*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 148*' |
			И в поле 'Number' я ввожу текст '148'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '148'
	И я нажимаю на кнопку 'Post and close'
	И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
	* Check filling inвторого Goods reciept
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Company" имеет значение "Main Company" тогда 
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
				| 'Dress' | '10,000'   | 'M/White'  | 'pcs'  | 'Store 02' | 'Purchase order 149*' |
			И в поле 'Number' я ввожу текст '149'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '149'
		Если поле с именем "Company" имеет значение "Second Company" тогда 
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'      |
			| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | 'Purchase order 148*' |
			| 'Dress'    | '20,000'   | 'L/Green'   | 'pcs'  | 'Store 02' | 'Purchase order 148*' |
			| 'Trousers' | '30,000'   | '36/Yellow' | 'pcs'  | 'Store 02' | 'Purchase order 148*' |
			И в поле 'Number' я ввожу текст '148'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '148'
	И я нажимаю на кнопку 'Post and close'
	* create документов
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
		Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Receipt basis'       | 'Store'    | 'Item key'  |
		| '20,000'   | 'Purchase order 148*' | 'Store 02' | 'M/White'   |
		| '20,000'   | 'Purchase order 148*' | 'Store 02' | 'L/Green'   |
		| '30,000'   | 'Purchase order 148*' | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Purchase order 149*' | 'Store 02' | 'M/White'   |
		| '10,000'   | 'Purchase order 149*' | 'Store 02' | 'M/White'   |
		| '20,000'   | 'Purchase order 148*' | 'Store 02' | 'M/White'   |
		| '20,000'   | 'Purchase order 148*' | 'Store 02' | 'L/Green'   |
		| '30,000'   | 'Purchase order 148*' | 'Store 02' | '36/Yellow' |
		И Пауза 5
		И я закрыл все окна клиентского приложения


Сценарий: _090318 create Purchase invoice по нескольким Purchase order с разными контрагентами по непрямой схеме отгрузки
# должно создаться 2 Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
			| Number |
			| 140    |
	И В таблице  "List" я перехожу на одну строку вниз с выделением
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	И я выбираю Goods Receipt по которым необходимо создать Purchase invoice
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
	* Check filling inPurchase invoice 142
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда 
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '142'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '142'
			И Пауза 5
			И я перехожу к закладке "Item list"
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 000,00'     | 'Purchase order 141*' | 'Goods receipt 143*' |
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '143'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '143'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' |'Purchase order'      | 'Goods receipt'      |
			| 'Trousers' | '210,00' | '36/Yellow' | '30,000' | 'pcs'  | '6 300,00'     | 'Store 02' | '*'             |'Purchase order 140*' | 'Goods receipt 142*' | 
			| 'Dress'    | '200,00' | 'M/White'   | '20,000' | 'pcs'  | '4 000,00'     | 'Store 02' | '*'             |'Purchase order 140*' | 'Goods receipt 142*' |
			| 'Dress'    | '210,00' | 'L/Green'   | '20,000' | 'pcs'  | '4 200,00'     | 'Store 02' | '*'             |'Purchase order 140*' | 'Goods receipt 142*' |
	И я нажимаю на кнопку 'Post and close'
	Когда Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
	* Check filling inвторого Purchase invoice
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда 
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '142'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '142'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 000,00'     | 'Purchase order 141*' | 'Goods receipt 143*' |
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '143'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '143'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' |'Purchase order'      | 'Goods receipt'      |
			| 'Trousers' | '210,00' | '36/Yellow' | '30,000' | 'pcs'  | '6 300,00'     | 'Store 02' | '*'             |'Purchase order 140*' | 'Goods receipt 142*' | 
			| 'Dress'    | '200,00' | 'M/White'   | '20,000' | 'pcs'  | '4 000,00'     | 'Store 02' | '*'             |'Purchase order 140*' | 'Goods receipt 142*' |
			| 'Dress'    | '210,00' | 'L/Green'   | '20,000' | 'pcs'  | '4 200,00'     | 'Store 02' | '*'             |'Purchase order 140*' | 'Goods receipt 142*' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '142'       |
			| '143'       |
		И я закрыл все окна клиентского приложения



Сценарий: _090319 create Purchase invoice по нескольким Purchase order с разными партнерами одного контрагента по непрямой схеме отгрузки
	# должно создаться 2 Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
			| Number |
			| 142    |
	И В таблице  "List" я перехожу на одну строку вниз с выделением
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	И я выбираю Goods Receipt по которым необходимо создать Purchase invoice
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
	* Check filling inPurchase invoice 145
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Partner" имеет значение "Partner Ferron 2" тогда 
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Partner 2'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 360,00'     | 'Purchase order 143*' | 'Goods receipt 154*' |	
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '154'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '154'
		Если поле с именем "Partner" имеет значение "Partner Ferron 1" тогда 
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron 1'
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  |  'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'       |
				| 'Dress'    | '200,00' | 'M/White'   |  'Store 02' | 'pcs'  | '20,000' | '4 720,00'     | 'Purchase order 142*' | 'Goods receipt 155*'  |
				| 'Dress'    | '210,00' | 'L/Green'   |  'Store 02' | 'pcs'  | '20,000' | '4 956,00'     | 'Purchase order 142*' | 'Goods receipt 155*'  |
				| 'Trousers' | '210,00' | '36/Yellow' |  'Store 02' | 'pcs'  | '30,000' | '7 434,00'     | 'Purchase order 142*' | 'Goods receipt 155*'  |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '155'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '155'
	И я нажимаю на кнопку 'Post and close'
	Когда Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
	* Check filling inPurchase invoice 146
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Partner" имеет значение "Partner Ferron 2" тогда 
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Partner 2'
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 360,00'     | 'Purchase order 143*' | 'Goods receipt 154*' |	
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '154'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '154'
		Если поле с именем "Partner" имеет значение "Partner Ferron 1" тогда 
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron 1'
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  |  'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'       |
				| 'Dress'    | '200,00' | 'M/White'   |  'Store 02' | 'pcs'  | '20,000' | '4 720,00'     | 'Purchase order 142*' | 'Goods receipt 155*'  |
				| 'Dress'    | '210,00' | 'L/Green'   |  'Store 02' | 'pcs'  | '20,000' | '4 956,00'     | 'Purchase order 142*' | 'Goods receipt 155*'  |
				| 'Trousers' | '210,00' | '36/Yellow' |  'Store 02' | 'pcs'  | '30,000' | '7 434,00'     | 'Purchase order 142*' | 'Goods receipt 155*'  |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '155'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '155'
	И я нажимаю на кнопку 'Post and close'
	И Я закрыл все окна клиентского приложения
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И я нажимаю на кнопку 'Refresh'
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '155'       |
			| '154'       |
		И я закрыл все окна клиентского приложения

Сценарий: _090320 create Purchase invoice по нескольким Purchase order с разными соглашениями по непрямой схеме отгрузки
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
			| Number |
			| 144    |
	И В таблице  "List" я перехожу на одну строку вниз с выделением
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	И я выбираю Goods Receipt по которым необходимо создать Purchase invoice
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
	* Check filling inPurchase invoice 145
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И я запоминаю количество строк таблицы "ItemList" как "N"
		Если переменная "N" имеет значение 1 Тогда
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'Item key' | 'Q'      | 'Unit' | 'Total amount' | 'Store'    | 'Purchase order'      | 'Goods receipt'      |
			| '200,00' | 'Dress' | 'M/White'  | '10,000' | 'pcs'  | '2 360,00'     | 'Store 02' | 'Purchase order 145*' | 'Goods receipt 145*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '148'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '148'
		Если переменная "N" имеет значение 3 Тогда
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron 1'
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      |
				| '200,00' | 'Dress'    | '18%' | 'M/White'   | '20,000' | 'pcs'  | '720,00'     | '4 000,00'   | '4 720,00'     | 'Store 02' | 'Purchase order 144*' |
				| '210,00' | 'Dress'    | '18%' | 'L/Green'   | '20,000' | 'pcs'  | '756,00'     | '4 200,00'   | '4 956,00'     | 'Store 02' | 'Purchase order 144*' |
				| '210,00' | 'Trousers' | '18%' | '36/Yellow' | '30,000' | 'pcs'  | '1 134,00'   | '6 300,00'   | '7 434,00'     | 'Store 02' | 'Purchase order 144*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '147'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '147'
		И я нажимаю на кнопку 'Post and close'
	Когда Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
	* Check filling inPurchase invoice 144
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И я запоминаю количество строк таблицы "ItemList" как "N"
		Если переменная "N" имеет значение 1 Тогда
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'Item key' | 'Q'      | 'Unit' | 'Total amount' | 'Store'    | 'Purchase order'      | 'Goods receipt'      |
			| '200,00' | 'Dress' | 'M/White'  | '10,000' | 'pcs'  | '2 360,00'     | 'Store 02' | 'Purchase order 145*' | 'Goods receipt 145*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '148'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '148'
		Если переменная "N" имеет значение 3 Тогда
			И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron 1'
			И     таблица "ItemList" содержит строки:
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Purchase order'      |
				| '200,00' | 'Dress'    | '18%' | 'M/White'   | '20,000' | 'pcs'  | '720,00'     | '4 000,00'   | '4 720,00'     | 'Store 02' | 'Purchase order 144*' |
				| '210,00' | 'Dress'    | '18%' | 'L/Green'   | '20,000' | 'pcs'  | '756,00'     | '4 200,00'   | '4 956,00'     | 'Store 02' | 'Purchase order 144*' |
				| '210,00' | 'Trousers' | '18%' | '36/Yellow' | '30,000' | 'pcs'  | '1 134,00'   | '6 300,00'   | '7 434,00'     | 'Store 02' | 'Purchase order 144*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '147'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '147'
		И я нажимаю на кнопку 'Post and close'
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И я нажимаю на кнопку 'Refresh'
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '147'       |
			| '148'       |
		И я закрыл все окна клиентского приложения



Сценарий: _090322 create Purchase invoice по нескольким Purchase order с разными компаниями по непрямой схеме отгрузки
# должно создаться 2 Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
			| Number |
			| 148    |
	И В таблице  "List" я перехожу на одну строку вниз с выделением
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	И я выбираю Goods Receipt по которым необходимо создать Purchase invoice
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
	* Check filling inPurchase invoice 148
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Company" имеет значение "Main Company" тогда
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 360,00'     | 'Purchase order 149*' | 'Goods receipt 149*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '149'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '149'
		Если поле с именем "Company" имеет значение "Second Company" тогда
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Unit' | 'Q'      |'Offers amount'|'Tax amount'| 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress'    | '200,00' | 'M/White'   | 'Store 02' | 'pcs'  | '20,000' | ''            | ''         | '4 000,00'     | 'Purchase order 148*' | 'Goods receipt 148*' |
				| 'Dress'    | '210,00' | 'L/Green'   | 'Store 02' | 'pcs'  | '20,000' | ''            | ''         | '4 200,00'     | 'Purchase order 148*' | 'Goods receipt 148*' |
				| 'Trousers' | '210,00' | '36/Yellow' | 'Store 02' | 'pcs'  | '30,000' | ''            | ''         | '6 300,00'     | 'Purchase order 148*' | 'Goods receipt 148*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '150'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '150'
	И я нажимаю на кнопку 'Post and close'
	Когда Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
	* Check filling inвторого Purchase invoice 149
		И     элемент формы с именем "Partner" стал равен 'Partner Ferron 1'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron Discount'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Company" имеет значение "Main Company" тогда
			И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Unit' | 'Q'      | 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress' | '200,00' | 'M/White'  | 'Store 02' | 'pcs'  | '10,000' | '2 360,00'     | 'Purchase order 149*' | 'Goods receipt 149*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '149'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '149'
		Если поле с именем "Company" имеет значение "Second Company" тогда
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Unit' | 'Q'      |'Offers amount'|'Tax amount'| 'Total amount' | 'Purchase order'      | 'Goods receipt'      |
				| 'Dress'    | '200,00' | 'M/White'   | 'Store 02' | 'pcs'  | '20,000' | ''            | ''         | '4 000,00'     | 'Purchase order 148*' | 'Goods receipt 148*' |
				| 'Dress'    | '210,00' | 'L/Green'   | 'Store 02' | 'pcs'  | '20,000' | ''            | ''         | '4 200,00'     | 'Purchase order 148*' | 'Goods receipt 148*' |
				| 'Trousers' | '210,00' | '36/Yellow' | 'Store 02' | 'pcs'  | '30,000' | ''            | ''         | '6 300,00'     | 'Purchase order 148*' | 'Goods receipt 148*' |
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '150'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '150'
	И я нажимаю на кнопку 'Post and close'
	* create Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И я нажимаю на кнопку 'Refresh'
		Тогда таблица "List" содержит строки:
			| 'Number'  |
			| '149'       |
			| '150'       |
		И я закрыл все окна клиентского приложения