#language: ru
@Positive
@Discount
@SpecialOffersMinimum


Функционал: calculation of discounts in a group Minimum (type joings Minimum, Special Offers MaxInRow)

As a sales manager
I want to check the order of discounts in the general group SpecialOffersMaxInRow, subgroup Minimum.
So that discounts in the Minimal group are calculated by choosing the lowest discount in the line.


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

# Checking the discount calculation in the group Minimum created inside the group Minimum, which is in the group Maximum
# With Type joins Minimum, discounts in this group will work out the discounts that are least beneficial to the client. 
# Checking for overall discounts on orders (not on lines). 
# Discounts that are outside the group are at least checked by lines and applied according to the rule "most advantageous to the client". 


Сценарий: _032001 discount calculation Discount 2 without Vat in the group Sum in Minimum and Discount 1 without Vat in the group Minimum (manual)
	# Discounted Discount 1 without Vat
	Когда переношу группу Sum in Minimum в Minimum
	Когда переношу скидку Discount 2 without Vat в группу Sum in Minimum
	Когда переношу скидку Discount 1 without Vat в Minimum
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
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |

Сценарий: _032002 discount calculation Discount 2 without Vat in the group Sum in Minimum и Discount 1 without Vat in the group Minimum (auto)
	# Discounted Discount 1 without Vat
	Когда меняю auto проведение скидки по Discount 1 without Vat
	Когда меняю auto проведение скидки Discount 2 without Vat
	Когда создаю заказ на MIO Basic Agreements, without VAT (Trousers и Shirt)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку 'Save'
	И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |


Сценарий: _032003 discount calculation Discount 2 without Vat in the main group Special Offers, Discount 1 without Vat in the group Sum in Minimum (auto)
	# Discounted Discount 2 without Vat
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
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
	
	

Сценарий: _032004 discount calculation Discount 1 without Vat in the main group Special Offers, Discount 2 without Vat in the group Sum in Minimum (auto)
	# Discounted Discount 2 without Vat
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
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
		| 'MIO'       | '3 086,88' |


# Procedure for calculating discounts in the main group Minimum


Сценарий: _032005 change Special offers main group Maximum by row to Minimum
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

Сценарий: _032006 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification (auto)
	И  Я закрыл все окна клиентского приложения
	Когда переношу скидку Discount Price 1 в Maximum
	Когда переношу скидку Discount Price 2 в группу Minimum
	Когда меняю priority Discount Price 1 с 1 на 3
	Когда меняю priority Discount Price 2 с 4 на 2
	Когда меняю auto проведение скидки Discount Price 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
	

Сценарий: _032007 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 на 1 
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032008 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 с 1 на 3
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
	И я нажимаю на кнопку "Post and close"
	И Пауза 2
	И таблица 'List' содержит строки
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|



Сценарий: _032009 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		Когда меняю priority Discount Price 1 на 1
		Когда меняю ручное проведение Discount Price 2
		Когда меняю auto проведение скидки Discount Price 1
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
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|

Сценарий: _032010 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (auto назначение 2-х скидок), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		Когда переношу скидку Discount Price 1 в Minimum
		Когда переношу скидку Discount Price 2 в группу Maximum
		Когда меняю auto проведение Discount Price 2
		Когда меняю auto проведение Discount Price 1
		Когда меняю priority Discount Price 1 с 1 на 3
		Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		И я нажимаю на кнопку "Post and close"
		И Пауза 2
		И таблица 'List' содержит строки
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|


Сценарий: _032011 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		Когда меняю priority Discount Price 1 на 1
		Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
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


Сценарий: _032012 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю priority Discount Price 1 с 1 на 3
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


Сценарий: _032013 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 на 1
	Когда меняю auto проведение скидки Discount Price 1
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


Сценарий: _032014 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 с 1 на 3
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

Сценарий: _032015 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 на 1
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

Сценарий: _032016 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда переношу скидку Discount Price 1 в Maximum
	Когда меняю auto проведение скидки Discount Price 1
	Когда меняю priority Discount Price 1 с 1 на 3
	Когда переношу скидку Discount Price 2 в группу Sum
	Когда меняю auto проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
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

Сценарий: _032017 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
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

Сценарий: _032018 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю priority Discount Price 1 с 1 на 3
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


Сценарий: _032019 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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

Сценарий: _032020 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда переношу скидку Discount Price 1 в Minimum
	Когда меняю auto проведение скидки Discount Price 1
	Когда меняю auto проведение Discount Price 2
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
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


Сценарий: _032021 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 на 1
	Когда создаю заказ на Lomaniti Basic Agreements, TRY (Dress и Boots)
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	Затем я жду, что в сообщениях пользователю будет подстрока "Message Notification" в течение 10 секунд
	И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
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

Сценарий: _032022 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 с 1 на 3
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

Сценарий: _032023 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю ручное проведение Discount Price 2
	Когда меняю auto проведение скидки Discount Price 1
	Когда меняю priority Discount Price 1 на 1
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

Сценарий: _032024 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю ручное проведение скидки Discount Price 1
	Когда меняю priority Discount Price 1 с 1 на 3
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

Сценарий: _032025 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	Когда меняю priority Discount Price 1 на 1
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










