#language: ru
@tree
@Positive


Функционал: barcode management

As a developer
I want to add barcode functionality
To work with the products


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _0905 barcode registry entry
	И я удаляю все записи РегистрСведений "Barcodes"
	* Adding barcode entries for Dress
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Barcode' я ввожу текст '2202283705'
		И я нажимаю кнопку выбора у поля "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | XS/Blue  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs         |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Presentation' я ввожу текст '2202283705'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Barcode' я ввожу текст '2202283713'
		И я нажимаю кнопку выбора у поля "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | S/Yellow |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Unit" я выбираю по строке 'pcs'
		И в поле 'Presentation' я ввожу текст '2202283713'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Barcode' я ввожу текст '2202283739'
		И я нажимаю кнопку выбора у поля "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Dress | L/Green  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs         |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Presentation' я ввожу текст '2202283739'
		И я нажимаю на кнопку 'Save and close'
	И Я закрыл все окна клиентского приложения
	* Adding barcode entries for Boots
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Barcode' я ввожу текст '4820024700016'
		И я нажимаю кнопку выбора у поля "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 36/18SD  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs         |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Presentation' я ввожу текст '4820024700016'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Barcode' я ввожу текст '978020137962'
		И я нажимаю кнопку выбора у поля "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| Item  | Item key |
			| Boots | 37/18SD  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs         |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Presentation' я ввожу текст '978020137962'
		И я нажимаю на кнопку 'Save and close'
	И Я закрыл все окна клиентского приложения

Сценарий: _0906 check barcode display by Item and item key
	* Opening the item catalog and selecting Dress
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
	* CheckingItem barcodes by Item
		И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
		Тогда таблица "List" содержит строки:
		| 'Barcode'    | 'Unit' | 'Item key' |
		| '2202283705' | 'pcs'  | 'XS/Blue'  |
		| '2202283713' | 'pcs'  | 'S/Yellow' |
		| '2202283739' | 'pcs'  | 'L/Green'  |
	* CheckingItem barcodes by Item key
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И в таблице "List" я перехожу к строке:
		| 'Item key' |
		| 'S/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
		Тогда таблица "List" содержит строки:
		| 'Barcode'    | 'Unit' | 'Item key' |
		| '2202283713' | 'pcs'  | 'S/Yellow' |
	И Я закрыл все окна клиентского приложения




