#language: ru
@tree
@Positive

Функционал: Check filling inи перезаполнения возвратов

Как тестировщик
Я хочу проверить заполнение и перезаполнение возвратов


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _299901 Check filling inи перезаполнения Sales return order
	* Открытие формы Sales return order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inPartner term если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by Standard Partner term Customer'
	* Check filling inCompany из Partner term
		* Изменение компании в Sales return order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Проверка очистки legal name, Partner term при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling inLegal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling inсклада и компании из Partner term при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling inцены при добавлении Item и выборе item key
		* Заполнение item и Item key
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
		* Проверка перезаполнения склада в добавленной строке и цены
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 02' |
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Добавление строки
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


Сценарий: _299902 Check filling inи перезаполнения Sales return
	* Открытие формы Sales return
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inPartner term если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Nicoletta'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by Standard Partner term Customer'
	* Check filling inCompany из Partner term
		* Изменение компании в Sales return order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Проверка очистки legal name, Partner term при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling inLegal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
	* Check filling inсклада и компании из Partner term при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Заполнение item и Item key
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
		* Перевыбор соглашения
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
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Добавление строки
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

Сценарий: _299903 Check filling inи перезаполнения Purchase return order
	* Открытие формы Purchase return order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inPartner term если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by standart Partner term (Veritas)'
	* Check filling inCompany из Partner term
		* Изменение компании в Purchase return order
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Проверка очистки legal name, Partner term при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling inLegal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
	* Check filling inсклада и компании из Partner term при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Заполнение item и Item key
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
		* Перевыбор соглашения
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
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Добавление строки
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

Сценарий: _299904 Check filling inи перезаполнения Purchase return
	* Открытие формы Purchase return
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inlegal name если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
	* Check filling inPartner term если оно у партнера одно
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Veritas'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Agreement" стал равен 'Posting by Standard Partner term (Veritas)'
	* Check filling inCompany из Partner term
		* Изменение компании в Purchase return
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'    |
				| 'Second Company' |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "Company" стал равен 'Second Company'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Проверка перезаполнения при выборе соглашения
			И     элемент формы с именем "Company" стал равен 'Main Company'
	* Check filling inStore из Partner term
		И     элемент формы с именем "Store" стал равен 'Store 01'
	* Проверка очистки legal name, Partner term при перевыборе партнера
		* Перевыбор партнера
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Partner Kalipso'     |
			И в таблице "List" я выбираю текущую строку
		* Проверка очистки полей
			И     элемент формы с именем "Agreement" стал равен ''
		* Check filling in Legal name после перевыбора партнера
			И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		* Выбор соглашения
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			И в таблице "List" я выбираю текущую строку
	* Check filling inсклада и компании из Partner term при перевыборе партнера
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	* Проверка авто заполнения item key при добавлении Item (у Item один item key)
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Router'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Заполнение item и Item key
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
		* Перевыбор соглашения
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
	* Проверка перерисовки формы по налогам при перевыборе компании
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
	* Добавление строки
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

	
	