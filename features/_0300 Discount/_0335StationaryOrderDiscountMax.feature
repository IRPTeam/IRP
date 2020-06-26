#language: ru

@Positive
@Discount
@tree
@SpecialOffersMaxInRow


Функционал: create заказа со скидкой по видам цены (Type joings MaxInRow, Special Offers MaxInRow)

Как тестировщик
Я хочу проверить порядок применения скидок в общей группе SpecialOffersMaxInRow, подгруппа Максимум (MaxInRow)
Чтобы скидки в группе Максимум начислялись по выбору наибольшей скидки в строке

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# При Type joings MaxInRow в Максимум по заказам со скидками находящимися в этой группе будут отрабатывать те скидки, которые наиболее выгодны для клиента. 
	# Проверка наиболее выгодной скидки по строкам.


Сценарий: _033501 меняю в главной группе Special offers правило Минимум на Maximum by row
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'      |
		| 'Special Offers' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
	И я нажимаю на кнопку открытия поля "Special offer type"
	И я нажимаю на кнопку 'Set settings'
	Тогда открылось окно 'Special offer rules'
	И из выпадающего списка "Type joining" я выбираю точное значение 'Maximum by row'
	И я нажимаю на кнопку 'Save settings'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И    Я закрыл все окна клиентского приложения


Сценарий: _033502 create заказа со скидкой во виду цен Discount Price 1 (цена с НДС)
# Скидка Discount Price 1 отрабатывает по соглашению Basic Price (цена включает НДС), параллельно по этому соглашению работает скидка Discount Price 2 (цены ниже чем Discount Price 1)
# В группе максимум находится 2 скидки Discount Price 1 и Discount Price 2
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Ferron BP' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я добавляю в заказ клиента товар
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Dress' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Boots' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Boots (12 pcs)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	И я назначаю скидку Discount Price 1
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'            |
			| 'Discount Price 1' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	# И я перехожу к закладке "ItemList"
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'           | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs'            | '2 470,00'        |
		| 'Boots' | '8 400,00' | '36/18SD'  | 'Store 01' | '2,000' | '2 400,00'    | 'Boots (12 pcs)' | '14 400,00'       |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'         |
		| 'Ferron BP' | '16 870,00' |



Сценарий: _033503 create заказа со скидкой во виду цен Discount Price 2 (цена с НДС)
# Скидка Discount Price 2 отрабатывает по соглашению Basic Price (цена включает НДС), параллельно по этому соглашению работает скидка Discount Price 1 (цены ниже чем Discount Price 1)
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'         | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01'      | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01'      | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'         |
		| 'Lomaniti' | '2 495,00' |

	
Сценарий: _033504 проверка порядка отрабатывания скидки в группе Maximum (ручное назначение)
# должна сработать скидка Discount Price 2
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Lomaniti' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
		| 'Description'                     |
		| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я добавляю в заказ клиента товар
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Dress' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Boots' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Boots (12 pcs)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'    | 'Item key' | 'Store'         | 'Q'     | 'Offers amount' | 'Unit'           | 'Total amount'    |
		| 'Dress' | '520,00'   | 'XS/Blue'  | 'Store 01'      | '5,000' | '655,00'        | 'pcs'            | '1 945,00'        |
		| 'Boots' | '8 400,00' | '36/18SD'  | 'Store 01'      | '2,000' | '3 600,00'      | 'Boots (12 pcs)' | '13 200,00'       |
	И я перехожу к закладке "Special offers"
	И таблица "SpecialOffers" стала равной:
		| 'Special offer'    | 'Amount'   |
		| 'Discount Price 2' | '655,00'   |
		| 'Discount Price 2' | '3 600,00' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'         |
		| 'Lomaniti' | '15 145,00' |

Сценарий: _033505 create заказа со скидкой во виду цен Discount Price 1 without Vat (цена не включает НДС) - ручное назначение в группе минимум со скидкой Discount Price 2 without Vat
	Когда переношу скидку Discount 2 without Vat из группы Maximum в Minimum
	Когда меняю ручное проведение скидки Discount 2 without Vat
	Когда переношу скидку Discount 1 without Vat из группы Maximum в группу Minimum
	И Пауза 2
	Когда меняю ручное проведение скидки по Discount 1 without Vat
	Когда создаю заказ на Kalipso Basic Agreements, without VAT, TRY (Dress и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 1 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '593,20'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '813,60'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	# И таблица 'List' содержит строки
	# 	| 'Partner'   | 'Σ'         |
	# 	| 'Kalipso' | '6 639,93' |


Сценарий: _033506 create заказа со скидкой во виду цен Discount Price 2 without Vat (цена не включает НДС)- ручное назначение в группе минимум со скидкой Discount Price 1 without Vat
	Когда создаю заказ на Kalipso Basic Agreements, without VAT, TRY (Dress и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'         | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02'      | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02'      | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	# И таблица 'List' содержит строки
	# 	| 'Partner'     | 'Σ'         |
	# 	| 'Kalipso' | '5 841,00' |

	

Сценарий: _033507 проверка порядка отрабатывания скидки в группе Minimum (автоматическая скидка)
# должна сработать скидка Discount Price without Vat 1
	Когда меняю автоматическое проведение скидки Discount 2 without Vat
	Когда меняю автоматическое проведение скидки по Discount 1 without Vat
	Когда создаю заказ на Kalipso Basic Agreements, without VAT, TRY (Dress и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И Пауза 2
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'         | 'Q'      | 'Offers amount' | 'Unit'|
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02'      | '10,000' | '593,20'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02'      | '12,000' | '813,60'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	# И таблица 'List' содержит строки
	# 	| 'Partner'     | 'Σ'         |
	# 	| 'Kalipso' | '6 639,93' |
	# 	| 'Kalipso' | '6 639,93' |

	

Сценарий: _033508 проверка порядка отрабатывания скидки в группе Maximum (автоматическая скидка)
# должна сработать скидка Discount Price without Vat 2
	Когда переношу скидки Discount 2 without Vat и Discount 1 without Vat из группы Minimum в группу Maximum 
	Когда меняю автоматическое проведение скидки Discount 2 without Vat
	Когда создаю заказ на Kalipso Basic Agreements, without VAT, TRY (Dress и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	# И таблица 'List' содержит строки
	# 	| 'Partner'     | 'Σ'         |
	# 	| 'Kalipso' | '5 841,00' |

Сценарий: _033509 проверка порядка отрабатывания скидки в группе Sum (автоматическая скидка по виду цен + сообщение)
# срабатывает скидка Discount Price without Vat 2 + сообщение Special Message DialogBox
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И я нажимаю на кнопку 'List'
	И Пауза 2
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '1'        | 'Sum'                |
	И я нажимаю на кнопку с именем 'FormChoose'
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'Special Message DialogBox' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И Пауза 2
	И я фиксирую текущую форму
	# И в таблице "List" я перехожу к строке:
	# 	| 'Special offer type' |
	# 	| 'Sum'                |
	И я нажимаю на кнопку с именем 'FormChoose'
	Когда создаю заказ на Kalipso Basic Agreements, without VAT, TRY (Dress и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 2" в течение 30 секунд
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	# И таблица 'List' содержит строки
	# 	| 'Partner'     | 'Σ'         |
	# 	| 'Kalipso' | '5 841,00' |
	# 	| 'Kalipso' | '5 841,00' |
	

Сценарий: _033510 проверка порядка отрабатывания скидки в группе Sum 2 автоматических сообщения + скидка по виду цен
	# срабатывает скидка Discount Price without Vat 2 + 2 сообщения Message 2 и Message 3
	Когда создаю скидку Message Dialog Box 2 (Message 3)
	Когда меняю автоматическое проведение скидки по Discount 1 without Vat
	Когда переношу скидку Discount 1 without Vat в группу Sum
	Когда создаю заказ на Kalipso Basic Agreements, without VAT, TRY (Dress и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 2" в течение 30 секунд
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 3" в течение 30 секунд
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	# И таблица 'List' содержит строки
	# 	| 'Partner'     | 'Σ'         |
	# 	| 'Kalipso' | '5 841,00' |
	# 	| 'Kalipso' | '5 841,00' |
	# 	| 'Kalipso' | '5 841,00' |

		

Сценарий: _033511 проверка порядка отрабатывания скидки в группе Sum 2 автоматических сообщения
	Когда меняю ручное проведение скидки по Discount 1 without Vat
	Когда меняю ручное проведение скидки Discount 2 without Vat
	Когда создаю заказ на MIO Basic Agreements, without VAT (High shoes и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 2" в течение 30 секунд
	Затем я жду, что в сообщениях пользователю будет подстрока "Message 3" в течение 30 секунд
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
		| 'Item'       | 'Price'  | 'Item key' | 'Store'    | 'Offers amount' | 'Q'     | 'Unit' |
		| 'High shoes' | '462,96' | '39/19SD'  | 'Store 02' | ''              | '8,000' | 'pcs'  |
		| 'Boots'      | '601,85' | '39/18SD'  | 'Store 02' | ''              | '4,000' | 'pcs'  |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	# И таблица 'List' содержит строки
	# 	| 'Partner'     | 'Σ'         |
	# 	| 'MIO'         | '6 599,96' |

	

Сценарий: _033512 проверка порядка отрабатывания скидки в группе Minimum (ручная скидка)
    # должна сработать скидка Discount Price without Vat 1
	Когда переношу скидки Discount 2 without Vat и Discount 1 without Vat из Maximum в Minimum
	Когда создаю заказ на MIO Basic Agreements, without VAT (Trousers и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount 1 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	# И я перехожу к закладке "ItemList"
	И таблица "ItemList" содержит строки:
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
	| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        | 'pcs' | '2 240,02'     |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        | 'pcs' | '1 279,97'     |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'MIO'         | '3 519,99' |



Сценарий: _033513 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (автоматическое назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	# также проверка на недействующую по заказу скидку Discount 2 without Vat
	Когда переношу скидку Discount Price 1 в максимум
	Когда переношу скидку Discount Price 2 в группу минимум
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю приоритет Discount Price 2 с 4 на 2
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю автоматическое проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033514 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1 
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033515 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю ручное проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033516 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (Discount Price 2 ручное назначение, Discount Price 1 - автоматическое), приоритет Discount Price 1 ниже чем Discount Price 2
# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда меняю ручное проведение Discount Price 2
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033517 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (автоматическое назначение 2-х скидок), приоритет Discount Price 1 выше чем Discount Price 2
# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда переношу скидку Discount Price 1 в минимум
	Когда переношу скидку Discount Price 2 в группу максимум
	Когда меняю автоматическое проведение Discount Price 2
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033518 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |



Сценарий: _033519 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю автоматическое проведение Discount Price 2 
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033520 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (Discount Price 2 ручное назначение, Discount Price 1 - автоматическое), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю ручное проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033521 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (ручное назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю ручное проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033522 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (ручное назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033523 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда переношу скидку Discount Price 1 в максимум
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда переношу скидку Discount Price 2 в группу Sum
	Когда меняю автоматическое проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033524 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033525 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033526 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (ручное назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю ручное проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Сценарий: _033527 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда переношу скидку Discount Price 1 в минимум
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю автоматическое проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033528 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033529 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю ручное проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033530 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (Discount Price 2 ручное назначение, Discount Price 1 - автоматическое), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю ручное проведение Discount Price 2
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033531 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (ручное назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Сценарий: _033532 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (ручное назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 2, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 2' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount Price 1' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 30 секунд
	И таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |