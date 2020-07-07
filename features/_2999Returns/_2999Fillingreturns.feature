#language: ru
@tree
@Positive

Функционал: check filling in and re-filling возвратов

Как тестировщик
Я хочу проверить заполнение и перезаполнение возвратов


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _299901 check filling in and re-filling Sales return order
	* Открытие формы Sales return order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by Standard Partner term Customer'
	* Check filling in Company from Partner term
		* Изменение компании в Sales return order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selecting a partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
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
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
		* Check store and price re-filling in the added line
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 02' |
	* Check the re-drawing of the form for taxes at company re-selection.
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 02' |
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Проверка очистки строки в дереве налогов при удалении строки из заявки на возврат
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
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
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И Я закрыл все окна клиентского приложения


Сценарий: _299902 check filling in and re-filling Sales return
	* Открытие формы Sales return
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by Standard Partner term Customer'
	* Check filling in Company from Partner term
		* Изменение компании в Sales return order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selecting a partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
			И я нажимаю на кнопку 'Add'
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
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
	* Проверка перезаполнения склада при перевыборе соглашения
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка перезаполнения склада в добавленной строке
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Проверка очистки строки в дереве налогов при удалении строки из заявки на возврат
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
		И я нажимаю на кнопку 'Add'
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
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И Я закрыл все окна клиентского приложения

Сценарий: _299903 check filling in and re-filling Purchase return order
	* Открытие формы Purchase return order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by standart Partner term (Veritas)'
	* Check filling in Company from Partner term
		* Изменение компании в Purchase return order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selecting a partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
			И я нажимаю на кнопку 'Add'
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
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
	* Проверка перезаполнения склада при перевыборе соглашения
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка перезаполнения склада в добавленной строке
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Проверка очистки строки в дереве налогов при удалении строки из заявки на возврат
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
		И я нажимаю на кнопку 'Add'
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
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И Я закрыл все окна клиентского приложения

Сценарий: _299904 check filling in and re-filling Purchase return
	* Открытие формы Purchase return
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling in legal name if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling in Partner term if the partner has only one
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by Standard Partner term (Veritas)'
	* Check filling in Company from Partner term
		* Изменение компании в Purchase return
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Check the refill when selecting a partner term
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling in Store from Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Check clearing fields
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in legal name after re-selecting a partner
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
	* Check filling in Store and Compane from Partner term when re-selection partner
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Check the item key autofill when adding Item (Item has one item key)
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Filling in item and item key
			И в таблице 'ItemList' я удаляю строку
			И я нажимаю на кнопку 'Add'
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
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
	* Проверка перезаполнения склада при перевыборе соглашения
		* Re-select partner term
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			И в таблице "List" я выбираю текущую строку
			Когда открылось окно 'Update item list info'
			И я нажимаю на кнопку 'OK'
		* Проверка перезаполнения склада в добавленной строке
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		Если в таблице "ItemList" нет колонки "VAT" Тогда
	* Проверка очистки строки в дереве налогов при удалении строки из заявки на возврат
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице 'ItemList' я удаляю строку
		И я перехожу к закладке "Tax list"
		Тогда таблица "ItemList" не содержит строки:
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
		И я нажимаю на кнопку 'Add'
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
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И Я закрыл все окна клиентского приложения

	
	