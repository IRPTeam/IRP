#language: ru
@tree
@Positive


Функционал: creating missing Item key by Item when creating Purchase Order

As a procurement manager
I want to create an Item key for the items
In order to form an order with a vendor

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _017101 checking input item key by line
	* Opening a form to create a purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in details
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я выбираю текущую строку
	* Filling out vendor information
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
	* Check input item key line by line
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке 's'
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
		| Item  | Item key |
		| Dress | S/Yellow |
		И Я закрываю текущее окно
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'No'


Сценарий: _017102 checking for the creation of the missing item key from the Purchase order document
	* Opening a form to create a purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in details
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я выбираю текущую строку
	* Filling out vendor information
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
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| Description        |
			| Vendor Ferron, TRY |
		И в таблице "List" я выбираю текущую строку
	* Creating an item key when filling out the tabular part
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И из выпадающего списка "Size" я выбираю по строке 'xxl'
		И из выпадающего списка "Color" я выбираю по строке 'red'
		И я нажимаю на кнопку 'Create new'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2	
		И в поле 'Size' я ввожу текст ''
		И в поле 'Color' я ввожу текст ''
		Тогда таблица "List" стала равной:
		| Item key  | Item  |
		| S/Yellow  | Dress |
		| XS/Blue   | Dress |
		| M/White   | Dress |
		| L/Green   | Dress |
		| XL/Green  | Dress |
		| Dress/A-8 | Dress |
		| XXL/Red   | Dress |
		И Я закрываю текущее окно
		И Я закрываю текущее окно
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'No'


Сценарий: _017105 filter when selecting item key in a purchase order document
	* Opening a form to create a purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in details
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я выбираю текущую строку
	* Filling out vendor information
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
	* Filter check on item key when filling out the commodity part
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И из выпадающего списка "Size" я выбираю по строке 'l'
		Тогда таблица "List" стала равной:
		| Item key |
		| L/Green  |
		| Dress/A-8  |
		И в поле 'Size' я ввожу текст ''
		И из выпадающего списка "Color" я выбираю по строке 'gr'
		Тогда таблица "List" стала равной:
		| Item key |
		| L/Green  |
		| XL/Green |
		| Dress/A-8  |
		И Я закрываю текущее окно
		И Я закрываю текущее окно
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'No'