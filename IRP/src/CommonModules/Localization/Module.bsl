Function Strings(Lang) Export
	
	Strings = New Structure();
	
	#Region Equipment
	Strings.Insert("Eq_001", NStr("en='Installed';
		|ru='Установлен';
		|tr='Kuruldu'", Lang));
	Strings.Insert("Eq_002", NStr("en='Not installed';
		|ru='Не установлен';
		|tr='Kurulmadı'", Lang));
	Strings.Insert("Eq_003", NStr("en='There are no errors.';
		|ru='Ошибок нет.';
		|tr='Bir hata tespit edilemedi.'", Lang));
	Strings.Insert("Eq_004", NStr("ru='Сканер подключен.';
		|en='Scanner is connected.';
		|tr='Barkod okuyucusu başarılya bağlandı.'", Lang));
	Strings.Insert("Eq_005", NStr("ru='Ошибка. Сканер не подключен.';
		|en='Error. Scanner not connected.';
		|tr='Hata. Barkod okuyucusu bağlanamadı'", Lang));
	Strings.Insert("Eq_006", NStr("en='Installed on current PC.';
		|ru='Установить на текущий компьютер';
		|tr='Bu bilgisayara kurulmuştu.'", Lang));
	
	Strings.Insert("EqError_001", NStr("en='The device is connected. The device must be disabled before the operation.';
		|ru='Устройство подключено. Устройство должно быть отключено перед началом работы.';
		|tr='Cihaz bağlandı. İşlemden önce cihaz devre dışı bırakılmalı.'", Lang));

	Strings.Insert("EqError_002", NStr("en='The device driver could not be downloaded.
		|Check that the driver is correctly installed and registered in the system.';
		|ru='Драйвер устройства не может быть загружен. 
		|Проверьте, что драйвер правильно установлен и зарегистрирован в системе.';
		|tr='Cihaz sürücüsü yüklenemedi.
		|Sürücünün düzgün kurulduğundan ve sistemde kayıtlı (registered) olduğundan emin olunuz.'", Lang));
	
	Strings.Insert("EqError_003", NStr("ru='Необходимо иметь минимум одну точку в доп. ID.';
		|en='It has to be minimum one dot at Add ID.';
		|tr='Ek ID''de minimum bir nokta olmalıdır.'", Lang));
	Strings.Insert("EqError_004", NStr("ru='Перед тем как установить драйвер, он должен быть загружен.';
		|en='Before install driver - it has to be loaded.';
		|tr='Sürücü yükemeden öncesi indirmek lazım.'", Lang));
	Strings.Insert("EqError_005", NStr("ru='У драйвера оборудования %1 неправильный AddIn ID %2.';
		|en='The equipment driver %1 has incorrect AddIn ID %2.';
		|tr='Donanım %1 sürücüsü yanlış AddIn ID %2 bilgisine sahiptir.'", Lang));
	#EndRegion
	
	#Region POS
	
	Strings.Insert("POS_s1", NStr("ru='Сумма оплаты меньше суммы документа';
		|en='Amount paid is less than amount of the document';
		|tr='Ödeme tutarı satış tutarından daha küçüktür'", Lang));
	Strings.Insert("POS_s2", NStr("ru='Сумма оплат по безналичному расчету больше суммы документа';
		|en='Card fees are more than the amount of the document';
		|tr='Kart ile ödeme tutarı satış tutarından daha büyüktür'", Lang));
	Strings.Insert("POS_s3", NStr("en='There is no need to use cash, as card payments are sufficient to pay';
		|ru='Суммы по безналичному расчету для оплаты достаточно. Нет необходимости дополнительно использовать наличный расчет. ';
		|tr='Nakit tutar girmenize gerek yok, çünkü kart ile alınan ödeme yeterlidir'", Lang));
	Strings.Insert("POS_s4", NStr("ru='Суммы оплат некорректны';
		|en='Amounts of payments are incorrect';
		|tr='Ödeme tutarlarda hata var'", Lang));
	#EndRegion
	
	#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("en='Cannot connect to %1:%2. Details: %3';
		|ru='Не получается подключиться к %1:%2. Подробности: %3.';
		|fr='Impossible de se connecter à %1 : %2. Détails : %3';
		|tr='%1:%2 ile bağlantı kurulamıyor. Ayrıntılar:%3';
		|de='Verbindung mit %1:%2 kann nicht hergestellt werden. Details: %3'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("fr='Réponse reçue du %1 : %2';
		|ru='Полученный ответ от %1:%2';
		|en='Received response from %1:%2';
		|tr='%1:%2 tarafından yanıt alındı';
		|de='Erhaltene Antwort von %1: %2'", Lang));
	Strings.Insert("S_004", NStr("en='Resource address is empty.';
		|fr='L’adresse de la ressource est vide.';
		|ru='Адрес ресурса не заполнен.';
		|tr='Kaynak adresi boş.';
		|de='Ressourcenadresse ist leer.'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("en='Integration setting with name %1 is not found.';
		|fr='Paramètre d''intégration avec le nom %1 est introuvable.';
		|ru='Настройки интеграции с наименованием %1 не найдены.';
		|tr='%1 adıyla entegrasyon ayarı bulunamadı.';
		|de='Die Integrationseinstellung mit dem Namen %1 wurde nicht gefunden.'", Lang));
	Strings.Insert("S_006", NStr("en='Method is not supported in Web Client.';
		|ru='В web клиенте метод не поддерживается.';
		|fr='La méthode n''est pas prise en charge dans le client Web.';
		|tr='Yöntem Web İstemcisinde desteklenmiyor';
		|de='Die Methode ist im Web-Client nicht unterstützt.'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("fr='Type d''objet non pris en charge : %1.';
		|ru='Неподдерживаемый тип объекта: %1.';
		|en='Unsupported object type: %1.';
		|tr='Desteklenmeyen nesne türü: %1.';
		|de='Nicht unterstützter Objekttyp: %1.'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("fr='Le nom de fichier est vide.';
		|ru='Имя файла не заполнено';
		|en='File name is empty.';
		|tr='Dosya adı boş.';
		|de='Dateiname ist leer.'", Lang));
	Strings.Insert("S_015", NStr("en='Path for saving is not set.';
		|fr='Le chemin pour l''enregistrement n''est pas défini.';
		|ru='Путь сохранения не установлен.';
		|tr='Kaydetme yolu belirlenmemiş.';
		|de='Der Pfad zum Speichern ist nicht festgelegt.'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("ru='%1 Статус код: %2 %3';
		|fr='%1 Code statut : %2 %3';
		|en='%1 Status code: %2 %3';
		|tr='%1 Durum kodu: %2 %3';
		|de='%1 Statuscode: %2%3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("fr='Article ajouté.';
		|en='Item added.';
		|ru='Номенклатура добавлена.';
		|tr='Malzeme eklendi.';
		|de='Das Produkt hinzugefügt.'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("ru='Штрихкод %1 не найден.';
		|fr='Le code-barres %1 introuvable.';
		|en='Barcode %1 not found.';
		|tr='%1 barkodu bulunamadı.';
		|de='Der Barcode %1 nicht gefunden.'", Lang));
	Strings.Insert("S_022", NStr("ru='Валюты в документах-основания должны совпадать.';
		|fr='Les devises dans les documents de base doivent correspondre.';
		|en='Currencies in the base documents must match.';
		|tr='Ana belgelerdeki para birimleri eşleşmelidir.';
		|de='Die Währungen in den Basisdokumenten müssen übereinstimmen.'", Lang));
	Strings.Insert("S_023", NStr("fr='Méthode d''approvisionnement';
		|ru='Метод обеспечения';
		|en='Procurement method';
		|tr='Tedarik şekli';
		|de='Beschaffungsmethode'", Lang));
	
	Strings.Insert("S_026", NStr("ru='Размер выбранной иконки будет изменен до 16x16 px.';
		|fr='L''icône sélectionnée sera redimensionnée à 16x16 px.';
		|en='Selected icon will be resized to 16x16 px.';
		|tr='Seçilen simge 16x16 piksel olarak yeniden boyutlandırılacaktır.';
		|de='Die Größe des ausgewählten Symbols wird auf 16x16 Pixel geändert.'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("fr='Non rempli';
		|en='[Not filled]';
		|ru='[не заполнено]';
		|tr='[ Doldurulmamış ]';
		|de='[Nicht ausgefüllt]'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("en='Success';
		|ru='Успешно';
		|tr='Başarılı'", Lang));
	Strings.Insert("S_029", NStr("en='Not supporting web client';
		|ru='Не поддерживаемый wreb клиент';
		|tr='Desteklenmeyen web istemci'", Lang));
	Strings.Insert("S_030", NStr("en='Cashback';
		|fr='Monnaie';
		|ru='Сдача';
		|tr='Para üstü';
		|de='Rückgeld'", Lang));
	Strings.Insert("S_031", NStr("en='or';
		|ru='или';
		|tr='veya'", Lang));
	Strings.Insert("S_032", NStr("en='Add code, ex: CurrentSessionDate()';
		|tr='Kod ekle, örneğin: CurrentSessionDate()'", Lang));
	#EndRegion
	
	#Region Service
	Strings.Insert("Form_001", NStr("fr='Nouvelle page';
		|ru='Новая страница';
		|en='New page';
		|tr='Yeni sayfa';
		|de='Neue Seite'", Lang));
	Strings.Insert("Form_002", NStr("en='Delete';
		|fr='Supprimer';
		|ru='Пометить на удаление/Снять пометку';
		|tr='Kaldır';
		|de='Löschen'", Lang));
	Strings.Insert("Form_003", NStr("ru='Количество';
		|en='Quantity';
		|fr='Quantité';
		|tr='Miktar';
		|de='Anzahl'", Lang));
	Strings.Insert("Form_004", NStr("en='Customers terms';
		|ru='Соглашения с клиентами';
		|fr='Accords avec les clients';
		|tr='Müşteri anlaşmaları';
		|de='Vereinbarungen mit Kunden'", Lang));
	Strings.Insert("Form_005", NStr("en='Customers';
		|fr='Clients';
		|ru='Клиенты';
		|tr='Müşteriler';
		|de='Kunden'", Lang));
	Strings.Insert("Form_006", NStr("fr='Fournisseurs';
		|en='Vendors';
		|ru='Поставщики';
		|tr='Tedarikçiler';
		|de='Lieferanten'", Lang));
	Strings.Insert("Form_007", NStr("fr='Accords avec les fournisseurs';
		|en='Vendors terms';
		|ru='Соглашения с поставщиками';
		|tr='Tedarikçi anlaşması';
		|de='Vereinbarungen mit Lieferanten'", Lang));
	Strings.Insert("Form_008", NStr("ru='Пользователь';
		|en='User';
		|fr='Utilisateur';
		|tr='Kullanıcı';
		|de='Benutzer'", Lang));
	Strings.Insert("Form_009", NStr("en='User group';
		|fr='Groupe d''utilisateurs';
		|ru='Группа пользователей';
		|tr='Kullanıcı grubu';
		|de='Benutzergruppe'", Lang));
	Strings.Insert("Form_013", NStr("ru='Дата';
		|en='Date';
		|fr='Date';
		|tr='Tarih';
		|de='Datum'", Lang));
	Strings.Insert("Form_014", NStr("fr='Numéro';
		|en='Number';
		|ru='Номер';
		|tr='Numara';
		|de='Nummer'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("fr='Changer';
		|ru='Изменить';
		|en='Change';
		|tr='Değiştir';
		|de='Ändern'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("en='Clear';
		|ru='Очистить';
		|fr='Effacer';
		|tr='Temizle';
		|de='Löschen'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("fr='Annuler';
		|en='Cancel';
		|ru='Отмена';
		|tr='İptal';
		|de='Abbrechen'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("en='1. By item keys';
		|ru='1. По характеристике номенклатуры';
		|fr='1. Par clés d''article';
		|tr='1. Varyantlara göre';
		|de='1. Nach Artikelvarianten'", Lang));
	Strings.Insert("Form_023", NStr("en='2. By properties';
		|ru='2. По свойствам';
		|fr='2. Par propriétés';
		|tr='2. Özelliklere göre';
		|de='2. Nach Eigenschaften'", Lang));
	Strings.Insert("Form_024", NStr("en='3. By items';
		|fr='3. Par articles';
		|ru='3. По номенклатуре';
		|tr='3. Malzemelere göre';
		|de='3. Nach Produkten'", Lang));
	
	Strings.Insert("Form_025", NStr("ru='Создать по классификатору';
		|fr='Créer à partir du classificateur';
		|en='Create from classifier';
		|tr='Sınıflandırıcıdan oluştur';
		|de='Aus Klassifizierer erstellen'", Lang));
	
	Strings.Insert("Form_026", NStr("ru='Номенклатура набора';
		|en='Item Bundle';
		|fr='Article de l''offre groupée';
		|tr='Malzeme Paketi';
		|de='Bündelprodukt'", Lang));
	Strings.Insert("Form_027", NStr("en='Item';
		|fr='Article';
		|ru='Номенклатура';
		|tr='Malzeme';
		|de='Produkt'", Lang));
	Strings.Insert("Form_028", NStr("en='Item type';
		|fr='Type d''article';
		|ru='Вид номенклатуры';
		|tr='Malzeme tipi';
		|de='Produkttyp'", Lang));
	Strings.Insert("Form_029", NStr("ru='Внешние реквизиты';
		|en='External attributes';
		|fr='Attributs externes';
		|tr='Dış özellikler';
		|de='Externe Attribute'", Lang));
	Strings.Insert("Form_030", NStr("en='Dimensions';
		|ru='Измерения';
		|tr='Boyutlar'", Lang));
	Strings.Insert("Form_031", NStr("en='Weight information';
		|ru='Информация о весе';
		|tr='Ağırlık bilgisi'", Lang));
	Strings.Insert("Form_032", NStr("fr='Période';
		|ru='Период';
		|en='Period';
		|tr='Dönem';
		|de='Periode'", Lang));
	#EndRegion
	
	#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("ru='%1 наименование не заполнено';
		|fr='Description %1 est vide';
		|en='%1 description is empty';
		|tr='%1 açıklaması boş';
		|de='%1 Beschreibung ist leer'", Lang));
	Strings.Insert("Error_003", NStr("en='Fill any description.';
		|ru='Заполните наименование.';
		|fr='Complétez une description.';
		|tr='Herhangi bir açıklama girininiz.';
		|de='Füllen Sie eine Beschreibung aus.'", Lang));
	Strings.Insert("Error_004", NStr("fr='Les métadonnées ne sont pas prises en charge.';
		|en='Metadata is not supported.';
		|ru='Метаданные не поддерживаются.';
		|tr='Meta veriler desteklenmiyor.';
		|de='Metadaten sind nicht unterstützt.'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("en='Fill the description of an additional attribute %1.';
		|ru='Заполните наименование дополнительного реквизита %1.';
		|fr='Complétez la description de l''attribut supplémentaire %1.';
		|tr='Ek bir %1 özniteliğinin açıklamasını doldurunuz.';
		|de='Füllen Sie eine Beschreibung des Zusatzattributs %1 aus.'", Lang));
	Strings.Insert("Error_008", NStr("fr='Les groupes sont créés par un administrateur.';
		|en='Groups are created by an administrator.';
		|ru='Группы создаются администратором.';
		|tr='Gruplar bir yönetici tarafından oluşturulur.';
		|de='Gruppen sind von einem Administrator erstellt.'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("en='Cannot write the object: [%1].';
		|ru='Ошибка при записи объекта: [%1].';
		|fr='Impossible d''écrire l''objet : [%1].';
		|tr='Nesne yazılamıyor: [%1].';
		|de='Das Objekt kann nicht geschrieben werden: [%1].'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("en='Field [%1] is empty.';
		|ru='Поле [%1] не заполнено.';
		|fr='Le champ [%1] est vide.';
		|tr='[%1] alanı boş.';
		|de='Feld [%1] ist leer.'", Lang));
	Strings.Insert("Error_011", NStr("fr='Ajoutez au moins une ligne.';
		|en='Add at least one row.';
		|ru='Нужно добавить хоть одну строку.';
		|tr='En az bir satır ekleyin.';
		|de='Fügen Sie mindestens eine Zeile hinzu.'", Lang));
	Strings.Insert("Error_012", NStr("ru='Переменная названа не в соответствии с правилами.';
		|en='Variable is not named according to the rules.';
		|fr='La variable n''est pas nommée conformément aux règles.';
		|tr='Değişken, kurallara göre adlandırılmaz.';
		|de='Die Variable ist nicht gemäß den Regeln benannt.'", Lang));
	Strings.Insert("Error_013", NStr("en='Value is not unique.';
		|fr='La valeur n''est pas unique.';
		|ru='Значение не уникально.';
		|tr='Değer benzersiz değil.';
		|de='Der Wert ist nicht eindeutig.'", Lang));
	Strings.Insert("Error_014", NStr("fr='Le mot de passe et la confirmation du mot de passe ne correspondent pas.';
		|ru='Пароль и подтверждение пароля не совпадают.';
		|en='Password and password confirmation do not match.';
		|tr='Parola ve parola onayı eşleşmiyor.';
		|de='Das Kennwort und die Kennwortbestätigung stimmen nicht überein.'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr("fr='Il n''y a plus d''articles dans le document ""%1"" que vous devez commander auprès des fournisseurs.';
		|ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.';
		|en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.';
		|de='Im Dokument ""%1"" gibt es keine weiteren Waren, die Sie von den Lieferanten bestellen müssen.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr("ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|fr='Tout d''abord, créez un document ""%1"" ou désactivez la case à cocher ""%1 avant %2"" dans l''onglet ""Autres"".';
		|en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.';
		|de='Zunächst erstellen Sie ein Dokument ""%1"" oder deaktivieren Sie das Kontrollkästchen ""%1 vor der %2"" auf der Registerkarte ""Sonstiges"".'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr("ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|fr='Tout d''abord, créez un document ""%1"" ou désactivez la case à cocher ""%1 avant %2"" dans l''onglet ""Autres"".';
		|en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.';
		|de='Zunächst erstellen Sie ein Dokument ""%1"" oder deaktivieren Sie das Kontrollkästchen ""%1 vor der %2"" auf der Registerkarte ""Sonstiges"".'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr("en='There are no lines for which you need to create a ""%1"" document in the ""%2"" document.';
		|fr='Il n''y a pas de lignes pour lesquelles vous devez créer un document ""%1"" dans le document ""%2"".';
		|ru='Строки по которым необходимо создать документ ""%1"" отсутствуют в документе ""%2"".';
		|tr='""%2"" belgesinde ""%1"" belgesi oluşturmanız gereken satır yok.';
		|de='Das Dokument ""%2"" enthält keine Zeilen, für die Sie ein Dokument ""%1"" erstellen müssen.'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("fr='Spécifiez un document de base pour la ligne %1.';
		|en='Specify a base document for line %1.';
		|ru='Необходимо заполнить документ-основания по строке %1.';
		|tr='%1 satırı için bir ana belge belirtin.';
		|de='Geben Sie ein Basisdokument für Zeile %1 an.'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr("en='There are no products to return in the ""%1"" document. All products are already returned.';
		|ru='По всем товарам из выбранного документа ""%1"" уже был оформлен возврат.';
		|fr='Il n''y a pas de produits à retourner dans le document ""%1"". Tous les produits ont déjà été retournés.';
		|tr='""%1"" belgesinde iade edilecek ürün yok. Tüm ürünler zaten iade edildi.';
		|de='Das Dokument ""%1"" enthält keine Produkte, die zurückgegeben werden müssen. Alle Produkte wurden bereits zurückgegeben.'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr("fr='Il n''y a plus d''articles dans le document ""%1"" que vous devez commander auprès des fournisseurs.';
		|ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.';
		|en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.';
		|de='Im Dokument ""%1"" gibt es keine weiteren Waren, die Sie von den Lieferanten bestellen müssen.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("ru='Необходимо установить галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|en='Select the ""%1 before %2"" check box on the ""Other"" tab.';
		|fr='Activez la case à cocher ""%1 avant %2"" dans l''onglet ""Autres"".';
		|tr='""Diğer"" sekmesinde ""%2''den %1 önce"" onay kutusunu seçin.';
		|de='Aktivieren Sie das Kontrollkästchen ""%1 vor der %2"" auf der Registerkarte ""Sonstiges"".'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("fr='Spécifiez %1 dans la ligne %2 de %3.';
		|en='Specify %1 in line %2 of the %3.';
		|ru='Поле %1 обязателено для заполнения в строке %2 %3.';
		|tr='%3''ün %2 satırında %1 belirtin.';
		|de='Geben Sie ein %1 in der Zeile %2 des Dokuments ""%3"" an.'", Lang));

	Strings.Insert("Error_031", NStr("fr='Les articles n''ont pas été reçus du fournisseur conformément a la méthode d''approvisionnement.';
		|ru='Заказанные товары у поставщика для обеспечения заказа не были получены.';
		|en='Items were not received from the supplier according to the procurement method.';
		|tr='Tedarik yöntemine göre malzemeler tedarikçiden alınmadı.';
		|de='Bestellte Waren, die für den Auftrag erforderlich sind, wurden vom Lieferanten nicht erhalten.'", Lang));
	Strings.Insert("Error_032", NStr("ru='Действие не завершено.';
		|en='Action not completed.';
		|fr='Action non terminée.';
		|tr='Eylem tamamlanmadı.';
		|de='Die Aktion ist nicht abgeschlossen.'", Lang));
	Strings.Insert("Error_033", NStr("fr='Attribut dupliqué.';
		|ru='Реквизит дублируется.';
		|en='Duplicate attribute.';
		|tr='Yinelenen özellik.';
		|de='Doppeltes Attribut.'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("ru='%1 не является томом для хранения изображений.';
		|en='%1 is not a picture storage volume.';
		|fr='%1 n''est pas un volume de stockage des images.';
		|tr='%1 bir resim depolama birimi değil.';
		|de='%1 ist nicht ein Bildspeichervolume.'", Lang));
	Strings.Insert("Error_035", NStr("ru='Невозможно загрузить более 1 файла.';
		|en='Cannot upload more than 1 file.';
		|fr='Impossible de charger plus d''un fichier.';
		|tr='1''den fazla dosya yüklenemez.';
		|de='Nur 1 Datei kann hochgeladen werden.'", Lang));
	Strings.Insert("Error_037", NStr("en='Unsupported type of data composition comparison.';
		|ru='Неподдерживаемый тип сравнения состава данных.';
		|fr='Le type de comparaison de la composition des données n''est pas pris en charge.';
		|tr='Desteklenmeyen veri bileşimi karşılaştırması türü.';
		|de='Nicht unterstützter Datenvergleichstyp.'", Lang));	
	Strings.Insert("Error_040", NStr("fr='Les fichiers images uniquement sont pris en charge.';
		|ru='Поддерживается только тип файла - картинка.';
		|en='Only picture files are supported.';
		|tr='Yalnızca resim dosyaları desteklenir.';
		|de='Nur Bilddateien sind unterstützt.'", Lang));
	Strings.Insert("Error_041", NStr("fr='La table d''impôts/taxes contient plus d''une ligne [clé : %1] [impôt/taxe : %2].';
		|en='Tax table contains more than 1 row [key: %1] [tax: %2].';
		|ru='Таблица налогов содержит больше 1 строки [ключ: %1] [налог: %2].';
		|tr='Vergi tablosu 1''den fazla satır içeriyor [anahtar: %1] [vergi: %2].';
		|de='Die Steuertabelle enthält mehr als 1 Zeile [Schlüssel: %1] [Steuer: %2].'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("fr='Impossible de trouver un impôt ou une taxe par le nom de colonne : %1.';
		|en='Cannot find a tax by column name: %1.';
		|ru='Не найден налог по наименованию колонки: %1.';
		|tr='Sütun adına göre bir vergi bulunamıyor: %1.';
		|de='Eine Steuer kann nach dem Spaltennamen %1 nicht gefunden werden.'", Lang));
	Strings.Insert("Error_043", NStr("en='Unsupported document type.';
		|fr='Type de document non pris en charge.';
		|ru='Неподдерживаемый тип документа.';
		|tr='Desteklenmeyen belge türü.';
		|de='Nicht unterstützter Dokumenttyp.'", Lang));
	Strings.Insert("Error_044", NStr("fr='L''opération n''est pas prise en charge.';
		|en='Operation is not supported.';
		|ru='Недопустимая операция.';
		|tr='İşlem desteklenmiyor.';
		|de='Der Vorgang ist nicht unterstützt.'", Lang));
	Strings.Insert("Error_045", NStr("ru='Документ не заполнен.';
		|en='Document is empty.';
		|fr='Le document est vide.';
		|tr='Belge boş.';
		|de='Das Dokument ist leer.'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("ru='Поле ""%1"" обязательное для заполнения.';
		|en='""%1"" is a required field.';
		|fr='""%1"" est un champ obligatoire.';
		|tr='""%1"" zorunlu bir alandır.';
		|de='""%1"" ist ein erforderliches Feld.'", Lang));
	Strings.Insert("Error_049", NStr("en='Default picture storage volume is not set.';
		|ru='Том хранения файлов по умолчанию не заполнен.';
		|fr='Le volume de stockage des images par défaut n''est pas défini.';
		|tr='Varsayılan resim saklama hacmi ayarlanmamıştır.';
		|de='Das Standardbildspeichervolume ist nicht festgelegt.'", Lang));
	Strings.Insert("Error_050", NStr("en='Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).';
		|ru='Обмен валюты возможен только между счетами одного типа (между двумя кассами или между двумя банковскими счетами).';
		|fr='Le change de devises est disponible uniquement pour les comptes du même type (caisses ou comptes bancaires).';
		|tr='Döviz değişimi yalnızca aynı türdeki hesaplar için (kasa hesapları veya banka hesapları) kullanılabilir.';
		|de='Der Währungsumtausch ist nur für die Konten mit demselben Typ verfügbar (Kassenkonten oder Bankkonten).'", Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr("ru='Отсутствуют строки по которым необходимо создать ""%1"" или же все документы ""%1"" уже были созданы ранее.';
		|fr='Il n''y a pas de lignes pour lesquelles vous pouvez créer un document ""%1"", ou tous les documents ""%1"" ont déjà été créés.';
		|en='There are no lines for which you can create a ""%1"" document, or all ""%1"" documents are already created.';
		|tr='Kendisi için bir ""%1"" belgesi oluşturabileceğiniz satır yok veya tüm ""%1"" belgeleri zaten oluşturulmuş.';
		|de='Es gibt keine Zeilen, für die Sie ein Dokument ""%1"" erstellen können, oder alle Dokumente ""%1"" wurden bereits erstellt.'", Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("en='Cannot clear the ""%2"" check box. 
		|Documents ""%3"" from store %1 were already created.';
		|ru='Снять галочку ""%2"" невозможно. 
		|Ранее со склада %1 уже были созданы документы ""%3"".';
		|fr='Impossible de désactiver la case à cocher ""%2"". 
		|Les documents ""%3"" de l''entrepôt %1 ont déjà été créés.';
		|tr='""%2"" onay kutusu temizlenemiyor.
		|%1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.';
		|de='Das Kontrollkästchen ""%2"" kann nicht deaktiviert werden. 
		|Dokumente ""%3"" für Lager %1 wurden bereits zuvor erstellt.'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr("fr='Impossible de désactiver la case à cocher ""%2"". Les documents ""%3"" de l''entrepôt %1 ont déjà été créés.';
		|ru='Невозможно снять галочку ""%2"". Ранее со склада %1 уже были созданы документы ""%3"".';
		|en='Cannot clear the ""%2"" check box. Documents ""%3"" from store %1 were already created.';
		|tr='""%2"" onay kutusu temizlenemiyor. %1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.';
		|de='Das Kontrollkästchen ""%2"" kann nicht deaktiviert werden. Dokumente ""%3"" für Lager %1 wurden bereits zuvor erstellt.'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("en='Cannot continue. The ""%1""document has an incorrect status.';
		|fr='Impossible de continuer. Le statut du document ""%1"" est erroné.';
		|ru='Невозможно продолжить. Статус документа ""%1"" для продолжения неверный.';
		|tr='Devam edilemez. ""%1"" belgesinin durumu yanlış.';
		|de='Der Vorgang kann nicht fortgesetzt werden. Das Dokument ""%1"" hat einen falschen Status.'", Lang));
															  
	Strings.Insert("Error_055", NStr("fr='Il n''y a pas de lignes avec une méthode d''approvisionnement correcte.';
		|ru='Отсутствуют строки с нужным способом обеспечения.';
		|en='There are no lines with a correct procurement method.';
		|tr='Doğru tedarik yöntemine sahip hatlar yoktur.';
		|de='Es gibt keine Zeilen mit einer richtigen Beschaffungsmethode.'", Lang));

	Strings.Insert("Error_056", NStr("fr='Tous les articles dans la commande client ont déjà été commandés au moyen de bon(s) de commande.';
		|ru='Все товары в заказе клиента уже заказаны поставщику.';
		|en='All items in the sales order are already ordered using purchase order(s).';
		|tr='Satış siparişindeki tüm kalemler, satın alma siparişleri kullanılarak zaten sipariş edilmiştir.';
		|de='Alle Produkte im Auftrag sind mithilfe von Bestellung(en) bereits bestellt.'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr("ru='Все товары в документе ""%1"" уже заказаны документом ""%2"".';
		|fr='Tous les articles dans le document ""%1"" ont déjà été commandés au moyen du document ou des documents ""%2"".';
		|en='All items in the ""%1"" document are already ordered using the ""%2"" document(s).';
		|tr='""%1"" belgesindeki tüm öğeler ""%2"" belgeleri kullanılarak zaten sıralanmıştır.';
		|de='Alle Produkte im Dokument ""%1"" sind bereits mithilfe von Dokument(en) ""%2"" bestellt.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr("fr='Vous n''avez pas besoin de créer un document ""%1"" pour le(s) document(s) ""%2"" sélectionné(s).';
		|en='You do not need to create a ""%1"" document for the selected ""%2"" document(s).';
		|ru='Для выбранного документа ""%1"" не нужно создавать документ ""%2"".';
		|tr='Seçili ""%2"" dokümanlar için ""%1"" doküman oluşturmanıza gerek yoktur.';
		|de='Es ist nicht erforderlich, ein Dokument ""%1"" für die ausgewählten Dokumente ""%2"" zu erstellen.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr("ru='Вся сумма по документу ""%2"" уже была выдана по документу ""%1"".';
		|fr='Le montant total du document(s) ""%2"" a déjà été payé sur la base du document(s) ""%1"".';
		|en='The total amount of the ""%2"" document(s) is already paid on the basis of the ""%1"" document(s).';
		|tr='""%2"" belgelerinin toplam tutarı, ""%1"" belgeleri temelinde zaten ödendi.';
		|de='Der Gesamtbetrag des Dokuments ""%2"" ist bereits mithilfe von Dokument ""%1"" bezahlt.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("fr='Dans les documents sélectionnés, il y a les document(s) ""%2"" avec les documents ""%1"" existants,
		| aussi que ceux qui n''ont pas besoin de document ""%1"".';
		|ru='В списке выбранных документов ""%2"" есть те по которым уже был создан документ ""%1""
		| и те по которым документ ""%1"" создавать не нужно.';
		|en='In the selected documents, there are ""%2"" document(s) with existing ""%1"" document(s)
		| and those that do not require a ""%1"" document.';
		|tr='Seçilen belgelerde, mevcut ""%1"" belgelerine sahip ""%2"" belgeler var
		|  ve ""%1"" belgesi gerektirmeyenler.';
		|de='Die ausgewählten Dokumente enthalten Dokumente ""%2"" mit vorhandenen Dokumenten ""%1""
		| und diejenige, für die das Dokument ""%1"" nicht erforderlich ist.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr("en='The total amount of the ""%2"" document(s) is already received on the basis of the ""%1"" document(s).';
		|fr='Le montant total du document(s) ""%2"" a déjà été reçu sur la base du document(s) ""%1"".';
		|ru='Вся сумма по документу ""%2"" уже была получена по документу ""%1"".';
		|tr='""%2"" belgelerinin toplam miktarı, ""%1"" belgeleri temelinde zaten alındı.';
		|de='Der Gesamtbetrag des Dokuments ""%2"" ist bereits mithilfe von Dokument ""%1"" erhalten.'", Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr("en='You do not need to create a ""%2"" document for store(s) %1. The item will be shipped using the ""%3"" document.';
		|ru='Для склада %1 нет необходимости создавать документ ""%2"". Товар будет отгружен по документу ""%3"".';
		|fr='Vous n''avez pas besoin de créer un document ""%2"" pour l''entrepôt(s) %1. L''article sera expédié au moyen du document ""%3"".';
		|tr='%1 mağazaları için ""%2"" belgesi oluşturmanıza gerek yok. Ürün, ""%3"" belgesi kullanılarak gönderilecek.';
		|de='Es ist nicht erforderlich, ein Dokument ""%2"" für Lager %1 zu erstellen. Das Produkt wird mithilfe von Dokument ""%3"" versendet.'", Lang));
	
	Strings.Insert("Error_065", NStr("ru='Характеристика не уникальна.';
		|en='Item key is not unique.';
		|fr='La clé d''article n''est pas unique.';
		|tr='Varyant benzersiz değil.';
		|de='Artikelvariante ist nicht eindeutig.'", Lang));
	Strings.Insert("Error_066", NStr("fr='La spécification n''est pas unique.';
		|ru='Спецификация товара не уникальна.';
		|en='Specification is not unique.';
		|tr='Spesifikasyon benzersiz değil.';
		|de='Spezifikation ist nicht eindeutig.'", Lang));
	Strings.Insert("Error_067", NStr("en='Fill Users or Group tables.';
		|tr='Kullanıcı ve Grup tabloları doldur'", Lang));


	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - ordered
	// %5 - 11
	// %6 - 15
	// %7 - 4
	// %8 - pcs
	Strings.Insert("Error_068", NStr("en='Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.';
		|fr='Ligne nº [%1] [%2 %3] %4 restants : %5 %8. Nécessaires : %6 %8. Manquants : %7 %8.';
		|ru='Строка № [%1] [%2%3] %4 остаток: %5%8 Требуется: %6%8 Разница: %7%8.';
		|tr='Satır No. [%1] [%2 %3] %4aldı: %5 %8. Gerekli: %6 %8. Eksik: %7 %8.';
		|de='Zeile Nr. [%1] [%2 %3] %4 Restmenge: %5%8. Erforderlich: %6%8. Es fehlt: %7%8.'", Lang));

	// %1 - some extention name
	Strings.Insert("Error_071", NStr("ru='Внешняя обработка ""%1"" не подключена.';
		|en='Plugin ""%1"" is not connected.';
		|fr='Plug-in ""%1"" n''est pas connecté.';
		|tr='""%1"" eklentisi bağlı değil.';
		|de='Plug-In ""%1"" ist nicht verbunden.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("ru='В строке %1 необходимо заполнить склад.';
		|en='Specify a store in line %1.';
		|fr='Spécifiez un entrepôt dans la ligne %1.';
		|tr='%1 satırında bir mağaza belirtin.';
		|de='Geben Sie ein Lager in der Zeile %1 an.'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr("en='All items in the ""%1"" document(s) are already received using the ""%2"" document(s).';
		|fr='Tous les articles dans le(s) document(s) ""%1"" ont déjà été reçus au moyen du document ou des documents ""%2"".';
		|ru='Все товары по документу ""%1"" уже получены на основании документа ""%2"".';
		|tr='""%1"" belgelerindeki tüm öğeler, ""%2"" belgeleri kullanılarak zaten alındı.';
		|de='Alle Produkte im Dokument ""%1"" sind bereits mithilfe von Dokument(en) ""%2"" erhalten.'", Lang));
	Strings.Insert("Error_074", NStr("en='Currency transfer is available only when amounts are equal.';
		|fr='Le transfert d''argent dans la même devise est disponible uniquement quand les montants sont égaux.';
		|ru='При перемещении денежных средств в одной валюте сумма отправки и получения должны совпадать.';
		|tr='Para birimi transferi yalnızca tutarlar eşit olduğunda kullanılabilir.';
		|de='Der Währungstransfer ist verfügbar, nur wenn Beträge gleich sind.'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("en='There are ""%1"" documents that are not closed.';
		|fr='Il y a des documents ""%1"" non fermés.';
		|ru='Есть незакрытые документы ""%1"".';
		|tr='Kapatılmamış ""%1"" dokümanlar var.';
		|de='Es gibt Dokumente ""%1"", die nicht geschlossen sind.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("ru='Не заполнен документ основания в строке %1';
		|en='Basis document is empty in line %1.';
		|tr='Ana belge %1 satırında boş.'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("en='Quantity [%1] does not match the quantity [%2] by serial/lot numbers';
		|ru='Количество [%1] по строке не совпадает с количеством [%2] заполненным по серийным номерам. ';
		|tr='Girilen [%1] adet, seri lotuna ait [%2] adedinden farklıdır'", Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("ru='Сумма оплаты [%1] и сумма возврата [%2] не сходятся';
		|en='Payment amount [%1] and return amount [%2] not match';
		|tr='Ödeme tutar ([%1]) iade tutarından ([%2]) farklıdır'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("en='In line %1 quantity by %2 %3 greater than %4';
		|ru='В строке %1 количество %2 %3 больше чем %4';
		|tr='%1 satırında %2 %3 adet %4 adedinden daha büyük'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("en='In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5';
		|ru='В строке %1 количество %2-%3 %4 меньше чем количество в приходном ордере %5';
		|tr='%1 satırında %2-%3 %4 adedi %5 alım irsaliyesindeki adetten daha küçük'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("en='In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5';
		|ru='В строке %1 количество %2-%3 %4 меньше чем количество в приходном ордере %5';
		|tr='%1 satırında %2-%3 %4 adedi %5 alım irsaliyesindeki adetten daha küçük'", Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("en='Location with number `%1` not found.';
		|ru='Локация с номером %1 не найдена.';
		|tr='`%1` nolu lokasyon bulunamadı'", Lang));
	
	// %1 - 1000
	// %2 - 300
	// %3 - 350
	// %4 - 50
	// %5 - USD
	Strings.Insert("Error_085", NStr("en='Credit limit exceeded. Limit: %1, limit balance: %2, transaction: %3, lack: %4 %5';
		|ru='Превышение лимита взаиморасчетов. Лимит: %1, остаток взаиморасчетов: %2, транзакция: %3, не хватающая сумма: %4 %5';
		|tr='Borç limiti aşıldı. Limit: %1, limit bakiyesi: %2, işlem: %3, yetersiz tutar: %4 %5'", Lang));
	
	// %1 - 10
	// %2 - 20	
	Strings.Insert("Error_086", NStr("ru='Сумма (%1) не сходится с условиями оплата (%2)';
		|en='Amount : %1 not match Payment term amount: %2';
		|tr='%1 tutarı, ödeme toplamı %2 ile tutmuyor'", Lang));
	
	Strings.Insert("Error_087", NStr("en='Parent can not be empty';
		|ru='Родитель не может быть пустым';
		|tr='Üst öğe boş olamaz'", Lang));
	Strings.Insert("Error_088", NStr("en='Basis unit has to be filled, if item filter used.';
		|ru='Если устанавливается фильтр по номенклатуре, основная единица измерения должны быть заполнена.';
		|tr='Malzemeye göre filtre uygulandığı takdirse, ana birimi doldurmak lazım.'", Lang));
	
	Strings.Insert("Error_089", NStr("ru='Наименование(%1) ""%2"" уже используется.';
		|en='Description%1 ""%2"" is already in use.';
		|tr='%1 ""%2"" tanımı mevcuttur.'", Lang));
	Strings.Insert("Error_090", NStr("en='%1 is undefined.';
		|ru='%1 неопределен.';
		|tr='%1 tanımlı değil.'", Lang));
	
	// %1 - Boots
	// %2 - Red XL
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090", NStr("ru='[%1 %2] %3 остаток: %4 %7. Требуется: %5 %7. Не хватает: %6 %7.';
		|en='[%1 %2] %3 remaining: %4 %7. Required: %5 %7. Lacking: %6 %7.';
		|tr='[%1 %2] %3 kalan: %4 %7. İhtiyaç: %5 %7. Eksik: %6 %7.'", Lang));
	
	Strings.Insert("Error_091", NStr("ru='Только Администраторы могут создавать пользователей';
		|en='Only Administrator can create users.';
		|tr='Sadece sistem yöneticiler kullanıcıları oluşturabilir.'", Lang));
	
	Strings.Insert("Error_092", NStr("en='Can not use %1 role in SaaS mode';
		|ru='Роль %1 нельзя использовать в Saas режиме';
		|tr='%1 rolü SaaS modunda kullanılamaz'", Lang));
	Strings.Insert("Error_093", NStr("en='Cancel reason has to be filled if string was canceled';
		|ru='Если строка отменена, необходимо указать причину отмены';
		|tr='Satır iptal olduğunda iptal sebebi doldurulmalıdır'", Lang));
	Strings.Insert("Error_094", NStr("ru='Нельзя использовать подтверждение отправки товара без подтверждения о его получении. ';
		|en='Сan not use confirmation of shipment without goods receipt';
		|tr='Satın alma irsaliyesi olmadan sevk irsaliyesi oluşturulamaz'", Lang));
	
	
	#EndRegion
	
	#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("fr='Les documents ""%1"" et ""%2"" ne correspondent pas complétement, 
		|parce qu''il y a un autre document ""%1"" qui couvre partiellement le document ""%2"".';
		|en='The ""%1"" document does not fully match the ""%2"" document because 
		|there is already another ""%1"" document that partially covered this ""%2"" document.';
		|ru='Созданный документ ""%1"" не совпадает с документом ""%2"" в силу того, что ранее
		| уже создан документ ""%1"", который частично закрыл документ ""%2"".';
		|tr='""%1"" belgesi, ""%2"" belgesiyle tam olarak eşleşmiyor çünkü
		|zaten bu ""%2"" belgesini kısmen kapsayan başka bir ""%1"" belgesi var.';
		|de='Das Dokument ""%1"" stimmt mit dem Dokument ""%2"" nicht vollständig überein. 
		|Es gibt ein anderes Dokument ""%1"", das das Dokument ""%2"" teilweise abgedeckt hat.'", Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("ru='Объект %1 создан.';
		|en='Object %1 created.';
		|fr='Objet %1 créé.';
		|tr='%1 nesnesi oluşturuldu.';
		|de='Objekt %1 erstellt.'", Lang));
	Strings.Insert("InfoMessage_003", NStr("en='This is a service form.';
		|fr='Il s''agit d''une forme service.';
		|ru='Это сервисная форма.';
		|tr='Bu bir hizmet formudur.';
		|de='Das ist ein Dienstformular.'", Lang));
	Strings.Insert("InfoMessage_004", NStr("en='Save the object to continue.';
		|fr='Enregistrez l''objet pour continuer.';
		|ru='Для продолжения необходимо сохранить объект.';
		|tr='Devam etmek için nesneyi kaydedin.';
		|de='Speichern Sie das Objekt, um fortzufahren.'", Lang));
	Strings.Insert("InfoMessage_005", NStr("ru='Завершено';
		|en='Done';
		|fr='Terminé';
		|tr='Tamamlandı';
		|de='Fertig'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr("en='The ""%1"" document is already created. You can update the quantity.';
		|ru='Документы ""%1"" уже созданы. Возможно использовать только функцию обновления количества.';
		|fr='Le document ""%1"" a déjà été créé. Vous pouvez mettre à jour la quantité.';
		|tr='""%1"" belgesi zaten oluşturulmuş. Miktarı güncelleyebilirsiniz.';
		|de='Das Dokument ""%1"" wurde bereits erstellt. Sie können die Anzahl aktualisieren.'", Lang));
	
	Strings.Insert("InfoMessage_007", NStr("fr='nº %1 date : %2';
		|en='#%1 date: %2';
		|ru='#%1 дата: %2';
		|tr='#%1 tarih: %2';
		|de='Nr. %1 Datum: %2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("fr='nº %1 date : %2';
		|en='#%1 date: %2';
		|ru='#%1 дата: %2';
		|tr='#%1 tarih: %2';
		|de='Nr. %1 Datum: %2'", Lang));
	
	Strings.Insert("InfoMessage_009", NStr("ru='Общее количество не сходится. Введите еще раз. Осталась последняя попытка.';
		|en='Total quantity doesnt match. Please count one more time. You have one more try.';
		|tr='Girilen ve sayılan toplam adet tutmadı. Lütfen bir daha sayın. Bir deneme daha var.'", Lang));
	Strings.Insert("InfoMessage_010", NStr("en='Total quantity doesnt match. Location need to be count again (current count is annulated).';
		|ru='Общее количество не совпадает. Локацию необходимо отсканировать заново (текущие данные очищены).';
		|tr='Toplam miktar tutmuyor. Lokasyon tekrar okutulmalı (okutulan veri silinmişti).'", Lang));
	Strings.Insert("InfoMessage_011", NStr("en='Total quantity is ok. Please scan and count next location.';
		|ru='Общее количество правильное. Можно начать работу со следующей локацией.';
		|tr='Mevcut lokasyon ile ilgili girilen ve sayılan adet tuttu. Lütfen bir sonraki lokasyonu okutun.'", Lang));
	
	// %1 - 12
	// %2 - Vasiya Pupkin
	Strings.Insert("InfoMessage_012", NStr("ru='Сканирование текущей локации %1 было начато другим пользователем. Пользователь: %2';
		|en='Current location #%1 was started by another user. User: %2';
		|tr='Bu lokasyon (#%1) başka kullanıcı tarafından başlatıldı. Kullanıcı: %2'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_013", NStr("ru='Текущая локация %1 закреплена за вами. Другие пользователи не смогут с ней работать.';
		|en='Current location #%1 was linked to you. Other users will not be able to scan it.';
		|tr='#%1 lokasyon size atanmıştır. Diğer kullanıcılar bu lokasyonu okutamazlar.'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_014", NStr("ru='Текущая локация (%1) уже была отсканирована и закрыта. Пожалуйста, отсканируйте следующую локацию .';
		|en='Current location #%1 was scanned and closed before. Please scan next location.';
		|tr='Bu %1 lokasyon daha önce okutulmuş ve kapatılmıştı. Bir sonraki lokasyon okutunuz.'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_015", NStr("ru='Серийный номер %1 не найдет. Создать новый?';
		|en='Serial lot %1 was not found. Create new?';
		|tr='%1 seri numarası bulunamadı. Yeni oluşturmak ister misiniz?'", Lang));

	// %1 - 123456
	// %2 - Some item
	Strings.Insert("InfoMessage_016", NStr("ru='Отсканированный штрихкод %1 уже используется для номенклатуры %2';
		|en='Scanned barcode %1 is using for another items %2';
		|tr='Okutulan %1 barkod, başka malzeme (%2) için tanımlıdır.'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_017", NStr("ru='Отсканированный штрихкод %1 не используется для серийных номеров';
		|en='Scanned barcode %1 is not using set for serial numbers';
		|tr='Okutulan %1 barkod seri lot numara seti kullanmıyor'", Lang));
	Strings.Insert("InfoMessage_018", NStr("en='Add or scan serial lot number';
		|ru='Добавьте серию или считайте штрихкод серии';
		|tr='Seri seçin veya barkodu okutun'", Lang));
	
	Strings.Insert("InfoMessage_019", NStr("ru='Причина запрета:';
		|en='Data lock reasons:';
		|tr='Veri değiştirme kısıtlama sebebi:'", Lang));
	
  	Strings.Insert("InfoMessage_020", NStr("en='Created document: %1';
  		|ru='Создан документ: %1';
  		|tr='Evrak oluştur: %1'", Lang));
  
  	// %1 - 42
  	Strings.Insert("InfoMessage_021", NStr("ru='Невозможно разблокировать реквизиты, данный элемент использовался %1 раз, например:';
  		|en='Can not unlock attributes, this is element used %1 times, ex.:';
  		|tr='Alan kilidi kaldırılamaz, nesne %1 kez kullanıldı, örneğin:'", Lang));
  	// %1 - 
  	Strings.Insert("InfoMessage_022", NStr("en='This order is closed by %1';
  		|ru='Этот заказ уже закрыт документом %1';
  		|tr='Bu sipariş %1 ile kapatılmıştı.'", Lang));
	Strings.Insert("InfoMessage_023", NStr("ru='Нельзя использовать подтверждение отправки товара без подтверждения о его получении. Необходимо включить режим ""Использовать приходную товарную накладную"".';
		|en='Сan not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.';
		|tr='Satın alma irsaliyesi olmadan sevk irsaliyesi oluşturulamaz. Sevk irsaliye zorunlu kullanımı geçerlidir.'", Lang));
	#EndRegion
	
	#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("fr='Écrivez l''objet pour continuer. Voulez-vous continuer ?';
		|en='Write the object to continue. Continue?';
		|ru='Для продолжения необходимо сохранить объект. Продолжить?';
		|tr='Devam etmek için nesneyi yazın. Devam edilsin mi?';
		|de='Schreiben Sie das Objekt, um fortzufahren. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("fr='Voulez-vous passer en mode de numérisation ?';
		|en='Do you want to switch to scan mode?';
		|ru='Переключиться в режим сканирования?';
		|tr='Tarama moduna geçmek istiyor musunuz?';
		|de='Möchten Sie zum Scanmodus wechseln?'", Lang));
	Strings.Insert("QuestionToUser_003", NStr("fr='Les données complétées sur les transactions relatives aux chèques et obligations seront effacées. Voulez-vous mettre à jour %1 ?';
		|en='Filled data on cheque bonds transactions will be deleted. Do you want to update %1?';
		|ru='Заполненные данные по чекам будут очищены. Обновить %1? ';
		|tr='Doldurulmuş çek/senet bilgiler temizlenecek. %1 güncellemek ister misiniz?';
		|de='Angegebene Daten über Schecks und Anleihen werden gelöscht. Möchten Sie %1 aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_004", NStr("en='Do you want to change tax rates according to the partner term?';
		|fr='Voulez-vous modifier les taux d''imposition conformément à l''accord ?';
		|ru='Изменить налоговые ставки в соответствии с соглашением?';
		|tr='Vergileri sözleşmeye göre değiştirmek ister misiniz?';
		|de='Möchten Sie die Steuersätze gemäß der Vereinbarung verändern?'", Lang));
	Strings.Insert("QuestionToUser_005", NStr("en='Do you want to update filled stores?';
		|fr='Voulez-vous mettre à jour les entrepôts complétés ?';
		|ru='Обновить заполненные склады?';
		|tr='Tüm depoları güncellemek ister misiniz?';
		|de='Möchten Sie die angegebenen Lager aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("ru='Обновить заполненные цены';
		|fr='Voulez-vous mettre à jour la devise complétée ?';
		|en='Do you want to update filled currency?';
		|tr='Doldurulan para birimini güncellemek istiyor musunuz?';
		|de='Möchten Sie die angegebene Währung aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("ru='Таблица транзакций будет очищена. Продолжить?';
		|fr='La table des transactions sera effacée. Voulez-vous continuer ?';
		|en='Transaction table will be cleared. Continue?';
		|tr='İşlemler tablosu temizlenecek. Devam etmek ister misiniz?';
		|de='Die Transaktionstabelle wird geleert. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_008", NStr("ru='При изменении валюты заполненные строки будут отвязаны от документа перемещения денежных средств. Продолжить?';
		|fr='Si vous changez la devise, les lignes avec les documents de transfert d''argent seront effacées. Voulez-vous continuer ?';
		|en='Changing the currency will clear the rows with cash transfer documents. Continue?';
		|tr='Para birimini değiştirmek, nakit transferi belgelerini içeren satırları temizleyecektir. Devam ediyor muyuz?';
		|de='Wenn Sie die Währung ändern, die Zeilen mit den Überweisungsdokumenten werden geleert. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("en='Do you want to replace filled stores with store %1?';
		|ru='Хотите заменить текущие склады на склад: %1?';
		|tr='Dolu depoları %1 deposu ile değiştirmek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("en='Do you want to replace filled price types with price type %1?';
		|ru='Хотите заменить текущие типы цен на : %1?';
		|tr='Dolu fiyat tipleri %1 fiyat tipi ile değiştirmek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_012", NStr("ru='Вы действительно хотите выйти?';
		|en='Do you want to exit?';
		|fr='Voulez-vous vraiment quitter ?';
		|tr='Çıkmak istediğinizden emin misiniz?';
		|de='Möchten Sie den Vorgang beenden?'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("en='Do you want to update filled prices?';
		|fr='Voulez-vous mettre à jour les prix complétés ?';
		|ru='Обновить заполненные цены?';
		|tr='Doldurulmuş fiyatları güncellemek istiyor musunuz?';
		|de='Möchten Sie die angegebenen Preise aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("en='Transaction type is changed. Do you want to update filled data?';
		|fr='Le type de transaction a été changé. Voulez-vous mettre à jour les données complétées ?';
		|ru='Тип операции изменен. Обновить заполненные данные? ';
		|tr='İşlem türü değiştirildi. Doldurulmuş verileri güncellemek istiyor musunuz?';
		|de='Der Transaktionstyp wurde geändert. Möchten Sie angegebene Daten aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_015", NStr("fr='Les données complétées seront effacées. Voulez-vous continuer ?';
		|ru='Заполненные данные будут очищены. Продолжить?';
		|en='Filled data will be cleared. Continue?';
		|tr='Doldurulan veriler silinecektir. Devam edilsin mi?';
		|de='Angegebene Daten werden geleert. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("fr='Voulez-vous changer ou effacer l''icône ?';
		|en='Do you want to change or clear the icon?';
		|ru='Заменить или удалить иконку?';
		|tr='Simgeyi değiştirmek mi yoksa temizlemek mi istiyorsunuz?';
		|de='Möchten Sie das Symbol verändern oder löschen?'", Lang));
	Strings.Insert("QuestionToUser_017", NStr("ru='Сколько немобходимо создать документов?';
		|en='How many documents to create?';
		|tr='Kaç tane evrak oluşturulsun?'", Lang));
	Strings.Insert("QuestionToUser_018", NStr("en='Please enter total quantity';
		|ru='Введите пожалуйста общее количество';
		|tr='Toplam lokasyon adedini giriniz'", Lang));
	Strings.Insert("QuestionToUser_019", NStr("en='Do you want to update payment term?';
		|ru='Хотите обновить условия оплаты?';
		|tr='Ödeme şekli güncellemek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_020", NStr("ru='Хотите перезаписать сохраненный вариант?';
		|en='Do you want to overwrite saved option?';
		|tr='Daha önce kaydedilmiş seçeneği ezip kaydetmek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_021", NStr("ru='Вы хотите закрыть текущую форму? Все изменения будут потеряны.';
		|en='Do you want to close this form? All changes will be lost.';
		|tr='Bu formu kapatmak istediğinizden emin misiniz? Tüm değişiklikler geri alınacaktır.'", Lang));
	#EndRegion
	
	#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en='Select a value';
		|ru='Выберите значение';
		|fr='Sélectionner une valeur';
		|tr='Bir değer seçin';
		|de='Wählen Sie einen Wert aus'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("en='Enter a barcode';
		|fr='Entrez un code-barres';
		|ru='Введите штрихкод';
		|tr='Bir barkod giriniz';
		|de='Geben Sie einen Barcode ein'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("en='Enter an option name';
		|ru='Наименование параметра ввода';
		|fr='Entrez le nom d''une option';
		|tr='Bir seçenek adı giriniz';
		|de='Geben Sie einen Optionsnamen ein'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("fr='Entrez un nouveau nom de l''option';
		|en='Enter a new option name';
		|ru='Введите новое наименование параметра';
		|tr='Yeni bir seçenek adı giriniz';
		|de='Geben Sie einen neuen Optionsnamen ein'", Lang));
	#EndRegion
	
	#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("ru='Пользователь по UUID %1 и имени %2не найден.';
		|en='User not found by UUID %1 and name %2.';
		|fr='L''utilisateur portant l''UUID %1 et le nom %2 est introuvable.';
		|tr='Kullanıcı, %1 UUID ve %2 adı ile bulunamadı.';
		|de='Benutzer wurde nach UUID %1 und Namen %2 nicht gefunden.'", Lang));
	Strings.Insert("UsersEvent_002", NStr("fr='L''utilisateur portant l''UUID %1 et le nom %2 est trouvé.';
		|ru='Пользователь по UUID %1 и имени %2 найден.';
		|en='User found by UUID %1 and name %2.';
		|tr='Kullanıcı, %1 UUID ve %2 adı tarafından bulundu.';
		|de='Der Benutzer wurde nach UUID %1 und Namen %2 gefunden.'", Lang));
	#EndRegion
	
	#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("ru='Введите Наименование';
		|en='Enter description';
		|fr='Entrez une description';
		|tr='Açıklama giriniz';
		|de='Geben Sie eine Beschreibung an'", Lang));
	
	Strings.Insert("I_2", NStr("en='Click to enter description';
		|fr='Cliquez pour entrer la description';
		|ru='Нажмите для заполнения';
		|tr='Açıklama girmek için tıklayın';
		|de='Geben Sie eine Beschreibung ein'", Lang));
	
	Strings.Insert("I_3", NStr("en='Fill out the document';
		|ru='Заполните документ';
		|fr='Remplissez le document';
		|tr='Belgeyi doldurunuz';
		|de='Füllen Sie das Dokument aus'", Lang));
	Strings.Insert("I_4", NStr("ru='Найти %1 строк в таблице по ключу %2';
		|en='Find %1 rows in table by key %2';
		|tr='Tabloda %2 anahtara göre %1 bulmak'", Lang));
	Strings.Insert("I_5", NStr("ru='Не поддерживаемая таблица';
		|en='Not supported table';
		|tr='Desteklenmeyen tablo'", Lang));
	Strings.Insert("I_6", NStr("ru='Заказано без ЗОТ';
		|en='Ordered without ISR';
		|tr='Normal sipariş'", Lang));
	#EndRegion
	
	#Region Exceptions
	Strings.Insert("Exc_001", NStr("en='Unsupported object type.';
		|fr='Type d''objet non pris en charge.';
		|ru='Неподдерживаемый тип объекта.';
		|tr='Desteklenmeyen nesne türü.';
		|de='Nicht unterstützter Objekttyp.'", Lang));
	Strings.Insert("Exc_002", NStr("en='No conditions';
		|ru='Без условий';
		|fr='Pas de conditions';
		|tr='Koşul yok';
		|de='Keine Bedingungen'", Lang));
	Strings.Insert("Exc_003", NStr("en='Method is not implemented: %1.';
		|fr='La méthode n’a pas été implémentée : %1.';
		|ru='Метод не реализован: %1.';
		|tr='Yöntem uygulanmadı: %1.';
		|de='Die Methode ist nicht implementiert: %1.'", Lang));
	Strings.Insert("Exc_004", NStr("fr='Impossible d''extraire la devise de l''objet.';
		|en='Cannot extract currency from the object.';
		|ru='Валюта из объекта не извлечена.';
		|tr='Nesneden para birimi çıkarılamıyor.';
		|de='Die Währung kann aus dem Objekt nicht extrahiert werden.'", Lang));
	Strings.Insert("Exc_005", NStr("ru='Наименование библиотеки не заполнено.';
		|en='Library name is empty.';
		|fr='Le nom de bibliothéque est vide.';
		|tr='Kütüphane adı boş.';
		|de='Der Bibliothekname ist leer.'", Lang));
	Strings.Insert("Exc_006", NStr("ru='Данные библиотеки не содержат версии.';
		|en='Library data does not contain a version.';
		|fr='Les données de bibliothèque n''ont pas de version.';
		|tr='Kütüphane veriler sürümü içermiyor.';
		|de='Bibliotheksdaten enthalten keine Version.'", Lang));
	Strings.Insert("Exc_007", NStr("ru='Не применимо для версии библиотеки: %1.';
		|fr='Non applicable pour la version de bibliothéque %1.';
		|en='Not applicable for library version %1.';
		|tr='%1 kütüphane sürümü için geçerli değil.';
		|de='Nicht anwendbar für die Bibliotheksversion %1.'", Lang));
	Strings.Insert("Exc_008", NStr("fr='Clé de ligne inconnue.';
		|ru='Неизвестный ключ строки.';
		|en='Unknown row key.';
		|tr='Bilinmeyen satır anahtarı.';
		|de='Unbekannter Zeilenschlüssel.'", Lang));
	Strings.Insert("Exc_009", NStr("en='Error: %1';
		|fr='Erreur : %1';
		|ru='Ошибка: %1';
		|tr='Hata: %1';
		|de='Fehler: %1'", Lang));
	#EndRegion
	
	#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("fr='La zone %1 est introuvable.';
		|en='Area %1 not found.';
		|ru='Рабочая область %1 не найдена.';
		|tr='%1 alanı bulunamadı.';
		|de='Bereich %1 ist nicht gefunden.'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("ru='Статус рабочей области: %1.';
		|fr='Statut de la zone : %1.';
		|en='Area status: %1.';
		|tr='Alan durumu:%1.';
		|de='Bereichsstatus: %1.'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("en='Localization %1 of the company is not available.';
		|ru='Локализация компании %1 не доступна.';
		|fr='La localisation %1 de l''entreprise n''est pas disponible.';
		|tr='Şirketin %1 yerelleştirmesi mevcut değil. ';
		|de='Lokalisierung %1 der Organisation ist nicht verfügbar.'", Lang));
	
	Strings.Insert("Saas_004", NStr("en='Area preparation completed';
		|ru='Подготовка области завершена';
		|tr='Bölge hazırlaması tamamlandı.'", Lang));
	#EndRegion
	
	#Region FillingFromClassifiers
    // Do not modify "en" strings
    Strings.Insert("Class_001", NStr("fr='Prix d''achat';
    	|en='Purchase price';
    	|ru='Цена закупки';
    	|tr='Alım fiyatı';
    	|de='Einkaufspreis'", Lang));
    Strings.Insert("Class_002", NStr("en='Sales price';
    	|fr='Prix de vente';
    	|ru='Цена продажи';
    	|tr='Satış fiyatı';
    	|de='Verkaufspreis'", Lang));
    Strings.Insert("Class_003", NStr("en='Prime cost';
    	|fr='Prix coûtant';
    	|ru='Себестоимость';
    	|tr='Birim maliyet fiyatı';
    	|de='Selbstkosten'", Lang));
    Strings.Insert("Class_004", NStr("en='Service';
    	|fr='Service';
    	|ru='Сервис';
    	|tr='Servis';
    	|de='Berichte'", Lang));
    Strings.Insert("Class_005", NStr("fr='Produit';
    	|en='Product';
    	|ru='Товар';
    	|tr='Malzeme';
    	|de='Ware'", Lang));
    Strings.Insert("Class_006", NStr("fr='Entrepôt principal';
    	|ru='Главный склад';
    	|en='Main store';
    	|tr='Ana depo';
    	|de='Hauptlager'", Lang));
    Strings.Insert("Class_007", NStr("fr='Responsable principal';
    	|en='Main manager';
    	|ru='Главный менеджер';
    	|tr='Ana sorumlu';
    	|de='Hauptmanager'", Lang));
    Strings.Insert("Class_008", NStr("ru='шт';
    	|fr='pcs';
    	|en='pcs';
    	|tr='adet';
    	|de='Stck.'", Lang));
    #EndRegion
    
    #Region PredefinedObjectDescriptions
	PredefinedDescriptions(Strings, Lang);
	#EndRegion
    
	#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("en='Select base documents in the ""%1"" document.';
		|fr='Sélectionnez les documents de base dans le document ""%1"".';
		|ru='Выбор документов-оснований в документе ""%1""';
		|tr='""%1"" belgesindeki ana belgeleri seçin.';
		|de='Wählen Sie Basisdokumente im Dokument ""%1"" aus.'", Lang));	// Form PickUpDocuments
	#EndRegion
	
	#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("ru='Все';
		|fr='Tout';
		|en='All';
		|tr='Tümü';
		|de='Alle'", Lang));
	#EndRegion
	
	#Region SalesOrderStatusReport
	Strings.Insert("SOR_1", NStr("en='Not enough items in free stock';
		|ru='Не достаточно товара на остатках';
		|tr='Serbest stok bakiyesi yetersizdir'", Lang));
	#EndRegion	
	Return Strings;
EndFunction

Procedure PredefinedDescriptions(Strings, CodeLanguage)

	Strings.Insert("Description_A001", NStr("en='Catalog Partner terms';
		|ru='Справочник Соглашения';
		|fr='Catalogue Accords';
		|tr='Sözleşmeler';
		|de='Katalog Vereinbarungen'", CodeLanguage));
	Strings.Insert("Description_A003", NStr("ru='Справочник Подразделения';
		|en='Catalog Business units';
		|fr='Catalogue Divisions';
		|tr='K Departmanlar';
		|de='Katalog Abteilungen'", CodeLanguage));
	Strings.Insert("Description_A004", NStr("fr='Catalogue Caisses et comptes bancaires';
		|ru='Справочник Кассы\банковские счета';
		|en='Catalog Cash accounts';
		|tr='K Kasa/Banka';
		|de='Katalog Kassenkonten'", CodeLanguage));
	Strings.Insert("Description_A005", NStr("ru='Справочник Банковские чеки';
		|en='Catalog Cheque bonds';
		|fr='Catalogue Chèques et obligations';
		|tr='K Çek/Senetler';
		|de='Katalog Bankschecks und Anleihen'", CodeLanguage));
	Strings.Insert("Description_A006", NStr("en='Catalog Companies';
		|ru='Справочник Организации';
		|fr='Catalogue Entreprises';
		|tr='K Şirketler';
		|de='Katalog Organisationen'", CodeLanguage));
	Strings.Insert("Description_A007", NStr("ru='Справочник Типы организаций';
		|fr='Catalogue Types des entreprises';
		|en='Catalog Company types';
		|tr='K Şirket tipleri';
		|de='Katalog Organisationsarten'", CodeLanguage));
	Strings.Insert("Description_A008", NStr("en='Catalog Countries';
		|fr='Catalogue Pays';
		|ru='Справочник Страны';
		|tr='K Ülkeler';
		|de='Katalog Länder'", CodeLanguage));
	Strings.Insert("Description_A009", NStr("ru='Справочник Валюты';
		|fr='Catalogue Devises';
		|en='Catalog Currencies';
		|tr='K Dövizler';
		|de='Katalog Währungen'", CodeLanguage));
	Strings.Insert("Description_A010", NStr("ru='Справочник Статьи доходов и расходов';
		|en='Catalog Expense and revenue types';
		|fr='Catalogue Catégories des dépenses et recettes';
		|tr='K Gider ve gelir tipleri';
		|de='Katalog Spesen- und Einnahmearten'", CodeLanguage));
	Strings.Insert("Description_A011", NStr("en='Catalog Item keys';
		|ru='Справочник Характеристика номенклатуры';
		|fr='Catalogue Clés des articles';
		|tr='K Varyantlar';
		|de='Dokument Artikelvarianten'", CodeLanguage));
	Strings.Insert("Description_A012", NStr("ru='Справочник Номенклатура';
		|fr='Catalogue Articles';
		|en='Catalog Items';
		|tr='K Malzemeler';
		|de='Katalog Produkte'", CodeLanguage));
	Strings.Insert("Description_A013", NStr("ru='Справочник Виды номенклатуры';
		|fr='Catalogue Types des articles';
		|en='Catalog Item types';
		|tr='K Malzeme tipleri';
		|de='Katalog Produkttypen'", CodeLanguage));
	Strings.Insert("Description_A014", NStr("fr='Catalogue Partenaires';
		|ru='Справочник Партнеры';
		|en='Catalog Partners';
		|tr='K Cari hesaplar';
		|de='Katalog Geschäftspartner'", CodeLanguage));
	Strings.Insert("Description_A015", NStr("fr='Catalogue Clés des prix';
		|en='Catalog Price keys';
		|ru='Справочник Ключи аналитики ценообразования';
		|tr='K Fiyat anahtarları';
		|de='Katalog Preisschlüssel'", CodeLanguage));
	Strings.Insert("Description_A016", NStr("en='Catalog Price types';
		|ru='Справочник Виды цен';
		|fr='Catalogue Types des prix';
		|tr='K Fiyat tipleri';
		|de='Katalog Preistypen'", CodeLanguage));
	Strings.Insert("Description_A017", NStr("ru='Справочник Серии номенклатуры';
		|en='Catalog Serial lot numbers';
		|fr='Catalogue Numéros de série/lot';
		|tr='K Seri lot numaraları';
		|de='Katalog Serien- und Chargennummern'", CodeLanguage));
	Strings.Insert("Description_A018", NStr("ru='Справочник Спецификации товаров';
		|en='Catalog Specifications';
		|fr='Catalogue Spécifications';
		|tr='K Reçeteler';
		|de='Katalog Spezifikationen'", CodeLanguage));
	Strings.Insert("Description_A019", NStr("fr='Catalogue Entrepôts';
		|en='Catalog Stores';
		|ru='Справочник Склады';
		|tr='K Depolar';
		|de='Katalog Lager'", CodeLanguage));
	Strings.Insert("Description_A020", NStr("ru='Справочник Налоги';
		|fr='Catalogue Impôts/Taxes';
		|en='Catalog Taxes';
		|tr='K Vergiler';
		|de='Katalog Steuern'", CodeLanguage));
	Strings.Insert("Description_A021", NStr("fr='Catalogue Unités';
		|ru='Справочник Единицы измерения номенклатуры';
		|en='Catalog Units';
		|tr='K Birimler';
		|de='Katalog Maßeinheiten'", CodeLanguage));
	Strings.Insert("Description_A022", NStr("en='Catalog Users';
		|fr='Catalogue Utilisateurs';
		|ru='Справочник Пользователи';
		|tr='K Kullanıcılar';
		|de='Katalog Benutzer'", CodeLanguage));
	Strings.Insert("Description_A023", NStr("ru='Документ Платежное поручение исходящие';
		|en='Document Bank payment';
		|fr='Document Paiement bancaire';
		|tr='D Banka ödeme fişi';
		|de='Dokument Ausgangszahlung'", CodeLanguage));
	Strings.Insert("Description_A024", NStr("ru='Документ Платежное поручение входящее';
		|en='Document Bank receipt';
		|fr='Document Rentrée de fonds sur compte bancaire';
		|tr='D Banka tahsilat fişi';
		|de='Dokument Eingangszahlung'", CodeLanguage));
	Strings.Insert("Description_A025", NStr("fr='Document Création de l''offre groupée';
		|en='Document Bundling';
		|ru='Документ Комплектация набора';
		|tr='D Takım oluşturma fişi';
		|de='Dokument Bündelung'", CodeLanguage));
	Strings.Insert("Description_A026", NStr("ru='Документ Прочие наличные расходы';
		|fr='Document Dépense en espèces';
		|en='Document Cash expense';
		|tr='D Nakit gider fişi';
		|de='Dokument Barausgabe'", CodeLanguage));
	Strings.Insert("Description_A027", NStr("ru='Документ Расходный кассовый ордер';
		|en='Document Cash payment';
		|fr='Document Décaissement';
		|tr='D Kasa ödeme fişi';
		|de='Dokument Ausgabebeleg'", CodeLanguage));
	Strings.Insert("Description_A028", NStr("ru='Документ Приходный кассовый ордер';
		|en='Document Cash receipt';
		|fr='Document Encaissement';
		|tr='D Kasa tahsilat fişi';
		|de='Dokument Einnahmebeleg'", CodeLanguage));
	Strings.Insert("Description_A029", NStr("ru='Документ Прочие наличные доходы';
		|fr='Document Revenu en espèces';
		|en='Document Cash revenue';
		|tr='D Nakit gelir fişi';
		|de='Dokument Bareinnahme'", CodeLanguage));
	Strings.Insert("Description_A030", NStr("fr='Document Demande de transfert d''argent';
		|ru='Документ Заявка на перемещение денежных средств';
		|en='Document Cash transfer order';
		|tr='D Finansal transfer siparişi';
		|de='Dokument Umbuchungsauftrag'", CodeLanguage));
	Strings.Insert("Description_A031", NStr("en='Document Cheque bond transaction';
		|ru='Документ Операция по чекам и долговым обязательствам';
		|fr='Document Transaction relative au chèque ou à l''obligation';
		|tr='D Çek/Senet bordrosu';
		|de='Dokument Scheck- und Anleihetransaktion'", CodeLanguage));
	Strings.Insert("Description_A032", NStr("fr='Document Bon de réception';
		|en='Document Goods receipt';
		|ru='Документ Приходная товарная накладная';
		|tr='D Satın alma irsaliyesi';
		|de='Dokument Wareneingang'", CodeLanguage));
	Strings.Insert("Description_A033", NStr("en='Document Incoming payment order';
		|ru='Документ Заявка на поступление денежных средств';
		|fr='Document Demande de l''entrée d''argent';
		|tr='D Tahsilat siparişi';
		|de='Dokument Antrag auf Geldeingang'", CodeLanguage));
	Strings.Insert("Description_A034", NStr("ru='Документ Перемещение товаров';
		|fr='Document Transfert de stock';
		|en='Document Inventory transfer';
		|tr='D Depo transfer fişi';
		|de='Dokument Lagerumbuchung'", CodeLanguage));
	Strings.Insert("Description_A035", NStr("fr='Document Ordre de transfert de stock';
		|ru='Документ Заказ на перемещение товаров';
		|en='Document Inventory transfer order';
		|tr='D Depo transfer siparişi';
		|de='Dokument Lagerumbuchungsauftrag'", CodeLanguage));
	Strings.Insert("Description_A036", NStr("en='Document Invoice match';
		|fr='Document Rapprochement des factures';
		|ru='Документ Сопоставление документа-основания взаиморасчетов с платежами';
		|tr='D Fatura kapatma fişi';
		|de='Dokument Rechnungsabgleich'", CodeLanguage));
	Strings.Insert("Description_A037", NStr("fr='Document Étiquetage';
		|ru='Документ Штрихкодирование';
		|en='Document Labeling';
		|tr='D Seri lot tanımlama fişi';
		|de='Dokument Kennzeichnung'", CodeLanguage));
	Strings.Insert("Description_A038", NStr("fr='Document Écriture d''entrée';
		|ru='Документ Ввод начальных остатков';
		|en='Document Opening entry';
		|tr='D Açılış kayıt fişi';
		|de='Dokument Anfangsbestand'", CodeLanguage));
	Strings.Insert("Description_A039", NStr("ru='Документ Заявка на расходование денежных средств';
		|en='Document Outgoing payment order';
		|fr='Document Demande de la sortie d''argent';
		|tr='D Ödeme siparişi';
		|de='Dokument Antrag auf Geldausgang'", CodeLanguage));
	Strings.Insert("Description_A040", NStr("ru='Документ Пересчет товаров';
		|en='Document Physical count by location';
		|fr='Document Comptage physique dans l''entrepôt';
		|tr='D Lokasyon sayım fişi';
		|de='Dokument Inventurliste'", CodeLanguage));
	Strings.Insert("Description_A041", NStr("fr='Document Inventaire physique';
		|ru='Документ Инвентаризация товаров';
		|en='Document Physical inventory';
		|tr='D Sayım fişi';
		|de='Dokument Inventur'", CodeLanguage));
	Strings.Insert("Description_A042", NStr("ru='Документ Установка цен номенклатуры';
		|fr='Document Liste des prix';
		|en='Document Price list';
		|tr='D Fiyat listesi';
		|de='Dokument Preiskalkulation'", CodeLanguage));
	Strings.Insert("Description_A043", NStr("en='Document Purchase invoice';
		|ru='Документ Поступление товаров и услуг';
		|fr='Document Facture d''achat';
		|tr='D Satın alma faturası';
		|de='Dokument Einkaufsrechnung'", CodeLanguage));
	Strings.Insert("Description_A044", NStr("ru='Документ Заказ поставщику';
		|en='Document Purchase order';
		|fr='Document Bon de commande';
		|tr='D Satın alma siparişi';
		|de='Dokument Bestellung'", CodeLanguage));
	Strings.Insert("Description_A045", NStr("ru='Документ Возврат поставщику';
		|fr='Document Retour d''achat';
		|en='Document Purchase return';
		|tr='D Alım iadesi';
		|de='Dokument Lieferantenretoure'", CodeLanguage));
	Strings.Insert("Description_A046", NStr("fr='Document Commande fournisseur de retour';
		|ru='Документ Заказ на возврат поставщику';
		|en='Document Purchase return order';
		|tr='D Alım iade siparişi';
		|de='Dokument Lieferantenretourenauftrag'", CodeLanguage));
	Strings.Insert("Description_A047", NStr("en='Document Reconciliation statement';
		|fr='Document Relevé de rapprochement';
		|ru='Документ Сверка взаиморасчетов';
		|tr='D Cari hesap mutabakat fişi';
		|de='Dokument Offene Posten'", CodeLanguage));
	Strings.Insert("Description_A048", NStr("ru='Документ Реализация товаров и услуг';
		|fr='Document Facture de vente';
		|en='Document Sales invoice';
		|tr='D Satış faturası';
		|de='Dokument Rechnung'", CodeLanguage));
	Strings.Insert("Description_A049", NStr("ru='Документ Заказ покупателя';
		|en='Document Sales order';
		|fr='Document Commande client';
		|tr='D Satış siparişi';
		|de='Dokument Auftrag'", CodeLanguage));
	Strings.Insert("Description_A050", NStr("ru='Документ Возврат товаров от покупателя';
		|fr='Document Retour de vente';
		|en='Document Sales return';
		|tr='D Satış iadesi';
		|de='Dokument Kundenretoure'", CodeLanguage));
	Strings.Insert("Description_A051", NStr("ru='Документ Заказ на возврат покупателя';
		|en='Document Sales return order';
		|fr='Document Commande client de retour';
		|tr='D Satış iade siparişi';
		|de='Dokument Kundenretourenauftrag'", CodeLanguage));
	Strings.Insert("Description_A052", NStr("en='Document Shipment confirmation';
		|fr='Document Bon de livraison';
		|ru='Документ Расходная товарная накладная';
		|tr='D Sevk irsaliyesi';
		|de='Dokument Lieferschein'", CodeLanguage));
	Strings.Insert("Description_A053", NStr("ru='Документ Оприходование товаров';
		|fr='Document Ajustement positif de stock';
		|en='Document Stock adjustment as surplus';
		|tr='D Stok sayım girişi';
		|de='Dokument Aktivierung von Warenüberschüssen'", CodeLanguage));
	Strings.Insert("Description_A054", NStr("en='Document Stock adjustment as write off';
		|fr='Document Ajustement négatif de stock';
		|ru='Документ Списание товаров';
		|tr='D Stok sayım çıkışı';
		|de='Dokument Warenabschreibung'", CodeLanguage));
	Strings.Insert("Description_A056", NStr("ru='Документ Разукомлектация набора';
		|en='Document Unbundling';
		|fr='Document Suppression de l''offre groupée';
		|tr='D Ürün takımı bozma fişi';
		|de='Dokument Entbündelung'", CodeLanguage));
	Strings.Insert("Description_A057", NStr("fr='Défini par l’utilisateur';
		|en='User defined';
		|ru='Произвольный';
		|tr='Kullanıcı tanımlı';
		|de='Benutzerdefiniert'", CodeLanguage));
	Strings.Insert("Description_A058", NStr("en='Cheque bond incoming';
		|fr='Chèques/obligations reçus';
		|ru='Входящие банковские чеки';
		|tr='Gelen çek/senet';
		|de='Eingangsschecks/Anleihen'", CodeLanguage));
	Strings.Insert("Description_A059", NStr("ru='Исходящие банковские чеки';
		|fr='Chèques/obligations émis';
		|en='Cheque bond outgoing';
		|tr='Çıkan çek/senet';
		|de='Ausgangsschecks/Anleihen'", CodeLanguage));
	Strings.Insert("Description_A060", NStr("fr='Document Avoir et note de débit';
		|en='Document Credit debit note';
		|ru='Документ Списание задолженности';
		|tr='D Borç alacak dekontu';
		|de='Dokument Gut- und Lastschrift'", CodeLanguage));
	Strings.Insert("Description_A061", NStr("en='Settlement currency';
		|fr='Devise de règlement';
		|ru='Валюта транзакции';
		|tr='Cari hesap dövizi';
		|de='Abrechnungswährung'", CodeLanguage));
	Strings.Insert("Description_A062", NStr("en='Credit note';
		|fr='Avoir';
		|ru='Кредит-нота';
		|tr='Alacak dekontu';
		|de='Gutschrift'", CodeLanguage));
	Strings.Insert("Description_A063", NStr("en='Debit note';
		|ru='Дебет-нота';
		|fr='Note de débit';
		|tr='Borç dekontu';
		|de='Lastschrift'", CodeLanguage));
		
EndProcedure
