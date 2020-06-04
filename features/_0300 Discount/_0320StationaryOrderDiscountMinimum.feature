#language: ru
@Positive
@Discount
@SpecialOffersMinimum


Функционал: расчет скидок в группе минимум (Type joings Minimum, Special Offers MaxInRow)

Как тестировщик
Я хочу проверить порядок применения скидок в общей группе SpecialOffersMaxInRow, подгруппа Минимум (Minimum)
Чтобы скидки в группе Минимум начислялись по выбору наименьшей скидки в строке

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# Проверка расчета скидки в группе Минимум при созданной внутри группы Минимум, которая находится в групе Максимум
# При Type joings Minimum в Минимум по заказам со скидками находящимися в этой группе будут отрабатывать те скидки, которые наименее выгодны для клиента. 
# Проверка скидки в целом на заказ (не по строкам). 
# При этом скидки которые находятся за пределами группы минимум проверяются по строкам и применяются по правилу "наиболее выгодно клиенту"


Сценарий: _032001 порядок расчета скидок Discount 2 without Vat в группе Sum in Minimum и Discount 1 without Vat в группе минимум (ручное назначение)
	# Должна сработать скидка Discount 1 without Vat
	Когда переношу группу Sum in Minimum в минимум
	Когда переношу скидку Discount 2 without Vat в группу Sum in Minimum
	Когда переношу скидку Discount 1 without Vat в минимум
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
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        |
		# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		# Тогда таблица "Offers" стала равной:
		# 	| 'Presentation'                 | 'Is select' | '%'     | '∑'      |
		# 	| 'Special Offers'               | ''          | ''      | ''       |
		# 	| 'Sum'                          | ''          | ''      | ''       |
		# 	| 'Discount Price 2'             | ' '         | ''      | ''       |
		# 	| 'Special Message DialogBox'    | '✔'         | ''      | ''       |
		# 	| 'DialogBox2'                   | '✔'         | ''      | ''       |
		# 	| 'Minimum'                      | ''          | ''      | ''       |
		# 	| 'Discount Price 1'             | ' '         | ''      | ''       |
		# 	| 'Discount 1 without Vat'       | '✔'         | '55,00' | '745,76' |
		# 	| 'Sum in Minimum'               | ''          | ''      | ''       |
		# 	| 'Discount 2 without Vat'       | ' '         | ''      | ''       |
		# 	| 'Maximum'                      | ''          | ''      | ''       |
		# 	| 'Special Message Notification' | '✔'         | ''      | ''       |
		# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |

Сценарий: _032002 порядок расчета скидок Discount 2 without Vat в группе Sum in Minimum и Discount 1 without Vat в группе минимум (автоматическое назначение)
	# Должна сработать скидка Discount 1 without Vat
	Когда меняю автоматическое проведение скидки по Discount 1 without Vat
	Когда меняю автоматическое проведение скидки Discount 2 without Vat
	Когда создаю заказ на MIO Basic Agreements, without VAT (Trousers и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'     | '∑'      |
	# 	| 'Special Offers'               | ''          | ''      | ''       |
	# 	| 'Sum'                          | ''          | ''      | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''      | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''      | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''      | ''       |
	# 	| 'Minimum'                      | ''          | ''      | ''       |
	# 	| 'Discount Price 1'             | ' '         | ''      | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | '55,00' | '745,76' |
	# 	| 'Sum in Minimum'               | ''          | ''      | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''      | ''       |
	# 	| 'Maximum'                      | ''          | ''      | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''      | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |


Сценарий: _032003 порядок расчета скидок Discount 2 without Vat в главной группе Special Offers, Discount 1 without Vat в группе Sum in Minimum (автоматическое назначение)
	# Должна сработать скидка Discount 2 without Vat
	Когда переношу скидку Discount 2 without Vat в Special Offers
	Когда создаю заказ на MIO Basic Agreements, without VAT (Trousers и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '716,88'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '395,92'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'     | '∑'        |
	# 	| 'Special Offers'               | ''          | ''      | ''         |
	# 	| 'Sum'                          | ''          | ''      | ''         |
	# 	| 'Discount Price 2'             | ' '         | ''      | ''         |
	# 	| 'Special Message DialogBox'    | '✔'         | ''      | ''         |
	# 	| 'DialogBox2'                   | '✔'         | ''      | ''         |
	# 	| 'Minimum'                      | ''          | ''      | ''         |
	# 	| 'Discount Price 1'             | ' '         | ''      | ''         |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''      | ''         |
	# 	| 'Maximum'                      | ''          | ''      | ''         |
	# 	| 'Special Message Notification' | '✔'         | ''      | ''         |
	# 	| 'Discount 2 without Vat'       | '✔'         | '82,07' | '1 112,80' |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
	
	

Сценарий: _032004 порядок расчета скидок Discount 1 without Vat в главной группе Special Offers, Discount 2 without Vat в группе Sum in Minimum (автоматическое назначение)
	# Должна сработать скидка Discount 2 without Vat
	Когда переношу скидку Discount 2 without Vat в группу Sum in Minimum
	Когда переношу Discount 1 without Vat в Special Offers
	Когда создаю заказ на MIO Basic Agreements, without VAT (Trousers и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'            |
		| 'Discount 2 without Vat' |
	И в таблице "Offers" я активизирую поле "Is select"
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '716,88'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '395,92'        |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'     | '∑'        |
	# 	| 'Special Offers'               | ''          | ''      | ''         |
	# 	| 'Sum'                          | ''          | ''      | ''         |
	# 	| 'Discount Price 2'             | ' '         | ''      | ''         |
	# 	| 'Special Message DialogBox'    | '✔'         | ''      | ''         |
	# 	| 'DialogBox2'                   | '✔'         | ''      | ''         |
	# 	| 'Minimum'                      | ''          | ''      | ''         |
	# 	| 'Discount Price 1'             | ' '         | ''      | ''         |
	# 	| 'Sum in Minimum'               | ''          | ''      | ''         |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''      | ''         |
	# 	| 'Discount 2 without Vat'       | '✔'         | '82,07' | '1 112,80' |
	# 	| 'Maximum'                      | ''          | ''      | ''         |
	# 	| 'Special Message Notification' | '✔'         | ''      | ''         |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
		| 'MIO'       | '3 086,88' |


# Порядок расчета скидок в главной группе Минимум

Сценарий: _032005 меняю в главной группе Special offers правило Maximum by row на Минимум
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'      |
		| 'Special Offers' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
	И я нажимаю на кнопку открытия поля "Special offer type"
	И я нажимаю на кнопку 'Set settings'
	Тогда открылось окно 'Special offer rules'
	И из выпадающего списка "Type joining" я выбираю точное значение 'Minimum'
	И я нажимаю на кнопку 'Save settings'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	И    Я закрыл все окна клиентского приложения

Сценарий: _032006 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (автоматическое назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	И    Я закрыл все окна клиентского приложения
	Когда переношу скидку Discount Price 1 в максимум
	Когда переношу скидку Discount Price 2 в группу минимум
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю приоритет Discount Price 2 с 4 на 2
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |

	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
	

Сценарий: _032007 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1 
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032008 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю ручное проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|



Сценарий: _032009 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Минимум (Discount Price 2 ручное назначение, Discount Price 1 - автоматическое), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
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
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		# Тогда таблица "Offers" стала равной:
		# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
		# 	| 'Special Offers'               | ''          | ''     | ''       |
		# 	| 'Sum'                          | ''          | ''     | ''       |
		# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
		# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
		# 	| 'Minimum'                      | ''          | ''     | ''       |
		# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
		# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
		# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
		# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
		# 	| 'Maximum'                      | ''          | ''     | ''       |
		# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
		# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
		# И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032010 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (автоматическое назначение 2-х скидок), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
		Когда переношу скидку Discount Price 1 в минимум
		Когда переношу скидку Discount Price 2 в группу максимум
		Когда меняю автоматическое проведение Discount Price 2
		Когда меняю автоматическое проведение Discount Price 1
		Когда меняю приоритет Discount Price 1 с 1 на 3
		Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		# Тогда таблица "Offers" стала равной:
		# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
		# 	| 'Special Offers'               | ''          | ''     | ''       |
		# 	| 'Sum'                          | ''          | ''     | ''       |
		# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
		# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
		# 	| 'Minimum'                      | ''          | ''     | ''       |
		# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
		# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
		# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
		# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
		# 	| 'Maximum'                      | ''          | ''     | ''       |
		# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
		# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
		# И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032011 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
		Когда меняю приоритет Discount Price 1 на 1
		Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		# Тогда таблица "Offers" стала равной:
		# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
		# 	| 'Special Offers'               | ''          | ''     | ''       |
		# 	| 'Sum'                          | ''          | ''     | ''       |
		# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
		# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
		# 	| 'Minimum'                      | ''          | ''     | ''       |
		# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
		# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
		# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
		# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
		# 	| 'Maximum'                      | ''          | ''     | ''       |
		# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
		# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
		# И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032012 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032013 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (Discount Price 2 ручное назначение, Discount Price 1 - автоматическое), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032014 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (ручное назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю ручное проведение скидки Discount Price 1
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032015 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Максимум (ручное назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032016 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда переношу скидку Discount Price 1 в максимум
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда переношу скидку Discount Price 2 в группу Sum
	Когда меняю автоматическое проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032017 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032018 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032019 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Максимум, Discount Price 2 в группе Sum (ручное назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032020 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда переношу скидку Discount Price 1 в минимум
	Когда меняю автоматическое проведение скидки Discount Price 1
	Когда меняю автоматическое проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032021 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (автоматическое назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | '✔'         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032022 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (Discount Price 1 ручное назначение, Discount Price 2 - автоматическое), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
	Когда меняю приоритет Discount Price 1 с 1 на 3
	Когда меняю ручное проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я перехожу к строке:
		| 'Presentation'                  |
		| 'Discount Price 1' |
	И в таблице "Offers" я выбираю текущую строку
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032023 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (Discount Price 2 ручное назначение, Discount Price 1 - автоматическое), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032024 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (ручное назначение), приоритет Discount Price 1 выше чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032025 проверка порядка отрабатывания скидки (одинаковое правило применения), Discount Price 1 в группе Минимум, Discount Price 2 в группе Sum (ручное назначение), приоритет Discount Price 1 ниже чем Discount Price 2
	# Должна сработать скидка Discount Price 1, также срабатывает автоматическая скидка из группы Максимум Special Message Notification
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
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	# И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	# Тогда таблица "Offers" стала равной:
	# 	| 'Presentation'                 | 'Is select' | '%'    | '∑'      |
	# 	| 'Special Offers'               | ''          | ''     | ''       |
	# 	| 'Sum'                          | ''          | ''     | ''       |
	# 	| 'Discount Price 2'             | ' '         | ''     | ''       |
	# 	| 'Special Message DialogBox'    | '✔'         | ''     | ''       |
	# 	| 'DialogBox2'                   | '✔'         | ''     | ''       |
	# 	| 'Minimum'                      | ''          | ''     | ''       |
	# 	| 'Discount Price 1'             | '✔'         | '8,85' | '230,00' |
	# 	| 'Sum in Minimum'               | ''          | ''     | ''       |
	# 	| 'Discount 1 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Discount 2 without Vat'       | '✔'         | ''     | ''       |
	# 	| 'Maximum'                      | ''          | ''     | ''       |
	# 	| 'Special Message Notification' | '✔'         | ''     | ''       |
	# И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|










