#language: ru
@tree
@Positive
@NotCritical

Функционал: check required fields



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.
	
Сценарий: check of the sign of required filling at the additional attribute and check for filling
	* Opening of additional details settings
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
	* Check of the sign of required filling at the additional attribute for Item
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Items'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я перехожу к строке:
			| 'Attribute'  |
			| 'Article'    |
		И в таблице "Attributes" я активизирую поле "Required"
		И в таблице "Attributes" я устанавливаю флаг 'Required'
		И в таблице "Attributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Check of the sign of required filling at the additional attribute for item key (shoes)
		И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shoes'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я перехожу к строке:
			| 'Attribute' |
			| 'Season'    |
		И в таблице "AvailableAttributes" я активизирую поле "Required"
		И в таблице "AvailableAttributes" я устанавливаю флаг 'Required'
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Check that the Article in Item is required to be filled in
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Article' я ввожу текст ''
		И я нажимаю на кнопку 'Save'
		Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Article] is empty" в течение 30 секунд
		И Я закрыл все окна клиентского приложения
	* Check that the Season account in the Item key is required by Shoes
		И я открываю навигационную ссылку "e1cib/list/Catalog.ItemKeys"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Season' я ввожу текст ''
		И я нажимаю на кнопку 'Save'
		Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Season] is empty" в течение 30 секунд
		И Я закрыл все окна клиентского приложения
	* Putt in an optional filling in the details
		* Открытие настроек доп реквизитов
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
	* Check of the sign of required filling at the additional attribute for Item
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Items'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я перехожу к строке:
			| 'Attribute'  |
			| 'Article'    |
		И в таблице "Attributes" я активизирую поле "Required"
		И в таблице "Attributes" я снимаю флаг 'Required'
		И в таблице "Attributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Check of the sign of required filling at the additional attribute for item key (обувь)
		И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shoes'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я перехожу к строке:
			| 'Attribute' |
			| 'Season'    |
		И в таблице "AvailableAttributes" я активизирую поле "Required"
		И в таблице "AvailableAttributes" я снимаю флаг 'Required'
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'







