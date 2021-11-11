
&AtClient
Procedure CreateSC(Command)
	CreateSCAtServer();
EndProcedure

&AtServer
Procedure CreateSCAtServer()
	// Создание документа ShpmentConfirmation
	
	// данные которые будут устанавливаться в реквизиты
	RefPartner  = Catalogs.Partners.FindByCode(64);
	RefItemKey1 = Catalogs.ItemKeys.FindByCode(159);
	RefItemKey2 = Catalogs.ItemKeys.FindByCode(158);
	RefStore    = Catalogs.Stores.FindByCode(1);
	RefUnit     = Catalogs.Units.FindByCode(27);
	
	// Для создания документа в параметре передаются метаданные документа
	// создавать напрямую (обычным образом) документ нельзя, он будет оторван от контекста
	Builder = BuilderServer_V2;
	Doc = Builder.CreateDocument(Metadata.Documents.ShipmentConfirmation);
	
	// устанавливаем значения в 3 реквизита
	// Через совойство Atr объекта Doc будут доступны все реквизиты документа
	// 3 параметр значение реквизита, LegalName не устанавливаем - будет заполнено из Partner
	Builder.SetProperty(Doc, Doc.Atr.Date           , CurrentSessionDate());
	Builder.SetProperty(Doc, Doc.Atr.TransactionType, Enums.ShipmentConfirmationTransactionTypes.Sales);
	Builder.SetProperty(Doc, Doc.Atr.Partner        , RefPartner);
	
	// Через свойство Tables будут доступны все табличные части документа
	// Колонки будут доступны как Doc.Tables.<Имя таблицы>.<Имя колонки>
	// Колонка Item доступна не будет,это реквизит формы
	ItemList = Doc.Tables.ItemList;
	
	// добавляем первую строку
	// Store и Unit не указываем, 
	// Store - будет заполнен из настроек пользователя 
	// Unit -  будет заполнен из ItemKey
	Row = Builder.AddRow(Doc, ItemList);
	Builder.SetRowProperty(Doc, Row, ItemList.ItemKey, RefItemKey1);
	// при установки значения Quantity будет пересчитан QuantityInBaseUnit
	Builder.SetRowProperty(Doc, Row, ItemList.Quantity, 10);

	// добавляем вторую строку
	// Quantity не заполняем, заполнится 1 по умолчанию
	Row = Builder.AddRow(Doc, ItemList);
	Builder.SetRowProperty(Doc, Row, ItemList.ItemKey, RefItemKey2);
	Builder.SetRowProperty(Doc, Row, ItemList.Store  , RefStore);
	// при изменении Unit ps на box 10 пересчитается QuantityInBaseUnit
	Builder.SetRowProperty(Doc, Row, ItemList.Unit  , RefUnit); // box 10
	
	// Записываем документ
	Builder.Write(Doc, DocumentWriteMode.Write);
EndProcedure

