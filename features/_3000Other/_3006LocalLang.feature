#language: ru
@tree
@Positive


Функционал: data multi-language

Как Разработчик
Я хочу разработать механизм
Для хранения данных на разных языках

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.



Сценарий: _300601 display check Description tr
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
	Тогда таблица "List" содержит строки:
		| Description             | Item type  |
		| Dress TR                | Сlothes TR |
		| Trousers TR             | Сlothes TR |
		| Shirt TR                | Сlothes TR |
		| Boots TR                | Shoes TR   |
		| High shoes TR           | Shoes TR   |
		| Box TR                  | Box TR     |
		| Bound Dress+Shirt TR    | Сlothes TR |
		| Bound Dress+Trousers TR | Сlothes TR |
		| Service TR              | Service TR |
		| Router                  | Equipment  |
	И я закрыл все окна клиентского приложения

Сценарий: _300602 check that the English name of the catalog element is saved and displayed in the list
	* Подготовка
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| 'Predefined data item name' |
			| 'Catalog_Items'             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я перехожу к строке:
			| 'Attribute'  | 'UI group'           |
			| 'Article TR' | 'Accounting information TR' |
		И в таблице "Attributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
	И я создаю номенклатуру только с английским наименованием
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля "TR"
		И в поле 'ENG' я ввожу текст 'Skittles'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Item type"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'TR' я ввожу текст 'Candy TR'
		И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
		И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'TR' я ввожу текст 'Taste TR'
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Candy TR       |
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю кнопку выбора у поля "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| adet        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save'
	И я проверяю отображение наименования в форме Item
		И     элемент формы с именем "Description_en" стал равен 'Skittles'
		И     элемент формы с именем "Description_tr" стал равен ''
	И я закрыл все окна клиентского приложения
	И я проверяю отображение наименования в списке
		# если нет Description_tr, то должен отобразиться Description_en
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		Тогда таблица "List" содержит строки:
		| Description             |
		| Skittles                |

Сценарий: _300603 search by Description_en and Description_tr in the Items catalog
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
	И я нажимаю на кнопку с именем 'FormFind'
	И из выпадающего списка "&Search in" я выбираю точное значение 'Description'
	И в поле 'F&ind' я ввожу текст 'tles'
	И я нажимаю на кнопку '&Find'
	Тогда таблица "List" стала равной:
		| Description |
		| Skittles    |
	И я нажимаю на кнопку с именем 'FormCancelSearch'
	И я нажимаю на кнопку с именем 'FormFind'
	И из выпадающего списка "&Search in" я выбираю точное значение 'Description'
	И в поле 'F&ind' я ввожу текст 'tr'
	И я нажимаю на кнопку '&Find'
	Тогда таблица "List" не содержит строки:
		| Description             |
		| Skittles                |
	И я закрыл все окна клиентского приложения



Сценарий: _300604 Turkish description search in Sales order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я проверяю отображение списка
		Тогда таблица "List" содержит строки:
		| 'Number' |'Partner'          | 'Status'      | 'Σ'         | 'Currency' | 'Reference'        |
		| '1'      |'Ferron BP TR'     | 'Approved TR' | '4 350,00'  | 'TRY'      | 'Sales order 1*'   |
	И я проверяю поиск наименований на турецком в форме заказа
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле "Partner" я ввожу текст "Kalipso TR"
		И из выпадающего списка "Partner" я выбираю по строке 'kali'
		И в поле "Legal name" я ввожу текст "Kalip"
		И из выпадающего списка "Legal name" я выбираю по строке 'kali'
		И я нажимаю кнопку выбора у поля "Partner term"
		Тогда открылось окно 'Partner terms'
		И в таблице "List" я перехожу к строке:
			| Description           |
			| Basic Partner terms, TRY |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Partner" стал равен 'Kalipso TR'
		И     элемент формы с именем "LegalName" стал равен 'Company Kalipso TR'
		И     элемент формы с именем "Status" стал равен 'Approved TR'
		И     элемент формы с именем "Company" стал равен 'Main Company TR'
		И     элемент формы с именем "Store" стал равен 'Store 01 TR'
	* Filling in items table
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'skit'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Shirt TR    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item     | Item key    |
			| Shirt TR | 38/Black TR |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| Item     |
			| Skittles |
		И в таблице 'ItemList' я удаляю строку
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Item key'    | 'Q'     |
			| 'Shirt TR' | '38/Black TR' | '1,000' |
		И я закрыл все окна клиентского приложения



Сценарий: _300605 check the display of the Turkish name in the list by the element for which initially there was only an English name
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
	И в таблице "List" я перехожу к строке:
		| Description    |
		| Skittles       |
	И в таблице "List" я выбираю текущую строку
	И в поле 'TR' я ввожу текст 'Skittles TR'
	И я нажимаю на кнопку 'Save and close'
	Тогда таблица "List" содержит строки:
		| Description             | Item type     |
		| Skittles TR             | Candy TR      |
	И я закрыл все окна клиентского приложения


Сценарий: _300606 check the opening of the catalog element for which the additional details filter is installed (English locale)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	И в таблице "List" я перехожу к строке:
		| Description    |
		| Ferron BP TR       |
	Тогда не появилось окно предупреждения системы
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно "Ferron BP TR (Partner)"
	И я закрыл все окна клиентского приложения

Сценарий: _300607 checking the display of names in Turkish in the forms of the list of catalogs
	И я проверяю форму списка Catalog.AccessGroups
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AccessGroups'
		Тогда таблица "List" содержит строки:
			| Description         |
			| Admin TR            |
			| Commercial Agent TR |
			| Manager TR          |
			| Administrators TR   |
			| Financier TR        |
	И я закрыл все окна клиентского приложения
	












