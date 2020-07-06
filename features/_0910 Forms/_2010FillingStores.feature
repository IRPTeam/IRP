#language: ru
@tree
@Positive

Функционал: filling of stores in documents




Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: check filling in Store field in the document Sales order
	* Opening a document form Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Partner and Legal name
	# the other details are filled in from the custom settings
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Legal name" я выбираю по строке 'comp'
	* Filling in items tab
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'dre'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке 'xs'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'sh'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	*Check filling in Sales order
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Status" стал равен 'Approved'
		И     элемент формы с именем "Store" стал равен 'Store 01'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Change store on Store 03 (not specified in agreement or settings)
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Cleaning the store value
		И в поле с именем 'Store' я ввожу текст ''
		И я нажимаю на кнопку 'OK'
	* Check filling in store from agreement
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Choosing an agreement with an empty store field
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron, USD' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
		И Я закрыл все окна клиентского приложения

Сценарий: check filling in Store field in the document Sales invoice
	* Opening a document form Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Partner and Legal name
	# the other details are filled in from the custom settings
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Legal name" я выбираю по строке 'comp'
	* Filling in items tab
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'dre'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке 'xs'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'sh'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check filling in Sales order
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Store" стал равен 'Store 01'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Change store on Store 03 (not specified in agreement or settings)
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Cleaning the store value
		И в поле с именем 'Store' я ввожу текст ''
		И я нажимаю на кнопку 'OK'
	* Check filling in store from agreement
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Choosing an agreement with an empty store field
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron, USD' |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
		И Я закрыл все окна клиентского приложения

Сценарий: check filling in Store field in the document Purchase order
	* Opening a document form Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in partner, legal name, partner term (store not specified)
	# the other details are filled in from the custom settings
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
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filling in items tab
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'dre'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке 'xs'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'sh'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check filling in Purchase order
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Store" стал равен 'Store 03'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Changing store on Store 02 (not specified in the partner terms or in the settings)
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
	* Cleaning the store value
		И в поле с именем 'Store' я ввожу текст ''
		И я нажимаю на кнопку 'OK'
	* Check filling in store from user settings (store not specified in agreement)
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Re-selecting a partner term with an empty store and check filling in the store from user settings
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
		И Я закрыл все окна клиентского приложения


Сценарий: check filling in Store field in the document Purchase invoice
	* Opening a document form Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in partner, legal name, partner term (store not specified)
	# the other details are filled in from the custom settings
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
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Filling in items tab
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'dre'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке 'xs'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'sh'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check filling in Purchase order
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
	* Change of store on Store 04 (not specified either in the partner terms or in the settings)
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 04'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 04' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 04' |
	* Cleaning the store value
		И в поле с именем 'Store' я ввожу текст ''
		И я нажимаю на кнопку 'OK'
	* Check filling in store from user settings (store in partner term not specified)
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
	* Re-selecting a partner term with an empty store and check filling in the store from user settings
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
		И Я закрыл все окна клиентского приложения


Сценарий: _0154516  check filling in Store field in the Shipment confirmation
	* Open a creation form Shipment confirmation
		И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
		И я нажимаю на кнопку 'Create'
	* Fillin in store and items tab
		* Filling store and type of operation
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
		* Add first line with the product
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Add second line
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
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListStore"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Check filling in store by lines
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 02' |
		* Change the store in the header and check the refill by lines
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			* Вывод информационного сообщения
				Когда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 03' |
		* Delete a line
			И в таблице "ItemList" я перехожу к последней строке
			И в таблице "ItemList" я удаляю текущую строку
		* Checking that the warehouse is not cleared on the lines with the products
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
			| 'Trousers' | '38/Yellow' | '2,000'    | 'Store 03' | 'pcs'  |
			И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле с именем 'ItemListStore' я ввожу текст ''
			И в таблице "ItemList" я завершаю редактирование строки
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			И в поле с именем 'Store' я ввожу текст ''
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'No'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			И Я закрыл все окна клиентского приложения


Сценарий: _0154517  check filling in Store field in the Goods receipt
	* Open a creation form Goods receipt
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И я нажимаю на кнопку 'Create'
	* Fillin in store and items tab
		* Filling store and type of operation
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Purchase'
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
		* Adding the first line with the product
			И я нажимаю на кнопку 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Add second line
			И я нажимаю на кнопку 'Add'
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
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListStore"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Check filling in store by lines
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 02' |
		* Change the store in the header and check the refill by lines
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'    |
			И в таблице "List" я выбираю текущую строку
			* Вывод информационного сообщения
				Когда открылось окно '1C:Enterprise'
				И я нажимаю на кнопку 'Yes'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 03' |
		* Delete a line
			И в таблице "ItemList" я перехожу к последней строке
			И в таблице "ItemList" я удаляю текущую строку
		* Checking that the warehouse is not cleared on the lines with the products
			И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
			| 'Trousers' | '38/Yellow' | '2,000'    | 'Store 03' | 'pcs'  |
			И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле с именем 'ItemListStore' я ввожу текст ''
			И в таблице "ItemList" я завершаю редактирование строки
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			И в поле с именем 'Store' я ввожу текст ''
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'No'
			И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			И Я закрыл все окна клиентского приложения