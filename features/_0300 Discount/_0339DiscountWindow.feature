#language: ru

@Positive
@Discount
@IgnoreOnCIMainBuild
@tree
Функционал: check that the discount window is displayed in Sales Order

As a developer
I want to add a discount window to the order.
So that the manager can immediately see the interest and discount amount on the order.



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
# For each product, a percentage discount is given (e.g. Product A from 2 to 5%, Product B from 3 to 7%). 
# The sales rep can set a discount from the specified range in the order himself

Сценарий: _033901 check the discount window in the order (displaying discounts accrued on the order)
	* Inactive Discount on Basic Partner terms
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| '3+1 Product 1 and Product 2 (not multiplicity), Discount on Basic Partner terms' |
		И в таблице "List" я выбираю текущую строку
		И я изменяю флаг 'Launch'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Когда создаю заказ на Partner A Basic Partner terms, TRY (Product 1 -10 и Product 3 - 5)
	* Check display of valid discounts in % Offers window
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
			| 'All items 5+1, Discount on Basic Partner terms'                                  | ' '         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''  | ''  |
	* Check display of selected discount, its amount and percentage
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Partner terms' |
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
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''  | ''  |
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
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '15,00' | '1 650,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
	* Check that the discount is not displayed after cancellation in the order.
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Partner terms' |
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
			| 'All items 5+1, Discount on Basic Partner terms'               | ' '         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms' | ' '         | ''  | ''  |
		И в таблице "Offers" я перехожу к строке:
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Partner terms' |
		И в таблице "Offers" я активизирую поле "Is select"
		И в таблице "Offers" я выбираю текущую строку
		И я нажимаю на кнопку 'OK'
	* Check the discount recalculation in the discount window
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
	* Discount recalculation check
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
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
		И я нажимаю на кнопку 'OK'
	* The discount window shows several valid discounts on order
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
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
		И я нажимаю на кнопку 'OK'
	* Checking the range discount display (not displayed in this window)
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
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку "Post and close"







	






	











	







	












