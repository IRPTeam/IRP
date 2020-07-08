#language: ru
@tree
@Positive

Функционал: buttons for selecting base documents



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.
	

Сценарий: _2040001 preparation 
	* Creating a structure of customers and suppliers for the test
		* Vendor segment + partner term
			* In USD
				И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
				И я нажимаю на кнопку с именем 'FormCreate'
				И в поле 'ENG' я ввожу текст 'Vendor, USD'
				И я меняю значение переключателя 'Type' на 'Vendor'
				И в поле 'Number' я ввожу текст '12389'
				И в поле 'Date' я ввожу текст '22.01.2020'
				И я нажимаю кнопку выбора у поля "Partner segment"
				И я нажимаю на кнопку с именем 'FormCreate'
				И в поле 'ENG' я ввожу текст 'Vendor'
				И я нажимаю на кнопку 'Save and close'
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Vendor'      |
				И я нажимаю на кнопку с именем 'FormChoose'
				И из выпадающего списка "Company" я выбираю по строке 'main'
				И я нажимаю кнопку выбора у поля "Multi currency movement type"
				И в таблице "List" я перехожу к строке:
					| 'Currency' | 'Deferred calculation' | 'Description' | 'Reference' | 'Source'       | 'Type'      |
					| 'USD'      | 'No'                   | 'USD'         | 'USD'       | 'Forex Seling' | 'Partner term' |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Price type"
				И в таблице "List" я перехожу к строке:
					| 'Currency' | 'Description'       |
					| 'TRY'      | 'Basic Price Types' |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Start using' я ввожу текст '22.01.2020'
				И я нажимаю кнопку выбора у поля "Store"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Store 02'    |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю на кнопку 'Save and close'
				И я жду закрытия окна 'Partner term (create) *' в течение 20 секунд
			* In TRY
				И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
				И я нажимаю на кнопку с именем 'FormCreate'
				И в поле 'ENG' я ввожу текст 'Vendor, TRY'
				И я меняю значение переключателя 'Type' на 'Vendor'
				И в поле 'Number' я ввожу текст '12389'
				И в поле 'Date' я ввожу текст '22.01.2020'
				И я нажимаю кнопку выбора у поля "Partner segment"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Vendor'      |
				И я нажимаю на кнопку с именем 'FormChoose'
				И из выпадающего списка "Company" я выбираю по строке 'main'
				И я нажимаю кнопку выбора у поля "Multi currency movement type"
				И в таблице "List" я перехожу к строке:
					| 'Currency' | 'Deferred calculation' | 'Description' | 'Reference' | 'Source'       | 'Type'      |
					| 'TRY'      | 'No'                   | 'TRY'         | 'TRY'       | 'Forex Seling' | 'Partner term' |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Price type"
				И в таблице "List" я перехожу к строке:
					| 'Currency' | 'Description'       |
					| 'TRY'      | 'Basic Price Types' |
				И в таблице "List" я выбираю текущую строку
				И в поле 'Start using' я ввожу текст '22.01.2020'
				И я нажимаю кнопку выбора у поля "Store"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Store 02'    |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю на кнопку 'Save and close'
			И Я закрыл все окна клиентского приложения
		* Main partner and Legal name
			И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Adel'
			И я изменяю флаг 'Vendor'
			И я изменяю флаг 'Customer'
			И я изменяю флаг 'Shipment confirmations before sales invoice'
			И я изменяю флаг 'Goods receipt before purchase invoice'
			И я нажимаю кнопку выбора у поля "Manager segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Region 2'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments content'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Vendor'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Company Adel'
			И я нажимаю кнопку выбора у поля "Country"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Turkey'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
			И я нажимаю на кнопку 'Save and close'
		* Subordinate partner with own legal name
			И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Astar'
			И я изменяю флаг 'Vendor'
			И я изменяю флаг 'Customer'
			И я изменяю флаг 'Shipment confirmations before sales invoice'
			И я изменяю флаг 'Goods receipt before purchase invoice'
			И я нажимаю кнопку выбора у поля "Main partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Adel' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Manager segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Region 2'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments content'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Vendor'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Company Astar'
			И я нажимаю кнопку выбора у поля "Country"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Turkey'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
			И я нажимаю на кнопку 'Save and close'
		* Subordinate partner without own legal name
			И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
			И я нажимаю на кнопку с именем 'FormCreate'
			И в поле 'ENG' я ввожу текст 'Crystal'
			И я изменяю флаг 'Vendor'
			И я изменяю флаг 'Customer'
			И я изменяю флаг 'Shipment confirmations before sales invoice'
			И я изменяю флаг 'Goods receipt before purchase invoice'
			И я нажимаю кнопку выбора у поля "Main partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Adel' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Manager segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Region 2'    |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments content'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Vendor'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
			И я нажимаю на кнопку 'Save and close'
	* Creation of a Sales order on Crystal, Basic Partner terms, TRY, Sales invoice before Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in items tab
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
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Shipment confirmations before sales invoice'
			И в поле 'Number' я ввожу текст '8 007'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 000'
			И я нажимаю на кнопку 'Post and close'
	* * Creation of a Sales order on Crystal, Basic Partner terms, TRY, Shipment confirmation before Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Shipment confirmations before sales invoice'
			И в поле 'Number' я ввожу текст '9 001'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 001'
			И я нажимаю на кнопку 'Post and close'
	* Creation of a Sales order on Crystal, Basic Partner terms, TRY, Sales invoice before Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Shipment confirmations before sales invoice'
			И в поле 'Number' я ввожу текст '9 002'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 002'
			И я нажимаю на кнопку 'Post and close'
	* Creation of a Sales order on Crystal, Basic Partner terms, without VAT, TRY, Sales invoice before Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Shipment confirmations before sales invoice'
			И в поле 'Number' я ввожу текст '9 004'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 004'
			И я нажимаю на кнопку 'Post and close'
		* Creation of a Sales order on Crystal, Basic Partner terms, without VAT, TRY, Shipment confirmation before Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Shipment confirmations before sales invoice'
			И в поле 'Number' я ввожу текст '9 005'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 005'
			И я нажимаю на кнопку 'Post and close'
	* Create Shipment confirmation on Crystal without Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '5 607'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '8 999'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Create one more Shipment confirmation on Crystal without Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '5 607'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '9 000'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Create Shipment confirmation to order 9 001
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		Когда открылось окно 'Sales orders'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner' |
			| '9 001'  | 'Crystal' |
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '5 607'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '9 001'
		И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Creating Purchase order to Crystal by agreement Vendor, TRY, Goods receipt before Purchase invoice №9000
		* Open form to create Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor, TRY |
			И в таблице "List" я выбираю текущую строку
		* Change document number to №9000
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '9 000'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 000'
		* Filling in item tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '250'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '210'
			И в таблице "ItemList" я завершаю редактирование строки
		* Post document
			И я нажимаю на кнопку 'Post and close'
	* Create Purchase order to Crystal, Vendor, TRY, Goods receipt before Purchase invoice № 9001
		* Open form to create Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor, TRY |
			И в таблице "List" я выбираю текущую строку
		* Filling in item tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '9 001'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 001'
			И я нажимаю на кнопку 'Post and close'
	* Create Purchase order to Crystal, Vendor, USD, Goods receipt before Purchase invoice № 9003
		* Open form to create Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor, USD |
			И в таблице "List" я выбираю текущую строку
		* Filling in item tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '990'
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '9 003'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 003'
			И я нажимаю на кнопку 'Post and close'
	* Create Purchase order to Crystal, Vendor, TRY, Purchase invoice before Goods receipt № 9004
		* Open form to create Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Crystal   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor, TRY |
			И в таблице "List" я выбираю текущую строку
		* Filling in item tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '990'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я завершаю редактирование строки
		* Change document number
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '9 004'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 004'
			И я нажимаю на кнопку 'Post and close'
	* Create Purchase order to Astar по Vendor, TRY, Purchase invoice before Goods receipt № 9005
		* Open form to create Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Astar   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor, TRY |
			И в таблице "List" я выбираю текущую строку
		* Filling in item tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '990'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я завершаю редактирование строки
		* Change document number
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '9 005'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 005'
			И я нажимаю на кнопку 'Post and close'
	* Create Purchase order to Astar по Vendor, TRY, Purchase invoice before Goods receipt, one Store use Goods receipt the other does not № 9002
		* Open form to create Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Astar   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor, TRY |
			И в таблице "List" я выбираю текущую строку
		* Filling in item tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Unit"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Boots (12 pcs)' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '990'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
		* Change document number
			И я перехожу к закладке "Other"
			И я снимаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '9 002'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 002'
			И я нажимаю на кнопку 'Post and close'
	* Create Purchase order to Astar по Vendor, TRY, Goods receipt before Purchase invoice, one Store use Goods receipt the other does not № 9002
		* Open form to create Purchase Order
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Astar   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor, TRY |
			И в таблице "List" я выбираю текущую строку
		* Filling in item tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'M/White'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| '36/Yellow'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '12,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '300'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
		* Specify shipping scheme and document number
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '9 006'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 006'
			И я нажимаю на кнопку 'Post and close'




Сценарий: _2040002 Sales order selection button in the Sales invoice document
# works to select Sales order when Sales invoice before Shipment confirmation. Selection by agreement, partner, legal name, company. Displays uncovered documents
	* Open a creation form SI 
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Select Sales order
		И в таблице "ItemList" я нажимаю на кнопку 'Select sales orders'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Sales order'                                 | 'Use' |
		| 'Sales order 9 000*'                          | 'No'  |
		| 'Shirt, 38/Black, pcs, 2,000'                 | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 1,000'       | 'No'  |
		| 'Boots, 37/18SD, pcs, 1,000'                  | 'No'  |
		| 'Sales order 9 002*'                          | 'No'  |
		| 'Dress, M/White, pcs, 4,000'                  | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 1,000'       | 'No'  |
		| 'Boots, 37/18SD, pcs, 1,000'                  | 'No'  |
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Item key' | 'Q'     | 'Price type'        | 'Unit'           | 'Store'    | 'Sales order'        |
		| 'Shirt' | '38/Black' | '2,000' | 'Basic Price Types' | 'pcs'            | 'Store 02' | 'Sales order 9 000*' |
		| 'Boots' | '36/18SD'  | '1,000' | 'Basic Price Types' | 'Boots (12 pcs)' | 'Store 02' | 'Sales order 9 000*' |
		| 'Boots' | '37/18SD'  | '1,000' | 'Basic Price Types' | 'pcs'            | 'Store 02' | 'Sales order 9 000*' |
		| 'Dress' | 'M/White'  | '4,000' | 'Basic Price Types' | 'pcs'            | 'Store 02' | 'Sales order 9 002*' |
		| 'Boots' | '36/18SD'  | '1,000' | 'Basic Price Types' | 'Boots (12 pcs)' | 'Store 02' | 'Sales order 9 002*' |
		Тогда в таблице "ItemList" количество строк "меньше или равно" 6
	* Check that the quantity already added by rows is not available to select products from Sales order
		И в таблице "ItemList" я перехожу к последней строке
		# | 'Item'  | 'Item key' | 'Sales order'        |
		# | 'Boots' | '37/18SD'  | 'Sales order 9 002*' |
		И в таблице 'ItemList' я удаляю строку
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key' | 'Q'     |
		| 'Dress' | 'M/White'  | '4,000' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку 'Select sales orders'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Sales order'                | 'Use' |
		| 'Sales order 9 002*'         | 'No'  |
		| 'Dress, M/White, pcs, 2,000' | 'No'  |
		| 'Boots, 37/18SD, pcs, 1,000' | 'No'  |
		И я нажимаю на кнопку 'Cancel'
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '9 000'
		И я нажимаю на кнопку 'Post and close'
	* Create one more Sales invoice for the remainder
		* Open a creation form SI 
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Select Sales order
			И в таблице "ItemList" я нажимаю на кнопку 'Select sales orders'
			Тогда таблица "DocumentsTree" содержит строки:
			| 'Sales order'                | 'Use' |
			| 'Sales order 9 002*'         | 'No'  |
			| 'Dress, M/White, pcs, 2,000' | 'No'  |
			| 'Boots, 37/18SD, pcs, 1,000' | 'No'  |
			И я нажимаю на кнопку с именем 'FormSelectAll'
			И я нажимаю на кнопку 'Ok'
		* Change the document number
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 002'
			И я нажимаю на кнопку 'Post and close'
	* Create Sales invoice by partner term Basic Partner terms, without VAT
		* Open a creation form SI 
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
		* Select Sales order
			И в таблице "ItemList" я нажимаю на кнопку 'Select sales orders'
			Тогда таблица "DocumentsTree" содержит строки:
			| 'Sales order'                           | 'Use' |
			| 'Sales order 9 004*'                    | 'No'  |
			| 'Dress, M/White, pcs, 8,000'            | 'No'  |
			| 'Boots, 36/18SD, Boots (12 pcs), 1,000' | 'No'  |
			| 'Boots, 37/18SD, pcs, 1,000'            | 'No'  |
			| 'Sales order 9 005*'                    | 'No'  |
			| 'Dress, S/Yellow, pcs, 8,000'           | 'No'  |
			| 'Boots, 36/18SD, Boots (12 pcs), 1,000' | 'No'  |
			| 'Boots, 37/18SD, pcs, 1,000'            | 'No'  |
			И я нажимаю на кнопку с именем 'FormSelectAll'
			И я нажимаю на кнопку 'Ok'
		* Change the document number
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 003'
			И я нажимаю на кнопку 'Post and close'


Сценарий: _2040003 selection button Shipment confirmation in Sales invoice document
# works to select Shipment confirmation when Shipment confirmation before Sales invoice. Selection by partner, legal name, company. Displays uncovered documents
	* Open a creation form SI 
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, without VAT' |
		И в таблице "List" я выбираю текущую строку
	* Check Shippment confirmation by partner terms
		И в таблице "ItemList" я нажимаю на кнопку 'Select shipment confirmations'
		И я нажимаю на кнопку с именем 'FormSelectAll'
		Тогда таблица "ShipmentConfirmationsTree" содержит строки:
			| 'Order'                        | 'Use'                          |
			| ''                             | ''                             |
			| 'Shipment confirmation 8 999*' | 'Yes'                          |
			| 'Shirt, 38/Black, pcs, 10,000' | 'Shirt, 38/Black, pcs, 10,000' |
			| 'Shipment confirmation 9 000*' | 'Yes'                          |
			| 'Dress, M/White, pcs, 10,000'  | 'Dress, M/White, pcs, 10,000'  |
		И я нажимаю на кнопку 'Ok'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 2
		* Change of agreement and check of selection
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           | 'Kind'    |
				| 'Basic Partner terms, TRY' | 'Regular' |
			И в таблице "List" я выбираю текущую строку
			И я изменяю флаг 'Update filled stores on Store 01'
			И я изменяю флаг 'Update filled price types on Basic Price Types'
			И я изменяю флаг 'Update filled prices.'
			И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я нажимаю на кнопку 'Select shipment confirmations'
		Тогда таблица "ShipmentConfirmationsTree" содержит строки:
		| 'Order'                        | 'Use'                         |
		| 'Sales order 9 001*'           | 'Sales order 9 001*'          |
		| 'Shipment confirmation 9 001*' | 'No'                          |
		| 'Dress, S/Yellow, pcs, 8,000'  | 'Dress, S/Yellow, pcs, 8,000' |
		| 'Boots, 36/18SD, pcs, 12,000'  | 'Boots, 36/18SD, pcs, 12,000' |
		| 'Boots, 37/18SD, pcs, 1,000'   | 'Boots, 37/18SD, pcs, 1,000'  |
		И я нажимаю на кнопку 'Ok'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 5
		И Я закрыл все окна клиентского приложения


Сценарий: _2040004 selection of base documents in line in the Shipment confirmation
	* Open a creation form SC
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Store 02' |
		И в таблице "List" я выбираю текущую строку
	* Filling in item tab
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Shipment basis"
		И в таблице "ItemList" я выбираю текущую строку
		Когда Проверяю шаги на Исключение:
		|'И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Shipment basis"'|
		Тогда открылось окно 'Select Receipt basises'
		Тогда таблица "DocumentsTree" содержит строки:
			| 'Currency'                             |
			| 'Sales invoice 9 003*'                 |
			| 'Dress, M/White, pcs, 8,000, Store 02' |
			| 'Sales invoice 9 000*'                 |
			| 'Dress, M/White, pcs, 2,000, Store 02' |
			| 'Sales invoice 9 002*'                 |
			| 'Dress, M/White, pcs, 2,000, Store 02' |
		И в таблице "DocumentsTree" я перехожу к последней строке
		И в таблице "DocumentsTree" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Check for product selections when adding a line
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Shipment basis"
		И в таблице "ItemList" я выбираю текущую строку
		Когда Проверяю шаги на Исключение:
		|'И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Shipment basis"'|
		Тогда таблица "DocumentsTree" содержит строки:
			| 'Currency'                              |
			| 'Sales invoice 9 003*'                  |
			| 'Dress, S/Yellow, pcs, 8,000, Store 02' |
		Тогда таблица "DocumentsTree" не содержит строки:
			| 'Currency'                              |
			| 'Sales invoice 9 002*'                  |
			| 'Dress, M/White, pcs, 2,000, Store 02' |
		И в таблице "DocumentsTree" я перехожу к последней строке
		И в таблице "DocumentsTree" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	И Я закрыл все окна клиентского приложения




Сценарий: _2040005 purchase order selection button in Purchase invoice document
# works to select Purchase order when Purchase invoice before Goods receipt. Selection by agreement, partner, legal name, company. Displays uncovered documents
	* Open a creation form PI 
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Select Purchase order
		И я нажимаю на кнопку 'Select purchase orders'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Purchase order'                        |
		| 'Purchase order 9 000*'                 |
		| 'Dress, M/White, pcs, 10,000'           |
		| 'Trousers, 36/Yellow, pcs, 12,000'      |
		| 'Purchase order 9 004*'                 |
		| 'Dress, M/White, pcs, 3,000'            |
		| 'Trousers, 36/Yellow, pcs, 10,000'      |
		| 'Trousers, 36/Yellow, pcs, 5,000'       |
		| 'Boots, 36/18SD, Boots (12 pcs), 5,000' |
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'      | 'Unit'           |
		| 'Dress'    | 'M/White'   | '10,000' | 'pcs'            |
		| 'Trousers' | '36/Yellow' | '12,000' | 'pcs'            |
		| 'Dress'    | 'M/White'   | '3,000'  | 'pcs'            |
		| 'Trousers' | '36/Yellow' | '10,000' | 'pcs'            |
		| 'Trousers' | '36/Yellow' | '5,000'  | 'pcs'            |
		| 'Boots'    | '36/18SD'   | '5,000'  | 'Boots (12 pcs)' |
		Тогда в таблице "ItemList" количество строк "меньше или равно" 6
	* Check that the quantity already added by rows is not available for selecting products from Purchase order
		И в таблице "ItemList" я перехожу к строке
		| 'Item'  | 'Item key' | 'Q'        |
		| 'Dress' | 'M/White'  | '3,000' |
		И в таблице 'ItemList' я удаляю строку
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key' | 'Q'     |
		| 'Boots' | '36/18SD'  | '5,000' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Select purchase orders'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Purchase order'                        |
		| 'Purchase order 9 004*'                 |
		| 'Dress, M/White, pcs, 3,000'            |
		| 'Boots, 36/18SD, Boots (12 pcs), 3,000' |
		И я нажимаю на кнопку 'Cancel'
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '9 000'
		И я нажимаю на кнопку 'Post and close'
	* Create one more Purchase invoice for the remainder
		* Open a creation form SI 
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Vendor, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Select Purchase order
			И я нажимаю на кнопку 'Select purchase orders'
			Тогда таблица "DocumentsTree" содержит строки:
			| 'Purchase order'                        |
			| 'Purchase order 9 004*'                 |
			| 'Dress, M/White, pcs, 3,000'            |
			| 'Boots, 36/18SD, Boots (12 pcs), 3,000' |
			И я нажимаю на кнопку с именем 'FormSelectAll'
			И я нажимаю на кнопку 'Ok'
		* Change the document number
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 001'
			И я нажимаю на кнопку 'Post and close'
	* Create Purchase invoice to Astar by partner term 'Vendor, TRY'
		* Open a creation form PI 
			И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Astar'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Vendor, TRY' |
			И в таблице "List" я выбираю текущую строку
		* Select Purchase order
			И я нажимаю на кнопку 'Select purchase orders'
			Тогда таблица "DocumentsTree" содержит строки:
			| 'Purchase order'                        |
			| 'Purchase order 9 002*'                 |
			| 'Trousers, 36/Yellow, pcs, 10,000'      |
			| 'Boots, 36/18SD, Boots (12 pcs), 5,000' |
			| 'Dress, M/White, pcs, 3,000'            |
			| 'Trousers, 36/Yellow, pcs, 5,000'       |
			| 'Purchase order 9 005*'                 |
			| 'Dress, M/White, pcs, 3,000'            |
			| 'Trousers, 36/Yellow, pcs, 5,000'       |
			| 'Trousers, 36/Yellow, pcs, 10,000'      |
			| 'Boots, 36/18SD, Boots (12 pcs), 5,000' |
			И я нажимаю на кнопку с именем 'FormSelectAll'
			И я нажимаю на кнопку 'Ok'
			Тогда в таблице "ItemList" количество строк "меньше или равно" 8
			И в таблице "ItemList" я перехожу к последней строке
			И в таблице 'ItemList' я удаляю строку
		* Change the document number
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 003'
			И я нажимаю на кнопку 'Post and close'

Сценарий: _2040006 button for filling items from the base documents in Goods receipt
	# No verification by partner term. A currency check is triggered when posted. There is no check at the store.
	* Open a creation form GR
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Purchase'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Company Adel' |
		И в таблице "List" я выбираю текущую строку
	* Check button Fill 'From basises'
		И я нажимаю на кнопку 'From basises'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Currency'                                         |
		| 'TRY'                                              |
		| 'Purchase invoice 9 000*'                          |
		| 'Dress, M/White, pcs, 10,000, Store 02'            |
		| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
		| 'Trousers, 36/Yellow, pcs, 10,000, Store 02'       |
		| 'Trousers, 36/Yellow, pcs, 12,000, Store 02'       |
		| 'Boots, 36/18SD, Boots (12 pcs), 24,000, Store 02' |
		| 'Purchase invoice 9 001*'                          |
		| 'Dress, M/White, pcs, 3,000, Store 02'             |
		| 'Boots, 36/18SD, Boots (12 pcs), 36,000, Store 02' |
		| 'Purchase order 9 001*'                            |
		| 'Dress, M/White, pcs, 8,000, Store 02'             |
		| 'Trousers, 36/Yellow, pcs, 12,000, Store 02'       |
		| 'USD'                                              |
		| 'Purchase order 9 003*'                            |
		| 'Dress, M/White, pcs, 3,000, Store 02'             |
		| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
		| 'Boots, 36/18SD, Boots (12 pcs), 60,000, Store 02' |
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 11
		# И     таблица "ItemList" содержит строки:
		# | 'Item'     | 'Quantity' | 'Item key'  | 'Store'    | 'Unit'           | 'Receipt basis'           |
		# | 'Dress'    | '10,000'   | 'M/White'   | 'Store 02' | 'pcs'            | 'Purchase invoice 9 000*' |
		# | 'Trousers' | '5,000'    | '36/Yellow' | 'Store 02' | 'pcs'            | 'Purchase invoice 9 000*' |
		# | 'Trousers' | '10,000'   | '36/Yellow' | 'Store 02' | 'pcs'            | 'Purchase invoice 9 000*' |
		# | 'Trousers' | '12,000'   | '36/Yellow' | 'Store 02' | 'pcs'            | 'Purchase invoice 9 000*' |
		# | 'Boots'    | '60,000'   | '36/18SD'   | 'Store 02' | 'pcs'            | 'Purchase invoice 9 001*' |
		# | 'Dress'    | '3,000'    | 'M/White'   | 'Store 02' | 'pcs'            | 'Purchase invoice 9 001*' |
		# | 'Dress'    | '8,000'    | 'M/White'   | 'Store 02' | 'pcs'            | 'Purchase order 9 001*'   |
		# | 'Trousers' | '12,000'   | '36/Yellow' | 'Store 02' | 'pcs'            | 'Purchase order 9 001*'   |
		# | 'Dress'    | '3,000'    | 'M/White'   | 'Store 02' | 'pcs'            | 'Purchase order 9 003*'   |
		# | 'Trousers' | '5,000'    | '36/Yellow' | 'Store 02' | 'pcs'            | 'Purchase order 9 003*'   |
		# | 'Boots'    | '60,000'   | '36/18SD'   | 'Store 02' | 'pcs'            | 'Purchase order 9 003*'   |
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '9 000'
	* Check the display of an error that GR documents with different currencies are selected in GR
		И я нажимаю на кнопку 'Post'
		Затем я жду, что в сообщениях пользователю будет подстрока "Multicurrency receipt basises" в течение 30 секунд
	* Post with the same currency
		И я перехожу к закладке "Items"
		И в таблице "ItemList" я перехожу к строке:
			| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    | 'Unit' |
			| 'USD'      | 'Dress' | 'M/White'  | '3,000'    | 'Store 02' | 'pcs'  |
		И в таблице 'ItemList' я удаляю строку
		И в таблице "ItemList" я перехожу к строке:
			| 'Currency' | 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
			| 'USD'      | 'Trousers' | '36/Yellow' | '5,000'    | 'Store 02' | 'pcs'  |
		И в таблице 'ItemList' я удаляю строку
		И в таблице "ItemList" я перехожу к строке:
			| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'USD'      | 'Boots' | '36/18SD'  | '60,000'   | 'Store 02' |
		И в таблице 'ItemList' я удаляю строку
		И я нажимаю на кнопку 'Post'
		Тогда в окне сообщений пользователю нет сообщений
	* Check that the quantity already added by lines is not available for the choice of goods from the bases documents
		И в таблице "ItemList" я перехожу к строке
		| 'Item'     | 'Item key' | 'Quantity'        |
		| 'Trousers' | '36/Yellow'  | '10,000' |
		И в таблице 'ItemList' я удаляю строку
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'  | 'Item key' | 'Quantity'     |
		| 'Boots' | '36/18SD'  | '60,000' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '24,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'From basises'
		Тогда таблица "DocumentsTree" содержит строки:
		| 'Currency'                                         | 'Use' |
		| 'TRY'                                              | 'No'  |
		| 'Purchase invoice 9 000*'                          | 'No'  |
		| 'Trousers, 36/Yellow, pcs, 10,000, Store 02'       | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 22,000, Store 02' | 'No'  |
		| 'Purchase invoice 9 001*'                          | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 36,000, Store 02' | 'No'  |
		Тогда в таблице "DocumentsTree" количество строк "меньше или равно" 11
		И я нажимаю на кнопку 'Cancel'
		И я нажимаю на кнопку 'Post and close'
	* Create one more Goods receipt for the remainder
		* Open a creation form GR
			И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Purchase'
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Crystal'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Company Adel' |
			И в таблице "List" я выбираю текущую строку
		* Select документов-оснований
			И я нажимаю на кнопку 'From basises'
			Тогда таблица "DocumentsTree" содержит строки:
			| 'Currency'                                         |
			| 'TRY'                                              |
			| 'Purchase invoice 9 000*'                          |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
			| 'Boots, 36/18SD, Boots (12 pcs), 24,000, Store 02' |
			| 'USD'                                              |
			| 'Purchase order 9 003*'                            |
			| 'Dress, M/White, pcs, 3,000, Store 02'             |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
			| 'Boots, 36/18SD, Boots (12 pcs), 60,000, Store 02' |
			И я нажимаю на кнопку с именем 'FormSelectAll'
			И я нажимаю на кнопку 'Ok'
		* Delete lines in dollars
			И я перехожу к закладке "Items"
			И в таблице "ItemList" я перехожу к строке:
				| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    | 'Unit' |
				| 'USD'      | 'Dress' | 'M/White'  | '3,000'    | 'Store 02' | 'pcs'  |
			И в таблице 'ItemList' я удаляю строку
			И в таблице "ItemList" я перехожу к строке:
				| 'Currency' | 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
				| 'USD'      | 'Trousers' | '36/Yellow' | '5,000'    | 'Store 02' | 'pcs'  |
			И в таблице 'ItemList' я удаляю строку
			И в таблице "ItemList" я перехожу к строке:
				| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
				| 'USD'      | 'Boots' | '36/18SD'  | '60,000'   | 'Store 02' |
			И в таблице 'ItemList' я удаляю строку
		# temporarily
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' | 'Quantity' |
				| 'Boots' | '36/18SD'  | '24,000'   |
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListUnit"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'pcs'         |
			И в таблице "List" я выбираю текущую строку
		# temporarily
		* Change the document number
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '0'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9 001'
			И я нажимаю на кнопку 'Post and close'
	
Сценарий: _2040007 button for filling in base documents in Goods receipt
	* Open a creation form GR
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '9 001'     |
		И в таблице "List" я выбираю текущую строку
	* Cleaning of base documents
		И в таблице "ItemList" я перехожу к первой строке
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Receipt basis"
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к следующей строке
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Receipt basis"
		И в таблице "ItemList" я завершаю редактирование строки
	* Fill in the base documents using the Fill receipt basises button
		И я нажимаю на кнопку 'Fill receipt basises'
	* Filling check
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    | 'Unit' | 'Receipt basis'           |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'Store 02' | 'pcs'  | 'Purchase order 9 003*'   |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'Store 02' | 'pcs'  | 'Purchase invoice 9 000*' |
			| 'Boots'    | '24,000'   | '36/18SD'   | 'Store 02' | 'pcs'  | 'Purchase order 9 003*'   |
	* Filling line by line
		И в таблице "ItemList" я перехожу к первой строке
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Receipt basis"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Receipt basis"
		Тогда таблица "DocumentsTree" содержит строки:
			| 'Currency'                                    |
			| 'USD'                                         |
			| 'Purchase order 9 003*'                       |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'   |
			| 'TRY'                                         |
			| 'Purchase invoice 9 000*'                     |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'   |
		И в таблице "DocumentsTree" я перехожу к последней строке
		И в таблице "DocumentsTree" я перехожу на одну строку вверх
		И я нажимаю на кнопку 'Ok'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Currency' | 'Item key'  | 'Store'    | 'Unit' | 'Receipt basis'           |
			| 'Trousers' | '5,000'    | 'TRY'      | '36/Yellow' | 'Store 02' | 'pcs'  | 'Purchase invoice 9 000*' |
			| 'Trousers' | '5,000'    | 'TRY'      | '36/Yellow' | 'Store 02' | 'pcs'  | 'Purchase invoice 9 000*' |
			| 'Boots'    | '24,000'   | 'USD'      | '36/18SD'   | 'Store 02' | 'pcs'  | 'Purchase order 9 003*' |
		И Я закрыл все окна клиентского приложения




Сценарий: _2040008 button to fill in items from Goods receipt in Purchase invoice
	* Open a creation form PI
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Crystal'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Vendor, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Check the button for filling items from Goods receipt
		И я нажимаю на кнопку 'Select goods receipt'
		Тогда таблица "GoodsReceiptTree" содержит строки:
		| 'Order'                            |
		| 'Purchase order 9 001*'            |
		| 'Goods receipt 9 000*'             |
		| 'Dress, M/White, pcs, 8,000'       |
		| 'Trousers, 36/Yellow, pcs, 12,000' |
		Тогда в таблице "GoodsReceiptTree" количество строк "меньше или равно" 4
		И я нажимаю на кнопку с именем 'FormSelectAll'
		И я нажимаю на кнопку 'Ok'
		И Я закрыл все окна клиентского приложения	