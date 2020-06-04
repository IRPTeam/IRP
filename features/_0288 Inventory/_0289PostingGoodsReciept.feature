#language: ru
@tree
@Positive
Функционал: проведение документа Приходный ордер на товары по регистрам складского учета

Как Разработчик
Я хочу создать проводки документа приходного ордера на товара
Для того чтобы фиксировать какой товар получен на склад

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _028901 создание документа приходный ордер (Goods Reciept) на основании поступления
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-187' с именем 'IRP-187'
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '2'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	* Заполнение реквизитов
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	И я устанавливаю номер документа 106
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '106'
	И я проверяю заполнение товарной части
		И     таблица "ItemList" содержит строки:
		| '#' | 'Item'     | 'Receipt basis'     | 'Item key' | 'Unit' | 'Quantity'       |
		| '1' | 'Dress'    | 'Purchase invoice 2*' | 'L/Green'  | 'pcs' | '500,000' |
	И я проверяю добавление склада в табличную часть
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-228' с именем 'IRP-228'
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' |
		| 'Dress' | '500,000'  | 'L/Green'  | 'Store 02' | 'pcs' |
	И я нажимаю на кнопку 'Post and close'
	И Я закрываю текущее окно
	

Сценарий: _028902 проверка движений документа Goods Reciept по регистру GoodsInTransitIncoming (минус)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-188' с именем 'IRP-188'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'          | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key'  |
		| '500,000'  | 'Goods receipt 106*'  | 'Purchase invoice 2*'   | '1'           | 'Store 02' | 'L/Green'   |

Сценарий: _028903 проверка движений документа Goods Reciept по регистру StockBalance (плюс)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-188' с именем 'IRP-188'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки: 
		| 'Quantity' | 'Recorder'             | 'Line number'  | 'Store'    | 'Item key' |
		| '500,000'  | 'Goods receipt 106*'   | '1'            | 'Store 02' | 'L/Green'  |

Сценарий: _028904 проверка движений документа Goods Reciept по регистру StockReservation (плюс)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-188' с именем 'IRP-188'
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки: 
		| 'Quantity' | 'Recorder'                          | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Goods receipt 106*'                 | '1'           | 'Store 02'    | 'L/Green'  |


# Сценарий: создание приходного ордера на основании возврата клиента

