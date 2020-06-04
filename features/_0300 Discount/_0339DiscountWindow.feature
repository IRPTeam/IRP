#language: ru

@Positive
@Discount
@IgnoreOnCIMainBuild
@tree
Функционал: проверка отображения окна скидок в Sales Order

Как разработчик
Я хочу добавить в заказ клиента окно с отображением действующих скидок
Чтобы торговый агент сразу видел процент и сумму скидки по заказу

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# По каждому товару задается скидка в виде процента (например Товар А от 2 до 5%, Товар В от 3 до 7%). 
# Агент самостоятельно в заказе может проставить скидку из указанного диапазона

Сценарий: _033901 проверка окна скидок в заказе (отображение начисленных по заказу скидок)
	И я ставлю скидку Discount on Basic Agreements недействующей
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| '3+1 Product 1 and Product 2 (not multiplicity), Discount on Basic Agreements' |
		И в таблице "List" я выбираю текущую строку
		И я изменяю флаг 'Launch'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Когда создаю заказ на Partner A Basic Agreements, TRY (Product 1 -10 и Product 3 - 5)
	И я проверяю отображение действующих скидок в окне % Offers
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И     таблица "Offers" стала равной:
			| 'Presentation'                                                                 | 'Is select' | '%' | '∑' |
			| 'Special Offers'                                                               | ''          | ''  | ''  |
			| 'Sum'                                                                          | ''          | ''  | ''  |
			| 'Special Message Notification'                                                 | ' '         | ''  | ''  |
			| 'Minimum'                                                                      | ''          | ''  | ''  |
			| 'Special Message DialogBox'                                                    | ' '         | ''  | ''  |
			| 'Discount 1 without Vat'                                                       | ' '         | ''  | ''  |
			| 'Maximum'                                                                      | ''          | ''  | ''  |
			| 'Discount Price 1'                                                             | ' '         | ''  | ''  |
			| 'Discount Price 2'                                                             | ' '         | ''  | ''  |
			| 'Discount 2 without Vat'                                                       | ' '         | ''  | ''  |
			| 'All items 5+1, Discount on Basic Agreements'                                  | ' '         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Agreements'                    | ' '         | ''  | ''  |
	И я проверяю отображение выбранной скидки, её суммы и процента
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Agreements' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И     таблица "Offers" стала равной:
			| 'Presentation'                                                                 | 'Is select' | '%' | '∑' |
			| 'Special Offers'                                                               | ''          | ''  | ''  |
			| 'Sum'                                                                          | ''          | ''  | ''  |
			| 'Special Message Notification'                                                 | ' '         | ''  | ''  |
			| 'Minimum'                                                                      | ''          | ''  | ''  |
			| 'Special Message DialogBox'                                                    | ' '         | ''  | ''  |
			| 'Discount 1 without Vat'                                                       | ' '         | ''  | ''  |
			| 'Maximum'                                                                      | ''          | ''  | ''  |
			| 'Discount Price 1'                                                             | ' '         | ''  | ''  |
			| 'Discount Price 2'                                                             | ' '         | ''  | ''  |
			| 'Discount 2 without Vat'                                                       | ' '         | ''  | ''  |
			| 'All items 5+1, Discount on Basic Agreements'                                  | '✔'         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Agreements'                    | ' '         | ''  | ''  |
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И     таблица "Offers" стала равной:
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | ' '         | ''      | ''         |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Agreements'                                  | '✔'         | '15,00' | '1 650,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Agreements'                    | ' '         | ''      | ''         |
	И я проверяю, что скидка не отображается после её отмены в заказе
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Agreements' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И     таблица "Offers" стала равной:
			| 'Presentation'                                              | 'Is select' | '%' | '∑' |
			| 'Special Offers'                                            | ''          | ''  | ''  |
			| 'Sum'                                                       | ''          | ''  | ''  |
			| 'Special Message Notification'                              | ' '         | ''  | ''  |
			| 'Minimum'                                                   | ''          | ''  | ''  |
			| 'Special Message DialogBox'                                 | ' '         | ''  | ''  |
			| 'Discount 1 without Vat'                                    | ' '         | ''  | ''  |
			| 'Maximum'                                                   | ''          | ''  | ''  |
			| 'Discount Price 1'                                          | ' '         | ''  | ''  |
			| 'Discount Price 2'                                          | ' '         | ''  | ''  |
			| 'Discount 2 without Vat'                                    | ' '         | ''  | ''  |
			| 'All items 5+1, Discount on Basic Agreements'               | ' '         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Agreements' | ' '         | ''  | ''  |
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Agreements' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	И я проверяю что скидка в окне скидок пересчитывается
		И я меняю количество по Product 1 на 30 штук
			И в таблице "ItemList" я нажимаю на кнопку 'Add'
			Тогда открылось окно 'Pick up items'
			И в таблице "ItemsList" я перехожу к строке:
				| 'Info'          | 'Item'      |
				| '20 unit × 550' | 'Product 1' |
			И я меняю значение переключателя 'FastQuantity' на '10'
			И в таблице "ItemsList" я активизирую поле "Info"
			И в таблице "ItemsList" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
	И я проверяю перерасчет акции
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И     таблица "Offers" стала равной:
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | ' '         | ''      | ''         |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Agreements'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Agreements'                    | ' '         | ''      | ''         |
		И я нажимаю на кнопку 'OK'
	И я проверяю что в окне скидок отображается несколько действующих скидок по заказу
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'Discount Price 1' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И     таблица "Offers" стала равной:
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | '✔'         | '25,00' | '500,00'   |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Agreements'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Agreements'                    | ' '         | ''      | ''         |
		И я нажимаю на кнопку 'OK'
	И я проверяю отображение диапазонной скидки (в этом окне не отображается)
		И я по Product 1 ставлю диапазонную скидку 8%
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'      |
				| 'Product 1' |
			И в таблице "ItemList" я активизирую поле с именем "ItemListInfo"
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuCheckOffersInRow'
			И в таблице "Offers" я перехожу к строке:
				| 'Offer'                               |
				| 'Range Discount Basic (Product 1, 3)' |
			И в таблице "Offers" я активизирую поле "∑"
			И в таблице "Offers" я выбираю текущую строку
			И в поле с именем "Percent" я ввожу текст "8"
			И я нажимаю на кнопку '<< Back'
			И в таблице "Offers" я нажимаю на кнопку 'OK'
			И Пауза 2
		И в таблице "ItemList" я нажимаю на кнопку '% Offers'
		И     таблица "Offers" стала равной:
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | '✔'         | '25,00' | '500,00'   |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Agreements'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Agreements'                    | ' '         | ''      | ''         |
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"







	






	











	







	












