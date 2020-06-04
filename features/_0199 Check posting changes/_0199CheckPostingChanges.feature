#language: ru
@tree
@Positive


Функционал: отображение изменений в регистрах при изменении ранее проведенных документов 

Как Разработчик
Я хочу разработать систему проверки необходимости изменении проводок при изменении документов
Для того чтобы не задвоить проводки по регистрам

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _019901 проверка изменения проводок по документу Purchase Order при изменении количества
	Когда создаю документ Purchase Order
	Когда устанавливаю номер Purchase order №103
	И я проверяю проводки по регистру OrderBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | '2'           | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | '3'           | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | '4'           | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | '5'           | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '6'           | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '7'           | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | '8'           | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | '9'           | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '10'          | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '11'          | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '12'          | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
		И Я закрыл все окна клиентского приложения
	И я меняю количество по Item Dress 'S/Yellow' на 250 штук
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'        | 'Unit' |
			| 'Dress' | 'S/Yellow' | '200,000'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '250,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	И я проверяю изменение записей регистра OrderBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
	
Сценарий: _019902 проверка изменения проводок по документу Purchase Order при удалении строк
	И я удаляю последнюю строку из заказа
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я перехожу к последней строке
		И в таблице "ItemList" я удаляю текущую строку
		И я нажимаю на кнопку 'Post and close'
	И я проверяю изменение записей регистра OrderBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | '12'          | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
	
Сценарий: _019903 проверка изменения проводок по документу Purchase Order при добавлении строк
	И я добавляю строку в заказ
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И Пауза 2
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '39/18SD'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '100,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '195,00'
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/19SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'pcs' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '50,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '190,00'
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	И я проверяю изменение записей регистра OrderBalance
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '100,000'  | 'Purchase order 103*' | '12'          | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '50,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
	
Сценарий: _019904 проверка проводок по документу Purchase Order при добавлении коробок (пересчет в единицу хранения)
	И я добавляю в заказ упаковку
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
			| 'Number'    |
			| '103' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я перехожу к последней строке
		И в таблице "ItemList" я удаляю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/19SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		Тогда открылось окно 'Units'
		И в таблице "List" я перехожу к строке:
			| 'Description'               |
			| 'High shoes box (8 pcs)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'High shoes box (8 pcs)' |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '190,00'
		И в таблице "ItemList" в поле 'Store' я ввожу текст 'Store 03'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	И я проверяю изменение записей регистра OrderBalance
	# Упаковки пересчитываются в штуки
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '80,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
	
Сценарий: _019905 проверка отмены проводок при пометке на удаление
	И я помечаю на удаление документ заказа поставщику на удаление
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
	И я проверяю изменение записей регистра OrderBalance
	# Упаковки пересчитываются в штуки
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | '2'           | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | '3'           | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | '4'           | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | '5'           | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '6'           | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '7'           | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | '8'           | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | '9'           | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '10'          | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '11'          | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | '12'          | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |

Сценарий: _019906 проверка проводок при проведении ранее помеченного на удаление документа
	И я провожу ранее помеченный на удаление документ
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuSetDeletionMark'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
	И я проверяю проводки документа
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | '2'           | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | '3'           | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | '4'           | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | '5'           | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '6'           | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '7'           | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | '8'           | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | '9'           | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '10'          | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '11'          | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | '12'          | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
		И Я закрываю текущее окно


Сценарий: _019907 проверка отмены проводок при отмене проведения документа
	И я распровожу ранее проведенный документ
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И Я закрываю текущее окно
	И я проверяю изменение проводок
		И Пауза 5
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		И таблица "List" не содержит строки:
			| 'Quantity' | 'Recorder'          |
			| '250,000'  | 'Purchase order 103*' |
			| '200,000'  | 'Purchase order 103*' |
		И Я закрываю текущее окно
	И я провожу ранее распроведенный документ
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И Я закрываю текущее окно
	И я проверяю проводки документа
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | '2'           | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | '3'           | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | '4'           | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | '5'           | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '6'           | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | '7'           | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | '8'           | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | '9'           | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '10'          | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | '11'          | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | '12'          | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
		И Я закрываю текущее окно
	
Сценарий: _019908 проведение поступления по штукам и приходного ордера
	# Коробки пересчитываются в штуки
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И в таблице "List" я перехожу к строке:
		| 'Number'    |
		| '103' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
	И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
	И я нажимаю кнопку выбора у поля "Company"
	И я нажимаю на кнопку с именем 'FormChoose'
	И я нажимаю кнопку выбора у поля "Store"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Store 03'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку "Post"
	И я провожу приходный ордер
		И я нажимаю на кнопку с именем "FormDocumentGoodsReceiptGenerateGoodsReceipt"
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 03'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post and close'
	И я закрываю текущее окно