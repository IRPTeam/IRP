#language: ru
@tree
@Positive


Функционал: check specification filling 



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.
	
Сценарий: _206001 check message output when creating a Bundle with empty item
	* Open the list of specifications
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the Bundle name and items (without quantity)
		И я меняю значение переключателя 'Type' на 'Bundle'
		И в поле 'ENG' я ввожу текст 'Test'
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Bound Dress+Trousers' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Blue'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save'
	* Check the output of the message that the quantity is not filled
		Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Quantity] is empty" в течение 10 секунд
	* Filling in the quantity and check the saving
		И в таблице "FormTable*" я выбираю текущую строку
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
		Тогда я проверяю наличие элемента справочника "Specifications" со значением поля "Description_en" "Test"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Test'        |
		И в таблице "List" я выбираю текущую строку
	* Checking for errors when saving without a filled item
		И в поле 'Item' я ввожу текст ''
		И я нажимаю на кнопку 'Save'
		* Check the output of the message that the item is not filled
			Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Item] is empty" в течение 10 секунд
	* Checking for errors when saving without a filled item bundle
		И я нажимаю кнопку выбора у поля "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'White'       |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в поле 'Item bundle' я ввожу текст ''
		И я нажимаю на кнопку 'Save'
		* Check the output of the message that the item bundle is not filled
			Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Item Bundle] is empty" в течение 10 секунд
	* Checking for errors when saving without a filled property
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Bound Dress+Trousers' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я выбираю текущую строку
		И В таблице "FormTable*" я нажимаю кнопку очистить у поля "Color"
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save'
		* Check the output of the message that the quantity is not filled
			Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Color] is empty" в течение 10 секунд
	* Check for errors when saving with the same lines
		И в таблице "FormTable*" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Yellow'      |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		И в таблице "List" я активизирую поле "Description"
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Yellow'      |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" я выбираю текущую строку
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save'
		* Check the output of the message that the quantity is not filled
			Затем я жду, что в сообщениях пользователю будет подстрока "Value is not unique" в течение 10 секунд
	* Delete double and check saving
		И в таблице 'FormTable*' я удаляю строку
		И я нажимаю на кнопку 'Save'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Test (Specification) *' в течение 10 секунд
		Тогда я проверяю наличие элемента справочника "Specifications" со значением поля "Description_en" "Test"
	* Mark to delete the created specification
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Type'   |
			| 'Test'        | 'Bundle' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
	И я закрыл все окна клиентского приложения


Сценарий: create a specification double
	# the double is created for the A-8 specification
	* Open specification catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		Тогда я проверяю наличие элемента справочника "Specifications" со значением поля "Description_en" "A-8"
	* Create a copy of the A-8 specification set
		И я нажимаю на кнопку с именем "FormCreate"
		И я меняю значение переключателя 'Type' на 'Set'
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сlothes'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'XS'          |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Blue'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'M'           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Brown'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'L'           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Green'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Duplicate A-8'
		И в поле 'TR' я ввожу текст 'Duplicate A-8'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save'
	* Check the output message that the specification cannot be saved
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Specification is not unique" в течение 10 секунд
		И я закрыл все окна клиентского приложения


