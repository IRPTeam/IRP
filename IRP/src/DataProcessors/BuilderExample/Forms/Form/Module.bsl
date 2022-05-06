
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
	DocMetadata = Metadata.Documents.ShipmentConfirmation;
	Wrapper = Builder.CreateDocument(DocMetadata);
	
	// устанавливаем значения в 3 реквизита
	// Через совойство Attr объекта Doc будут доступны все реквизиты документа
	// 3 параметр значение реквизита, 
	// LegalName не устанавливаем - будет заполнено из Partner
	Builder.SetProperty(Wrapper, Wrapper.Attr.Date           , CurrentSessionDate());
	Builder.SetProperty(Wrapper, Wrapper.Attr.TransactionType, Enums.ShipmentConfirmationTransactionTypes.Sales);
	Builder.SetProperty(Wrapper, Wrapper.Attr.Partner        , RefPartner);
	
	// Через свойство Tables будут доступны все табличные части документа
	// Колонки будут доступны как Doc.Tables.<Имя таблицы>.<Имя колонки>
	// Колонка Item доступна не будет, это реквизит формы
	ItemList = Wrapper.Tables.ItemList;
	
	// добавляем первую строку
	// Store и Unit не указываем, 
	// Store - будет заполнен из настроек пользователя 
	// Unit -  будет заполнен из ItemKey
	Row = Builder.AddRow(Wrapper, ItemList);
	Builder.SetRowProperty(Wrapper, Row, ItemList.ItemKey, RefItemKey1);
	// при установки значения Quantity будет пересчитан QuantityInBaseUnit
	Builder.SetRowProperty(Wrapper, Row, ItemList.Quantity, 10);

	// добавляем вторую строку
	// Quantity не заполняем, заполнится 1 по умолчанию
	Row = Builder.AddRow(Wrapper, ItemList);
	Builder.SetRowProperty(Wrapper, Row, ItemList.ItemKey, RefItemKey2);
	Builder.SetRowProperty(Wrapper, Row, ItemList.Store  , RefStore);
	// при изменении Unit ps на box 10 пересчитается QuantityInBaseUnit
	Builder.SetRowProperty(Wrapper, Row, ItemList.Unit  , RefUnit); // box 10
	
	// Записываем документ
	Builder.Write(Wrapper, DocMetadata, DocumentWriteMode.Write);
EndProcedure

&AtClient
Procedure CreateRetailSales(Command)
	CreateRetailSalesServer();
EndProcedure

&AtServer
Procedure CreateRetailSalesServer()
	Builder = BuilderServer_V2;
	DocMetadata = Metadata.Documents.RetailSalesReceipt;
	Wrapper = Builder.CreateDocument(DocMetadata);
	Context = ValueToStringInternal(Wrapper);
	Presentation = GetPresentation(Wrapper);
		
	Context2 = AddRow_ItemList(Context);
	
	Wrapper2 = ValueFromStringInternal(Context2);
	
	
	Builder.Write(Wrapper2, DocMetadata, DocumentWriteMode.Write);
EndProcedure

Function AddRow_ItemList(Context)
	Builder = BuilderServer_V2;
	Wrapper = ValueFromStringInternal(Context);
	ItemList = Wrapper.Tables.ItemList;
	Row = Builder.AddRow(Wrapper, ItemList);
	
	Context = ValueToStringInternal(Wrapper);
	Presentation = GetPresentation(Wrapper);
	
	Return Context;
EndFunction

Function GetPresentation(Wrapper)
	Presentation = New Structure();
	For Each KeyValue In Wrapper.Object Do
		_Key = KeyValue.Key;
		Value = KeyValue.Value;
		Type = TypeOf(Value);
		If Value = Undefined Then
			Presentation.Insert(_Key, null);
		ElsIf IsRefType(Type) Then
			Presentation.Insert(_Key, GetRefPresentation(Value));
		ElsIf Type = Type("ValueTable") Then
			ValueArray = New Array();
			For Each Row In Value Do
				ValueRow = New Structure();
				For Each Column In Value.Columns Do
					CellValue = Row[Column.Name];
					If IsRefType(TypeOf(CellValue)) Then
						ValueRow.Insert(Column.Name, GetRefPresentation(CellValue));
					Else
						ValueRow.Insert(Column.Name, CellValue);
					EndIf;
				EndDo;
				ValueArray.Add(ValueRow);
			EndDo;
			Presentation.Insert(_Key, ValueArray);
		Else
			Presentation.Insert(_Key, Value);
		EndIf;
	EndDo;
	Return Presentation;
EndFunction

Function IsRefType(Type)
	Return Catalogs.AllRefsType().ContainsType(Type) Or Documents.AllRefsType().ContainsType(Type);
EndFunction

Function GetRefPresentation(value)
	Return New Structure("Ref, Presentation", String(value.UUID()), String(value));
EndFunction

