При создании документа в метадатах:

## Main
- [ ] Fill Synonym
- [ ] Fill Object presentaion
- [ ] Fill List presentation
- [ ] Code type - `Number`
- [ ] Lenght - `12`
- [ ] Non periodical
- [ ] Create on input = `Don't use`
- [ ] Add to subsystem
- [ ] Add to functional option
- [ ] Set common attribute Use: `Author, Branch, Description, SourceNodeID`
- [ ] RealTimePosting = `Deny` 
- [ ] Add to `FilterCriteria` - `RelatedDocuments` add to content and to button

## Access
- [ ] Copy any document Role and rename to `Document_DocName`. Set all right to this role, except `Delete`. Check, that `Restiction template` is filled.
- [ ] Add `Access restriction` to `Read`, `Insert`, `Update`:
```bsl
#CheckDocumentAccess()
```
- [ ] Do the same with role `TemplateDocument`
- [ ] Remove interactive Delete from role `FullAccess`
- [ ] Add read and View to role `FullAccessOnlyRead`
- [ ] Add to role `FilterForUserSettings` `Read` and `View`. And set attribute for using in `Default Settings` (`Catalog Users` - in header `Settings`)
- [ ] Add to Object Manager module:
```bsl
#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	//AccessKeyMap.Insert("Company", Obj.Company);
	//AccessKeyMap.Insert("Branch", Obj.Branch);
	//StoreList = Obj.ItemList.Unload(, "Store");
	//StoreList.GroupBy("Store");
	//AccessKeyMap.Insert("Store", StoreList.UnloadColumn("Store"));
	Return AccessKeyMap;
EndFunction

#EndRegion
```
## Other
- [ ] Add to content `FullExchange` in `Plan Exchange`
- [ ] In `Catalog.AddAttributeAndPropertySets` add new predefined document with name `Document_DocumentName`, set description as `Document Document name`.
- [ ] Copy from `document SalesOrder` table `AddAttributes` and setup it:
![](CreateNewDocument/.png)
![](https://user-images.githubusercontent.com/11927866/104844375-915e7900-58d8-11eb-93d9-f32e19b0e5cc.png)
- [ ] Добавить реквизит документа Company
- [ ] В Common Attributes указать что используются в документе - Author и Description всегда. DocumentAmount по необходимости
- [ ] Добавить в определяемые типы typeAddPropertyOwners
- [ ] Добавить в определяемые типы typeObjectWithItemList (если у документа есть табличная часть ItemList)
- [ ] Добавить тип в команду отчета DocumentRegistrationsReport
- [ ] Создать два общих модуля DocDocumentNameClient и DocDocumentNameServer, лучше скопировать их похожего документа и удалить лишнее
- [ ] В функции SetGroupItemsList оставить те реквизиты, которые должны формировать представление документа
- [ ] Добавить формы DocumentForm, ListForm, ChoiceForm именно в таком порядке они должны располагаться в метаданных

В форме ChoiceForm и ListForm 
- [ ] вывести в таблицу Ref, и скрыть ее.
![image](https://github.com/IRPTeam/IRP/assets/11927866/32a7f964-80c4-4beb-9fc3-0b49f74ad99b)
- [ ] Вставить области Commands и FormEvents
- [ ] В форме документа сформировать группу представлений (можно скопировать) 

![изображение](https://user-images.githubusercontent.com/11927866/104845289-4135e580-58dd-11eb-8720-9c2de3d67c41.png)

- [ ] Сформировать страницы и группу подвала (даже если она будет пустая) 

![изображение](https://user-images.githubusercontent.com/11927866/104845401-efda2600-58dd-11eb-91f8-e042b114b3b7.png)

- [ ] Скопировать реквизиты формы:

![изображение](https://user-images.githubusercontent.com/11927866/104851107-97198600-58fb-11eb-93ce-640257aa465e.png)

- [ ] В модуле формы документа определить области:

```bsl
#Region Variables
// Используется для описания переменных, лучше никогда не использовать
#EndRegion

#Region FormEventHandlers
// события самой формы - при открытии, при создании и т.д.
#EndRegion

#Region FormHeaderItemsEventHandlers
// события элементов формы, обычно- реквизиты при изменении, страницы и т.д.
#EndRegion

#Region FormTableItemsEventHandlers
#Region TableName
// События табличной части, 
#EndRegion
#EndRegion

#Region FormCommandsEventHandlers
// события по нажатию кнопок формы (не табличных частей
#EndRegion

#Region Initialize
// инициализация - не использовать
#EndRegion

#Region Public
// все методы, которые являются экспортными, и не относятся к оповещениям внутри формы
#EndRegion

#Region Private
// весь основной код.
#EndRegion
```
Надо понимать, что в во всех регионах - не должно быть никакой логики прописано, кроме модуля Private - там может быть прописана логика, в остальных местах - должны или вызываться общие модули документа, или функции из региона Privat.

- [ ] Скопировать Регионы GroupTitleDecorations, DescriptionEvents, AddAttributes, ExternalCommands

- [ ] В модуль объекта документа вставить код:

```bsl

Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

```

- [ ] Вставить шаблон в модуль менеджера клиента:

```bsl
#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	PostingServer.SetRegisters(Tables, Ref);
	QueryArray = GetQueryTexts();
	PostingServer.FillPostingTables(Tables, Ref, QueryArray);
	Return Tables;
	
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();

	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Return;
EndProcedure

#EndRegion

#Region PostingInfo

Function GetQueryTexts()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R4051T_StockAdjustmentAsWriteOff());
	QueryArray.Add(R4052T_StockAdjustmentAsSurplus());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
        // Сортировка по номеру строки, и отбор по ссылке документа
		"SELECT
		|	ItemStockAdjustmentItemList.Ref,
		|	ItemStockAdjustmentItemList.Key,
		|	ItemStockAdjustmentItemList.ItemKey,
		|	ItemStockAdjustmentItemList.Unit,
		|	ItemStockAdjustmentItemList.Quantity,
		|	ItemStockAdjustmentItemList.QuantityInBaseUnit,
		|	ItemStockAdjustmentItemList.ItemKeyWriteOff,
		|	ItemStockAdjustmentItemList.Ref.Date,
		|	ItemStockAdjustmentItemList.Ref.Company,
		|	ItemStockAdjustmentItemList.Ref.Store
                |INTO ItemList
		|FROM
		|	Document.ItemStockAdjustment.ItemList AS ItemStockAdjustmentItemList
		|WHERE
		|	ItemStockAdjustmentItemList.Ref = &Ref
		|ORDER BY
		|	ItemStockAdjustmentItemList.LineNumber";
EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE 
		|	NOT QueryTable.IsService 
		|	AND NOT QueryTable.UseShipmentConfirmation";

EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.SalesOrder AS Basis,
		|*
		|
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.IsService
		|	AND NOT QueryTable.UseShipmentConfirmation 
		|	AND QueryTable.SalesOrderExists
		|	AND QueryTable.SalesOrder.UseItemsShipmentScheduling";

EndFunction

Function R4050B_StockInventory()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|*
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.IsService";

EndFunction

Function R4051T_StockAdjustmentAsWriteOff()
	Return
		"SELECT *
		|INTO R4051T_StockAdjustmentAsWriteOff
		|FROM
		|	ItemList AS QueryTable
		|WHERE False";

EndFunction

Function R4052T_StockAdjustmentAsSurplus()
	Return
		"SELECT *
		|INTO R4052T_StockAdjustmentAsSurplus
		|FROM
		|	ItemList AS QueryTable
		|WHERE False";

EndFunction

#EndRegion
```