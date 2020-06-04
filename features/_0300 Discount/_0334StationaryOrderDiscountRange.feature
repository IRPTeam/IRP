#language: ru
@Positive
@Discount
@SpecialOffersMaxInRow
@tree


Функционал: скидка в виде диапазона процентов

Как тестировщик
Я хочу проверить расчет и порядок применения диапазонной скидки (применяется на строку вручную, суммируется с другими скидками)
Чтобы диапазонная скидка рассчитывалась верно

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# По каждому товару задается скидка в виде процента (например Товар А от 2 до 5%, Товар В от 3 до 7%). 
# Агент самостоятельно в заказе может проставить скидку из указанного диапазона

Сценарий: _033401 подготовка к проверке
	Когда меняю ручное проведение Discount Price 2
	Когда меняю ручное проведение скидки Discount Price 1
	Когда переношу скидку 3+1 Dress and Trousers (not multiplicity), Discount on Basic Agreements в группу Maximum
	Когда переношу скидку 4+1 Dress and Trousers, Discount on Basic Agreements в группу Maximum
	Когда переношу скидку All items 5+1, Discount on Basic Agreements в группу  Maximum
	Когда меняю ручное проведение скидки All items 5+1, Discount on Basic Agreements
	Когда переношу скидку Discount Price 1 в максимум 
	Когда меняю ручное проведение скидки 3+1 Dress and Trousers (not multiplicity), Discount on Basic Agreements
	Когда меняю ручное проведение 4+1 Dress and Trousers, Discount on Basic Agreements


Сценарий: _033402 проверка расчета диапазонной акции по строкам
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
	И я по Trousers я ставлю диапазонную скидку 6%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers'     |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "6"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	И я по Dress ставлю диапазонную скидку 5%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Dress' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Dress)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "5"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '260,00'        | 'pcs'  | '4 940,00'        |
		| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '120,00'        | 'pcs'  | '1 880,00'        |
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И таблица 'List' содержит строки
		| 'Partner'    | 'Σ'     |
		| 'Ferron BP'  |  '6 820,00'|
	

Сценарий: _033403 проверка отрабатывания минимальных процентов диапазонной акции по строкам
# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
		Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
		И я по Trousers ставлю диапазонную скидку 4%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Trousers' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Trousers)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "5"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
		И я по Dress ставлю диапазонную скидку 3%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Dress' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Dress)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "3"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'| 'Total amount'    |
				| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '156,00'        | 'pcs' | '5 044,00'        |
				| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '100,00'        | 'pcs' | '1 900,00'        |
			И в таблице "ItemList" я нажимаю на кнопку '% Offers'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку "Post and close"
			И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 944,00'|
		

Сценарий: _033404 проверка отрабатывания максимальных процентов диапазонной акции по строкам
# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
		Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
		И я по Trousers ставлю диапазонную скидку 8%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Trousers' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Trousers)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "7"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
		И я по Dress ставлю диапазонную скидку 10%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Dress' |
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Presentation'                               |
				| 'Range Discount Basic (Dress)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "PercentNumber" я ввожу текст "10"
			И я нажимаю на кнопку с именем "FormOk"
			И я нажимаю на кнопку с именем "FormOK"
			И Пауза 2
			И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
				| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '520,00'        | 'pcs'  | '4 680,00'        |
				| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '140,00'        | 'pcs'  | '1 860,00'        |
			И в таблице "ItemList" я нажимаю на кнопку '% Offers'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку "Post and close"
			И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 540,00'|
		


# Сценарий: проверка отрабатывания диапазонной акции и акции вида 5+1
# 	Когда создаю заказ на Partner A Basic Agreements, TRY (Product 1 -10 и Product 3 - 5)
# 	И я по Product 1 ставлю диапазонную скидку 8%
# 		И в таблице "ItemList" я перехожу к строке:
# 			| 'Item'      | 'Total amount' |
# 			| 'Product 1' | '11 000'       |
# 		И в таблице "ItemList" я активизирую поле с именем "ItemListInfo"
# 		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                               |
# 			| 'Range Discount Basic (Product 1, 3)' |
# 		И в таблице "Offers" я активизирую поле "∑"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И в поле с именем "PercentNumber" я ввожу текст "8"
# 		И я нажимаю на кнопку с именем "BackToOffersTree"
# 		И Пауза 2
# 	И я ставлю акцию 5+1
# 		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                  |
# 			| 'All items 5+1, Discount on Basic Agreements' |
# 		И в таблице "Offers" я активизирую поле "Is select"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И я нажимаю на кнопку 'OK'
	# И я проверяю правильность расчета

Сценарий: _033405 проверка отрабатывания диапазонной акции и ценовой акции
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
	И я по Trousers ставлю диапазонную скидку 7%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "7"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	И я назначаю акцию Discount price 1
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 1' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	И я проверяю правильность расчета
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '260,00'        | 'pcs'  | '4 940,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '540,00'        | 'pcs'  | '1 460,00'        |
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 400,00'|


Сценарий: _033406 проверка отрабатывания диапазонной акции и вытеснения 2-х ценовых акций
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда переношу скидку Discount Price 2 в группу максимум
	Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
	И я по Trousers ставлю диапазонную скидку 7%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "7"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	И я назначаю акцию Discount price 1
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 1' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 2' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	И я проверяю правильность расчета
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '1 310,00'      | 'pcs'  | '3 890,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '725,00'        | 'pcs'  | '1 275,00'        |
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"
		И таблица 'List' содержит строки
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '5 165,00'|


# Сценарий: проверка отрабатывания диапазонной акции и вытеснения ценовой акции и акции вида 5+1 (в группе Максимум)
# 	# по Product 1 скидка по 5+1 и Discount Price 1 одинаковая сумма
# 	Когда создаю заказ на Partner A Basic Agreements, TRY (Product 1 -10 и Product 3 - 5)
# 	И я по Product 1 ставлю диапазонную скидку 8%
# 		И в таблице "ItemList" я перехожу к строке:
# 			| 'Item'      | 'Total amount' |
# 			| 'Product 1' | '11 000'       |
# 		И в таблице "ItemList" я активизирую поле с именем "ItemListInfo"
# 		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                               |
# 			| 'Range Discount Basic (Product 1, 3)' |
# 		И в таблице "Offers" я активизирую поле "∑"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И в поле с именем "PercentNumber" я ввожу текст "8"
# 		И я нажимаю на кнопку с именем "BackToOffersTree"
# 		И Пауза 2
# 	И я назначаю акцию Discount price 1
# 		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                  |
# 			| 'Discount Price 1' |
# 		И в таблице "Offers" я активизирую поле "Is select"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                  |
# 			| 'All items 5+1, Discount on Basic Agreements' |
# 		И в таблице "Offers" я активизирую поле "Is select"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И я нажимаю на кнопку 'OK'
# 	# И я проверяю правильность расчета


# Сценарий: проверка отрабатывания диапазонной акции и вытеснения ценовой акции и акции вида 5+1 (в группе Минимум)
# 	Когда переношу скидку Discount Price 1 в Минимум
# 	Когда переношу скидку All items 5+1, Discount on Basic Agreements в группу Минимум
# 	Когда создаю заказ на Partner A Basic Agreements, TRY (Product 1 -10 и Product 3 - 5)
# 	И я по Product 1 ставлю диапазонную скидку 8%
# 		И в таблице "ItemList" я перехожу к строке:
# 			| 'Item'      | 'Total amount' |
# 			| 'Product 1' | '11 000'       |
# 		И в таблице "ItemList" я активизирую поле с именем "ItemListInfo"
# 		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                               |
# 			| 'Range Discount Basic (Product 1, 3)' |
# 		И в таблице "Offers" я активизирую поле "∑"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И в поле с именем "PercentNumber" я ввожу текст "8"
# 		И я нажимаю на кнопку с именем "BackToOffersTree"
# 		И Пауза 2
# 	И я назначаю акцию Discount price 1
# 		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                  |
# 			| 'Discount Price 1' |
# 		И в таблице "Offers" я активизирую поле "Is select"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И в таблице "Offers" я перехожу к строке:
# 			| 'Presentation'                  |
# 			| 'All items 5+1, Discount on Basic Agreements' |
# 		И в таблице "Offers" я активизирую поле "Is select"
# 		И в таблице "Offers" я выбираю текущую строку
# 		И я нажимаю на кнопку 'OK'
# 	# И я проверяю правильность расчета

Сценарий: _033407 проверка перерасчета диапазонной акции при изменении количества товара в заказе
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	Когда создаю заказ на Ferron BP Basic Agreements, TRY (Dress -10 и Trousers - 5)
	И я по Trousers ставлю диапазонную скидку 7%
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'      |
			| 'Trousers' |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuSetSpecialOffersAtRow'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "Offers" я активизирую поле "∑"
		И в таблице "Offers" я выбираю текущую строку
		И в поле с именем "PercentNumber" я ввожу текст "7"
		И я нажимаю на кнопку с именем "FormOk"
		И я нажимаю на кнопку с именем "FormOK"
		И Пауза 2
	И я проверяю расчет акции
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'| 'Total amount'    |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | ''              | 'pcs' | '5 200,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '140,00'        | 'pcs' | '1 860,00'        |
	И я меняю количество по Trousers на 30 штук
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'      |
		| 'Trousers' |
		И в таблице "ItemList" в поле 'Q' я ввожу текст '30,000'
		И в таблице "ItemList" я завершаю редактирование строки
	И я пересчитываю акцию
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
	И я проверяю пересчет акции
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | ''              | 'pcs'  | '5 200,00'        |
		| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '30,000' | '840,00'        | 'pcs'  | '11 160,00'       |
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И я нажимаю на кнопку 'OK'
	И я нажимаю на кнопку "Post and close"
	И таблица 'List' содержит строки
		| 'Partner'    | 'Σ'     |
		| 'Ferron BP'  |  '16 360,00'|


	


	







	












