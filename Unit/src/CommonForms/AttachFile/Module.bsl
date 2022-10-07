
&AtServer
Procedure IRPTE_OnCreateAtServerAfter(Cancel, StandardProcessing)
	IRPTE_CreateBtn("dragFileBtn");	           
	
	 // Добавляем новый реквизит в форму
    ДобавляемыеРеквизиты = Новый Массив;
    Реквизит = Новый РеквизитФормы("saveFile", Новый ОписаниеТипов("Строка"), , "saveFile", Истина);
    ДобавляемыеРеквизиты.Добавить(Реквизит);
    ИзменитьРеквизиты(ДобавляемыеРеквизиты);
   
    //Добавляем новое поле ввода на форму
    Элемент = ЭтаФорма.Элементы.Добавить("saveFile", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид = ВидПоляФормы.ПолеВвода;
    Элемент.ПутьКДанным = "saveFile";
	
	// Добавляем новый реквизит в форму
    ДобавляемыеРеквизиты = Новый Массив;
    Реквизит = Новый РеквизитФормы("dragFile", Новый ОписаниеТипов("Строка"), , "dragFile", Истина);
    ДобавляемыеРеквизиты.Добавить(Реквизит);
    ИзменитьРеквизиты(ДобавляемыеРеквизиты);
   
    //Добавляем новое поле ввода на форму
    Элемент = ЭтаФорма.Элементы.Добавить("dragFile", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид = ВидПоляФормы.ПолеВвода;
    Элемент.ПутьКДанным = "dragFile";

EndProcedure

&AtServer
Procedure IRPTE_CreateBtn(Name)
	//Добавляем новую команду
	Btn = ЭтаФорма.Команды.Добавить(Name);
	Btn.Действие = Name;
	Btn.Заголовок = Name;
	
	//Добавляем новую кнопку
	Itm = ЭтаФорма.Элементы.Добавить(Name, Тип("КнопкаФормы"), ЭтаФорма);
	Itm.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
	Itm.ИмяКоманды = Name;
EndProcedure

&НаКлиенте
Процедура saveFileBtn()
	
КонецПроцедуры

&НаКлиенте
Async Процедура dragFileBtn()  
                                               
	Files = Await PutFilesToServerAsync(, , ThisObject["dragFile"]);
	StandardProcessing = True;
	DragParameters = New Structure("Value", Files[0].FileRef);
	Item = Items.Upload;
	UploadDrag(Item, DragParameters, StandardProcessing);
КонецПроцедуры

&AtClient
&ChangeAndValidate("DownloadFile")
Procedure IRPTE_DownloadFile(Command)
	If Items.FileList.CurrentData = Undefined Then
		Return;
	EndIf;
	PictureParameters = CreatePictureParameters(Items.FileList.CurrentData.File);
	PictureURL = PictureViewerClient.GetPictureURL(PictureParameters);           
#Delete
	GetFileFromServerAsync(PictureURL, PictureParameters.Description, New GetFilesDialogParameters());
#EndDelete
#Insert                        
	If Not IsTempStorageURL(PictureURL) Then
	   PictureURL = PutToTempStorage(New BinaryData(PictureURL));
	EndIf;
	GetFileFromServerAsync(PictureURL, ThisObject["saveFile"]);
#EndInsert
EndProcedure
